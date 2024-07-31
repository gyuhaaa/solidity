// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q81 {
    /*
        Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.  
    */
    mapping(address => uint) mapAddressToBalance;

    function deposit() public payable  {
        require(msg.value > 0, "No money");
        mapAddressToBalance[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(_amount > 0 && mapAddressToBalance[msg.sender] >= _amount, "Invalid amount");
        mapAddressToBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function withdrawAddress(address _addr) public view returns (uint _balance) {
        return mapAddressToBalance[_addr];
    }
}

contract Q82 {
    /*
        특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    */
    function multipleCount(uint _n) public pure returns(uint, uint, uint) {
        return (_n/3, _n/5, _n/8);
    }
}

contract Q83 {
    /*
        이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 
        사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    */
    struct Person {
        string name;
        uint number;
        address addr;
        mapping(uint => string) map;
    }

    Person[] people;

    function pushPeople(string memory _name, uint _number, address _addr, uint _mapKey, string memory _mapValue) public {
        // 먼저 빈 Person을 배열에 추가
        people.push();

        // 배열의 마지막 요소를 가리키는 참조를 가져옴
        Person storage newPerson = people[people.length - 1];

        // 필드 초기화
        newPerson.name = _name;
        newPerson.number = _number;
        newPerson.addr = _addr;

        // mapping 초기화
        newPerson.map[_mapKey] = _mapValue;    
    }

    function getPersonMappingValue(uint personIndex, uint key) public view returns (string memory) {
        require(personIndex < people.length, "Invalid person index");
        return people[personIndex].map[key];
    }
}

contract Q84 {
    /*
        2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    */
    address[] public blacklist;

    constructor() {
        blacklist.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        blacklist.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    function calculate(uint _a, uint _b) public view returns(uint, uint, uint) {
        for (uint i=0; i<blacklist.length; i++) {
            require(msg.sender != blacklist[i], "Blacklisted wallet");
        }
        require(_a > _b, "input1 must be greater than input2");

        return (_a + _b, _a - _b, _a * _b);
    }
}

contract Q85 {
    /*
        숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
        찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    */
    uint public pros;
    uint public cons;
    uint public blockNumber;
    
    constructor() {
        blockNumber = block.number;
    }

    function vote(bool _isPros) public {
        require(block.number <= blockNumber + 20, "Voting ends");
        _isPros ? pros++ : cons++;
    }
}

contract Q86 {
    /*
        숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
        찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    */
    uint public pros;
    uint public cons;
    mapping(address => uint) userDeposit;

    function deposit() public payable {
        require(msg.value > 0, "Deposit no money");
        userDeposit[msg.sender] += msg.value;
    }

    function vote(bool _isPros) public {
        require(userDeposit[msg.sender] >= 1 ether, "Deposit more than 1 Ether");
        _isPros ? pros++ : cons++;
    }
}

contract Q87 {
    /*
        visibility에 신경써서 구현하세요. 
    
        숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.
    */
    uint private a;

    function setA(uint _n) internal {
        a = _n;
    }
}

    /*
        아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요. (힌트 : 상속)
        contract OWNER {
            address private owner;

            constructor() {
                owner = msg.sender;
            }

            function setInternal(address _a) internal {
                owner = _a;
            }

            function getOwner() public view returns(address) {
                return owner;
            }
        }
    */
    contract OWNER {
        address private owner;

        constructor() {
            owner = msg.sender;
        }

        function setInternal(address _a) internal {
            owner = _a;
        }

        function getOwner() public view returns(address) {
            return owner;
        }
    }

    contract OWNER_2 is OWNER {
        function changeOwner(address _addr) public {
            setInternal(_addr);
        }
    }

contract Q89 {
    /*
        이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 
        이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. 
        (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    */
    struct Customer {
        string name;
        string introduction;
    }

    Customer[] public customers;

    function setCustomer(string memory _name, string memory _introduction) public {
        require(bytes(_name).length >= 5 && bytes(_name).length <= 10 && bytes(_introduction).length >= 20 && bytes(_introduction).length <= 50, "Invalid value");
        customers.push(Customer(_name, _introduction));
    }
}

contract Q90 {
    /*
        당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    */

}