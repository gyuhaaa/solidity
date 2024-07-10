// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q21 {
    /* 
        3의 배수만 들어갈 수 있는 array를 구현하세요.
    */
    uint[] multiplesOfThree;

    function addMultiplesOfThree(uint _n) public {
        require(_n % 3 == 0, "Only multiples of 3");
        multiplesOfThree.push(_n);
    }

    function getMultiplesOfThree() public view returns(uint[] memory) {
        return multiplesOfThree;
    }
}

contract Q22 {
    /* 
        2. 뺄셈 함수를 구현하세요. 
        임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.   
        예) 2,5 input → 5-2=3(output)
    */
    function sub(uint _a, uint _b) public pure returns(uint) {
        if (_a >= _b) {
            return _a - _b;
        } else {
            return _b - _a;
        }
    }
}

contract Q23 {
    /* 
        3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 
        나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    */
    function ABC(uint _n) public pure returns(string memory) {
        if (_n % 3 == 0) {
            return "A";
        } else if (_n % 3 == 1) {
            return "B";
        } else {
            return "C";
        }
    }

}

contract Q24 {
    /* 
        string을 input으로 받는 함수를 구현하세요. 
        “Alice”가 들어왔을 때에만 true를 반환하세요.
    */
    function checkBob(string memory _s) public pure returns(bool) {
        return keccak256(abi.encodePacked(_s)) == keccak256(abi.encodePacked("Alice"));
    }
}

contract Q25 {
    /* 
        배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
    */
    uint[] A;

    function setA(uint _n) public {
        for (uint i=_n+1; i>0; i--) {
            A.push(i-1);
        }
    }

    function getA() public view returns(uint[] memory) {
        return A;
    }

    function initA() public {
        delete A;
    }
}

contract Q26 {
    /* 
        홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 
        숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    */
    uint[] Odd;
    uint[] Even;

    function setOddEven(uint _n) public {
        if (_n % 2 == 0) {
            Even.push(_n);
        } else {
            Odd.push(_n);
        }
    }

    function getOdd() public view returns(uint[] memory) {
        return Odd;
    }
    
    function getEven() public view returns(uint[] memory) {
        return Even;
    }
}

contract Q27 {
    /* 
        string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 
        해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    */
    mapping (string => bytes32) a;

    function setA(string memory _s, bytes32 _b) public {
        a[_s] = _b;
    }

    function deleteA(string memory _s) public {
        delete a[_s];
    }

    function getA(string memory _s) public view returns(bytes32) {
        return a[_s];
    }
}

contract Q28 {
    /* 
        ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    */
    function hash(string memory _id, string memory _pw) public pure returns(bytes32, bytes32) {
        return (keccak256(abi.encodePacked(_id)), keccak256(abi.encodePacked(_pw)));
    }
}

contract Q29 {
    /* 
        숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    */
    uint a;
    string b;
    constructor() {
        a = 10;
        b = "A";
    }

    function getAB() public view returns(uint, string memory) {
        return (a, b);
    }
}

contract Q30 {
    /* 
        10. 임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
        (sorting 코드 응용 → 약간 까다로움)
    
        예 : [2,6,7,4,5,1,9] → [9,7,6,5,4,2,1]
    */
    function decending(uint[] memory _numbers) public pure returns(uint[] memory) {
        for(uint i=0; i<_numbers.length; i++) {
            for(uint j=i+1; j<_numbers.length; j++) {
                if(_numbers[i] < _numbers[j]) {
                    (_numbers[i], _numbers[j]) = (_numbers[j], _numbers[i]);
                }
            }
        }

        return _numbers;
    }
}