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

    const wei = toWei('1', 'ether');
    await ico.sendTransaction({
        from: _address,
        value: wei,
    });
};

const getEvent = (result, eventName) => {
    for(let i=0; i< result.logs.length; i++) {
        const log = result.logs[i];

        if (log.event === eventName) {
            return log;
        }
    }
};

contract('properties', async (accounts) => {
    let storage, token, controller;

    before(async () => {
        storage = await PropertyStorage.deployed();
        token = await ZFBToken.deployed();
        controller = await PropertyController.deployed();
    });

    it("can't publish property without controller", async () => {
        try {
            await storage.publishProperty(accounts[1], '一室一厅', 5);
            assert.fail();
        } catch (err) {
            assertVMException(err);
        }
    });

    it("can publish property with controller when has enough ZFB", async () => {
        const _address = accounts[1];
        await getFund(_address);

        const userBalance = await token.balanceOf.call(_address);
        assert.equal(userBalance.toString(), '1000');

        token.approve.sendTransaction(PropertyController.address, 5, {from: _address});

        const tx = await controller.publishProperty.sendTransaction('一室一厅', {from: _address});
        assert.isOk(tx);

        const propertyStorageBalance = await token.balanceOf.call(PropertyStorage.address);
        assert.equal(propertyStorageBalance.toString(), '5');
    });

    it("can't publish property with controller when has no ZFB", async () => {
        try {
            const tx = await controller.publishProperty.sendTransaction('一室一厅', {from: accounts[2]});
            assert.fail();
        } catch (err) {
            assertVMException(err);
        }
    });

    it("can submit rent for property with controller when has enough ZFB", async () => {
        const _ownerAddress = accounts[1];
        await getFund(_ownerAddress);

        const _rentAddress = accounts[3];
        await getFund(_rentAddress);

        const storageBalance = await token.balanceOf.call(storage.address);
        token.approve.sendTransaction(PropertyController.address, 5, {from: _ownerAddress});
        token.approve.sendTransaction(PropertyController.address, 15, {from: _rentAddress});

        await controller.publishProperty('一室一厅', {from: _ownerAddress}).then(async (result) => {
            let event = getEvent(result, 'PropertyPublished');
            const propertyId = event.args.id.toNumber();

            const tx1 = await controller.submitRent.sendTransaction(propertyId, new Date().getTime(), 15, 15, {from: _rentAddress});
            assert.isOk(tx1);

            const propertyStorageBalance = await token.balanceOf.call(_rentAddress);
            assert.equal(propertyStorageBalance.toString(), '985');

            const currentStorageBalance = await token.balanceOf.call(storage.address);
            assert.equal(currentStorageBalance.sub(storageBalance).toString(), '20');

            const tx2 = await controller.agreeRent(propertyId, {from: _ownerAddress});
            assert.isOk(tx2);
        });
    });

});