pragma solidity ^0.4.21;

import "../util/BaseController.sol";
import "../ContractManager.sol";
import "../token/ZFBToken.sol";
import "./PropertyStorage.sol";

contract PropertyController is BaseController, PropertyOwner {
    function publishProperty() public {
        ContractManager _manager = ContractManager(managerAddress);

        address _zfbTokenAddress = _manager.getAddress("ZFBToken");
        ZFBToken _zfbToken = ZFBToken(_zfbTokenAddress);

        address _propertyStorageAddress = _manager.getAddress("PropertyStorage");
        PropertyStorage _propertyStorage = PropertyStorage(_propertyStorageAddress);

        require(_zfbToken.balanceOf(msg.sender) >= 5, 'balance is not enough');
        _propertyStorage.publishProperty(deposit);
//        _zfbToken.transfer(_propertyStorageAddress, deposit);
    }
}