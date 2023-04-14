// SPDX-License-Identier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

interface TokenRecipient {
    function tokenReceived(address sender, uint amount) external returns (bool);
}

contract MyERC20ozV2 is ERC20Upgradeable {
    using AddressUpgradeable for address;

    function transferWithCallback(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(msg.sender, recipient, amount);

        if (recipient.isContract()) {
            bool rv = TokenRecipient(recipient).tokenReceived(
                msg.sender,
                amount
            );
            require(rv, "No tokenReceived");
        }

        return true;
    }
}
