// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// 引入 Forge 标准库 的 Test 合约，并让测试合约继承 Test 合约， 这是使用 Forge 编写测试的首选方式。
import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    // 初始化
    function setUp() public {
        counter = new Counter(1);
        // counter.setNumber(0);
    }

    // 以test为前缀的测试用例
    function testInitEqual1() public {
        // 测试用例中使用 assertEq 断言判断相等。
        assertEq(counter.counter(), 1);
    }

    function testAdd1Equal2() public {
        counter.add(1);
        assertEq(counter.counter(), 2);
    }

    // 它使用了基于属性的模糊测试， forge 模糊器默认会随机指定256个值运行测试。
    function testAdd(uint256 x) public {
        if (x < 1e18) {
            console2.log(x);
            counter.add(x);
            console2.log(counter.counter());
            assertEq(counter.counter(), 1 + x);
        }
    }

}
