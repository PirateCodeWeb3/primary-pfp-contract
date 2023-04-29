// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/TestPFP.sol";
import "../src/PFPVerification.sol";

contract PFPVerificationTest is Test {
    event VerificationAdded(address indexed contract_);

    event VerificationRemoved(address indexed contract_);

    PFPVerification public pv;
    TestPFP public testPFP;
    address public testPFPAddress;
    address[] public pfpAddresses;

    function setUp() public {
        pv = new PFPVerification();
        testPFP = new TestPFP();
        testPFPAddress = address(testPFP);
        pfpAddresses.push(testPFPAddress);
    }

    function testAddVerification() public {
        vm.expectEmit(true, false, false, true);

        emit VerificationAdded(testPFPAddress);
        pv.addVerification(pfpAddresses);
        assertTrue(pv.isVerified(testPFPAddress));
    }

    function testRemoveVerification() public {
        pv.addVerification(pfpAddresses);

        vm.expectEmit(true, false, false, true);

        emit VerificationRemoved(testPFPAddress);
        pv.removeVerification(pfpAddresses);
        assertFalse(pv.isVerified(testPFPAddress));
    }
}
