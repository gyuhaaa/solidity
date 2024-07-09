// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

/*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    * 가장 점수가 낮은 사람의 정보를 보여주는 기능,
    * 총 점수 합계, 총 점수 평균을 보여주는 기능,
    * 특정 학생을 반환하는 기능 -> 학생 정보
    ---------------------------------------------------
    * 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
*/
contract TEST2 {
    struct Student {
        uint number;
        string name;
        uint score;
    }

    Student[] students;

    function addStudent(string memory _name, uint _score) public {
        uint _number = students.length + 1;
        students.push(Student(_number, _name, _score));
    }

    function setStudent() public {
        addStudent("gyuseon", 85);
        addStudent("gyu", 100);
        addStudent("seon", 70);
    }

    // 가장 점수가 낮은 사람의 정보를 보여주는 기능
    function getLowestStudent() public view returns (Student memory) {
        require(students.length > 0, "No students");
        Student memory lowest = students[0];
        for (uint i=1; i < students.length; i++) {
            if (students[i].score < lowest.score) {
                lowest = students[i];
            }
        }
        return lowest;
    }

    // 총 점수 합계, 총 점수 평균을 보여주는 기능
    function getSumScore() public view returns (uint) {
        uint sumScore = 0;
        for (uint i=0; i < students.length; i++) {
            sumScore += students[i].score;
        }
        return sumScore;
    }

    function getAvgScore() public view returns (uint) {
        require(students.length > 0, "No students");
        return getSumScore() / students.length;
    }

    // 특정 학생을 반환하는 기능 -> 학생 정보
    function getStudentByNum(uint _n) public view returns (Student memory) {
        require(_n > 0 && _n <= students.length, "(1) Number must be greater than 0 (2) No student");
        return students[_n - 1];
    }

    // 학생 전체를 반환하는 기능
    function getAllStudents() public view returns (Student[] memory) {
        return students;
    }
}