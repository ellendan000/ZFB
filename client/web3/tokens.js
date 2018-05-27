import { eth, getInstance, utils } from './provider';
import ZFBTokenICO from "./artifacts/ZFBTokenICO.json";
import ZFBToken from "./artifacts/ZFBToken.json";

export const exchangeForToken = async (amount) => {
    const ico = await getInstance(ZFBTokenICO);
    const addresses = await eth.getAccounts();

    const wei = utils.toWei(amount, 'ether');
    await ico.sendTransaction({
        from: addresses[0],
        value: wei,
    });
};

export const getTokenInfo = async () => {
    const token = await getInstance(ZFBToken);
    const addresses = await eth.getAccounts();
    const amount = await token.balanceOf.call(addresses[0]);
    return amount.toNumber();
};