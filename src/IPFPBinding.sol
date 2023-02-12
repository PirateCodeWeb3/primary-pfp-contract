// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

/**
 * @title Bind address to PFP 1:1 mapping like ENS reverse record.
 * @dev Only owner of the token can bind or unbind the PFP.
 */
interface IPFPBinding {
    struct PFP {
        address contract_;
        uint256 tokenId;
    }

    // @notice Emitted when a PFP unbound from the owner.
    event PFPBound(
        address indexed to,
        address indexed contract_,
        uint256 tokenId,
        bool isDelegation
    );

    // @notice Emitted when a PFP unbound from the owner.
    event PFPUnbound(
        address indexed from,
        address indexed contract_,
        uint256 tokenId
    );

    /**
     * @notice Bind PFP to the msg.sender.
     * Only the token owner can bind.
     *
     * @param contract_ The address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function bind(address contract_, uint256 tokenId) external;

    /**
     * @notice Bind PFP to the delegate.
     * Only the token owner can bind the delegate.
     *
     * @param contract_ The address of the PFP
     * @param tokenId The tokenId of the PFP
     * @param delegate The delegate/hotwallet address owner want to delegate to
     */
    function bindDelegate(
        address contract_,
        uint256 tokenId,
        address delegate
    ) external;

    /**
     * @notice Unbind PFP from bound address.
     * Only the token owner can unbind the binding.
     *
     * @param contract_ The address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function unbind(address contract_, uint256 tokenId) external;

    /**
     * @notice Get ERC721 collection address and tokenId as PFP for an address.
     * Returns address(0) & 0 if this addr has no PFP binding
     *
     * @param addr The address for querying PFP binding
     */
    function getPFP(address addr) external view returns (address, uint256);

    /**
     * @notice Get address mapping to one PFP.
     * Returns delegated address if this PFP is bind to delegate, returns address(0) if the PFP is not bound to any address.
     *
     * @param contract_ The address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function getBindingAddress(
        address contract_,
        uint256 tokenId
    ) external view returns (address);
}
