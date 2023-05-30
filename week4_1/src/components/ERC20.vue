<script setup>
// 改成setup
import { ethers } from "ethers";

import erc2612Addr from "../../deployments/dev/ERC2612.json";
import erc2612Abi from "../../deployments/abi/ERC2612.json";

import bankAddr from "../../deployments/dev/Bank.json";
import bankAbi from "../../deployments/abi/Bank.json";

import ethBankAbi from "../../deployments/abi/EthBank.json";
import ethBankAddr from "../../deployments/dev/EthBank.json";

import { ref, reactive } from "vue";

const state = reactive({
  account: null, // 账户
  recipient: null, // 接受者
  amount: null, // 数量
  ethAmount: null,
  balance: null, //
  ethbalance: null, //eth余额

  name: null,
  decimal: null,
  symbol: null,
  supply: null,

  stakeAmount: null,
});

let provider;
let signer;
let erc20Token;
let bank;
let ethBank;

async function connect() {
  await initProvider();
  await initAccount();

  // 如果获取到了账号,进行合约初始化，并读取合约数据
  if (state.account) {
    initContract();
    readContract();
  }
}

async function initProvider() {
  if (window.ethereum) {
    console.log(ethers);
    // provider = new ethers.providers.Web3Provider(window.ethereum);
    // provider = new ethers.getDefaultProvider()
    provider = new ethers.BrowserProvider(window.ethereum);

    console.log(provider);
    let network = await provider.getNetwork();
    console.log(network);
    state.chainId = network.chainId;
    console.log("chainId:", state.chainId);
  } else {
    console.log("Need install MetaMask");
  }
}

async function initAccount() {
  try {
    let accounts = await provider.send("eth_requestAccounts", []);
    console.log("accounts:" + accounts);
    state.account = accounts[0];

    signer = await provider.getSigner();
    console.log(signer);
  } catch (error) {
    console.log("User denied account access", error);
  }
}

async function initContract() {
  console.log(signer);
  erc20Token = new ethers.Contract(erc2612Addr.address, erc2612Abi, signer);

  bank = new ethers.Contract(bankAddr.address, bankAbi, signer);
  ethBank = new ethers.Contract(ethBankAddr.address, ethBankAbi, signer);
  console.log("ethBank", ethBank);
}

async function readContract() {
  provider.getBalance(state.account).then((r) => {
    // 将一个值变成带小数点的类型
    state.ethbalance = ethers.formatUnits(r, 18);
  });
  erc20Token.name().then((r) => {
    state.name = r;
  });
  erc20Token.name().then((r) => {
    state.name = r;
  });
  erc20Token.decimals().then((r) => {
    state.decimal = r;
  });
  erc20Token.symbol().then((r) => {
    state.symbol = r;
  });
  erc20Token.totalSupply().then((r) => {
    state.supply = ethers.formatUnits(r, 18);
  });

  erc20Token.balanceOf(state.account).then((r) => {
    console.log(state.balance);
    state.balance = ethers.formatUnits(r, 18);
  });
}

function transfer() {
  // 将一个值变成不带小数点的类型 实际数值为 amount*e18
  let amount = ethers.parseUnits(state.amount, 18);
  //   signer.sendTransaction({
  //     to: state.recipient,
  //     value: 100,
  //   });
  erc20Token.transfer(state.recipient, amount).then(async (r) => {
    console.log(r); // 返回值不是true
    await readContract();
  });
}

function deposit() {
  console.log(state.ethAmount);
  let amount = ethers.parseEther(state.ethAmount);
  ethBank.deposit({ value: amount }).then((r) => {
    console.log(r);
  });
}

async function transferEth() {
  console.log(signer);
  console.log(state.ethAmount);
  let ethAmount = ethers.parseEther(state.ethAmount);
  await signer.sendTransaction({
    to: state.recipient,
    value: ethAmount,
  });
  console.log(ethAmount);
}

