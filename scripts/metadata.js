require('dotenv').load();

const util = require('util');
const exec = util.promisify(require('child_process').exec);
const EthereumTx = require('ethereumjs-tx');
const Web3 = require('web3');

const bs58 = require('bs58');

const fs = require('fs');

const conf = require('./config.json');
const bigJson = require('./big.json');
const testContractAddress = conf.metadataContract.address;

const ourAddress = process.env.ADDRESS;
const ourPrivateKey = process.env.PRIV_KEY;

const web3 = new Web3(new Web3.providers.HttpProvider("https://kovan.decenter.com"));
web3.eth.defaultAccount = ourAddress;

const testContract = web3.eth.contract(conf.metadataContract.abi).at(testContractAddress);

let nonce = web3.eth.getTransactionCount(ourAddress);

const gasPrice = 1502509001;

async function parseBigJson(cb) {

    const numCards = 42;

    let i = 0;

    let cards = bigJson.cards.sort((a,b) => parseInt(a['1'].ID) - parseInt(b['1'].ID));

    for(let card of cards) {
        const { stdout, stderr } = await exec('ipfs add -q ./images/' + card['1'].image);

        const ipfsHashes  = stdout.split('\n');

        const imgHash = ipfsHashes[0];

        card['1'].img = imgHash;

        fs.writeFile(`./cards/card_${i}`, JSON.stringify(card['1']), (err) => {
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
        const cards = ['card_0', 'card_1', 'card_2', 'card_3', 'card_4', 'card_5', 'card_6', 'card_7', 'card_8', 'card_9', 'card_10', 'card_11', 'card_12', 'card_13', 'card_14', 'card_15', 'card_16', 'card_17', 'card_18', 'card_19', 'card_20', 'card_21', 'card_22', 'card_23', 'card_24', 'card_25', 'card_26', 'card_27', 'card_28', 'card_29', 'card_30', 'card_31', 'card_32', 'card_33', 'card_34', 'card_35','card_36', 'card_37', 'card_38', 'card_39', 'card_40', 'card_41','card_42'];

        let ipfsHashes = [];

        for(let card of cards) {
            const { stdout, stderr } = await exec('ipfs add -q ./cards/' + card);

            ipfsHashes.push(stdout.split('\n')[0]);
        }

        let cc = bigJson.cards.sort((a,b) => parseInt(a['1'].ID) - parseInt(b['1'].ID));

        const rarity = cc.map(c => c['1'].rarityScore);

        console.log(rarity);

        const artist = [];

        // test artists addresses 
        const artistsAddr = ['0xae0aFD6a330D6CA572441f29F6ef0dc4372d8ee4', '0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6', '0xd07C572DF544C2C6BD31f3ea413BbEF839B00eB1'];

        for (let i = 0; i < 43; ++i) {
            artist.push(artistsAddr[i % 3]);
        }

        console.log(ipfsHashes.length);
    
        await sendTxInBatch(ipfsHashes, rarity, artist);
    });

}

async function sendTxInBatch(arr, rarity, artist) {
    let i = 0;
    
    for (const key in arr) {
        const hash = arr[key];

        const {hashFunction, size, ipfsHash} = deconstructIpfsHash(hash);

        if (rarity[i] != undefined) {
            //console.log(rarity[i], ipfsHash, hashFunction, size, artist[i]);
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

    // console.log(constructIpfsHash(18, 32, '5e896d13a472bcc493b2ea5d74cf12e1fe4c0ca6c122d7b25809ec52a44043c5'));

    // const ipfsBase58 = bs58.encode(Buffer.from("1220cc4e84e88983588834fbebc707dc6c7c89bc8275f8e0b337f6ea002ffacb755c", "hex"));

    // console.log(ipfsBase58);

    //const ipfsHash = constructIpfsHash(18, 32, "2e29612cea9f1a7cbcd16a68eb9b27a3a37e0b2ca926d4034e1d9a27a4642677");

    //console.log(ipfsHash);
})();