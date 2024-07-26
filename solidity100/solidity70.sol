// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q61 {
    /*
        a의 b승을 반환하는 함수를 구현하세요.
    */

    function squared(uint _a, uint _b) public pure returns(uint) {
        return _a ** _b;
    }
}

contract Q62 {
    /*
        2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 
        3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    */

    modifier underTen(uint _a, uint _b) {
        require(_a <= 10 && _b <= 10, "Inputs must be less than 10");
        _;
    }

    function add(uint _a, uint _b) public pure underTen(_a, _b) returns(uint) {
        return _a + _b;
    }

    function mul(uint _a, uint _b) public pure underTen(_a, _b) returns(uint) {
        return _a * _b;
    }

    function squared(uint _a, uint _b) public pure underTen(_a, _b) returns(uint) {
        return _a ** _b;
    }
}

contract Q63 {
    /*
        2개 숫자의 차를 나타내는 함수를 구현하세요.
    */

    function diff(uint _a, uint _b) public pure returns(uint) {
        return _a > _b ? _a - _b : _b - _a;
    }
}

contract Q64 {
    /*
        지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    */

    function splitBytes(address _addr) public pure returns(bytes4[5] memory) {
        bytes4[5] memory split;

        for (uint i=0; i<5; i++) {
            split[i] = bytes4(bytes20(_addr)[i * 4]) |
                (bytes4(bytes20(_addr)[i * 4 + 1]) >> 8) |
                (bytes4(bytes20(_addr)[i * 4 + 2]) >> 16) |
                (bytes4(bytes20(_addr)[i * 4 + 3]) >> 24);
        }
        return split;
    }
}

contract Q65 {
    /*
        1. 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
    
        예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자)
    */

    function getSquared(uint _a, uint _b, uint _c) public pure returns(uint, uint, uint) {
        return (_a ** 2, _b ** 2, _c ** 2);
    }

    function getMiddle(uint _a, uint _b, uint _c) public pure returns(uint) {
        (, uint _m, ) = getSquared(_a, _b, _c);
        return _m;
    }
}

contract Q66 {
    /*
        특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 
        추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    */

    function getTenDigit(uint _n) public pure returns(uint) {
        uint digit;
        while (_n > 0) {
            _n /= 10;
            digit ++;
        }
        return digit;
    }

    function getFiveDigit(uint _n) public pure returns(uint) {
        uint digit;
        while (_n > 0) {
            _n /= 5;
            digit ++;
        }
        return digit;
    }

}

// Q67
    /*
        자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
    
        B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
    */

    contract A {
        function getBalance() public view returns (uint) {
            return address(this).balance;
        }

        receive() external payable {}
    }

    contract B {
        function sendEther(address payable _to) public payable {
            require(msg.value > 0, "No money");
            _to.transfer(msg.value);
        }
    }

contract Q68 {
    /*
        계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
    
        예) 5 → 1*2*3*4*5 = 60, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
        
        while을 사용해보세요
    */

    function factorial(uint _n) public pure returns(uint) {
        uint result = 1;

        while (_n > 0) {
            result *= _n;
            _n -= 1;
        }

        return result;
    }

}

import "@openzeppelin/contracts/utils/Strings.sol";

contract Q69 {
    /*
        숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    
        힌트 : 7번 문제(시,분,초로 변환하기)
    */
    using Strings for uint;

    function uintToString(uint _a, uint _b, uint _c) public pure returns(string memory) {
        return string(abi.encodePacked(_a.toString(), " and ", _b.toString(), " or ", _c.toString()));
    }

}

contract Q70 {
    /*
        번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. 
        bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 
        고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    */

    struct Customer {
        uint number;
        string name;
        bytes32 hash;
    }

    Customer[] public customers;

    function setHash(uint _number, string memory _name) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_number, _name));
    }

    function setCustomer(string memory _name) public {
        uint _number = customers.length + 1;
        customers.push(Customer(_number, _name, setHash(_number, _name)));
    }

    function changeCustomer(uint _number, string memory _name) public {
        customers[_number-1].name = _name;
        customers[_number-1].hash = setHash(_number, _name);
    }
}