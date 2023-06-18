// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;

import {IPrimaryPFP} from "./IPrimaryPFP.sol";
import {Initializable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

/**
 * @title Set primary PFP by binding a PFP to an address like primary ENS.
 *
 */

interface DelegateCashInterface {
    function checkDelegateForAll(
        address delegate,
        address vault
    ) external view returns (bool);

    function checkDelegateForContract(
        address delegate,
        address vault,
        address contract_
    ) external view returns (bool);

    function checkDelegateForToken(
        address delegate,
        address vault,
        address contract_,
        uint256 tokenId
    ) external view returns (bool);
}

contract PrimaryPFP is IPrimaryPFP, ERC165, Initializable {
    // keccak256(abi.encode(collection, tokenId)) => ownerAddress
    mapping(bytes32 => address) private pfpOwners;
    // ownerAddress => PFPStruct
    mapping(address => PFP) private primaryPFPs;

    DelegateCashInterface private dci;

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IPrimaryPFP).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function initialize(address dciAddress) public initializer {
        dci = DelegateCashInterface(dciAddress);
    }

    function setPrimary(address contract_, uint256 tokenId) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        require(tokenOwner == msg.sender, "msg.sender is not the owner");
        _set(contract_, tokenId);
        emit PrimarySet(msg.sender, contract_, tokenId);
    }

    function setPrimaryByDelegateCash(
        address contract_,
        uint256 tokenId
    ) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        require(
            dci.checkDelegateForToken(
                msg.sender,
                tokenOwner,
                contract_,
                tokenId
            ) ||
                dci.checkDelegateForContract(
                    msg.sender,
                    tokenOwner,
                    contract_
                ) ||
                dci.checkDelegateForAll(msg.sender, tokenOwner),
            "msg.sender is not delegated"
        );
        _set(contract_, tokenId);
        emit PrimarySetByDelegateCash(msg.sender, contract_, tokenId);
    }

    function _set(address contract_, uint256 tokenId) internal {
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address lastOwner = pfpOwners[pfpHash];
        require(lastOwner != msg.sender, "duplicated set");
        pfpOwners[pfpHash] = msg.sender;
        PFP memory pfp = primaryPFPs[msg.sender];
        // owner has PFP record
        if (pfp.contract_ != address(0)) {
            emit PrimaryRemoved(msg.sender, pfp.contract_, pfp.tokenId);
            delete pfpOwners[_pfpKey(pfp.contract_, pfp.tokenId)];
        }
        primaryPFPs[msg.sender] = PFP(contract_, tokenId);
        if (lastOwner == address(0)) {
            return;
        }
        emit PrimaryRemoved(lastOwner, contract_, tokenId);
        delete primaryPFPs[lastOwner];
    }

    function removePrimary(
        address contract_,
        uint256 tokenId
    ) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = pfpOwners[pfpHash];
        require(boundAddress != address(0), "primary PFP not set");

        emit PrimaryRemoved(boundAddress, contract_, tokenId);
        delete pfpOwners[pfpHash];
        delete primaryPFPs[boundAddress];
    }

    function getPrimary(
        address addr
    ) external view override returns (address, uint256) {
        PFP memory pfp = primaryPFPs[addr];
        return (pfp.contract_, pfp.tokenId);
    }

    function getPrimaries(
        address[] calldata addrs
    ) external view returns (PFP[] memory) {
        uint256 length = addrs.length;
        PFP[] memory result = new PFP[](length);
        for (uint256 i; i < length; ) {
            result[i] = primaryPFPs[addrs[i]];
            unchecked {
                ++i;
            }
        }
        return result;
    }

    function getPrimaryAddress(
        address contract_,
        uint256 tokenId
    ) external view override returns (address) {
        return pfpOwners[_pfpKey(contract_, tokenId)];
    }

    function _pfpKey(
        address collection,
        uint256 tokenId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(collection, tokenId));
    }
}
