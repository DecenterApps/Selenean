require('dotenv').load();

const util = require('util');
const exec = util.promisify(require('child_process').exec);
const EthereumTx = require('ethereumjs-tx');
const Web3 = require('web3');

const bs58 = require('bs58');

const fs = require('fs');

const testAbi = require('../build/contracts/CardMetadata.json');
const bigJson = require('./big.json');
const testContractAddress = '0x3ade0e8977355a734ed21c58f707ef4650feb6e0';

const ourAddress = process.env.ADDRESS;
const ourPrivateKey = process.env.PRIV_KEY;

const web3 = new Web3(new Web3.providers.HttpProvider("http://ropsten.decenter.com"));
web3.eth.defaultAccount = ourAddress;

const testContract = web3.eth.contract(testAbi.abi).at(testContractAddress);

let nonce = web3.eth.getTransactionCount(ourAddress);

const gasPrice = 1502509001;

async function parseBigJson(cb) {

    const numCards = bigJson.cards.length - 1;

    bigJson.cards.forEach(async (card, i) => {
        const { stdout, stderr } = await exec('ipfs add -q ' + card.img);

        const ipfsHashes  = stdout.split('\n');

        const imgHash = ipfsHashes[0];

        card.img = imgHash;

        fs.writeFile(`./cards/card_${i}`, JSON.stringify(card), (err) => {
            if (err) console.log(err);

            console.log(numCards, i);

            if (numCards === i) {
                cb();
            }
        });
        
    });
}

async function ipfs() {

    parseBigJson(async () => {
        const { stdout, stderr } = await exec('ipfs add -rq ./cards');

        let ipfsHashes = stdout.split('\n');
    
        ipfsHashes.pop();
        ipfsHashes.pop();
    
        const rarity = bigJson.cards.map(c => c.rarity);
    
        await sendTxInBatch(ipfsHashes, rarity);
    });

}

async function sendTxInBatch(arr, rarity) {
    let i = 0;

    for (const key in arr) {
        const hash = arr[key];

        const {hashFunction, size, ipfsHash} = deconstructIpfsHash(hash);

        console.log(rarity[i], ipfsHash, hashFunction, size);

        await sendTransaction(web3, testContract.addCardMetadata, ourAddress, [rarity[i], ipfsHash, hashFunction, size], gasPrice, web3.toHex(nonce));
        nonce++;
        i++;
    }
}

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

        const gas = web3.toHex(1190000);

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

function deconstructIpfsHash(ipfs) {
    const ipfsBase58 = bs58.decode(ipfs).toString('hex');

    console.log('ipfs: ', ipfs, 'IpfsB58: ', ipfsBase58);

    const hashFunction = '0x' + ipfsBase58.slice(0, 2);
    const size = '0x' + ipfsBase58.slice(2, 4);
    const ipfsHash = '0x' + ipfsBase58.slice(4);

    return {
        hashFunction,
        size,
        ipfsHash
    };
}

function constructIpfsHash(hashFunction, size, ipfsHash) {
    const hexHashFunction = hashFunction.toString(16);
    const hexSize = size.toString(16);

    console.log(hexHashFunction, hexSize, ipfsHash);

    return bs58.encode(Buffer.from(`${hexHashFunction}${hexSize}${ipfsHash}`, 'hex'));
}

(async () => {
    await ipfs();

    //const ipfsHash = constructIpfsHash(18, 32, "2e29612cea9f1a7cbcd16a68eb9b27a3a37e0b2ca926d4034e1d9a27a4642677");

    //console.log(ipfsHash);
})();