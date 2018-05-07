const PropertyStorage = artifacts.require('PropertyStorage');

module.exports = (deployer) => {
  deployer.deploy(PropertyStorage);
};