// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {IPFPBinding} from "./IPFPBinding.sol";
import {ICommunityVerification} from "./ICommunityVerification.sol";
import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

/**
 * @title
 * Forever by binding binding to an address like ENS reverse,
 * PFP by community verification.
 */
contract ForeverPFP is Ownable, IPFPBinding, ICommunityVerification {
    mapping(bytes32 => address) private bindingAddresses;
    mapping(address => IPFPBinding.PFP) private pfps;
    mapping(address => bool) private verifications;

    function bind(address contract_, uint256 tokenId) external {
        _bind(contract_, tokenId, msg.sender);
        emit PFPBound(msg.sender, contract_, tokenId, false);
    }

    function bindDelegate(
        address contract_,
        uint256 tokenId,
        address delegate
    ) external {
        _bind(contract_, tokenId, delegate);
        emit PFPBound(delegate, contract_, tokenId, true);
    }

    function _bind(address contract_, uint256 tokenId, address addr) internal {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != addr, "duplicated binding");
        bindingAddresses[pfpHash] = addr;
        pfps[addr] = IPFPBinding.PFP(contract_, tokenId);
        if (boundAddress == address(0)) {
            return;
        }
        emit PFPUnbound(boundAddress, contract_, tokenId);
        delete pfps[boundAddress];
        return;
    }

    function unbind(address contract_, uint256 tokenId) external {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != address(0), "PFP not bound");

        emit PFPUnbound(boundAddress, contract_, tokenId);

        delete bindingAddresses[pfpHash];
        delete pfps[boundAddress];
    }

    function getPFP(address addr) external view returns (address, uint256) {
        IPFPBinding.PFP memory pfp = pfps[addr];
        return (pfp.contract_, pfp.tokenId);
    }

    function getBindingAddress(
        address contract_,
        uint256 tokenId
    ) external view returns (address) {
        return bindingAddresses[_pfpKey(contract_, tokenId)];
    }

    function addVerification(address contract_) external onlyOwner {
        require(!verifications[contract_], "duplicated collection");
        verifications[contract_] = true;
        emit VerificationAdded(contract_);
    }

    function removeVerification(address contract_) external onlyOwner {
        require(verifications[contract_], "collection not verified");
        verifications[contract_] = false;
        emit VerificationRemoved(contract_);
    }

    function isVerified(address contract_) external view returns (bool) {
        return verifications[contract_];
    }

    function _pfpKey(
        address collection,
        uint256 tokenId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encode(collection, tokenId));
    }
}
