require("@nomicfoundation/hardhat-toolbox");

// const mnemonic = process.env.MNEMONIC
// const scankey = process.env.ETHERSCAN_API_KEY
let dotenv = require('dotenv')

dotenv.config({
  path: "./.env"
})
const PRIVATE_KEY1 = process.env.PRIVATEKEY;
const scankey = process.env.ETHERSCAN_API_KEY;
// console.log(PRIVATE_KEY1)

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.4",
  // 配置网络
  networks: {
    // 本地网络配置
    development: {
      url: "http://127.0.0.1:8545",
      chainId: 31337
    },
    // goerli测试网
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/demo",
      accounts: [PRIVATE_KEY1],
      chainId: 11155111
    }
  },
  etherscan: {
    apiKey: scankey
  }

}