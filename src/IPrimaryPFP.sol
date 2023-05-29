// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;

/**
 * @title Set primary PFP for an address like primary ENS.
 * @dev owner or delegated/warmed address can set primary PFP, only owner can remove the primary PFP.
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

    // @notice Emitted when a primary PFP removed.
    event PrimaryRemoved(
        address indexed from,
        address indexed contract_,
        uint256 tokenId
    );

    // @notice Emitted when a new PFP collection user set primary PFP.
    event CollectionAdded(address indexed contract_);

    // @notice Emitted when last user from one collection remove primary PFP.
    event CollectionRemoved(address indexed contract_);

    /**
     * @notice Set primary PFP for an address.
     * Only the PFP owner can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function setPrimary(address contract_, uint256 tokenId) external;

    /**
     * @notice Set primary PFP for an address from a delegated address from delegate.cash.
     * Only the delegated address from delegate cash can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function setPrimaryByDelegateCash(
        address contract_,
        uint256 tokenId
    ) external;

    /**
     * @notice Set primary PFP for an address from a warmed address from warm.xyz.
     * Only the warmed address from warm.xyz can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function setPrimaryByWarmXyz(address contract_, uint256 tokenId) external;

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
     * @notice Get primary PFPs for an array of addresses.
     * Returns a list of PFP struct for addrs.
     *
     * @param addrs The addresses for querying primary PFP
     */
    function getPrimaries(
        address[] calldata addrs
    ) external view returns (PFP[] memory);

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

    /**
     * @notice Returns all primary PFP collections addresses set by users.
     */
    function getCollections() external view returns (address[] memory);

    /**
     * @notice Returns all community primary PFP addresses from one community.
     * @param contract_ The collection address of the PFP
     */
    function getCommunities(
        address contract_
    ) external view returns (address[] memory);
}
