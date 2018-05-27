pragma solidity ^0.4.21;

import 'truffle/Assert.sol';
import '../../contracts/property/PropertyStorage.sol';

contract TestPropertyStorage {
    PropertyStorage propertyStorage;

    constructor() public {
        propertyStorage = new PropertyStorage();
        propertyStorage.setControllerAddress(this);
    }

    function testPublishProperty() public {
        uint _expectedId = 1;

        uint _propertyId;
        address _owner;
        (_propertyId, _owner) = propertyStorage.publishProperty(this, '一室一厅', 5);
        Assert.equal(_propertyId, _expectedId, "Should publish property with ID 1");
        Assert.equal(_owner, this, "Should publish property with current address");
    }

    function testSubmitRent() public {
        uint _givenPropertyId = 1;
        uint _givenStartTime = now;
        uint _givenHowLong = 15;
        uint _rental = 15;

        Assert.equal(propertyStorage.submitRent(this, _givenPropertyId, _givenStartTime, _givenHowLong, _rental),
            0, 'Should rent property with rent serial 0');
    }

}