// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract TEST8 {
    /*
        안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
        안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
        안건들을 모아놓은 자료구조도 구현하세요. 

        사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 
        어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

        * 사용자 등록 기능 - 사용자를 등록하는 기능
        * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
        * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
        * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
        * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
        -------------------------------------------------------------------------------------------------
        * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    */

    struct Agenda {
        uint number;
        string title;
        string content;
        address proposer;
        uint yesCount;
        uint noCount;
    }

    struct User {
        string name;
        address addr;
        Agenda[] myAgendas;
        Agenda[] myVotedAgendas;
        mapping(string => bool) isYes;
    }

    enum AgendaStatus { Ongoing, Passed, Rejected }

    mapping(address => User) public users;
    Agenda[] agendas;

    // * 사용자 등록 기능 - 사용자를 등록하는 기능
    function setUser(string memory _name) public {
        require(bytes(_name).length != 0, "Name cannot be empty");
        require(bytes(users[msg.sender].name).length == 0, "User already registered");
        require(msg.sender != address(0), "Invalid address");

        User storage user = users[msg.sender];
        user.name = _name;
        user.addr = msg.sender;
    }

    // * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 
    //                  이미 투표한 건에 대해서는 재투표 불가능
    function vote(string memory _title, bool _isYes) public {
        require(bytes(users[msg.sender].name).length != 0, "User not registered");

        for (uint i = 0; i < users[msg.sender].myVotedAgendas.length; i++) {
            if (keccak256(bytes(users[msg.sender].myVotedAgendas[i].title)) == keccak256(bytes(_title))) {
                revert("Already voted on this agenda");
            }
        }

        for (uint i=0; i<agendas.length; i++) {
            if (keccak256(bytes(agendas[i].title)) == keccak256(bytes(_title))) {
                if (_isYes) {
                    agendas[i].yesCount++;
                } else {
                    agendas[i].noCount++;
                }

                users[msg.sender].myVotedAgendas.push(agendas[i]);
                users[msg.sender].isYes[_title] = _isYes;
                
                break;
            }
        }
    }
    
    // * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function setAgenda(string memory _title, string memory _content) public {
        require(bytes(users[msg.sender].name).length != 0, "User not registered");
        require(bytes(_title).length != 0, "Title cannot be empty");
        require(bytes(_content).length != 0, "Content cannot be empty");

        Agenda memory newAgenda = Agenda({
            number: agendas.length,
            title: _title,
            content: _content,
            proposer: msg.sender,
            yesCount: 0,
            noCount: 0
        });

        agendas.push(newAgenda);
        users[msg.sender].myAgendas.push(newAgenda);
    }
    
    // * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    
    
    // * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getAgenda(string memory _title) public view returns(Agenda memory) {
        for (uint i = 0; i < agendas.length; i++) {
            if (keccak256(bytes(agendas[i].title)) == keccak256(bytes(_title))) {
                return agendas[i];
            }
            revert("Agenda not found");
        }
    }
    
    
    // * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각

}
