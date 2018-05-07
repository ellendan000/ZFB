pragma solidity ^0.4.19;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract ContractManager is Ownable {
  mapping (string => address) addresses;

  function setAddress(string _name, address _address) public onlyOwner {
    addresses[_name] = _address; 
  }

  function getAddress(string _name) public view returns (address) {
    return addresses[_name];
  }

  function deleteAddress(string _name) public onlyOwner {
    addresses[_name] = address(0);
  }
}