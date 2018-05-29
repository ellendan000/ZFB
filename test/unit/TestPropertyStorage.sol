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

        address tenant;
         (tenant,,,,,,,) = propertyStorage.propertyIdToRents(_givenPropertyId, 0);
        Assert.equal(tenant, this, 'should put rent in rents');
    }

    function testLatestRent() public {
        uint _givenPropertyId = 1;
        uint _givenStartTime = now;
        uint _givenHowLong = 15;
        uint _rental = 15;
        propertyStorage.submitRent(this, _givenPropertyId, _givenStartTime, _givenHowLong, _rental);

        address tenant;
        uint startTime;
        (tenant, startTime,,,,,,) = propertyStorage.getLatestRent(_givenPropertyId);
        Assert.equal(tenant, this, 'should get latest rent');
        Assert.isTrue(now >= startTime, 'should get the start time of latest rent');
    }

    function testCalculateRental() public {
        address _tenantAddress = 0x00;
        uint _givenStartTime = now;
        uint _givenHowLong = 0;
        uint _rental = 15;

        uint _propertyId;
        (_propertyId, ) = propertyStorage.publishProperty(this, '一室一厅', 5);
        propertyStorage.submitRent(_tenantAddress, _propertyId, _givenStartTime, _givenHowLong, _rental);
        propertyStorage.agreeRent(this, _propertyId);
        Assert.equal(propertyStorage.calculateRental(this, _propertyId), 15, 'should return ZFB number is 15');
    }

}