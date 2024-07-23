// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract TEST7 {
    /*
        * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 
            연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
        * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
        * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 
            속도가 0이면 브레이크는 더이상 못씀
        * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
        * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
        --------------------------------------------------------
        * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    */
    uint public speed;
    uint public fuel;
    bool public engineOn;
    mapping(address => uint) public mapPrepaidGas;

    constructor() {
        speed = 0;
        fuel = 100;
        engineOn = false;
    }

    modifier EngineOn() {
        require(engineOn, "Engine is off");
        _;
    }

    modifier whenGasUp() {
        require(!engineOn, "Engine must be off");
        _;
    }

    // * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function accelerate() public EngineOn {
        require(fuel > 30, "Fuel too low to accelerate");
        require(speed < 70, "Speed is too high to accelerate");

        speed += 10;
        fuel -= 20;
    }

    // * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function gasUp() public payable whenGasUp {
        require(msg.value == 1 ether, "Refuel costs 1 ETH");

        fuel += 100;
    }

    // * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function brake() public EngineOn {
        require(speed > 0, "Speed is zero, cannot brake");
        require(fuel >= 10, "Not enough fuel");

        speed -= 10;
        fuel -= 10;
    }

    // * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function stopEngine() public {
        require(engineOn, "Engine is already off");
        require(speed == 0, "Speed must be 0");

        engineOn = false;
    }

    // * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function startEngine() public {
        require(!engineOn, "Engine is already on");
        engineOn = true;
        speed = 0;
    }

    // * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    function prepaidGas() public payable {
        require(msg.value > 0, "Must send ETH to prepay");
        mapPrepaidGas[msg.sender] += msg.value;
    }

    function usePrepaidGas() public whenGasUp {
        require(mapPrepaidGas[msg.sender] >= 1 ether, "Not enough prepaid fuel");

        mapPrepaidGas[msg.sender] -= 1 ether;
        fuel += 100;
    }
}