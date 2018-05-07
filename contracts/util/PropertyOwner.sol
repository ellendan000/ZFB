pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract PropertyOwner is Ownable {
    uint8 deposit = 5;

    function modifyDeposit(uint8 amount) public onlyOwner {
        deposit = amount;
    }
}