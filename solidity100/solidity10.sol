// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q1 {
    /* 
        더하기, 빼기, 곱하기, 나누기 그리고 제곱을 반환하는 계산기를 만드세요. 
    */
    function calc(uint _a, uint _b) public pure returns(uint, uint, uint, uint, uint) {
        require(_a>=_b, "The first input must bigger than the second input.");
        return (_a+_b, _a-_b, _a*_b, _a/_b, _a**2);
    }
}

contract Q2 {
    /* 
        2개의 Input값을 가지고 1개의 output값을 가지는 4개의 함수를 만드시오. 각각의 함수는 더하기, 빼기, 곱하기, 나누기(몫)를 실행합니다.
    */
    function add(uint _a, uint _b) public pure returns(uint) {
        return _a + _b;
    }

    function sub(uint _a, uint _b) public pure returns(uint) {
        require(_a>=_b, "The first input must bigger than the second input.");
        return _a - _b;
    }

    function mul(uint _a, uint _b) public pure returns(uint) {
        return _a * _b;
    }

    function div(uint _a, uint _b) public pure returns(uint) {
        return _a / _b;
    }
}

contract Q3 {
    /* 
        1개의 Input값을 가지고 1개의 output값을 가지는 2개의 함수를 만드시오. 
        각각의 함수는 제곱, 세제곱을 반환합니다.
    */
    function square(uint _n) public pure returns(uint) {
        return _n ** 2;
    }

    function cube(uint _n) public pure returns(uint) {
        return _n ** 3;
    }
}

contract Q4 {
    /* 
        이름(string), 번호(uint), 듣는 수업 목록(string[])을 담은 student라는 구조체를 만들고 
        그 구조체들을 관리할 수 있는 array, students를 선언하세요.
    */
    struct student {
        string name;
        uint number;
        string[] class;
    }

    student[] students;
}

contract Q5 {
    /* 
        아래의 함수를 만드세요
        1~3을 입력하면 입력한 수의 제곱을 반환받습니다.
        4~6을 입력하면 입력한 수의 2배를 반환받습니다.
        7~9를 입력하면 입력한 수를 3으로 나눈 나머지를 반환받습니다.
    */
    function ifCalc(uint _n) public pure returns(uint) {
        if (_n <= 3) {
            return _n ** 2;
        } else if (_n > 3 && _n <= 6) {
            return _n * 2;
        } else if (_n > 6 && _n <= 9) {
            return _n % 3;
        } else {
            return 0;
        }
    }
}

contract Q6 {
    /* 
        숫자만 들어갈 수 있는 array numbers를 만들고 
        그 array안에 0부터 9까지 자동으로 채우는 함수를 구현하세요.(for 문)
    */
    uint[] numbers;

    function setNum() public {
        for (uint i = 0; i < 10; i++) {
            numbers.push(i);
        }
    }

    // function getNum() public view returns(uint[] memory) {
    //     return numbers;
    // }
}

contract Q7 {
    /* 
        숫자만 들어갈 수 있는 array numbers를 만들고 
        그 array안에 0부터 5까지 자동으로 채우는 함수와 
        array안의 모든 숫자를 더한 값을 반환하는 함수를 각각 구현하세요.(for 문)
    */
    uint[] numbers;

    function setNum() public {
        for (uint i = 0; i <= 5; i++) {
            numbers.push(i);
        }
    }

    // function getNum() public view returns(uint[] memory) {
    //     return numbers;
    // }

    function sumNum() public view returns(uint) {
        uint sum;
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}

contract Q8 {
    /* 
        아래의 함수를 만드세요
        1~10을 입력하면 “A” 반환받습니다.
        11~20을 입력하면 “B” 반환받습니다.
        21~30을 입력하면 “C” 반환받습니다.
    */
    function ifABC(uint _n) public pure returns(string memory) {
        if (_n > 0 && _n <= 10) {
            return "A";
        } else if (_n > 10 && _n <= 20) {
            return "B";
        } else if (_n > 20 && _n <= 30) {
            return "C";
        } else {
            return "";
        }
    }
}

contract Q9 {
    /* 
        문자형을 입력하면 bytes 형으로 변환하여 반환하는 함수를 구현하세요.
    */
    function stringToBytes(string memory _s) public pure returns(bytes memory) {
        return abi.encodePacked(_s);
    }

    function stringToBytes2(string memory _s) public pure returns(bytes memory) {
        return bytes(_s);
    }
}

contract Q10 {
    /* 
        숫자만 들어가는 array numbers를 선언하고 
        숫자를 넣고(push), 빼고(pop), 특정 n번째 요소의 값을 볼 수 있는(get)함수를 구현하세요.
    */
    uint[] numbers;

    function pushNum(uint _n) public {
        numbers.push(_n);
    }

    function popNum() public {
        numbers.pop();
    }

    function getNum(uint _n) public view returns(uint) {
        return numbers[_n-1];
    }

    // function getNumbers() public view returns(uint[] memory) {
    //     return numbers;
    // }
}