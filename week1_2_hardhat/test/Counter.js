const { expect } = require("chai");

let counter;


let account1;
describe("Counter", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
 
  async function init(){
    const [owner, otherAccount] = await ethers.getSigners();
    const Counter = await ethers.getContractFactory("Counter");
    counter = await Counter.deploy(1);
    await counter.deployed()
    account1 = otherAccount;

    console.log("counter:" + counter.address);
  }

  before(async function () {
    await init();
  })

  it("init equal 1", async function() {
    expect(await counter.counter()).to.equal(1);
  })

  it("add 1 equal 2", async function() {
    await counter.add(1);
    expect(await counter.counter()).to.equal(2);
  })

  it("count_success", async function () {
    await counter.count();
    // 不指定会用默认账户
    expect(await counter.counter()).to.equal(3)
  })

  it("count_fail", async function () {
    // 连接新的账户
    let counter2 = counter.connect(account1);
    expect(await counter2.counter()).to.equal(3);
  })
  
});
