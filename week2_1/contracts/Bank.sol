// SPDX-License-Identifier: MIT;
pragma solidity ^0.8.4;

import "hardhat/console.sol";

error CallFailed();

contract Bank {
    address private owner;
    uint256 public amount;

    constructor() {
        owner = msg.sender;
        amount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    mapping(address => uint256) balances;

    // 存款
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        amount += msg.value;
        console.log("new balance", amount);
    }

    // 取款
    function withdraw(uint256 value) public {
        uint256 balance = balances[msg.sender];
        if (amount >= balance) {
            // 避免重入 先减余额 再执行转账
            balances[msg.sender] -= value;
            amount -= value;
            // 执行transfer时合约余额得大于等于转账数量 否则报错
            (bool success, ) = msg.sender.call{value: value}("");
            if (!success) {
                revert CallFailed();
            }
        }
    }

    // 跑路
    function rug() public onlyOwner {
        console.log(msg.sender);
        console.log(owner);
        if (amount > 0) {
            // 执行transfer时合约余额得大于等于转账数量 否则报错
            payable(owner).transfer(amount);
            amount = 0;
        }
    }

    // 获取余额
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
