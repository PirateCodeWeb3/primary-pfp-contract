// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

/**
 * @title Same image url will confuse people, so verify a collection list of unique PFPs is important for public social networking.
 *
 * @dev this verfication can be maintained by the community by voting on snapshot with future developed tokens.
 */
interface IPFPVerification {
    // @notice Emitted when a PFP collection is verified.
    event VerificationAdded(address indexed contract_);

    // @notice Emitted when a PFP collection is removed.
    event VerificationRemoved(address indexed contract_);

    /**
     * @notice Owner only, multi-sig by community voted.
     *
     * @param contracts The collection addresses of the PFPs
     */
    function addVerification(address[] calldata contracts) external;

    /**
     * @notice Owner only, multi-sig by community voted.
     *
     * @param contracts The collection addresses of the PFPs
     */
    function removeVerification(address[] calldata contracts) external;

    /**
     * @notice Returns whether a PFP collection is verified.
     *
     * @param contract_ The collection address of the PFP
     */
    function isVerified(address contract_) external view returns (bool);
}
