// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

/*
    간단한 게임이 있습니다.
    유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
    참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array)
    선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
*/

contract TEST4 {
    struct User {
        uint number;
        string name;
        address addr;
        uint balance;
        uint score;
    }

    User[] users;

    address payable public smartcontract;
    address payable public admin;

    string[4] room;

    function pushUser() public {
        users.push(User(1, "a", 0xdD870fA1b7C4700F2BD7f44238821C26f7392148, 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.balance, 0));
        users.push(User(2, "b", 0x583031D1113aD414F02576BD6afaBfb302140225, 0x583031D1113aD414F02576BD6afaBfb302140225.balance, 0));
        users.push(User(3, "c", 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB, 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB.balance, 0));
        users.push(User(4, "d", 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C.balance, 0));
    }

    function getRoom() public view returns(string[4] memory) {
        return room;
    }

    function setRoom(string memory _name) public {
        require(checkExistUser(_name), "User does not exist.");
        require(checkRoom(_name), "User already exist in room.");
        if (abi.encodePacked(room[0]).length == 0) {
            room[0] = _name;
        } else if (abi.encodePacked(room[1]).length == 0) {
            room[1] = _name;
        } else if (abi.encodePacked(room[2]).length == 0) {
            room[2] = _name;
        } else if (abi.encodePacked(room[3]).length == 0) {
            room[3] = _name;
            setScore();
            delete room;
        }
    }

    // users에 존재하는 이름인지 확인
    function checkExistUser(string memory _name) public view returns(bool) {
        bool exist = false;

        for (uint i=0; i<users.length; i++) {
            if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(users[i].name))) {
                exist = true;
            }
        }

        return exist;
    }

    // room에 이미 존재하는지 확인
    function checkRoom(string memory _name) public view returns(bool) {
        bool nodup = true;

        for (uint i=0; i<room.length; i++) {
            if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(room[i]))) {
                nodup = false;
            }
        }

        return nodup;
    }

    function setScore() internal {
        for (uint i=0; i<users.length; i++) {
            if (keccak256(abi.encodePacked(users[i].name)) == keccak256(abi.encodePacked(room[0]))) {
                users[i].score += 4;
            } else if (keccak256(abi.encodePacked(users[i].name)) == keccak256(abi.encodePacked(room[1]))) {
                users[i].score += 3;
            } else if (keccak256(abi.encodePacked(users[i].name)) == keccak256(abi.encodePacked(room[2]))) {
                users[i].score += 2;
            } else if (keccak256(abi.encodePacked(users[i].name)) == keccak256(abi.encodePacked(room[3]))) {
                users[i].score += 1;
            }
        }   
    }

    // 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function setUser(string memory _name) public {
        require(!checkExistUser(_name), "User already exist in users.");
        uint userCount = users.length + 1;
        users.push(User(userCount, _name, msg.sender, msg.sender.balance, 0));
    }
    
    // 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환.
    function getUser() public view returns(User[] memory) {
        return users;
    }

    // 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function deposit() public payable {
        require(msg.value >= 0.01 ether, "0.01 ETH is required to join the game.");
    }

    // 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function exchangeMoney(uint _userNumber) public {
        require(_userNumber-1 < users.length, "Invalid user number.");
        require(users[_userNumber-1].score >= 10, "Not enough score to exchange.");

        uint exchangeableScore = users[_userNumber-1].score / 10;
        uint amount = exchangeableScore * 0.1 ether;

        require(address(this).balance >= amount, "Contract doesn't have enough balance.");

        users[_userNumber-1].score -= exchangeableScore * 10;
        users[_userNumber-1].balance += 0.1 ether;
        payable(users[_userNumber-1].addr).transfer(amount);
    }

    // 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    constructor() {
        admin = payable(address(0));
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    } 
    
    // 관리자가 전액을 인출하는 함수
    function withdrawAll() public payable onlyAdmin {
        uint amount = smartcontract.balance;
        require(amount > 0, "Contract has no balance");
        payable(msg.sender).transfer(amount);
    }

    // 관리자가 특정 금액을 인출하는 함수
    function withdrawAmount(uint _amount) public payable onlyAdmin {
        require(_amount <= smartcontract.balance, "Insufficient contract balance");
        uint amount = smartcontract.balance;
        require(amount > _amount, "Contract has no balance.");
        payable(msg.sender).transfer(amount);
    }

    // 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.

}