// SPDX-License-Identifer:MIT;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract MyERC20ozV1 is ERC20Upgradeable {
    // 使用initilaizer修饰确保初始化函数只能被调用一次
    function initializable() external initializer {
        __ERC20_init("MyERC20", "MyERC20");
        _mint(msg.sender, 10000e18);
    }
}
