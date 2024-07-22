// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract TEST6 {
    /*
        숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
        예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2
        --------------------------------------------------------------------------------------------
        문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
        예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f
    */

    function numberDetail(uint _n) public pure returns (uint, uint[] memory) {
        uint temp = _n;
        uint length;

        while (temp != 0) {
            length++;
            temp /= 10;
        }

        temp = _n;
        uint[] memory detail = new uint[](length);
        
        for (uint i=length; i>0; i--) {
            detail[i-1] = temp % 10;
            temp /= 10;
        }

        return (length, detail);
    }

    function stringDetail(string memory _s) public pure returns (uint, string[] memory) {
        uint length = bytes(_s).length;
        string[] memory detail = new string[](length);

        for (uint i=0; i<length; i++) {
            detail[i] = string(abi.encodePacked(bytes(_s)[i]));
        }

        return (length, detail);
    }
}