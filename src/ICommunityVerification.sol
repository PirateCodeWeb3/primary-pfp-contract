// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

/**
 * @title Same image url will confuse people, so verify a collection list of unique PFPs is important by the community.
 *
 * @dev this verfication can be maintained by the community by voting on snapshot with future developed ERC721/ERC20 tokens.
 */
interface ICommunityVerification {
    // @notice Emitted when a PFP collection is verified.
    event VerificationAdded(address indexed contract_);

    // @notice Emitted when a PFP collection is removed.
    event VerificationRemoved(address indexed contract_);

    /**
     * @notice Owner only, multi-sig by community voted.
     *
     * @param contract_ The collection address of the PFP
     */
    function addVerification(address contract_) external;

    /**
     * @notice Owner only, multi-sig by community voted.
     * Just in case one collection change metadata image to confuse people.
     *
     * @param contract_ The collection address of the PFP
     */
    function removeVerification(address contract_) external;

    /**
     * @notice Returns whether a PFP collection is verified.
     *
     * @param contract_ The collection address of the PFP
     */
    function isVerified(address contract_) external view returns (bool);
}
