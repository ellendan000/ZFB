pragma solidity ^0.4.21;

import "../util/PropertyOwner.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../util/BaseStorage.sol";

contract PropertyStorage is BaseStorage {
    using SafeMath for uint256;
    enum State {Idle, Locked, Renting}

    struct Rent {
        uint startTime;
        uint8 howLong;
        uint8 rental;
        address renter;
    }

    struct Property {
        uint id;
        uint deposit;
        address owner;
        State state;
        //        bytes32 key;
    }

    Property[] public properties;
    mapping(address => uint[]) public ownerToProperties;
    mapping(uint => Rent[]) public idToRents;

    uint latestPropertyId = 0;

    function publishProperty(uint _deposit) public onlyController returns (uint){
        latestPropertyId = latestPropertyId.add(1);
        properties.push(Property(latestPropertyId, _deposit, msg.sender, State.Idle));
        ownerToProperties[msg.sender].push(latestPropertyId);
        return latestPropertyId;
    }

    function rent(uint _propertyId,
        uint _startTime,
        uint8 _howLong,
        uint8 _rental) public onlyController returns (uint){
        idToRents[_propertyId].push(Rent(_startTime, _howLong, _rental, msg.sender));
        return idToRents[_propertyId].length - 1;
    }

}