pragma solidity ^0.4.21;

import "./ZFBToken.sol";

contract Depositary {
    ZFBToken token;
    uint256 public depositary = 0;

    constructor(address _tokenAddress) public {
        token = ZFBToken(_tokenAddress);
    }

    function input(address _from, uint256 _value) external {
        depositary += _value;
        token.transferFrom(_from, this, _value);
    }

    function output(address _to, uint256 _value) external {
        depositary -= _value;
        token.approve(_to, _value);
    }

}