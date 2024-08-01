// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract TEST12 {
    /*
        가능한 모든 것을 inline assembly로 진행하시면 됩니다.
        1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
        2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
        3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
        4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
        5. number의 k번째 요소를 반환하는 함수를 구현하세요.
        6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
    */
    uint[] number;
    uint[4] number2;

    // 1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
    function setNumber(uint _n) public {
        assembly {
            sstore(number.slot, 0)

            for { let i:=1 } lt(i, add(_n, 1)) { i:=add(i,1) } {
                let length := sload(number.slot)
                sstore(add(keccak256(number.slot, 32), length), i)
                sstore(number.slot, add(length, 1))
            }
        }
    }

    // 2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
    function setNumber2(uint _a, uint _b, uint _c, uint _d) public {
        assembly {
            sstore(add(number2.slot, 0), _a)
            sstore(add(number2.slot, 1), _b)
            sstore(add(number2.slot, 2), _c)
            sstore(add(number2.slot, 3), _d)
        }
    }

    // 3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요.
    function sumNumber() public view returns (uint sum) {
        assembly {
            let length := sload(number.slot)
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                sum := add(sum, sload(add(keccak256(number.slot, 32), i)))
            }
        }
    }


    // 4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요.
    function sumNumber2() public view returns (uint sum) {
        assembly {
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                sum := add(sum, sload(add(number2.slot, i)))
            }
        }
    }

    // 5. number의 k번째 요소를 반환하는 함수를 구현하세요.
    function getNumberK(uint k) public view returns (uint element) {
        assembly {
            let length := sload(number.slot)
            if lt(k, length) {
                element := sload(add(keccak256(number.slot, 32), k))
            }
        }
    }

    // 6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
    function getNumber2K(uint k) public view returns (uint element) {
        assembly {
            if lt(k, 4) {
                element := sload(add(number2.slot, k))
            }
        }
    }
}