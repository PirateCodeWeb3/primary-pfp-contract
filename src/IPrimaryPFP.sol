// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

/**
 * @title Set primary PFP for an address like primary ENS.
 * @dev Only owner of the PFP can set or remove the data onchain.
 */
interface IPrimaryPFP {
    struct PFP {
        address contract_;
        uint256 tokenId;
    }

    // @notice Emitted when a primary PFP set for the owner.
    event PrimarySet(
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    // @notice Emitted when a primary PFP set for a delegate.
    event PrimaryDelegateSet(
        address indexed from,
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    // @notice Emitted when a primary PFP removed.
    event PrimaryRemoved(
        address indexed from,
        address indexed contract_,
        uint256 tokenId
    );

    /**
     * @notice Set primary PFP for an address.
     * Only the PFP owner can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function setPrimary(address contract_, uint256 tokenId) external;

    /**
     * @notice Set primary PFP for a delegate address.
     * Only the PFP owner can set it, works like delegate cash for hotwallet.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     * @param delegate The delegate/hotwallet address owner want to delegate to
     */
    function setPrimaryForDelegate(
        address contract_,
        uint256 tokenId,
        address delegate
    ) external;

    /**
     * @notice Remove the primary PFP setting.
     * Only the PFP owner can remove it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function removePrimary(address contract_, uint256 tokenId) external;

    /**
     * @notice Get primary PFP for an address.
     * Returns address(0) & 0 if this addr has no primary PFP.
     *
     * @param addr The address for querying primary PFP
     */
    function getPrimary(address addr) external view returns (address, uint256);

    /**
     * @notice Get address of primary PFP for an address.
     * Returns delegated address if this PFP is bind to delegate, returns address(0) if the PFP is not bound to any address.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function getPrimaryAddress(
        address contract_,
        uint256 tokenId
    ) external view returns (address);
}
