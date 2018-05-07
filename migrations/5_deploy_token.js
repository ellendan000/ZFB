const ZFBToken = artifacts.require("ZFBToken");
const ContractManager = artifacts.require('ContractManager');

module.exports = (deployer) => {
  deployer.deploy(ZFBToken)
    .then(() => {
      return ContractManager.deployed()
    })
    .then((manager) => {
      manager.setAddress("ZFBToken", ZFBToken.address)
    });
};