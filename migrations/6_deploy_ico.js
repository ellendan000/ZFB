const ZFBToken = artifacts.require("ZFBToken");
const ZFBTokenICO = artifacts.require("ZFBTokenICO");

module.exports = (deployer) => {

  deployer.deploy(ZFBTokenICO, ZFBToken.address)
    .then(() => {
      return ZFBToken.deployed()
    })
    .then(token => {
      return token.fundICO(ZFBTokenICO.address)
    })

};