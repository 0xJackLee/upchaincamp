// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 实际使用：通过Openzeppelin库实现可升级合约
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

// 由于逻辑合约中的构造函数无效 这里继承oz的Initialize合约实现初始化
contract CounterWithOz is Initializable {

    uint private counter;

    function initialize(uint256 _x) public initializer {
        counter = _x;
    }

    function add(uint256 i) public {
        counter += i;
    }

    function get() public view returns(uint) {
        return counter;
    }

}