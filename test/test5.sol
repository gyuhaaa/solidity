// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Strings.sol"; // OpenZeppelin 라이브러리 import

/*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10 min 
    1000 -> 16 min 40 sec
    5250 -> 1 hour 27 min 30 sec
*/

contract TEST5 {
    using Strings for uint;

    function convertToTime(uint _seconds) public pure returns (string memory result) {
        uint hours = _seconds / 3600;
        uint minutes = (_seconds % 3600) / 60;
        uint seconds = _seconds % 60;

        string memory result;

        if (hours > 0) {
            result = string(abi.encodePacked(hours.toString(), " hour "));
        }
        
        if (minutes > 0) {
            result = string(abi.encodePacked(result, minutes.toString(), " min "));
        }
        
        if (seconds > 0 || (hours == 0 && minutes == 0)) {
            result = string(abi.encodePacked(result, seconds.toString(), " sec"));
        }
    }
}