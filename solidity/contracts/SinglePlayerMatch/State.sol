pragma solidity ^0.4.20;

contract State {
   mapping(address => uint[]) states;

    function resetState() public returns (bool) {
        if (states[msg.sender].length == 3) {
            states[msg.sender][0] = 0;
            states[msg.sender][1] = 0;
            states[msg.sender][2] = 0;
        } else {
            states[msg.sender] = new uint[](3);
        }

        return true;
    }

    function getState() public view returns (uint[]) {
        return states[msg.sender];
    }

    function setState(uint[] state) public {
        states[msg.sender][0] = state[0];
        states[msg.sender][1] = state[1];
    }

    event Print(uint broj);

    //TODO comment code
    function updateState(uint[] moves) public returns (bool) {
        uint state = states[msg.sender][0];

        assembly {
            let len := mload(moves)
            let move := add(moves, 0x20)

            let funds := div(and(state, mul(exp(2, 224), sub(exp(2, 32), 1))), exp(2, 224))
            let fundsPerBlock := div(and(state, mul(exp(2, 208), sub(exp(2, 16), 1))), exp(2, 208))
            let experience := div(and(state, mul(exp(2, 176), sub(exp(2, 32), 1))), exp(2, 176))
            let devLeft := div(and(state, mul(exp(2, 160), sub(exp(2, 16), 1))), exp(2, 160))
            let blockNumber := div(and(state, mul(exp(2, 128), sub(exp(2, 32), 1))), exp(2, 128))

            for
                { let end := add(move, len) }
                lt(move, end)
                { move := add(move, 0x20) }
            {
                let incr := 0
                for
                    {  }
                    lt(incr, 28)
                    { incr := add(incr, 4) }
                {
                    let move256 := div(and(mload(move), mul(exp(2, mul(sub(28, incr), 8)), sub(exp(2, 32), 1))), exp(2, mul(sub(28, incr), 8)))

                    if gt(and(move256, exp(2, 31)), 0) {
                        //adding
                    }

                    if iszero(and(state, mul(move256, 31))) {
                        //removing
                        state := add(sub(state, move256), mul(move256, 32))
                    }
                }
            }
        }

        states[msg.sender][0] = state;

        return true;
    }
}