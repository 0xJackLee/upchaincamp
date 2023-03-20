// 使用 chai 断言库来验证合约的行为是否正确
const {
    expect
} = require("chai");

let bank;

describe("Bank", function () {
    let notOwnerAccount;
    let ownerAccount

    async function init() {
        const [owner, otherAccount] = await ethers.getSigners();
        const Bank = await ethers.getContractFactory("Bank");
        bank = await Bank.deploy();
        await bank.deployed();
        notOwnerAccount = otherAccount;
        ownerAccount = owner
        console.log("Bank:" + bank.address);
    }

    before(async function () {
        await init();
    })

    it("init deposit amount 0", async function () {
        expect(await bank.amount()).to.equal(0);
    })

    // 测试存款
    it("should get right deposit amount ", async () => {
        await bank.deposit({
            value: 100
        });
        expect(await bank.amount()).to.equal(100);
    })

    // 测试获取余额
    it("should allow deposits", async () => {
   
        let old_balance= await bank.getBalance()

        await bank.deposit({
            value: 100
        })

        expect(await bank.getBalance()).to.equal(200);

        // 获取帐户余额
        console.log(await ethers.provider.getBalance(ownerAccount.address));
        // 测试总量是否增加
        expect(await bank.amount()).to.equal(parseInt(old_balance) + 100)
    })

    // 测试取款
    it("should withdraw", async () => {
        // .equal和.to.equal方法都能用于比较两个库是否相等
        // 区别在于 .to.equal方法是Chai库中的方法 更加灵活且需要额外显式引用Chai库 
        // .equal是Mocha框架自带的方法，不用显式引入
        let old_balance = await bank.getBalance()
        let old_amount = await bank.amount()
        await bank.withdraw(100)

        expect(await bank.getBalance()).equal(old_balance - 100);
        // 总量检测
        expect(await bank.amount()).to.equal(old_amount - 100)
    })

    // 测试rug
    it("should owner get all", async () => {
        await bank.deposit({
            value: 100
        })
        console.log('balance', await bank.getBalance())
        await bank.rug();
        expect(await bank.amount()).to.equal(0)
    })


})