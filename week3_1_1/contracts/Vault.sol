// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Vault {
    
    mapping (address => uint256) public balances;
    address tokenAddress;

    constructor (address tokenAddress_) {
        tokenAddress = tokenAddress_;
    }


    /**
     * @dev deposit ERC20 Token
     * need to approve firstly
     */
    function deposit(uint256 amount) public {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    /**
     * @dev withdraw ERC20 Token
     */
    function withdraw(uint256 amount) public {
        // check balance > amount
        require(balances[msg.sender] > amount, "balance is not enough"); 
        balances[msg.sender] -= amount;
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }

}