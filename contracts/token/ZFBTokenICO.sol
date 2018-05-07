pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./ZFBToken.sol";

contract ZFBTokenICO {
    using SafeMath for uint256;

    ZFBToken token;
    uint256 public RATE = 1000;

    constructor(address _tokenAddress) public {
        token = ZFBToken(_tokenAddress);
    }

    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount.div(10 ** 18).mul(RATE);
    }

    function () public payable {
        uint256 _amount = _getTokenAmount(msg.value);
        token.transfer(msg.sender, _amount);
    }

}