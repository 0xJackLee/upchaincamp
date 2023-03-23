const {
    expect
} = require("chai");

let score;

let teacher;
let student;

describe("Score", function () {
    async function init() {
        const [owner, teacherAccount, studentAccount] = await ethers.getSigners();
        const Score = await ethers.getContractFactory("Score");
        score = await Score.deploy();
        await score.deployed();
        await score.setTeacher(teacherAccount.address)
        teacher = teacherAccount;
        student = studentAccount;
    }

    before(async function () {
        await init();
    })

    it("init with teacher address", async () => {
        expect(await score.teacher()).to.equal(teacher.address);
        console.log(await score.teacher());
        console.log(teacher.address)
    })

    it("should only teacher add new score", async () => {
        try {
            await score.newScore(student.address, 1);
        } catch (error) {
            console.log('transaction reverted');
            // add score failed
            expect(await score.scores(student.address)).to.equal(0);
        }
    })

    it("should only teacher change score", async () => {
        try {
            await score.changeScore(student, 1);
        } catch (error) {
            console.log('transaction reverted');
            // change score failed
            expect(await score.scores(student.address)).to.equal(0);
        }
    })
})