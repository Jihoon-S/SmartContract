// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

contract MoneyBox {
    event WhoPaid(address indexed sender, uint256 payment);

    address owner;

    mapping (uint256 => mapping(address => bool)) paidMemberList;
    uint256 round = 1;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.1 ether, "Must be 0.1 ether.");
        require(paidMemberList[round][msg.sender] == false, "Must be a new player in each game.");

        paidMemberList[round][msg.sender] = true;

        emit WhoPaid(msg.sender, msg.value);

        if (address(this).balance == 1 ether) {
            (bool sent, ) = payable(msg.sender).call{value: address(this).balance}("");
            require(sent, "Failed to pay.");
            round++;
        }
    }

    function checkRound() public view returns(uint256) {
        return round;
    }

    function checkBalance() public view returns(uint256) {
        require(owner == msg.sender, "Only onwer can check the balance.");
        return address(this).balance;
    }
}