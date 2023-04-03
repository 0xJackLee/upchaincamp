// SPDX-Licnese-Identifier: MIT

// ERC20Permit
// 使用EIP2612的标准Token
// 链下签名授权， 授权可以在线下签名进行，签名信息可以在执行接收转账交易时提交到链上，让授权和转账在一笔交易里完成
// 同时转账交易也可以由接受方（或第三方）来提交，解决平台用户无ETH付gas情况

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MyERC20Permit is ERC20Permit {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        _mint(msg.sender, 1000e18);
    }
}
