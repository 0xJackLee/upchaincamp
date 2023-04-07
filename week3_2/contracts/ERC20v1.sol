// SPDX-Identifier-MIT: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20v1 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function balanceOfv1(
        address account
    ) public view returns (uint256, string memory) {
        return (ERC20.balanceOf(account), "erc20v1");
    }
}
