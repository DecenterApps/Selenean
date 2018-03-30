// # STATE
// STATE
// /funds/fundsPerBlock/experience/devLeft/blockNumber/registryPosition/
// 48 16 32 20 36 8        total 160/256
// /card/blockNumberUntilFinished/
// 10 * (6 + 18) project               total 240/256
// /card/numberOfCards/space/computeCaseSpaceLeft/rigSpaceLeft/mountSpaceLeft/powerLeft/devPointsCount/CoffeMiner
// 3 * 6 10 13 10 10 10 13 12 1      total 255/256 locations
// 3 * 6 10 13 10 10 10 13 12 1     total 255/256
// /cardType/numberOfCards/
// 10 6 karta

// MOVES
// /blockNumber/
// 32                total 32    
// /add/dynamic-static/cardSpecificBits/card/blockNumberOffset            
// n * 1 1 4 10 16        n * 32

const bigInt = require("big-integer");

//This is only for the first uint
const firstUintStateBin = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001110010010000100000000000011001000000000000000000000000000000011110000000000000000100000000000000000110011111000100000100000000101";
const firstUintStateHex = "00000000000000000000000000000003921000c80000000f0000800033e20805";

const metadata = {
    funds: {
        startPos: 0,
        endPos: 48
    },
    fundsPerBlock: {
        startPos: 48,
        endPos: 16
    },
    experience: {
        startPos: 64,
        endPos: 32
    },
    devLeft: {
        startPos: 96,
        endPos: 20
    },
    blockNumber: {
        startPos: 116,
        endPos: 36
    },
    registryPosition: {
        startPos: 152,
        endPos: 8
    },
};

const state = {
    funds: 234000,
    fundsPerBlock: 200,
    experience: 15,
    devLeft: 8,
    blockNumber: 3400200,
    registryPosition: 5,
    projects: [
        {
            card: 1,
            blockNumberUntilFinished: 10
        },
        {
            card: 2,
            blockNumberUntilFinished: 11
        },
        {
            card: 3,
            blockNumberUntilFinished: 9
        },
        {
            card: 4,
            blockNumberUntilFinished: 7
        },
        {
            card: 5,
            blockNumberUntilFinished: 8
        },
        {
            card: 6,
            blockNumberUntilFinished: 4
        },
    ],
    locations: [{
            card: 4,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        },
        {
            card: 1,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 0,
        },
        {
            card: 2,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        },
        {
            card: 3,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        },
        {
            card: 4,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        },
        {
            card: 5,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        },
        {
            card: 6,
            numberOfCards: 3,
            space: 7,
            computeCaseSpaceLeft: 10,
            rigSpaceLeft: 11,
            mountSpaceLeft: 2,
            powerLeft: 6,
            devPointsCount: 50,
            coffeMiner: 1,
        }],
        cardPositions: [{
            cardType: 46,
            numberOfCards: 5
        },
        {
            cardType: 36,
            numberOfCards: 2
        },
        {
            cardType: 16,
            numberOfCards: 7
        },
        {
            cardType: 66,
            numberOfCards: 9
        }],
        blockNumber: 345345,
        moves: [{
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        },
        {
            add: 0,
            dynamicStatic: 1,
            cardSpecificBits: 2,
            card: 6,
            blockNumberOffset: 54
        }]
};

// A test method to read the first uint from the state
function readFromBinary() {
    let bin = (new bigInt(firstUintStateHex, 16).toString(2));

    bin = bin.padStart(160, 0)

    // /funds/fundsPerBlock/experience/devLeft/blockNumber/registryPosition/
// 48 16 32 20 36 8        total 160/256

    console.log('Funds: ', bin2dec(bin.substr(0, 48)));
    console.log('Funds per block: ', bin2dec(bin.substr(48, 16)));
    console.log('Experience: ', bin2dec(bin.substr(64, 32)));
    console.log('DevLeft: ', bin2dec(bin.substr(96, 20)));
    console.log('blockNum', bin2dec(bin.substr(116, 36)));
    console.log('registryPosition', bin2dec(bin.substr(152, 48)));
}

// Ispada da state ne treba da se packuje, vec samo moves
function fromStateToBinary(_state) {
    //first uint
    const firstHex = getBinary(_state, 'funds') + getBinary(_state, 'fundsPerBlock') +
    getBinary(_state, 'experience') + getBinary(_state, 'devLeft') +
    getBinary(_state, 'blockNumber') + getBinary(_state, 'registryPosition');

    // const secondHex = getProjects(_state);

    // const locHexes = getLocations(_state);

    // const cardPos = packCardPositions(_state);

    const moves = packMoves(_state);

    //console.log(firstHex);
    // console.log(dec2bin(234000, 48));
    // console.log(dec2bin(200, 16));
    // console.log(dec2bin(15, 32));
    // console.log(dec2bin(8, 20));
    // console.log(dec2bin(3400200, 36));
    // console.log(dec2bin(5, 8));
}
// Helper functions

function getProjects(_state) {
    const binProjects = _state.projects.map(p => dec2bin(p.card, 6) + dec2bin(p.blockNumberUntilFinished, 18));

    return toHex(binProjects.join(''));
}

function getLocations(_state) {
   const binLocs =  _state.locations.map((loc, i) => 
        dec2bin(loc.card, 6) + dec2bin(loc.numberOfCards, 10) + dec2bin(loc.space, 13) +
        dec2bin(loc.computeCaseSpaceLeft, 10) + dec2bin(loc.rigSpaceLeft, 10) + dec2bin(loc.mountSpaceLeft, 10) +
        dec2bin(loc.powerLeft, 13) + dec2bin(loc.devPointsCount, 12) + dec2bin(loc.coffeMiner, 1));

    return [toHex(binLocs[0] + binLocs[1] + binLocs[2]), toHex(binLocs[3] + binLocs[4] + binLocs[5])];
}

function packMoves(_state) {
    const blockNum = dec2bin(_state.blockNumber, 32);

    const binMoves = _state.moves.map(move => dec2bin(move.add, 1) + dec2bin(move.dynamicStatic, 1) +
        + dec2bin(move.cardSpecificBits, 4) + dec2bin(move.card, 10) + dec2bin(move.blockNumberOffset, 16));

    
    return _pack(binMoves, blockNum);
}

function packCardPositions(_state) {
    const bin = _state.cardPositions.map(c => dec2bin(c.card, 10) + dec2bin(c.numberOfCards, 6));

    console.log(bin);

    return _pack(bin, "");
}

// helper functions

function _pack(arr, start) {
    const hexValues = [];
    let str = start;

    arr.forEach(b => {
        if ((str.length + b.length) < 256) {
            str += b;
        } else {
            hexValues.push(str);
            str = "";
        }
    });

    if (str.length !== 0) {
        hexValues.push(str);
    }

    return hexValues.map(h => toHex(h));
}

const dec2bin = (d, l) => (d >>> 0).toString(2).padStart(l, '0');
const bin2dec = (bin) => parseInt(bin, 2);
const getBinState = (bin, type) => bin.substr(metadata[type].startPos, metadata[type].endPos);
const getState = (bin, type) => bin2dec(getBinState(bin, type));
const getBinary = (state, type) => dec2bin(state[type], metadata[type].endPos);
const toHex = (str) => '0x' + ((new bigInt(str.padStart(256, '0'), 2)).toString(16)).padStart(64, 0);

// call the methods
//fromStateToBinary(state);

readFromBinary();
