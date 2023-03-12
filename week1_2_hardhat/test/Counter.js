const { expect } = require("chai");

let counter;

describe("Counter", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
 
  async function init(){
    const [owner, otherAccount] = await ethers.getSigners();
    const Counter = await ethers.getContractFactory("Counter");
    counter = await Counter.deploy(1);
    await counter.deployed()

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
  

});
