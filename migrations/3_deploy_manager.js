const ContractManager = artifacts.require('ContractManager');
const PropertyStorage = artifacts.require('PropertyStorage');

module.exports = (deployer) => {
  
  deployer.deploy(ContractManager)
  .then(() => {
    return ContractManager.deployed()
  })
  .then(manager => {
    return Promise.all([
      manager.setAddress("PropertyStorage", PropertyStorage.address),
    ])
  })

};