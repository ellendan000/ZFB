const ZFBToken = artifacts.require("ZFBToken");
const Depositary = artifacts.require("Depositary");
const ContractManager = artifacts.require('ContractManager');

module.exports = (deployer) => {
  deployer.deploy(Depositary, ZFBToken.address)
    .then(() => {
        return Promise.all([
            Depositary.deployed(),
            ContractManager.deployed(),
        ])
    })
    .then(([depositary, manager]) => {
        manager.setAddress("Depositary", depositary.address)
    })
};