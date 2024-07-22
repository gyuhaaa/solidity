// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q31 {
    /* 
        string을 input으로 받는 함수를 구현하세요.
        "Alice"나 "Bob"일 때에만 true를 반환하세요.
    */

    function aliceBob(string memory _s) public pure returns(bool) {
        return (keccak256(abi.encodePacked(_s)) == keccak256(abi.encodePacked("Alice")) || keccak256(abi.encodePacked(_s)) == keccak256(abi.encodePacked("Bob")));
    }
}

contract Q32 {
    /* 
        2. 3의 배수만 들어갈 수 있는 array를 구현하되, 
        3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    
        예) 3 → o , 9 → o , 15 → o , 30 → x
    */
    uint[] array;

    function pushOnlyThree2(uint _n) public {
        if (_n % 3 == 0 && _n % 10 > 0) {
            array.push(_n);
        }
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}

contract Q33 {
    /* 
        이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요.
        고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */

    struct Customer {
        string name;
        uint number;
        address wallet;
        uint birth;
    }

    mapping(string => Customer) nameToCustomer;

    function setCustomer(string memory _name, uint _number, address _wallet, uint _birth) public {
        nameToCustomer[_name] = Customer(_name, _number, _wallet, _birth);
    }

    function setCustomers() public {
        setCustomer("min", 1, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 970616);
        setCustomer("gyu", 2, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 980616);
        setCustomer("seon", 3, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 990616);
    }

    function getCustomer(string memory _name) public view returns(Customer memory) {
        require(abi.encodePacked(nameToCustomer[_name].name).length != 0, "No customer");
        return nameToCustomer[_name];
    }

}

contract Q34 {
    /* 
        이름, 번호, 점수가 들어간 학생 구조체를 선언하세요.
        학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */

    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] students;

    function setStudent(string memory _name, uint _number, uint _score) public {
        students.push(Student(_name, _number, _score));
    }

    function pushStudent() public {
        setStudent("min", 1, 100);
        setStudent("gyu", 2, 100);
        setStudent("seon", 3, 80);
    }

    function getStudent() public view returns(Student[] memory) {
        return students;
    }

    function avgStudent() public view returns(uint) {
        uint sum;
        for (uint i=0; i<students.length; i++) {
            sum += students[i].score;
        }
        return sum/students.length;
    }
}

contract Q35 {
    /* 
        5. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    
        예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
    */

    uint[] array;

    function pushArray(uint _n) public {
        array.push(_n);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }

    function getEvenArray() public view returns(uint[] memory) {
        uint length = array.length/2;
        uint[] memory evenArray = new uint[](length);
        uint a;

        for (uint i=1; i<array.length; i+=2) {
            evenArray[a] = array[i];
            a++;
        }

        return evenArray;
    }
}

contract Q36 {
    /* 
        high, neutral, low 상태를 구현하세요. 
        a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 
        그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */

    enum State {
        high,
        neutral,
        low
    }

    State public currentState;
    uint public a;

    function setA(uint _n) public {
        a = _n;
    }

    function setState() public {
        if (a >= 7) {
            currentState = State.high;
        } else if (a >= 4) {
            currentState = State.neutral;
        } else {
            currentState = State.low;
        }
    }
}

contract Q37 {
    /* 
        7. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 
        최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    
        (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function depositWei() public payable {
        require(msg.value == 1 wei, "Must send exactly 1 wei");
    }

    function depositFinney() public payable {
        require(msg.value == 0.001 ether, "Must send exactly 1 finney");
    }

    function depositEther() public payable {
        require(msg.value == 1 ether, "Must send exactly 1 ether");
    }

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "only owner");
        require(_amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(_amount);
    }

}

contract Q38 {
    /* 
        8. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 
        단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    
        (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    */

    string public a = "A";
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function changeB() public onlyOwner {
        a = "B";
    }

    function changeC() public onlyOwner {
        a = "C";
    }

}

contract Q39 {
    /* 
        9. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    
        예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */

    function count(uint _n) public pure returns(uint[] memory) {
        uint[] memory a = new uint[](4);

        a[0] = _n / 2;
        a[1] = _n / 3;
        a[2] = _n / 5;
        a[3] = _n / 7;

        return a;
    }
}

contract Q40 {
    /* 
        10. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요.
        가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    
        예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    */

    function getMiddleNumber(uint[] memory _n) public pure returns(uint[] memory) {
        uint n = _n.length;
        
        for (uint i = 0; i < n - 1; i++) {
            for (uint j = i + 1; j < n; j++) {
                if (_n[i] > _n[j]) {
                    uint temp = _n[i];
                    _n[i] = _n[j];
                    _n[j] = temp;
                }
            }
        }

        if (n % 2 == 1) {
            uint[] memory result = new uint[](1);
            result[0] = _n[n / 2];
            return result;
        } else {
            uint[] memory result = new uint[](2);
            result[0] = _n[n / 2 - 1];
            result[1] = _n[n / 2];
            return result;
        }
    }
}