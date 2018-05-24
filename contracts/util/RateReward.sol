pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract RateReward is Ownable {
    uint rewardNum = 1;

    function modifyRewardNum(uint amount) public onlyOwner {
        rewardNum = amount;
    }
}