pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract ZFBToken is StandardToken, Ownable {
    string public name = "Zhufangbi";
    string public symbol = "ZFB";
    uint8 public decimals = 0;

    uint256 public FOR_ICO = 750000;
    uint256 public FOR_FOUNDER = 250000;

    constructor() public {
        totalSupply_ = FOR_FOUNDER + FOR_ICO;
        balances[msg.sender] = totalSupply_;
    }

    function fundICO(address _icoAddress) onlyOwner public {
        transfer(_icoAddress, FOR_ICO);
    }

}