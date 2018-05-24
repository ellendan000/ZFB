pragma solidity ^0.4.21;

import "../util/BaseController.sol";
import "../util/RateReward.sol";
import "../ContractManager.sol";
import "../token/ZFBToken.sol";
import "./PropertyStorage.sol";

contract PropertyController is BaseController, PropertyOwner, RateReward {
    event PropertyPublished(uint id, address owner);
    ZFBToken _zfbToken;
    PropertyStorage _propertyStorage;

    constructor(){
        loadReferenceContracts();
    }

    function loadReferenceContracts() public onlyOwner {
        _zfbToken = getZFBToken();
        _propertyStorage = getPropertyStorage();
    }

    function publishProperty() public {
        require(_zfbToken.balanceOf(msg.sender) >= deposit, 'not sufficient funds');
        _zfbToken.transferFrom(msg.sender, address(_propertyStorage), deposit);

        uint _propertyId;
        address _owner;
        (_propertyId, _owner) = _propertyStorage.publishProperty(msg.sender, deposit);
        emit PropertyPublished(_propertyId, _owner);
    }

    function submitRent(uint _propertyId,
        uint _startTime,
        uint _howLong,
        uint _rental) public {
        require(_zfbToken.balanceOf(msg.sender) >= _rental, 'not sufficient funds');
        _zfbToken.transferFrom(msg.sender, address(_propertyStorage), _rental);
        _propertyStorage.submitRent(msg.sender, _propertyId, _startTime, _howLong, _rental);
    }

    function agreeRent(uint _propertyId) public {
        _propertyStorage.agreeRent(msg.sender, _propertyId);
    }

    function getRental(uint _propertyId) public {
        _zfbToken.approve(
            msg.sender,
            _propertyStorage.calculateRental(msg.sender, _propertyId)
        );
    }

    function ownerRate(uint _propertyId, uint8 _rate) public {
        _propertyStorage.ownerRate(msg.sender, _propertyId, _rate);
        _zfbToken.approve(msg.sender, rewardNum);
    }

    function tenantRate(uint _propertyId, uint8 _rate) public {
        _propertyStorage.tenantRate(msg.sender, _propertyId, _rate);
        _zfbToken.approve(msg.sender, rewardNum);
    }

    function getZFBToken() private returns (ZFBToken) {
        ContractManager _manager = ContractManager(managerAddress);
        address _zfbTokenAddress = _manager.getAddress("ZFBToken");
        return ZFBToken(_zfbTokenAddress);
    }

    function getPropertyStorage() private returns (PropertyStorage) {
        ContractManager _manager = ContractManager(managerAddress);
        address _propertyStorageAddress = _manager.getAddress("PropertyStorage");
        return PropertyStorage(_propertyStorageAddress);
    }



}