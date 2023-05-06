// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title BlueChips
 * @dev This contract is only for deployed on testnet for better testing.
 */
contract TestPFP is Ownable, ERC721Enumerable {
    string public baseURI;
    uint256 public collectionLimit;
    mapping(address => uint256) public mintCounts;

    constructor(
        string memory name,
        string memory symbol
    ) Ownable() ERC721(name, symbol) {
        baseURI = "https://MintableERC721/";
        collectionLimit = 10000;
    }

    /**
     * @dev Function to mint tokens
     * @param tokenId The id of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(uint256 tokenId) external returns (bool) {
        require(tokenId < collectionLimit, "exceed collection limit");

        mintCounts[_msgSender()] += 1;
        require(mintCounts[_msgSender()] <= 10, "exceed mint limit");

        _mint(_msgSender(), tokenId);
        return true;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        baseURI = baseURI_;
    }

    function setCollectionLimit(uint256 collectionLimit_) external onlyOwner {
        collectionLimit = collectionLimit_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
