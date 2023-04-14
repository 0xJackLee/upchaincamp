// 引入hardhat库实现upgrades
const {
    ethers,
    upgrades
} = require("hardhat");


const {
    getImplementationAddress
} = require('@openzeppelin/upgrades-core');


async function main() {
    const MyERC20ozV1 = await ethers.getContractFactory("MyERC20ozV1");

    const instance = await upgrades.deployProxy(MyERC20ozV1)
    await instance.deployed()

    let currentImplAddressV1 = await getImplementationAddress(ethers.provider, instance.address)

    console.log('implAddressV1', currentImplAddressV1)
    console.log('proxyAddress', instance.address)

    const MyERC20ozV2 = await ethers.getContractFactory("MyERC20ozV2");

    const upgraded = await upgrades.upgradeProxy(instance.address, MyERC20ozV2);

    let currentImplAddressV2 = await getImplementationAddress(ethers.provider, upgraded.address)

    console.log('implAddressV2', currentImplAddressV2)
    console.log('proxyAddress', upgraded.address)

    console.log(`Please verify AppController: npx hardhat verify ${currentImplAddressV2}`)

}


main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
})