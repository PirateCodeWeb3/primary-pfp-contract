// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/console.sol";
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
        testPFP = new TestPFP("Test PFP", "TPFP");
        testPFPAddress = address(testPFP);
        delegate = makeAddr("delegate");
        vm.prank(msg.sender);
        testPFP.mint(0);
    }

    function _setPrimaryPFP(uint256 _tokenId) internal {
        vm.prank(msg.sender);
        ppfp.setPrimary{value: 0.01 ether}(testPFPAddress, _tokenId);
    }

    function _setPrimaryForDelegate(
        uint256 _tokenId,
        address _delegate
    ) internal {
        vm.prank(msg.sender);
        ppfp.setPrimaryForDelegate{value: 0.01 ether}(
            testPFPAddress,
            _tokenId,
            _delegate
        );
    }

    function testSetNotFromSender() public {
        vm.expectRevert("msg.sender is not the owner");
        ppfp.setPrimary(testPFPAddress, 0);
    }

    function testDuplicatedSet() public {
        _setPrimaryPFP(0);
        vm.expectRevert("duplicated set");
        _setPrimaryPFP(0);
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
        _setPrimaryPFP(0);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testSetPrimayPFPInsufficient() public {
        vm.prank(msg.sender);
        vm.expectRevert("insufficient payment, fee 0.01eth");

        ppfp.setPrimary{value: 0.005 ether}(testPFPAddress, 0);
    }

    function testSetEvent() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PrimarySet(msg.sender, testPFPAddress, 0);
        ppfp.setPrimary{value: 0.01 ether}(testPFPAddress, 0);
    }

    function testSetDelegate() public {
        _setPrimaryForDelegate(0, delegate);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetDelegateEvent() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PrimaryDelegateSet(msg.sender, delegate, testPFPAddress, 0);
        ppfp.setPrimaryForDelegate{value: 0.01 ether}(
            testPFPAddress,
            0,
            delegate
        );
    }

    function testSetOverrideByNewPFP() public {
        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        testPFP.mint(1);
        _setPrimaryPFP(1);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);

        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, msg.sender);
    }

    function testSetOverrideBySameOwner() public {
        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PrimaryRemoved(msg.sender, testPFPAddress, 0);

        vm.expectEmit(true, true, true, true);
        emit PrimaryDelegateSet(msg.sender, delegate, testPFPAddress, 0);
        ppfp.setPrimaryForDelegate{value: 0.01 ether}(
            testPFPAddress,
            0,
            delegate
        );

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetOverrideByNewOwner() public {
        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        address newDelegate = makeAddr("newDelegate");
        vm.prank(delegate);
        vm.deal(delegate, 1 ether);

        ppfp.setPrimaryForDelegate{value: 0.01 ether}(
            testPFPAddress,
            0,
            newDelegate
        );

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(newDelegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, newDelegate);
    }

    function testSetOverrideBySameAddress() public {
        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        testPFP.mint(1);
        _setPrimaryPFP(1);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testRemoveFromWrongSender() public {
        vm.expectRevert("msg.sender is not the owner");
        vm.prank(delegate);
        ppfp.removePrimary(testPFPAddress, 0);
    }

    function testRemoveFromAddressNotSet() public {
        vm.expectRevert("primary PFP not set");
        vm.prank(msg.sender);
        ppfp.removePrimary(testPFPAddress, 0);
    }

    function testRemovePrimary() public {
        _setPrimaryPFP(0);

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
        _setPrimaryPFP(0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(testPFPAddress, 0);

        assertEq(IERC721(testPFPAddress).ownerOf(0), delegate);
        assertTrue(addr != delegate);
    }

    function testWithdraw() public {
        _setPrimaryPFP(0);

        ppfp.transferOwnership(delegate);
        assertEq(address(delegate).balance, 0 ether);
        ppfp.withdraw();
        assertEq(address(delegate).balance, 0.01 ether);
    }
}
