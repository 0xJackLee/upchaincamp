const {
    expect
} = require("chai");
const {
    ethers
} = require("hardhat");

let score;
let teacher;


describe("Teacher", function () {
    let normalUser;

    async function init() {
        const [owner, otherAccount] = await ethers.getSigners();


        const Teacher = await ethers.getContractFactory('Teacher');
        const Score = await ethers.getContractFactory('Score');
        score = await Score.deploy()
        await score.deployed();

        teacher = await Teacher.deploy(score.address);
        await teacher.deployed();

        //设置teacher地址
        await score.setTeacher(teacher.address);

        normalUser = otherAccount;
    }

    before(async function () {
        await init();
    });

    it("init with teacher contract address", async () => {
        expect(await score.teacher()).to.equal(teacher.address);
    })


    it("should only teacher add new score", async () => {
        // 用户调用score添加分数失败
        try {
            await score.newScore(normalUser.address, 100)
        } catch {
            console.log('transaction reverted');
            expect(await score.scores(normalUser.address)).to.equal(0);
        }

        // 只有Teacher合约用户才能添加
        await teacher.addStudentScore(normalUser.address, 100)
        expect(await score.scores(normalUser.address)).to.equal(100);
    })

    it("should only teacher change score", async () => {
        // 用户调用score修改分数失败
        try {
            await score.changeScore(normalUser.address, 88)
        } catch {
            console.log('transaction reverted');
            expect(await score.scores(normalUser.address)).to.equal(100);
        }

        // 只有Teacher合约用户才能修改
        await teacher.changeStudentScore(normalUser.address, 87)
        expect(await score.scores(normalUser.address)).to.equal(87);

    })

})