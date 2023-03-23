// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IScore.sol";

contract Teacher {
    
    IScore Score; 

    constructor (address scoreAddress) {
        Score = IScore(scoreAddress);
    }

    function addStudentScore(address student, uint8 score) public {
        Score.newScore(student, score);
    }

    function changeStudentScore(address student, uint8 score) public {
        Score.changeScore(student, score);
    }
}
