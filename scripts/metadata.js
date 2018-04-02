require('dotenv').load();

const util = require('util');
const exec = util.promisify(require('child_process').exec);
const EthereumTx = require('ethereumjs-tx');
const Web3 = require('web3');

const bs58 = require('bs58');

const fs = require('fs');

const conf = require('./config.dist.json');
const bigJson = require('./big.json');
const testContractAddress = conf.metadataContract.address;

const ourAddress = process.env.ADDRESS;
const ourPrivateKey = process.env.PRIV_KEY;

const web3 = new Web3(new Web3.providers.HttpProvider("http://kovan.decenter.com"));
web3.eth.defaultAccount = ourAddress;

const testContract = web3.eth.contract(conf.metadataContract.abi).at(testContractAddress);

let nonce = web3.eth.getTransactionCount(ourAddress);

const gasPrice = 1502509001;

async function parseBigJson(cb) {

    const numCards = bigJson.cards.length - 1;

    let i = 0;

    for(let card of bigJson.cards) {
        const { stdout, stderr } = await exec('ipfs add -q ./images/' + card.image);

        const ipfsHashes  = stdout.split('\n');

        const imgHash = ipfsHashes[0];

        card.img = imgHash;

        fs.writeFile(`./cards/card_${i}`, JSON.stringify(card), (err) => {
            if (err) console.log(err);

            console.log(numCards, i);

            if (numCards === i) {
                cb();
            }

            i++;
        });
        
    }
}

async function ipfs() {

    parseBigJson(async () => {
        const { stdout, stderr } = await exec('ipfs add -rq ./cards');

        let ipfsHashes = stdout.split('\n');
    
        ipfsHashes.pop();
        ipfsHashes.pop();
    
        const rarity = bigJson.cards.map(c => c.rarity);
        const artist = bigJson.cards.map(c => c.artist);
    
        await sendTxInBatch(ipfsHashes, rarity, artist);
    });

}

async function sendTxInBatch(arr, rarity, artist) {
    let i = 0;

    for (const key in arr) {
        const hash = arr[key];

        const {hashFunction, size, ipfsHash} = deconstructIpfsHash(hash);

        console.log(rarity[i], ipfsHash, hashFunction, size);

        if (rarity[i] != undefined) {
            await sendTransaction(web3, testContract.addCardMetadata, ourAddress, [rarity[i], ipfsHash, hashFunction, size, artist[i]], gasPrice, web3.toHex(nonce));
            nonce++;
            i++;
        }
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

function hexToBase58(hex) {

}

(async () => {
    await ipfs();

    // const ipfsBase58 = bs58.encode(Buffer.from("1220cc4e84e88983588834fbebc707dc6c7c89bc8275f8e0b337f6ea002ffacb755c", "hex"));

    // console.log(ipfsBase58);

    //const ipfsHash = constructIpfsHash(18, 32, "2e29612cea9f1a7cbcd16a68eb9b27a3a37e0b2ca926d4034e1d9a27a4642677");

    //console.log(ipfsHash);
})();