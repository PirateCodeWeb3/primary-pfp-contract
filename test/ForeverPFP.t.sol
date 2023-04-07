// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/ForeverPFP.sol";
import "../src/TestPFP.sol";

contract ForeverPFPTest is Test {
    event PFPBound(
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    event PFPBoundDelegate(
        address indexed from,
        address indexed to,
        address indexed contract_,
        uint256 tokenId
    );

    event PFPUnbound(
        address indexed from,
        address indexed contract_,
        uint256 tokenId
    );

    event VerificationAdded(address indexed contract_);

    event VerificationRemoved(address indexed contract_);

    ForeverPFP public foreverPFP;
    TestPFP public testPFP;
    address public testPFPAddress;
    address public delegate;
    address contract_;
    uint256 tokenId;

    function setUp() public {
        foreverPFP = new ForeverPFP();
        testPFP = new TestPFP();
        testPFPAddress = address(testPFP);
        foreverPFP.addVerification(testPFPAddress);
        delegate = makeAddr("delegate");
    }

    function testAddVerificationDuplicatedCollection() public {
        vm.expectRevert("duplicated collection");
        foreverPFP.addVerification(testPFPAddress);
    }

    function testRemoveNotverificationAddedCollection() public {
        vm.expectRevert("collection not verified");
        foreverPFP.removeVerification(delegate);
    }

    function testCollectionAddedEvent() public {
        foreverPFP.removeVerification(testPFPAddress);

        vm.expectEmit(true, false, false, true);
        emit VerificationAdded(testPFPAddress);
        foreverPFP.addVerification(testPFPAddress);
    }

    function testRemoveCollection() public {
        assertTrue(foreverPFP.isVerified(testPFPAddress));

        vm.expectEmit(true, false, false, true);
        emit VerificationRemoved(testPFPAddress);
        foreverPFP.removeVerification(testPFPAddress);

        assertFalse(foreverPFP.isVerified(testPFPAddress));
    }

    function testBindNotFromSender() public {
        testPFP.safeMint(msg.sender);
        vm.expectRevert("msg.sender is not the owner");
        foreverPFP.bind(testPFPAddress, 0);
    }

    function testDuplicatedBind() public {
        testPFP.safeMint(msg.sender);
        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);
        vm.expectRevert("duplicated binding");
        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);
    }

    function testGetPFPFromNotBoundAddress() public {
        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, address(0));
        assertEq(tokenId, 0);
    }

    function testGetPFPBoundAddressFromUnbound() public {
        address addr = foreverPFP.getBindingAddress(testPFPAddress, 0);
        assertEq(addr, address(0));
    }

    function testBind() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testBindEvent() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PFPBound(msg.sender, testPFPAddress, 0);
        foreverPFP.bind(testPFPAddress, 0);
    }

    function testBindDelegate() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bindDelegate(testPFPAddress, 0, delegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testBindDelegateEvent() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PFPBoundDelegate(msg.sender, delegate, testPFPAddress, 0);
        foreverPFP.bindDelegate(testPFPAddress, 0, delegate);
    }

    function testBindOverrideByNewPFP() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        testPFP.safeMint(msg.sender);
        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 1);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testBindOverrideBySameOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PFPUnbound(msg.sender, testPFPAddress, 0);

        vm.expectEmit(true, true, true, true);
        emit PFPBoundDelegate(msg.sender, delegate, testPFPAddress, 0);
        foreverPFP.bindDelegate(testPFPAddress, 0, delegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testBindOverrideByNewOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        address newDelegate = makeAddr("newDelegate");
        vm.prank(delegate);
        foreverPFP.bindDelegate(testPFPAddress, 0, newDelegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(newDelegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(contract_, tokenId);
        assertEq(addr, newDelegate);
    }

    function testBindOverrideBySameAddress() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 1);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testUnbindFromWrongSender() public {
        testPFP.safeMint(msg.sender);

        vm.expectRevert("msg.sender is not the owner");
        vm.prank(delegate);
        foreverPFP.unbind(testPFPAddress, 0);
    }

    function testUnbind() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PFPUnbound(msg.sender, testPFPAddress, 0);
        foreverPFP.unbind(testPFPAddress, 0);

        vm.prank(msg.sender);
        (contract_, tokenId) = foreverPFP.getPFP(msg.sender);
        assertEq(contract_, address(0));
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(testPFPAddress, 0);
        assertEq(addr, address(0));
    }

    function testBindAddressNotOwner() public {
        testPFP.safeMint(msg.sender);

        vm.prank(msg.sender);
        foreverPFP.bind(testPFPAddress, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        vm.prank(msg.sender);
        address addr = foreverPFP.getBindingAddress(testPFPAddress, 0);

        assertEq(IERC721(testPFPAddress).ownerOf(0), delegate);
        assertTrue(addr != delegate);
    }
}
