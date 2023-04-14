// 引入hardhat库实现upgrades
const {
    ethers,
    upgrades
} = require("hardhat");


const {
    getImplementationAddress
} = require('@openzeppelin/upgrades-core');

async function main() {

    const CounterWithOz = await ethers.getContractFactory("CounterWithOz");
    // 返回代理合约
    const instance = await upgrades.deployProxy(CounterWithOz, [11]);
    await instance.deployed();

    // instance.address指向代理合约地址

    // hardhat-upgrades部会先部署逻辑合约
    // 部署代理TransparentUpgradeableProxy
    // 部署代理管理员 ProxyAdmin 用于执行upgradeTo


    // Upgrading
    const CounterWithOz2 = await ethers.getContractFactory("CounterWithOz2");
    // upgraded指向代理合约
    const upgraded = await upgrades.upgradeProxy(instance.address, CounterWithOz2);
    // 获取逻辑合约地址 由于实现合约的地址是动态计算的，因此您无法直接获取实现合约的地址。
    let currentImplAddress = await getImplementationAddress(ethers.provider, upgraded.address);
    // let currentImplAddress = await getImplementationAddress(ethers.provider, instance.address);
    console.log('implAddress', currentImplAddress)
    console.log('proxyAddress', upgraded.address)
    console.log(`Please verify AppController: npx hardhat verify ${currentImplAddress} `);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });