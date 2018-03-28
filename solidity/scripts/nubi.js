
// STATE
// /funds/fundsPerBlock/experience/devLeft/blockNumber/registryPosition/
// 48 16 32 20 36 8        total 152/256
// /card/blockNumberUntilFinished/
// 10 * 6 18 project               total 240/256
// /card/numberOfCards/space/computeCaseSpaceLeft/rigSpaceLeft/mountSpaceLeft/powerLeft/devPointsCount/CoffeMiner
// 3 * 6 10 13 10 10 10 13 12 1      total 255/256
// 3 * 6 10 13 10 10 10 13 12 1     total 255/256
// /cardType/numberOfCards/
// 11 5 karta

// MOVES
// /blockNumber/
// 32
// /add/dynamic-static/cardSpecificBits/card/blockNumberOffset            
// n * 1 4 11 16        total 32 + n * 32

const inputBinary = "0000000000000000000000000000001110010010000100000000000011001000000000000000000000000000000011110000000000000000100000000000000000110011111000100000100000000101";

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
    slots: [
        1, 2, 3, 4, 5, 6
    ]
};

const state = {
    funds: 234000,
    fundsPerBlock: 200,
    experience: 15,
    devLeft: 8,
    blockNumber: 3400200,
    registryPosition: 5
};

function getBinState(_binState, _type) {
    return _binState.substr(metadata[_type].startPos, metadata[_type].endPos);
}

function fromBinaryState(_inputBinary) {
    console.log('Funds: ', bin2dec(getBinState(_inputBinary, 'funds')));
    console.log('Funds per block: ', bin2dec(getBinState(_inputBinary, 'fundsPerBlock')));
    console.log('Experience: ', bin2dec(getBinState(_inputBinary, 'experience')));
    console.log('Dev left: ', bin2dec(getBinState(_inputBinary, 'devLeft')));
    console.log('Blocknumber: ', bin2dec(getBinState(_inputBinary, 'blockNumber')));
    console.log('Registry Position: ', bin2dec(getBinState(_inputBinary, 'registryPosition')));
}

function fromStateToBinary(_state) {
    console.log(dec2bin(_state.funds, 48), dec2bin(_state.fundsPerBlock, 16),
    dec2bin(_state.experience, 32), dec2bin(_state.devLeft, 20),
    dec2bin(_state.blockNumber, 36), dec2bin(_state.registryPosition, 8)
    );
}

const dec2bin = (d, l) => (d >>> 0).toString(2).padStart(l, '0');
const bin2dec = (bin) => parseInt(bin, 2);

fromStateToBinary(state);
fromBinaryState(inputBinary);