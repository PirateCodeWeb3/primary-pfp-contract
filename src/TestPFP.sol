// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/console.sol";
import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/utils/Counters.sol";
import {ITestPFP} from "./ITestPFP.sol";

contract TestPFP is ERC721, ITestPFP {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("TestPFP", "Test PFP") {}

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}
