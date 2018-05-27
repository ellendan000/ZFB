const sender = web3.eth.accounts[1];
const receiver = '0x40aEfa4160201Efa86d33Cad691BbcA2f83A84fE';
const amount = web3.toWei(10, 'ether');

module.exports = function(callback) {
  web3.eth.sendTransaction({
    from: sender,
    to: receiver,
    value: amount
  }, callback)
};