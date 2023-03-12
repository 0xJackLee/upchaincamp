// Truffle 执行脚本
let Counter = artifacts.require("Counter")
module.exports = async function (callback) {
    let counter = await Counter.deployed()

    await counter.count()

    let value = await counter.counter()

    console.log("current counter value:" + value)
}