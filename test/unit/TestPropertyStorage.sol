pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "../../contracts/property/PropertyStorage.sol";

contract TestPropertyStorage {
    PropertyStorage propertyStorage;

    constructor() public {
        propertyStorage = new PropertyStorage();
        propertyStorage.setControllerAddress(this);
    }

    function testPublishProperty() public {
        uint _expectedId = 1;
        Assert.equal(propertyStorage.publishProperty(5), _expectedId, "Should publish property with ID 1");
    }

    function testRent() public {
        uint _givenPropertyId = 1;
        uint _givenStartTime = now;
        uint8 _givenHowLong = 15;
        uint8 _rental = 15;

        Assert.equal(propertyStorage.rent(_givenPropertyId, _givenStartTime, _givenHowLong, _rental),
            0, "Should rent property with rent serial 0");
    }

}