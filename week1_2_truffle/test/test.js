let Counter= artifacts.require("Counter")

contract("Counter", function(accounts) {
    let counterInstance;
    // it指定一个测试用例
    it("Counter", function() {
        return Counter.deployed().then(function(instance){
            counterInstance = instance;
            return counterInstance.count();
        }).then(function() {
            return counterInstance.counter();
        }).then(function (count) {
            // 满足断言则测试用例通过
            assert.equal(count, 2); 
        })
    })
})