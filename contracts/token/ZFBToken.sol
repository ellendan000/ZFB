pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract ZFBToken is StandardToken, Ownable {
    string public name = "Zhufangbi";
    string public symbol = "ZFB";
    uint8 public decimals = 0;

    uint256 public FOR_ICO = 750000;
    uint256 public FOR_FOUNDER = 250000;
    uint256 public depositary = 0;

    constructor() public {
        totalSupply_ = FOR_FOUNDER + FOR_ICO;
        balances[msg.sender] = totalSupply_;
    }

    function fundICO(address _icoAddress) onlyOwner public {
        transfer(_icoAddress, FOR_ICO);
    }

    function inputTS(address _from, uint256 _value) external {
        depositary += _value;
        transferFrom(_from, this, _value);
    }

    function outputTS(address _to, uint256 _value) external {
        depositary -= _value;
        approve(_to, _value);
    }

}