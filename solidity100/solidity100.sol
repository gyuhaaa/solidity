 // SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;


contract Q91 {
    /*
        배열에서 특정 요소를 없애는 함수를 구현하세요. 
        예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */
    uint[] public array = [4,3,2,1,8];

    function removeElement(uint _n) public {
        require(_n < array.length, "Index out of bounds");
        
        for (uint i=_n; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        array.pop();
    }
}

contract Q92 {
    /*
        특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */
    function isCA(address _addr) public view returns(bool) {
        return _addr.code.length > 0;
    }
}

contract Q93 {
    /*
        다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
        input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */
    function callFunction(address _contract, bytes4 _methodId, uint256 _n, address _addr) public returns (bool success, bytes memory result) {
        (success, result) = _contract.call(abi.encodeWithSelector(_methodId, _n, _addr));
    }
}

contract Q94 {
    /*
        inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */
    function add(uint256 _a, uint256 _b) public pure returns (uint256 result) {
        assembly {
            result := add(_a, _b)
        }
    }

    function sub(uint256 _a, uint256 _b) public pure returns (uint256 result) {
        assembly {
            result := sub(_a, _b)
        }
    }

    function mul(uint256 _a, uint256 _b) public pure returns (uint256 result) {
        assembly {
            result := mul(_a, _b)
        }
    }

    function div(uint256 _a, uint256 _b) public pure returns (uint256 result) {
        require(_b != 0, "Division by zero");
        assembly {
            result := div(_a, _b)
        }
    }
}

contract Q95 {
    /*
        inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    */
    function add(uint256 _a, uint256 _b, uint256 _c) public pure returns (uint256 result) {
        assembly {
            result := add(add(_a, _b), _c)
        }
    }

    function mul(uint256 _a, uint256 _b, uint256 _c) public pure returns (uint256 result) {
        assembly {
            result := mul(mul(_a, _b), _c)
        }
    }
}

contract Q96 {
    /*
        inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */
    function minMax(uint _a, uint _b, uint _c, uint _d) public pure returns (uint min, uint max) {
        assembly {
            min := _a
            max := _a

            if lt(_b, min) { min := _b }
            if gt(_b, max) { max := _b }

            if lt(_c, min) { min := _c }
            if gt(_c, max) { max := _c }

            if lt(_d, min) { min := _d }
            if gt(_d, max) { max := _d }
        }
    }
}

contract Q97 {
    /*
        inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
    */
    uint[] numbers;

    function push(uint _n) public {
        assembly {
            let length := sload(numbers.slot)
            let arraySlot := keccak256(add(numbers.slot, 0x20), 0x20)

            sstore(add(arraySlot, length), _n)
            sstore(numbers.slot, add(length, 1))
        }
    }

    function pop() public {
        assembly {
            let length := sload(numbers.slot)

            if iszero(length) {
                revert(0, 0)
            }

            let arraySlot := keccak256(add(numbers.slot, 0x20), 0x20)

            sstore(add(arraySlot, sub(length, 1)), 0)
            sstore(numbers.slot, sub(length, 1))
        }
    }

    function getNumbers() public view returns (uint[] memory _numbers) {
        assembly {
            let length := sload(numbers.slot)

            _numbers := mload(0x40)
            mstore(_numbers, length)

            let arraySlot := keccak256(add(numbers.slot, 0x20), 0x20)

            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                mstore(add(_numbers, mul(add(i, 1), 0x20)), sload(add(arraySlot, i)))
            }

            mstore(0x40, add(_numbers, mul(add(length, 1), 0x20)))
        }
    }
}

contract Q98 {
    /*
        inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
    */
    string public letter;

    function setLetter(string memory _letter) public {
        assembly {
            let length := mload(_letter)
            let ptr := add(_letter, 0x20)
            let size := shl(1, length)
            
            switch lt(length, 32)
            case 1 {
                sstore(letter.slot, or(mload(ptr), size))
            }
            default {
                sstore(letter.slot, add(size, 1))
                mstore(0x00, letter.slot)
                let nSlot := keccak256(0x00, 0x20)
                
                for { let i := 0 } lt(i, length) { i := add(i, 0x20) } {
                    sstore(nSlot, mload(add(ptr, i)))
                    nSlot := add(nSlot, 1)
                }
                
                let lastSlot := mload(add(ptr, sub(length, mod(length, 0x20))))
                sstore(nSlot, lastSlot)
            }
        }
    }
}

contract Q99 {
    /*
        inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
    */
    bytes4 public b;
    
    function setB(bytes4 _b) public {
        assembly {
            sstore(b.slot, shr(224, _b))
        }
    }
}

contract Q100 {
    /*
        inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
    */
    bytes public b;
    
    function setB(bytes memory _b) public {
        assembly {
            let length := mload(_b)
            let ptr := add(_b, 0x20)
            let size := shl(1, length)
            
            switch lt(length, 32)
            case 1 {
                sstore(b.slot, or(mload(ptr), size))
            }
            default {
                sstore(b.slot, add(size, 1))
                mstore(0x00, b.slot)
                let nSlot := keccak256(0x00, 0x20)
                
                for { let i := 0 } lt(i, length) { i := add(i, 0x20) } {
                    sstore(nSlot, mload(add(ptr, i)))
                    nSlot := add(nSlot, 1)
                }
                
                let lastSlot := mload(add(ptr, sub(length, mod(length, 0x20))))
                sstore(nSlot, lastSlot)
            }
        }
    }
}
