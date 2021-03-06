pragma solidity ^0.4.21;

import "../util/BaseController.sol";
import "../util/RateReward.sol";
import "../ContractManager.sol";
import "../token/ZFBToken.sol";
import "./PropertyStorage.sol";
import "../token/Depositary.sol";

contract PropertyController is BaseController, PropertyOwner, RateReward {
    event PropertyPublished(uint id, address owner);
    event WithdrawRental(uint amount);

    function publishProperty(string _title) public {
        ZFBToken _zfbToken = getZFBToken();
        PropertyStorage _propertyStorage = getPropertyStorage();
        Depositary _depositary = getDepositary();

        require(_zfbToken.balanceOf(msg.sender) >= deposit, 'not sufficient funds');
        _depositary.input(msg.sender, deposit);

        uint _propertyId;
        address _owner;
        (_propertyId, _owner) = _propertyStorage.publishProperty(msg.sender, _title, deposit);
        emit PropertyPublished(_propertyId, _owner);
    }

    function submitRent(uint _propertyId,
        uint _startTime,
        uint _howLong,
        uint _rental) public {
        ZFBToken _zfbToken = getZFBToken();
        PropertyStorage _propertyStorage = getPropertyStorage();
        Depositary _depositary = getDepositary();

        require(_zfbToken.balanceOf(msg.sender) >= _rental, 'not sufficient funds');
        _depositary.input(msg.sender, _rental);
        _propertyStorage.submitRent(msg.sender, _propertyId, _startTime, _howLong, _rental);
    }

    function agreeRent(uint _propertyId) public {
        PropertyStorage _propertyStorage = getPropertyStorage();
        _propertyStorage.agreeRent(msg.sender, _propertyId);
    }

    function getRental(uint _propertyId) public {
        PropertyStorage _propertyStorage = getPropertyStorage();
        Depositary _depositary = getDepositary();

        uint withdrawAmount = _propertyStorage.calculateRental(msg.sender, _propertyId);
        _depositary.output(msg.sender, withdrawAmount);
        emit WithdrawRental(withdrawAmount);
    }

//    function ownerRate(uint _propertyId, uint8 _rate) public {
//        ZFBToken _zfbToken = getZFBToken();
//        PropertyStorage _propertyStorage = getPropertyStorage();
//
//        _propertyStorage.ownerRate(msg.sender, _propertyId, _rate);
//        _zfbToken.approve(msg.sender, rewardNum);
//    }
//
//    function tenantRate(uint _propertyId, uint8 _rate) public {
//        ZFBToken _zfbToken = getZFBToken();
//        PropertyStorage _propertyStorage = getPropertyStorage();
//
//        _propertyStorage.tenantRate(msg.sender, _propertyId, _rate);
//        _zfbToken.approve(msg.sender, rewardNum);
//    }

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

    function getDepositary() private returns (Depositary) {
        ContractManager _manager = ContractManager(managerAddress);
        address _depositaryAddress = _manager.getAddress("Depositary");
        return Depositary(_depositaryAddress);
    }

}