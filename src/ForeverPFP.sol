// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {IPFPBinding} from "./IPFPBinding.sol";
import {ICommunityVerification} from "./ICommunityVerification.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title
 * Forever by binding binding to an address like ENS reverse,
 * PFP by community verification.
 */
contract ForeverPFP is Ownable, IPFPBinding, ICommunityVerification {
    mapping(bytes32 => address) private bindingAddresses;
    mapping(address => IPFPBinding.PFP) private pfps;
    mapping(address => bool) private verifications;

    function bind(address contract_, uint256 tokenId) external override {
        _bind(contract_, tokenId, msg.sender);
        emit PFPBound(msg.sender, contract_, tokenId);
    }

    function bindDelegate(
        address contract_,
        uint256 tokenId,
        address delegate
    ) external override {
        _bind(contract_, tokenId, delegate);
        emit PFPBoundDelegate(msg.sender, delegate, contract_, tokenId);
    }

    function _bind(address contract_, uint256 tokenId, address addr) internal {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != addr, "duplicated binding");
        bindingAddresses[pfpHash] = addr;
        IPFPBinding.PFP memory pfp = pfps[addr];
        if (pfp.contract_ != address(0)) {
            delete bindingAddresses[_pfpKey(pfp.contract_, pfp.tokenId)];
        }
        pfps[addr] = IPFPBinding.PFP(contract_, tokenId);
        if (boundAddress == address(0)) {
            return;
        }
        emit PFPUnbound(boundAddress, contract_, tokenId);
        delete pfps[boundAddress];
    }

    function unbind(address contract_, uint256 tokenId) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != address(0), "PFP not bound");

        emit PFPUnbound(boundAddress, contract_, tokenId);

        delete bindingAddresses[pfpHash];
        delete pfps[boundAddress];
    }

    function getPFP(
        address addr
    ) external view override returns (address, uint256) {
        IPFPBinding.PFP memory pfp = pfps[addr];
        return (pfp.contract_, pfp.tokenId);
    }

    function getBindingAddress(
        address contract_,
        uint256 tokenId
    ) external view override returns (address) {
        return bindingAddresses[_pfpKey(contract_, tokenId)];
    }

    function addVerification(address contract_) external override onlyOwner {
        require(!verifications[contract_], "duplicated collection");
        verifications[contract_] = true;
        emit VerificationAdded(contract_);
    }

    function removeVerification(address contract_) external override onlyOwner {
        require(verifications[contract_], "collection not verified");
        verifications[contract_] = false;
        emit VerificationRemoved(contract_);
    }

    function isVerified(
        address contract_
    ) external view override returns (bool) {
        return verifications[contract_];
    }

    function _pfpKey(
        address collection,
        uint256 tokenId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encode(collection, tokenId));
    }
}
