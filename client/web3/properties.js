import {eth, getInstance} from './provider';
import PropertyController from "./artifacts/PropertyController.json";
import PropertyStorage from "./artifacts/PropertyStorage.json";
import ZFBToken from "./artifacts/ZFBToken.json";
import Depositary from "./artifacts/Depositary.json";

export const publishProperty = async (title) => {
    const controller = await getInstance(PropertyController);
    const token = await getInstance(ZFBToken);
    const depositary = await getInstance(Depositary);
    const addresses = await eth.getAccounts();

    await token.approve.sendTransaction(depositary.address, 5, {from: addresses[0]});
    const [propertyId, ownerAddress] = await controller.publishProperty.sendTransaction(title, {from: addresses[0]});
    return propertyId;
};

export const getProperty = async (propertyId) => {
    const storage = await getInstance(PropertyStorage);
    const property = await storage.idToProperty.call(propertyId);
    const [id, deposit, title, owner, state] = property;

    return {
        id: id.toNumber(),
        title,
        owner,
        state: state.toNumber()
    }
};

export const getRents = async (propertyId) => {
    const storage = await getInstance(PropertyStorage);

    const length = await storage.getRentsLength.call(propertyId);
    const list = [];
    for (let i = 0; i < length; i++) {
        const rent = await storage.propertyIdToRents.call(propertyId, i);
        const [tenant, startTime, minutes, rental,
            lastWithdrawTime, withdrawTotal, ownerRate, tenantRate] = rent;
        list.push({
            tenant,
            startTime: new Date(startTime.toNumber()),
            minutes: minutes.toNumber(),
            rental: rental.toNumber(),
            lastWithdrawTime: new Date(lastWithdrawTime.toNumber()),
            withdrawTotal: withdrawTotal.toNumber(),
            ownerRate: ownerRate.toNumber(),
            tenantRate: tenantRate.toNumber(),
        });
    }
    return list;
};

export const submitRent = async (propertyId, startTime, minutes, rental) => {
    const controller = await getInstance(PropertyController);
    const token = await getInstance(ZFBToken);
    const addresses = await eth.getAccounts();

    await token.approve.sendTransaction(depositary.address, rental, {from: addresses[0]});
    await controller.submitRent.sendTransaction(propertyId, startTime, minutes, rental, {from: addresses[0]});
};

export const agreeRent = async (propertyId) => {
    const controller = await getInstance(PropertyController);
    const token = await getInstance(ZFBToken);
    const addresses = await eth.getAccounts();

    await token.approve.sendTransaction(depositary.address, rental, {from: addresses[0]});
    await controller.submitRent.sendTransaction(propertyId, startTime, minutes, rental, {from: addresses[0]});
};
