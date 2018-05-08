const web3 = require('web3');
const {
  utils: {toWei},
} = web3;

const PropertyStorage = artifacts.require('PropertyStorage');
const PropertyController = artifacts.require('PropertyController');
const ZFBTokenICO = artifacts.require('ZFBTokenICO');
const ZFBToken = artifacts.require('ZFBToken');
const utils = require('../utils');
const {assertVMException} = utils;

const getFund = async (_address) => {
  const ico = await ZFBTokenICO.deployed();

  const wei = toWei('1', "ether");
  await ico.sendTransaction({
    from: _address,
    value: wei,
  });
};

contract('properties', (accounts) => {

  it("can't publish property without controller", async () => {
    const storage = await PropertyStorage.deployed();

    try {
      await storage.publishProperty(5);
      assert.fail();
    } catch (err) {
      assertVMException(err);
    }
  });

  it("can publish property with controller when has enough ZFB", async () => {
    const _address = accounts[1];
    getFund(_address);

    const token = await ZFBToken.deployed();
    const userBalance = await token.balanceOf.call(_address);
    assert.equal(userBalance.toString(), "1000");

    const controller = await PropertyController.deployed();
    const tx = await controller.publishProperty.sendTransaction({from: _address});

    assert.isOk(tx);

    const propertyStorageBalance = await token.balanceOf.call(PropertyStorage.address);
    assert.equal(propertyStorageBalance.toString(), "5");
  });

  it("can't publish property with controller when has no ZFB", async () => {
    const controller = await PropertyController.deployed();

    try {
      const tx = await controller.publishProperty.sendTransaction({from: accounts[2]});
      assert.fail();
    } catch (err) {
      assertVMException(err);
    }
  });


});