// SPDX-Identifier-MIT: MIT

pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
contract ERC20v1 is ERC20Upgradeable {

    // 逻辑合约中的构造函数无效 
    // constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    // 可以通过新的方式对逻辑合约进行初始化 如
    // function init () {}

    function balanceOfv1(
        address account
    ) public view returns (uint256, string memory) {
        return (ERC20Upgradeable.balanceOf(account), "erc20v1");
    }

    function mint(address account) public {
        _mint(account, 100);
    }
}
