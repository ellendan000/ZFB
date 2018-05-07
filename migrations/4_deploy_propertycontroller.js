const PropertyController = artifacts.require('PropertyController');
const PropertyStorage = artifacts.require('PropertyStorage');
const ContractManager = artifacts.require('ContractManager');

module.exports = (deployer) => {

  deployer.deploy(PropertyController)
    .then(() => {
      return PropertyController.deployed()
    })
    .then(propertyController => {
      propertyController.setManagerAddress(ContractManager.address);

      return Promise.all([
        ContractManager.deployed(),
        PropertyStorage.deployed(),
      ])
    })
    .then(([manager, storage]) => {
      return Promise.all([
        manager.setAddress("PropertyController", PropertyController.address),
        storage.setControllerAddress(PropertyController.address),
      ])
    })

};