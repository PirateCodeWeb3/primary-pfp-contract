// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

import "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {PrimaryPFP} from "../src/PrimaryPFP.sol";

interface ImmutableCreate2Factory {
    function safeCreate2(bytes32 salt, bytes calldata initCode) external payable returns (address deploymentAddress);
    function findCreate2Address(bytes32 salt, bytes calldata initCode)
        external
        view
        returns (address deploymentAddress);
    function findCreate2AddressViaHash(bytes32 salt, bytes32 initCodeHash)
        external
        view
        returns (address deploymentAddress);
}

contract Deploy is Script {
    ImmutableCreate2Factory immutable factory = ImmutableCreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);
    bytes initCode = type(PrimaryPFP).creationCode;
    bytes32 salt = 0x00000000000000000000000000000000000000006558deb6a07b8000787f0b3a;

    function run() external {
        vm.startBroadcast();

        address primaryPFPAddress = factory.safeCreate2(salt, initCode);
        PrimaryPFP primaryPFP = PrimaryPFP(primaryPFPAddress);
        console2.log(address(primaryPFP));
	
        vm.stopBroadcast();
    }
}
