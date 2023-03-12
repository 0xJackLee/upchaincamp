require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.4",
  // 配置网络
  network: {
    // 本地网络配置
    development: {
      url: "http://127.0.0.1:8545",
      chainId: 31337
    }
  }
};