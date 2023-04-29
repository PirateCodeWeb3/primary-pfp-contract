// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {IPrimaryPFP} from "./IPrimaryPFP.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

/**
 * @title Set primary PFP by binding a PFP to an address like primary ENS.
 *
 */
contract PrimaryPFP is IPrimaryPFP {
    mapping(bytes32 => address) private bindingAddresses;
    mapping(address => IPrimaryPFP.PFP) private primaryPFPs;
    mapping(address => bool) private verifications;

    function setPrimary(address contract_, uint256 tokenId) external override {
        _set(contract_, tokenId, msg.sender);
        emit PrimarySet(msg.sender, contract_, tokenId);
    }

    function setPrimaryForDelegate(
        address contract_,
        uint256 tokenId,
        address delegate
    ) external override {
        _set(contract_, tokenId, delegate);
        emit PrimaryDelegateSet(msg.sender, delegate, contract_, tokenId);
    }

    function _set(address contract_, uint256 tokenId, address addr) internal {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != addr, "duplicated set");
        bindingAddresses[pfpHash] = addr;
        IPrimaryPFP.PFP memory pfp = primaryPFPs[addr];
        if (pfp.contract_ != address(0)) {
            delete bindingAddresses[_pfpKey(pfp.contract_, pfp.tokenId)];
        }
        primaryPFPs[addr] = IPrimaryPFP.PFP(contract_, tokenId);
        if (boundAddress == address(0)) {
            return;
        }
        emit PrimaryRemoved(boundAddress, contract_, tokenId);
        delete primaryPFPs[boundAddress];
    }

    function removePrimary(
        address contract_,
        uint256 tokenId
    ) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = bindingAddresses[pfpHash];
        require(boundAddress != address(0), "primary PFP not set");

        emit PrimaryRemoved(boundAddress, contract_, tokenId);

        delete bindingAddresses[pfpHash];
        delete primaryPFPs[boundAddress];
    }

    function getPrimary(
        address addr
    ) external view override returns (address, uint256) {
        IPrimaryPFP.PFP memory pfp = primaryPFPs[addr];
        return (pfp.contract_, pfp.tokenId);
    }

    function getPrimaryAddress(
        address contract_,
        uint256 tokenId
    ) external view override returns (address) {
        return bindingAddresses[_pfpKey(contract_, tokenId)];
    }

    function _pfpKey(
        address collection,
        uint256 tokenId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encode(collection, tokenId));
    }
}
