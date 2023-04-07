// SPDX-Identifier-MIT: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

interface TokenRecipient {
    function tokenReceived(address sender, uint amount) external returns (bool);
}

contract ERC20v2 is ERC20 {
    using AddressUpgradeable for address;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function balanceOfv2(
        address account
    ) public view returns (uint256, string memory) {
        return (ERC20.balanceOf(account), "erc20v2");
    }

    function mint(address account) public {
        _mint(account, 200);
    }

    // 带回调的转账
    function trnasferWithCallback(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(msg.sender, recipient, amount);

        if (recipient.isContract()) {
            // 执行目标合约回调
            bool rv = TokenRecipient(recipient).tokenReceived(
                msg.sender,
                amount
            );
            require(rv, "No tokensReceived");
        }

        return true;
    }
}
