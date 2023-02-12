// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/TestPFP.sol";

contract TestPFPTest is Test {
    TestPFP public testPFP;

    function setUp() public {
        testPFP = new TestPFP();
    }

    function testName() public {
        assertEq(testPFP.name(), "TestPFP");
    }
}
