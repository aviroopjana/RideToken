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

    //CheckOut Bike

    function CheckOut(address walletAddress) public {
        require(renters[walletAddress].due == 0, "You have a pending balance.");
        require(renters[walletAddress].canRent == true, "You can not rent at this time.");
        renters[walletAddress].active = true; 
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    //Check in a Bike

    function CheckIn(address walletAddress) public {
        require(renters[walletAddress].active ==  true, "Please Check Out a Bike first!");
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        setDue(walletAddress);
    }

    //Get Total duration of bike use

    function renterTimespan(uint start, uint end) internal pure returns(uint) {
        return end - start;
    }
    
    function getTotalDuration(address walletAddress) public view returns(uint){
        require(renters[walletAddress].active == false, "Bike is currently Checked Out");
        // uint timespan = renterTimespan(renters[walletAddress].start, renters[walletAddress].end);
        // uint timespanInMinutes = timespan / 60;
        // return timespanInMinutes;
        return 6;
    }

    //Get Contract balance

    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }

    //Get Renter's balance

    function balanceOfReneter(address walletAddress) public view returns(uint) {
        return renters[walletAddress].balance;
    }

    //Set Due Amount

    function setDue(address walletAddress) internal {
        uint timespanInMinutes = getTotalDuration(walletAddress);
        uint fiveMinuteIncrements = timespanInMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 500000000000000;
    }

    function canRentBike(address walletAddress) public view returns(bool) {
        return renters[walletAddress].canRent;
    }

    //Deposit

    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }

    //Make Payment
    function makePayment(address walletAddress) payable public{
        require(renters[walletAddress].due > 0, "You do not have anything due at this time.");
        require(renters[walletAddress].balance > msg.value, "You do not have enough funds to make payment. Please make a deposit.");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].start = 0;
        renters[walletAddress].end = 0;
    }

    function getDue(address walletAddress) public view returns(uint) {
        return renters[walletAddress].due;
    }

    function getRenter(address walletAddress) public view returns(string memory firstname, string memory lastname, bool canRent, bool active){
        firstname = renters[walletAddress].firstname;
        lastname = renters[walletAddress].lastname;
        canRent = renters[walletAddress].canRent;
        active = renters[walletAddress].active;
    }
}

}