//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RideToken {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    //Add Yourself as a Renter

    struct Renter {
        address payable walletAddress;
        string firstname;
        string lastname;
        bool canRent;
        bool active;
        uint balance;
        uint due;
        uint start;
        uint end;
    }

    mapping (address => Renter) public renters;

    function addRenter(address payable walletAddress, string memory firstname, string memory lastname, bool canRent, bool active, uint balance, uint due, uint start, uint end) public {
        renters[walletAddress] = Renter(walletAddress, firstname, lastname, canRent, active, balance, due, start, end);
    }

}