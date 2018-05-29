pragma solidity ^0.4.21;

import "../util/PropertyOwner.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../util/BaseStorage.sol";

contract PropertyStorage is BaseStorage {
    using SafeMath for uint256;
    enum State {Idle, Locked, Renting}

    struct Rent {
        address tenant;
        uint startTime;
        uint howLong; //minutes
        uint rental;
        uint lastWithdrawTime;
        uint withdrawTotal;
        uint8 ownerRate;
        uint8 tenantRate;
    }

    struct Property {
        uint id;
        uint deposit;
        string title;
        address owner;
        State state;
        //        bytes32 key;
    }

    mapping(uint => Property) public idToProperty;
    mapping(uint => Rent[]) public propertyIdToRents;
    mapping(address => uint[]) public tenantToPropertyIds;

    uint latestPropertyId = 0;

    function publishProperty(address _owner, string _title, uint _deposit) public onlyController returns (uint, address){
        latestPropertyId = latestPropertyId.add(1);
        idToProperty[latestPropertyId] = Property(latestPropertyId, _deposit, _title, _owner, State.Idle);
        return (latestPropertyId, _owner);
    }

    function submitRent(address _tenant,
        uint _propertyId,
        uint _startTime,
        uint _howLong,
        uint _rental) public onlyController returns (uint) {
        propertyIdToRents[_propertyId].push(Rent(_tenant, _startTime, _howLong, _rental, _startTime, 0, 0, 0));
        tenantToPropertyIds[_tenant].push(_propertyId);
        idToProperty[_propertyId].state = State.Locked;
        return propertyIdToRents[_propertyId].length - 1;
    }

    function agreeRent(address _owner, uint _propertyId) public
    onlyController onlyPropertyOwner(_owner, _propertyId)
    returns (State) {
        require(idToProperty[_propertyId].owner == _owner
        && idToProperty[_propertyId].state == State.Locked
        );
        idToProperty[_propertyId].state = State.Renting;
        return State.Renting;
    }

    function calculateRental(address _owner, uint _propertyId) public
    onlyPropertyOwner(_owner, _propertyId)
    returns (uint) {
        require(idToProperty[_propertyId].state == State.Renting);

        Rent[] memory rents = propertyIdToRents[_propertyId];
        Rent storage currentRent = propertyIdToRents[_propertyId][rents.length - 1];
        uint currentTime = now;
        require(currentTime >= currentRent.startTime);

        uint result;
        if (currentTime >= currentRent.startTime.add(currentRent.howLong * 60)) {
            idToProperty[_propertyId].state = State.Idle;
            result = currentRent.rental - currentRent.withdrawTotal;
            currentRent.withdrawTotal = currentRent.rental;
            currentRent.lastWithdrawTime = currentTime;
            return result;
        }

        result = currentTime.sub(currentRent.lastWithdrawTime).div(60);
        result = result.mul(currentRent.rental.div(currentRent.howLong));

        currentRent.withdrawTotal = currentRent.withdrawTotal.add(result);
        currentRent.lastWithdrawTime = currentTime;
        return result;
    }

//    function ownerRate(address _owner, uint _propertyId, uint8 _rate) public
//    onlyController
//    onlyPropertyOwner(_owner, _propertyId)
//    checkRate(_rate)
//    returns (uint) {
//        Rent[] memory rents = propertyIdToRents[_propertyId];
//        Rent storage rent = propertyIdToRents[_propertyId][rents.length - 1];
//
//        require(rent.ownerRate == 0);
//        rent.ownerRate == _rate;
//        return _rate;
//    }
//
//    function tenantRate(address _tenant, uint _propertyId, uint8 _rate) public
//    onlyController
//    onlyTenant(_tenant, _propertyId)
//    checkRate(_rate)
//    returns (uint) {
//        Rent storage rent;
//        for (uint i = propertyIdToRents[_propertyId].length - 1; i >= 0; i--) {
//            if (propertyIdToRents[_propertyId][i].tenant == _tenant) {
//                rent = propertyIdToRents[_propertyId][i];
//            }
//        }
//
//        require(rent.tenantRate == 0);
//        rent.tenantRate == _rate;
//        return _rate;
//    }

    function getLatestRent(uint _propertyId) public view returns (address, uint, uint, uint, uint, uint, uint8, uint8){
        require(propertyIdToRents[_propertyId].length > 1);
        Rent memory latestRent = propertyIdToRents[_propertyId][propertyIdToRents[_propertyId].length - 1];
        return (latestRent.tenant,
        latestRent.startTime,
        latestRent.howLong,
        latestRent.rental,
        latestRent.lastWithdrawTime,
        latestRent.withdrawTotal,
        latestRent.ownerRate,
        latestRent.tenantRate);
    }

    function getRentsLength(uint _propertyId) public view returns (uint) {
        return propertyIdToRents[_propertyId].length;
    }

    modifier onlyPropertyOwner(address _owner, uint _propertyId) {
        require(idToProperty[_propertyId].owner == _owner);
        _;
    }

    modifier onlyTenant(address _tenant, uint _propertyId) {
        bool existing = false;
        for (uint i = 0; i < tenantToPropertyIds[_tenant].length; i++) {
            if (tenantToPropertyIds[_tenant][i] == _propertyId) {
                existing = true;
            }
        }
        require(existing == true);
        _;
    }

    modifier checkRate(uint _rate) {
        require(_rate > 0);
        _;
    }

}