// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q51 {
    /*
        숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    */

    uint[] array;

    function pushArray(uint _n) public {
        array.push(_n);
    }

    function getThird() public view returns(uint) {
        require(array.length >= 3, "Array length is less than 3");

        uint[] memory sortedArray = new uint[](array.length);
        sortedArray = array;

        for (uint i = 0; i < sortedArray.length - 1; i++) {
            for (uint j = i + 1; j < sortedArray.length; j++) {
                if (sortedArray[i] < sortedArray[j]) {
                    uint temp = sortedArray[i];
                    sortedArray[i] = sortedArray[j];
                    sortedArray[j] = temp;
                }
            }
        }
        
        return sortedArray[2];
    }
}

contract Q52 {
    /*
        자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
    */

    function createId(string memory _name, uint _birth, address _addr) public pure returns(bytes10) {
        bytes32 hashConcat = keccak256(abi.encodePacked(_name, _birth, _addr));

        return bytes10(hashConcat);
    }
}

contract Q53 {
    /*
        시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 
        각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    
        힌트 : 이중 mapping을 꼭 이용하세요.
    */

    enum Bank { A, B, C, D, E }
    mapping(Bank => mapping(address => uint)) mapBankToBalance;

    function deposit(Bank _bank) public payable {
        require(msg.value > 0, "There's no deposit");
        mapBankToBalance[_bank][msg.sender] += msg.value;
    }

    function withdraw(Bank _bank, uint _amount) public {
        require(_amount > 0, "There's no withdraw");
        require (mapBankToBalance[_bank][msg.sender] >= _amount, "Insufficient balance");
        mapBankToBalance[_bank][msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function balance(Bank _bank) public view returns(uint) {
        return mapBankToBalance[_bank][msg.sender];
    }
}

contract Q54 {
    /*
        기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    
        힌트 : 굳이 mapping을 만들 필요는 없습니다.
    */

    struct Donor {
        address addr;
        uint donation;
    }

    Donor public bestDonor;

    function deposit() public payable {
        require(msg.value > 0, "There's no deposit");
        if (msg.value > bestDonor.donation) {
            bestDonor.addr = msg.sender;
            bestDonor.donation = msg.value;
        }
    }
}

contract Q55 {
    /*
        배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
    */

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _addr) public {
        require(msg.sender == owner, "only owner");
        owner = _addr;
    }
}

contract Q56 {
    /*
        위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    */

    address owner;
    address sub_owner;

    bool agreeOwner;
    bool agreeSubOwner;

    constructor() {
        owner = msg.sender;
    }

    function setSubOwner(address _addr) public {
        require(msg.sender == owner, "only owner");
        sub_owner = _addr;
    }

    function setAgreeOwner() public {
        require(msg.sender == owner);
        agreeOwner = true;
    }

    function setAgreeSubOwner() public {
        require(msg.sender == sub_owner);
        agreeSubOwner = true;
    }

    function changeOwner(address _addr) public {
        if (agreeOwner && agreeSubOwner) {
            owner = _addr;
        }
    }
}

contract Q57 {
    /*
        위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
    */

    address owner;
    address sub_owner;

    bool agreeOwner;

    constructor() {
        owner = msg.sender;
    }

    function setSubOwner(address _addr) public {
        require(msg.sender == owner, "only owner");
        sub_owner = _addr;
    }

    function setAgreeOwner() public {
        require(msg.sender == owner);
        agreeOwner = true;
    }

    function changeOwner(address _addr) public {
        if (msg.sender == owner) {
            owner = _addr;
        } else if (msg.sender == sub_owner && agreeOwner) {
            owner = _addr;
        } else {
            revert("no permission");
        }
    }
}

contract Q58 {
    /*
        A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. 
        b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
    */
    
    uint private a;
    uint internal b;
    uint public c;    
}

contract Q59 {
    /*
        현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
    */

    function getCurrentTime() public view returns(uint32) {
        return uint32(block.timestamp % 2**32);
    }

    function twoDaysLater() public view returns(uint32) {
        return getCurrentTime() + 2 days;
    }
}

contract Q60 {
    /*
        방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 
        특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    
        예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
        
        힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
    */

    enum Room { A, B }
    string[3] guests;
    mapping(uint => mapping(Room => string[])) reservations;

    function addReservation(uint _date, Room _room, string[] memory _guests) public {
        require(_guests.length <= 3, "Too many guests");
        reservations[_date][_room] = _guests;

        for (uint8 i=0; i < _guests.length; i++) {
            guests[i] = _guests[i];
        }
    }

    function getGuest(uint _date, Room _room) public view returns(string[] memory) {
        return reservations[_date][_room];
    }
}