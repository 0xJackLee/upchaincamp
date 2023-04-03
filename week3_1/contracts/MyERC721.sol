// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/* 
    发行一个ERC721Token 铸造一个NFT并在测试完发行
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract MyERC721 is ERC721 {

    constructor (string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        
    }

    function mint(address to, uint256 tokenId) public  {
        _mint(to, tokenId);
    }

}