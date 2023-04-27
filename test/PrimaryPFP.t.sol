// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/PrimaryPFP.sol";
import "../src/TestPFP.sol";

contract PrimaryPFPTest is Test {
    event PrimarySet(
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    event PrimaryDelegateSet(
        address indexed from,
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    event PrimaryRemoved(
        address indexed from,
        address indexed contract_,
        uint256 tokenId
    );

    event VerificationAdded(address indexed contract_);

    event VerificationRemoved(address indexed contract_);

    PrimaryPFP public ppfp;
    TestPFP public testPFP;
    address public testPFPAddress;
    address public delegate;
    address contract_;
    uint256 tokenId;

    function setUp() public {
        ppfp = new PrimaryPFP();
        testPFP = new TestPFP();
        testPFPAddress = address(testPFP);
        delegate = makeAddr("delegate");
    }

    function testSetNotFromSender() public {
        testPFP.safeMint(msg.sender);
        vm.expectRevert("msg.sender is not the owner");
        ppfp.setPrimary(testPFPAddress, 0);
    }

    function testDuplicatedSet() public {
        testPFP.safeMint(msg.sender);
        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);
        vm.expectRevert("duplicated set");
        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);
    }

    function testGetPrimaryWrong() public {
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, address(0));
        assertEq(tokenId, 0);
    }

    function testGetPrimarySetAddressNotSet() public {
        address addr = ppfp.getPrimaryAddress(testPFPAddress, 0);
        assertEq(addr, address(0));
    }

    function testSetPrimaryPFP() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testSetEvent() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PrimarySet(msg.sender, testPFPAddress, 0);
        ppfp.setPrimary(testPFPAddress, 0);
    }

    function testSetDelegate() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimaryForDelegate(testPFPAddress, 0, delegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetDelegateEvent() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PrimaryDelegateSet(msg.sender, delegate, testPFPAddress, 0);
        ppfp.setPrimaryForDelegate(testPFPAddress, 0, delegate);
    }

    function testSetOverrideByNewPFP() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        testPFP.safeMint(msg.sender);
        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 1);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testSetOverrideBySameOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PrimaryRemoved(msg.sender, testPFPAddress, 0);

        vm.expectEmit(true, true, true, true);
        emit PrimaryDelegateSet(msg.sender, delegate, testPFPAddress, 0);
        ppfp.setPrimaryForDelegate(testPFPAddress, 0, delegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetOverrideByNewOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        address newDelegate = makeAddr("newDelegate");
        vm.prank(delegate);
        ppfp.setPrimaryForDelegate(testPFPAddress, 0, newDelegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(newDelegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, newDelegate);
    }

    function testSetOverrideBySameAddress() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 1);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testRemoveFromWrongSender() public {
        testPFP.safeMint(msg.sender);

        vm.expectRevert("msg.sender is not the owner");
        vm.prank(delegate);
        ppfp.removePrimary(testPFPAddress, 0);
    }

    function testRemoveFromAddressNotSet() public {
        testPFP.safeMint(msg.sender);

        vm.expectRevert("primary PFP not set");
        vm.prank(msg.sender);
        ppfp.removePrimary(testPFPAddress, 0);
    }

    function testRemovePrimary() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PrimaryRemoved(msg.sender, testPFPAddress, 0);
        ppfp.removePrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, address(0));
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(testPFPAddress, 0);
        assertEq(addr, address(0));
    }

    function testSetAddressNotOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(testPFPAddress, 0);

        assertEq(IERC721(testPFPAddress).ownerOf(0), delegate);
        assertTrue(addr != delegate);
    }
}
