// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract Counter {

    uint256 public counter;
    address private _owner;
    constructor (uint256 x) {
        counter = x;
        _owner = msg.sender;
    }

    function count() public {
        require(msg.sender == _owner, "only contract owner can count");
        counter += 1;
    }

    function add(uint256 x) public {
        counter += x;
        // 调试利器 通过hardhat框架使用console.log
        console.log('counter now is:', x);
    }

}