// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q51 {
    /*
        숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    */

    uint[] arr;

    // 내림차순 정렬
    function sort() public view returns(uint) {
        uint[] memory tem = arr;
        for (uint i=0; i<tem.length; i++) {
            for (uint j=i+1; j<tem.length; j++) {
                if(tem[i] < tem[j]) {
                    (tem[i], tem[j]) = (tem[j], tem[i]);
                }
            }
        }

        return tem[2];
    }
}

contract Q52 {
    /*
        자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
    */

    function makeID(string calldata _name, uint _b, address _addr) public pure returns(bytes10) {
        return bytes10(keccak256(abi.encodePacked(_name, _b, _addr)));
    }
}

contract Q53 {
    /*
        시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 
        각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    
        힌트 : 이중 mapping을 꼭 이용하세요.
    */

    mapping(string => mapping(address => uint)) balances;

    function getBalance(string calldata _bank) public view returns(uint) {
        return balances[_bank][msg.sender];
    }

    function deposit(string calldata _bank) public payable {
        balances[_bank][msg.sender] += msg.value;
    }

    function withdraw(string calldata _bank, uint _n) public {
        balances[_bank][msg.sender] -= _n;
        payable(msg.sender).transfer(_n);
    }
}

contract Q54 {
    /*
        기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    
        힌트 : 굳이 mapping을 만들 필요는 없습니다.
    */

    uint public max;
    address public honor;

    function donate() public payable {
        if(msg.value > max) {
            max = msg.value;
            honor = msg.sender;
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

    function change(address _addr) public {
        require(owner == msg.sender);
        owner = _addr;
    }
}

contract Q56 {
    /*
        위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    */

    address public owner;
    address public sub;

    constructor(address _addr) {
        owner = msg.sender;
        sub = _addr;
    }

    bool _owner;
    bool _sub;

    function ownerAgree(bool _isAgree) public {
        require(msg.sender == owner);
        _owner = _isAgree;
    }

    function subAgree(bool _isAgree) public {
        require(msg.sender == sub);
        _sub = _isAgree;
    }

    function change(address _addr) public {
        require(_owner == true && _sub == true);
        require(owner == msg.sender);
        owner = _addr;
    }
}

contract Q57 {
    /*
        위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
    */

    address public owner;
    address public sub;

    constructor(address _addr) {
        owner = msg.sender;
        sub = _addr;
    }

    function changeSubowner(address _addr) public {
        require(msg.sender == owner);
        sub = _addr;
    }

    function changeOwner(address _addr) public {
        require(msg.sender == owner);
        owner = _addr;
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

    uint public time;

    function setTime() public {
        time = block.timestamp + 2 days;
    }
}

contract Q60 {
    /*
        방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 
        특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    
        예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
        
        힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
    */

    mapping(uint => mapping(uint => string[])) book;

    function setInfo(uint _date, uint _room, string[] memory _guest) public {
        require((_room == 1 || _room == 2) && _guest.length < 3);
        book[_date][_room] = _guest;
    }

    function getInfo(uint _date, uint _room) public view returns(string[] memory) {
        return book[_date][_room];
    }
}