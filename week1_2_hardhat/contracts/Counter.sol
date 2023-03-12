// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract Counter {

    uint256 public counter;

    constructor (uint256 x) {
        counter = x;
    }

    function count() public {
        counter += 1;
    }

    function add(uint256 x) public {
        counter += x;
        // 调试利器 通过hardhat框架使用console.log
        console.log('counter now is:', x);
    }

}