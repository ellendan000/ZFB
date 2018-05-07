pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract BaseStorage is Ownable {
    address public controllerAddress;

    modifier onlyController() {
        require(msg.sender == controllerAddress);
        _;
    }

    function setControllerAddress(address _controllerAddress) public onlyOwner {
        controllerAddress = _controllerAddress;
    }
}