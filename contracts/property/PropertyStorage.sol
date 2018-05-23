pragma solidity ^0.4.21;

import "../util/PropertyOwner.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../util/BaseStorage.sol";

contract PropertyStorage is BaseStorage {
    using SafeMath for uint256;
    enum State {Idle, Locked, Renting}

    struct Rent {
        address renter;
        uint startTime;
        uint howLong; //minutes
        uint rental;
        uint lastWithdrawTime;
        uint withdrawTotal;
    }

    struct Property {
        uint id;
        uint deposit;
        address owner;
        State state;
        //        bytes32 key;
    }

    mapping(uint => Property) public idToProperty;
    mapping(uint => Rent[]) public propertyIdToRents;

    uint latestPropertyId = 0;

    function publishProperty(address _owner, uint _deposit) public onlyController returns (uint, address){
        latestPropertyId = latestPropertyId.add(1);
        idToProperty[latestPropertyId] = Property(latestPropertyId, _deposit, _owner, State.Idle);
        return (latestPropertyId, _owner);
    }

    function submitRent(address _renter,
        uint _propertyId,
        uint _startTime,
        uint _howLong,
        uint _rental) public onlyController returns (uint){
        propertyIdToRents[_propertyId].push(Rent(_renter, _startTime, _howLong, _rental, _startTime));
        idToProperty[_propertyId].state = State.Locked;
        return propertyIdToRents[_propertyId].length - 1;
    }

    function agreeRent(address _owner, uint _propertyId) public onlyController returns (State){
        require(idToProperty[_propertyId].owner == _owner);
        idToProperty[_propertyId].state = State.Renting;
        return State.Renting;
    }

    function calculateRental(address _owner, uint _propertyId) public view onlyController returns (uint) {
        require(idToProperty[_propertyId].owner == _owner);

        Rent[] currentProperty = propertyIdToRents[_propertyId];
        Rent currentRent = currentProperty[currentProperty.length -1];
        require(now > currentRent.startTime);

        uint result;
        if(now >= currentRent.startTime.add(howLong * 1000 * 60)){
            idToProperty[_propertyId].state = State.Idle;
            result = rent.rental - rent.withdrawTotal;
            rent.withdrawTotal = rent.rental;
            return result;
        }

        result = now.sub(currentRent.lastWithdrawTime).div(1000 * 60);
        rent.withdrawTotal = rent.withdrawTotal.add(result);
        return result;
    }

}