// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/Counter.sol";


// 使用 solidity-scripting 部署合约
// 创建一个名为 CounterScript 的合约，它从 Forge Std 继承了 Script
contract CounterScript is Script {
    function setUp() public {}

    // 默认情况下，脚本是通过调用名为 run 的函数（入口点）来执行的部署。
    function run() public {
        // 从 .env 文件中加载助记词，并推导出部署账号，
        //如果 .env 配置的是私钥，这使用uint256 deployer = vm.envUint("PRIVATE_KEY"); 
        string memory mnemonic = vm.envString("MNEMONIC");
        (address deployer, ) = deriveRememberKey(mnemonic, 0);
        // 这是一个作弊码，表示使用该密钥来签署交易并广播。
        vm.startBroadcast(deployer);
        // 创建合约
        Counter c = new Counter(1);
        console2.log("Counter deployed on %s", address(c));
        vm.stopBroadcast();

    }
}
