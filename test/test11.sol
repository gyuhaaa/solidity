// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

/*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
*/

contract TEST11 {
    address public owner;
    
    struct Ticket {
        uint8[4] numbers;
        bytes1[2] letters;
    }

    Ticket winningTicket;
    mapping(address => Ticket) tickets;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable { }

    // 내 로또 번호 확인
    function getMyTicket() public view returns(Ticket memory) {
        return tickets[msg.sender];
    }

    // 로또 구매 / 1,2,3,4,"A","B" / 50000000000000000
    function buyTicket(uint _n1, uint _n2, uint _n3, uint _n4, string memory _s1, string memory _s2) public payable {
        require(msg.value == 0.05 ether, "0.05 ether please");
        uint8[4] memory _numbers = [uint8(_n1), uint8(_n2), uint8(_n3), uint8(_n4)];
        bytes1[2] memory _letters = [bytes1(bytes(_s1)), bytes1(bytes(_s2))];
        tickets[msg.sender] = Ticket(_numbers, _letters);
    }

    // 당첨 번호 설정
    function setWinningTicket() public {
        require(msg.sender == owner, "only owner");
        uint8[4] memory _numbers;
        bytes1[2] memory _letters;
        
        for (uint i = 0; i < 4; i++) {
            _numbers[i] = uint8(random(i) % 10); // 0-9 범위의 숫자
        }

        bytes1[26] memory alphabet = [bytes1('A'), bytes1('B'), bytes1('C'), bytes1('D'), bytes1('E'), bytes1('F'), bytes1('G'), bytes1('H'), bytes1('I'), bytes1('J'), bytes1('K'), bytes1('L'), bytes1('M'), bytes1('N'), bytes1('O'), bytes1('P'), bytes1('Q'), bytes1('R'), bytes1('S'), bytes1('T'), bytes1('U'), bytes1('V'), bytes1('W'), bytes1('X'), bytes1('Y'), bytes1('Z')];
        
        for (uint i = 0; i < 2; i++) {
            _letters[i] = alphabet[random(i + 4) % 26]; // A-Z 범위의 문자
        }

        winningTicket = Ticket(_numbers, _letters);
    }

    // 랜덤 숫자 생성
    function random(uint seed) internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed)));
    }

    function getWinningTicket() public view returns (uint8[4] memory, bytes1[2] memory) {
        return (winningTicket.numbers, winningTicket.letters);
    }

    // 일치 개수 계산
    function countMatches() public view returns (uint) {
        Ticket memory userTicket = tickets[msg.sender];
        uint matchCount = 0;

        // 숫자 일치 확인
        for (uint i = 0; i < 4; i++) {
            for (uint j = 0; j < 4; j++) {
                if (userTicket.numbers[i] == winningTicket.numbers[j]) {
                    matchCount++;
                    break;
                }
            }
        }

        // 문자 일치 확인
        for (uint i = 0; i < 2; i++) {
            for (uint j = 0; j < 2; j++) {
                if (userTicket.letters[i] == winningTicket.letters[j]) {
                    matchCount++;
                    break;
                }
            }
        }

        return matchCount;
    }

    // 당첨금 수령
    function claimPrize() public {
        uint matchCount = countMatches();
        uint prize = calculatePrize(matchCount);
        require(prize > 0, "No prize for you.");
        payable(msg.sender).transfer(prize);
    }

    // 당첨금 계산
    function calculatePrize(uint matchCount) public pure returns (uint) {
        if (matchCount == 6) {
            return 1 ether;
        } else if (matchCount == 5) {
            return 0.75 ether;
        } else if (matchCount == 4) {
            return 0.25 ether;
        } else if (matchCount == 3) {
            return 0.1 ether;
        } else {
            return 0;
        }
    }
}