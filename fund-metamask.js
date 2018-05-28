const sender = web3.eth.accounts[1];
const receivers = [
    '0x40aEfa4160201Efa86d33Cad691BbcA2f83A84fE',
    '0xF4e766aF0190Bcf2e4353f599FD4951FAdca7990',
];
const amount = web3.toWei(10, 'ether');

module.exports = function(callback) {
  receivers.forEach(receiver =>
      web3.eth.sendTransaction({
          from: sender,
          to: receiver,
          value: amount
      }, callback)
  );
};