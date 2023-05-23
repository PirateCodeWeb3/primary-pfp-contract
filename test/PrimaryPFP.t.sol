// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/PrimaryPFP.sol";
import "../src/TestPFP.sol";
import "../lib/delegate-cash/DelegationRegistry.sol";
import "../lib/warm-xyz/HotWalletProxy.sol";

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

    DelegationRegistry dc;
    HotWalletProxy warm;
    PrimaryPFP public ppfp;
    TestPFP public testPFP;
    address public testPFPAddress;
    address public delegate;
    address contract_;
    uint256 tokenId;

    function setUp() public {
        dc = new DelegationRegistry();
        warm = new HotWalletProxy();
        ppfp = new PrimaryPFP(address(dc), address(warm));
        testPFP = new TestPFP("Test PFP", "TPFP");
        testPFPAddress = address(testPFP);
        delegate = makeAddr("delegate");
        vm.prank(msg.sender);
        testPFP.mint(0);
    }

    function _setPrimaryPFP(uint256 _tokenId) internal {
        vm.prank(msg.sender);
        ppfp.setPrimary(testPFPAddress, _tokenId);
    }

    function _setPrimaryForDelegate(
        uint256 _tokenId,
        address _delegate
    ) internal {
        vm.prank(msg.sender);
        ppfp.setPrimaryForDelegate(testPFPAddress, _tokenId, _delegate);
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

    function testEventForSetPrimary() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit PrimarySet(msg.sender, testPFPAddress, 0);
        ppfp.setPrimary(testPFPAddress, 0);
    }

    function testSetPrimaryPFPByDelegateCashNotDelegated() public {
        vm.expectRevert("msg.sender is not delegated by delegate.cash");
        ppfp.setPrimaryByDelegateCash(testPFPAddress, 0);
    }

    function testSetPrimaryPFPByDelegateCashToken() public {
        vm.prank(msg.sender);

        dc.delegateForToken(delegate, testPFPAddress, 0, true);
        assertTrue(
            dc.checkDelegateForToken(delegate, msg.sender, testPFPAddress, 0)
        );

        vm.prank(delegate);
        ppfp.setPrimaryByDelegateCash(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetPrimaryPFPByDelegateCashContract() public {
        vm.prank(msg.sender);

        dc.delegateForContract(delegate, testPFPAddress, true);
        assertTrue(
            dc.checkDelegateForContract(delegate, msg.sender, testPFPAddress)
        );

        vm.prank(delegate);
        ppfp.setPrimaryByDelegateCash(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetPrimaryPFPByDelegateCashAll() public {
        vm.prank(msg.sender);

        dc.delegateForAll(delegate, true);
        assertTrue(dc.checkDelegateForAll(delegate, msg.sender));

        vm.prank(delegate);
        ppfp.setPrimaryByDelegateCash(testPFPAddress, 0);

        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
    }

    function testSetPrimaryPFPByWarmXyzNotWarmed() public {
        vm.expectRevert("msg.sender is not warmed by warm.xyz");
        ppfp.setPrimaryByWarmXyz(testPFPAddress, 0);
    }

    function testSetPrimaryPFPByWarmXyzSuccess() public {
        vm.prank(msg.sender);

        warm.setHotWallet(delegate, block.timestamp * 2, true);
        assertEq(warm.getHotWallet(msg.sender), delegate);

        vm.prank(delegate);
        ppfp.setPrimaryByWarmXyz(testPFPAddress, 0);

        vm.prank(msg.sender);
        (contract_, tokenId) = ppfp.getPrimary(delegate);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        address addr = ppfp.getPrimaryAddress(contract_, tokenId);
        assertEq(addr, delegate);
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

    function testEventForSetDelegate() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, true, true);
        emit PrimaryDelegateSet(msg.sender, delegate, testPFPAddress, 0);
        ppfp.setPrimaryForDelegate(testPFPAddress, 0, delegate);
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
        _setPrimaryPFP(0);

        (contract_, tokenId) = ppfp.getPrimary(msg.sender);
        assertEq(contract_, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        address newDelegate = makeAddr("newDelegate");
        vm.prank(delegate);
        vm.deal(delegate, 1 ether);

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
}
