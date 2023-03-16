// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Counter {
    uint256 public counter;

    constructor(uint256 x) {
        counter = x;
    }

    function add(uint256 x) public {
        require(x < 1e18, "x is too big");
        counter += x;
    }

    function count() public {
        counter += 1;
    }
}
