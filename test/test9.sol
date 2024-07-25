// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract TEST9 {
    /*
        흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 
        등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

        입력값을 받으면 그 입력값 안에 대문자, 
        소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 
        알려주는 함수를 구현하세요.
    */

    function checkPW(string memory _s) public pure returns(bool) {
        bytes memory bytesPW = bytes(_s);

        bool checkNumber;
        bool checkUppercase;
        bool checkLowercase;

        for (uint i=0; i<bytesPW.length; i++) {
            bytes1 bytePW = bytesPW[i];
            if (bytePW > 0x30 && bytePW <= 0x39) {
                checkNumber = true;
            } else if (bytePW >= 0x41 && bytePW <= 0x5A) {
                checkUppercase = true;
            } else if (bytePW >= 0x61 && bytePW <= 0x7A) {
                checkLowercase = true;
            }
        }

        return checkNumber && checkUppercase && checkLowercase;
    }
}