// ERC2612 存款
async function permitDeposit() {
  // let nonce = await erc20Token.nonces(state.account);
  // console.log(nonce)
  let nonce = 0;
  // 当前时间加上20分钟后的时间戳   Math.ceil将结果返回四舍五入最近的整数
  let deadline = Math.ceil(Date.now() / 1000) + parseInt(20 * 60);

  let amount = ethers.parseUnits(state.stakeAmount).toString();

  //  signTypedData限定的格式
  // 这些信息会在用户签名的时候显示
  const domain = {
    name: "ERC2612",
    version: "1",
    chainId: state.chainId,
    verifyingContract: erc2612Addr.address,
  };

  // 消息格式 与ERC2612合约中的PERMIT_TYPEHASH类型保持一致
  const types = {
    Permit: [
      { name: "owner", type: "address" }, // 持有者
      { name: "spender", type: "address" }, // 要允许花费的人
      { name: "value", type: "uint256" }, // 要允许发送的数量
      { name: "nonce", type: "uint256" }, // 随机数
      { name: "deadline", type: "uint256" }, // 签名到期时间
    ],
  };

  // 消息内容的具体值
  const message = {
    owner: state.account,
    spender: bankAddr.address,
    value: amount,
    nonce: nonce,
    deadline: deadline,
  };

  const signature = await signer.signTypedData(domain, types, message);
  // console.log(splitSig);
  console.log(signature);

  // const { v, r, s } = ethers.splitSignature(signature);
  // const splitSig = ethers.Signature.from(signature);
  // console.log(splitSig);
  // console.log(splitSig.v);
  // console.log(splitSig.r);
  // console.log(splitSig.s);
  const { v, r, s } = ethers.Signature.from(signature);
  // let sigBytes = ethers.Signature.from(splitSig).serialized;
  // console.log(sigBytes);
  console.log(v);
  console.log(r);
  console.log(s);
  try {
    let tx = await bank.permitDeposit(state.account, amount, deadline, v, r, s);

    let receipt = await tx.wait();
    readContract();
  } catch (e) {
    console.log(e);
    alert("Error , please check the console log:", e);
  }
}
</script>

<template>
  <div>
    <button @click="connect">链接钱包</button>
    <div>我的地址 : {{ state.account }}</div>
    <div>
      <br />
      Token 名称 : {{ state.name }} <br />
      Token 符号 : {{ state.symbol }} <br />
      Token 精度 : {{ state.decimal }} <br />
      Token 发行量 : {{ state.supply }} <br />
      我的 Token 余额 : {{ state.balance }} <br />
      我的ETH余额 : {{ state.ethbalance }}
    </div>

    <div
      style="border-bottom: 1px solid black; width: 100%; margin: 10px 0"
    ></div>

    <div>
      recipient: {{ state.recipient }}<br />
      转账ERC20到:
      <input type="text" v-model="state.recipient" />
      <br />转账ERC20金额
      <input type="text" v-model="state.amount" />
      <br />
      <button @click="transfer">转账ERC20</button>
    </div>

    <div
      style="border-bottom: 1px solid black; width: 100%; margin: 10px 0"
    ></div>

    <div>
      转账ETH到:
      <input type="text" v-model="state.recipient" />
      <br />转账ETH数量
      <input type="text" v-model="state.ethAmount" />
      <br />
      <button @click="transferEth">转账ETH</button>
    </div>

    <div>
      <input v-model="state.stakeAmount" placeholder="输入质押量" />
      <button @click="permitDeposit">离线授权存款</button>
    </div>

    <div
      style="border-bottom: 1px solid black; width: 100%; margin: 10px 0"
    ></div>
    <div>
      存款eth: 存款eth数量
      <input type="text" v-model="state.ethAmount" />
      <br />
      <button @click="deposit">确定存款</button>
    </div>
  </div>
</template>

<style scoped>
h1 {
  font-weight: 500;
  font-size: 2.6rem;
  top: -10px;
}

h3 {
  font-size: 1.2rem;
}

.greetings h1,
.greetings h3 {
  text-align: center;
}

div {
  font-size: 1.2rem;
}

@media (min-width: 1024px) {
  .greetings h1,
  .greetings h3 {
    text-align: left;
  }
}
</style>
