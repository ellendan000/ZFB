pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract PropertyOwner is Ownable {
    uint deposit = 5;

    function modifyDeposit(uint amount) public onlyOwner {
        deposit = amount;
    }
}