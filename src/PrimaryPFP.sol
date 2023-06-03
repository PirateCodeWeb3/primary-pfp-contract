// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;

import {IPrimaryPFP} from "./IPrimaryPFP.sol";
import {ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {EnumerableSet} from "../lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title Set primary PFP by binding a PFP to an address like primary ENS.
 *
 */
interface WarmXyzInterface {
    function getHotWallet(address coldWallet) external view returns (address);
}

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

    function delegateForToken(
        address delegate,
        address contract_,
        uint256 tokenId,
        bool value
    ) external;
}

contract PrimaryPFP is IPrimaryPFP, ERC165 {
    using EnumerableSet for EnumerableSet.AddressSet;

    // keccak256(abi.encode(collection, tokenId)) => ownerAddress
    mapping(bytes32 => address) private pfpOwners;
    // ownerAddress => PFPStruct
    mapping(address => PFP) private primaryPFPs;
    // all the PFP collections using
    EnumerableSet.AddressSet private collections;
    // PFP collection => ownerAddress EnumerableSet
    mapping(address => EnumerableSet.AddressSet) private communities;

    DelegateCashInterface private immutable dci;

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

    constructor(address dciAddress) {
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
            // owner set new PFP collection
            if (pfp.contract_ != contract_) {
                communities[pfp.contract_].remove(msg.sender);
            }
            delete pfpOwners[_pfpKey(pfp.contract_, pfp.tokenId)];
        }
        primaryPFPs[msg.sender] = PFP(contract_, tokenId);
        if (collections.add(contract_)) {
            emit CollectionAdded(contract_);
        }
        // owner set new PFP collection
        if (pfp.contract_ != contract_) {
            communities[contract_].add(msg.sender);
        }
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
        communities[contract_].remove(msg.sender);
        if (communities[contract_].length() == 0) {
            collections.remove(contract_);
            emit CollectionRemoved(contract_);
        }

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

    function getCollections() external view returns (address[] memory) {
        uint256 length = collections.length();
        address[] memory result = new address[](length);
        for (uint256 i; i < length; ) {
            result[i] = collections.at(i);
            unchecked {
                ++i;
            }
        }
        return result;
    }

    function getCommunities(
        address contract_
    ) external view returns (address[] memory) {
        EnumerableSet.AddressSet storage communityAddresses = communities[
            contract_
        ];
        uint256 length = communityAddresses.length();
        address[] memory result = new address[](length);
        for (uint256 i; i < length; ) {
            result[i] = communityAddresses.at(i);
            unchecked {
                ++i;
            }
        }
        return result;
    }

    function _pfpKey(
        address collection,
        uint256 tokenId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(collection, tokenId));
    }
}
