// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {IPFPVerification} from "./IPFPVerification.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title PFP unique images by community verification.
 *
 */
contract PFPVerification is Ownable, IPFPVerification {
    mapping(address => bool) private verifications;

    function addVerification(
        address[] calldata contracts
    ) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; i++) {
            address contract_ = contracts[i];
            verifications[contract_] = true;
            emit VerificationAdded(contract_);
        }
    }

    function removeVerification(
        address[] calldata contracts
    ) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; i++) {
            address contract_ = contracts[i];
            verifications[contract_] = false;
            emit VerificationRemoved(contract_);
        }
    }

    function isVerified(
        address contract_
    ) external view override returns (bool) {
        return verifications[contract_];
    }
}
