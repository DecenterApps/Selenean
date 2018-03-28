require('dotenv').load();

const util = require('util');
const exec = util.promisify(require('child_process').exec);
const EthereumTx = require('ethereumjs-tx');
const Web3 = require('web3');

const bs58 = require('bs58');

const fs = require('fs');

const testAbi = require('./testAbi.json');
const bigJson = require('./big.json');
const testContractAddress = '0x471e5e671e70c34ad90d5077bbeda782e7e8c6b3';

const ourAddress = process.env.ADDRESS;
const ourPrivateKey = process.env.PRIV_KEY;

const web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io"));
web3.eth.defaultAccount = ourAddress;

const BN = require('bn.js');

const testContract = web3.eth.contract(testAbi.abi).at(testContractAddress);

let nonce = web3.eth.getTransactionCount(ourAddress);

const gasPrice = 8502509001;

const getEncodedParams = (contractMethod, params = null) => {
    let encodedTransaction = null;
    if (!params) {
      encodedTransaction = contractMethod.request.apply(contractMethod); // eslint-disable-line
    } else {
      encodedTransaction = contractMethod.request.apply(contractMethod, params); // eslint-disable-line
    }
    return encodedTransaction.params[0];
  };

const sendTransaction = async (web3, contractMethod, from, params, _gasPrice, nonce) =>
    new Promise(async (resolve, reject) => {
    try {
        const privateKey = new Buffer(ourPrivateKey, 'hex');

        const { to, data } = getEncodedParams(contractMethod, params);

        const gasPrice = web3.toHex(_gasPrice);

        const gas = web3.toHex(590000);

        let transactionParams = { from, to, data, gas, gasPrice, nonce };

        const txHash = await sendRawTransaction(web3, transactionParams, privateKey);
        console.log('TX hash', txHash);
        resolve(txHash);
    } catch (err) {
        reject(err);
    }
});

const sendRawTransaction = (web3, transactionParams, privateKey) =>
    new Promise((resolve, reject) => {
        const tx = new EthereumTx(transactionParams);

        tx.sign(privateKey);

        const serializedTx = `0x${tx.serialize().toString('hex')}`;

        web3.eth.sendRawTransaction(serializedTx, (error, transactionHash) => {
            console.log("Err: ", error);
            if (error) reject(error);

            resolve(transactionHash);
        });
});

const convert = async (cards) => {
    let b = '0x';

    const arr = [];

    cards.forEach(card => {
        const a0 = web3.toHex(card);
        const a = a0.slice(2, a0);
        let a1 = Array(3 - a.length).join("0");
        b += a1 + a;

        if(b.length === 64) {
            arr.push(b);
            b = '0x';
        }
    });

    if (b.length < 64) {
        b = b.padEnd(64, '0');
    }

    arr.push(b);

    return arr;
};

async function updateState(inputs) {

    await sendTransaction(web3, testContract.updateState, ourAddress, [inputs], gasPrice, web3.toHex(nonce));
    nonce++;
}

(async () => {
    //await parseData();

    const parsedArr = await convert(["180","180","180","180","180","180","180","180" ,"180" ,"180" ,"180", "20",
     "20", "20", "20", "20", "20", "20", "20", "20", "20", "20", "130", "130", "130", "130",
     "130", "130", "130", "130", "130", "130", "130", "10", "10", "10", "10", "10", "10", "10",
     "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10",
     "10", "10", "10", "10", "10", "10", "10", "10", "0", "0", "0", "0", "0", "0", "0", "0", "0",
     "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0",
     "0", "0", "0"]);

    console.log(parsedArr);

    const results = parsedArr.map(p => (new BN(p, 16)).toString(10));

    console.log(results);

    await updateState(results);


    //console.log('0xb4b4b4b4b4b4b4b4b4b4b4141414141414141414141482828282828282828282820a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000'.length)

})();