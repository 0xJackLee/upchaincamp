// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Score {
    // scores
    mapping(address => uint8) public scores;
    address public teacher;

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only has teacher role can do this!");
        _;
    }

    function newScore(address student, uint8 score) public onlyTeacher {
        require(score <= 100, "max score is 100");
        scores[student] = score;
    }

    function changeScore(address student, uint8 score) public onlyTeacher {
        require(score <= 100, "max score is 100");
        scores[student] = score;
    }

    function setTeacher(address teacherAccount) public {
        teacher = teacherAccount;
    }
}
