// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IScore {
    
    function newScore(address student, uint8 score) external;

    function changeScore(address student, uint8 score) external;
}