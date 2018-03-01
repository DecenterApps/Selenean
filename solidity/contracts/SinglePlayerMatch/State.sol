pragma solidity ^0.4.19;

contract State {
    uint public constant DEV1A = 2 >> 1;
    uint public constant DEV1U = 2 << 4;
    uint public constant DEV2A = 2 << 9;
    uint public constant DEV2U = 2 << 14;
    uint public constant DEV3A = 2 << 19;
    uint public constant DEV3U = 2 << 24;

    uint public constant DEV4A = 2 << 29;
    uint public constant DEV4U = 2 << 34;
    uint public constant DEV5A = 2 << 39;
    uint public constant DEV5U = 2 << 44;
    uint public constant DEV6A = 2 << 49;
    uint public constant DEV6U = 2 << 54;

    uint public constant GAR1A = 2 << 59;
    uint public constant GAR1U = 2 << 64;
    uint public constant GAR2A = 2 << 69;
    uint public constant GAR2U = 2 << 74;
    uint public constant GAR3A = 2 << 79;
    uint public constant GAR3U = 2 << 84;

    uint public constant GAR4A = 2 << 89;
    uint public constant GAR4U = 2 << 94;
    uint public constant GAR5A = 2 << 99;
    uint public constant GAR5U = 2 << 104;
    uint public constant GAR6A = 2 << 109;
    uint public constant GAR6U = 2 << 114;

    uint public constant RIG1A = 2 << 119;
    uint public constant RIG1U = 2 << 124;
    uint public constant RIG2A = 2 << 129;
    uint public constant RIG2U = 2 << 134;
    uint public constant RIG3A = 2 << 139;
    uint public constant RIG3U = 2 << 144;

    uint public constant RIG4A = 2 << 149;
    uint public constant RIG4U = 2 << 154;
    uint public constant RIG5A = 2 << 159;
    uint public constant RIG5U = 2 << 164;
    uint public constant RIG6A = 2 << 169;
    uint public constant RIG6U = 2 << 174;

    uint public constant POW1A = 2 << 179;
    uint public constant POW1U = 2 << 184;
    uint public constant POW2A = 2 << 189;
    uint public constant POW2U = 2 << 194;
    uint public constant POW3A = 2 << 199;
    uint public constant POW3U = 2 << 204;

    uint public constant POW4A = 2 << 209;
    uint public constant POW4U = 2 << 214;
    uint public constant POW5A = 2 << 219;
    uint public constant POW5U = 2 << 224;
    uint public constant POW6A = 2 << 229;
    uint public constant POW6U = 2 << 234;

    mapping(address => uint) states;

    function createState() public returns (bool) {
        states[msg.sender] = DEV1A + DEV2A + DEV3A + GAR1A + GAR2A + RIG1A + RIG2A + POW1A + POW2A + POW3A
        + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A + POW1A
        + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A + DEV3A
        + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A + RIG2A
        + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A
        + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A + DEV2A
        + DEV2A + DEV2A + DEV2A + DEV2A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A
        + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A
        + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A + DEV1A;

        return true;
    }

    function getState() public view returns (uint) {
        return states[msg.sender];
    }

    //TODO comment code
    function updateState(uint[] moves) public returns (bool) {
        uint state = states[msg.sender];

        assembly {
            //TODO fix len
            let len := 0x20
            let move := add(moves, 0x01)

            for
                { let end := add(move, len) }
                lt(move, end)
                { move := add(move, 0x01) }
            {
                let move256 := exp(2, mload(move))
                if gt(and(state, mul(move256, 31)), 0) {
                    state := add(sub(state, move256), mul(move256, 32))
                }
            }
        }

        states[msg.sender] = state;

        return true;
    }
}