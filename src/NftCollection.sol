// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.34;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NftCollection is ERC721{

    uint256 public currentTokenId = 0;
    uint256 public totalSupply;

    event NftMinted(address user, uint256 tokenId);

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) ERC721(name_, symbol_) {
        totalSupply = totalSupply_;
    }    

    function mint() external {
        require(currentTokenId < totalSupply, "Cannot create more tokens");
        _safeMint(msg.sender, currentTokenId);
        currentTokenId++;

        emit NftMinted(msg.sender, currentTokenId--);
    }

}