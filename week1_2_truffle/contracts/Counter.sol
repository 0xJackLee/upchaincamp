// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Counter {
  uint256 public counter;
  constructor(uint256 x) {
    counter = x;
  }

  function count() public {
    counter = counter + 1;
  }

  function add(uint256 x) public {
    counter += x;
  }
}
