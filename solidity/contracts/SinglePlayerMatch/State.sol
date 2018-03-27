pragma solidity ^0.4.19;

contract State {
    // mapping(address => bytes32) states;
    mapping(address => uint[]) states;

    function resetState() public {
        states[msg.sender] = new uint[](10);
        states[msg.sender][0] = 1532495540865888858358347027150309183618739122183602176;
    }

    function getState() public view returns (uint[]) {
        return states[msg.sender];
    }

    function getExp () public view returns (uint) {
        uint[] memory state = states[msg.sender];
        uint experience;

        assembly {
            experience := div(and(mload(add(state, 0x20)), mul(exp(2, 180), sub(exp(2, 24), 1))), exp(2, 180))
        }

        return experience;
    }

    event Print(uint broj);

    //TODO comment code
    function updateState(uint[] moves) public returns (uint[]) {
        uint[] memory state = states[msg.sender];

        assembly {
            let move := add(moves, 0x20)
            let end := add(move, mload(moves))

            let funds := div(and(mload(add(state, 0x20)), mul(exp(2, 216), sub(exp(2, 40), 1))), exp(2, 216))
            let fundsPerBlock := div(and(mload(add(state, 0x20)), mul(exp(2, 204), sub(exp(2, 12), 1))), exp(2, 204))
            let experience := div(and(mload(add(state, 0x20)), mul(exp(2, 180), sub(exp(2, 24), 1))), exp(2, 180))
            let devLeft := div(and(mload(add(state, 0x20)), mul(exp(2, 168), sub(exp(2, 12), 1))), exp(2, 168))

            let startBlock := div(add(mload(add(move, 0x20)), mul(exp(2, 224), sub(exp(2, 32), 1))), exp(2, 224))
            let incr := 4
            // let lastRegisterPosition := div(and(mload(add(state, 0x20)), mul(exp(2, 129), sub(exp(2, 4), 1))), exp(2, 129))
            // let stateType := div(and(mload(add(state, 0x20)), exp(2, 128)), exp(2, 128))

            for
                { }
                lt(move, end)
                { move := add(move, 0x20) }
            {
                for
                    {  }
                    lt(incr, 28)
                    { incr := add(incr, 4) }
                {
                    let move256 := div(and(mload(move), mul(exp(2, mul(sub(28, incr), 8)), sub(exp(2, 32), 1))), exp(2, mul(sub(28, incr), 8)))


                    //TODO add block time verifications
                    funds := add(
                            funds,
                            //Mul with fundsPerBlock
                            mul(
                                //Sub last updated block number
                                sub(
                                    //Add offset
                                    add(
                                        startBlock,
                                        // Offset
                                        and(move256, mul(exp(2, 18), sub(exp(2, 18), 1)))
                                    ),
                                    // last updated block number
                                    div(and(mload(add(state, 0x20)), mul(exp(2, 133), sub(exp(2, 31), 1))), exp(2, 133))
                                ),
                                fundsPerBlock
                            )
                        )

                    let location := 0
                    switch div(div(and(move256, mul(exp(2, 18), sub(exp(2, 11), 1))), exp(2, 18)), 180)
                    case 0 {
                        location := div(and(mload(add(state, 0x20)), mul(exp(2, 64), sub(exp(2, 64), 1))), exp(2, 64))
                    }
                    case 1 {
                        location := and(mload(add(state, 0x20)), sub(exp(2, 64), 1))
                    }
                    case 2 {
                        location := div(and(mload(add(state, 0x40)), mul(exp(2, 192), sub(exp(2, 64), 1))), exp(2, 192))
                    }
                    case 3 {
                        location := div(and(mload(add(state, 0x40)), mul(exp(2, 128), sub(exp(2, 64), 1))), exp(2, 128))
                    }
                    case 4 {
                        location := div(and(mload(add(state, 0x40)), mul(exp(2, 64), sub(exp(2, 64), 1))), exp(2, 64))
                    }
                    default {
                        location := and(mload(add(state, 0x40)), sub(exp(2, 64), 1))
                    }

                    if gt(and(move256, exp(2, 31)), 0) {

                        switch mod(div(and(move256, mul(exp(2, 18), sub(exp(2, 11), 1))), exp(2, 18)), 180)
                        case 0 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 10), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 10)
								location := sub(location, mul(5, exp(2, 48)))
								location := add(location, 1)
							}
						}
						case 1 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 12), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 12)
								location := sub(location, mul(5, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2)
								location := add(location, 2)
							}
						}
						case 2 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 16), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 16)
								location := sub(location, mul(5, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 4)
								location := add(location, 3)
							}
						}
						case 3 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 22), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 22)
								location := sub(location, mul(5, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 6)
								location := add(location, 4)
							}
						}
						case 4 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 30), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 30)
								location := sub(location, mul(5, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 8)
								location := add(location, 5)
							}
						}
						case 5 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 40), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 5)))) {
								funds := sub(funds, 40)
								location := sub(location, mul(5, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10)
								location := add(location, 6)
							}
						}
						case 6 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 1000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 1000)
								location := sub(location, mul(15, exp(2, 48)))
								location := add(location, 4)
							}
						}
						case 7 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 1200), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 1200)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 200)
								location := add(location, 8)
							}
						}
						case 8 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 1600), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 1600)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 400)
								location := add(location, 12)
							}
						}
						case 9 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 2200), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 2200)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 600)
								location := add(location, 16)
							}
						}
						case 10 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 3000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 3000)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 800)
								location := add(location, 20)
							}
						}
						case 11 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 4000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 4000)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1000)
								location := add(location, 24)
							}
						}
						case 12 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 10000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 10000)
								location := sub(location, mul(25, exp(2, 48)))
								location := add(location, 4)
							}
						}
						case 13 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 12000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 12000)
								location := sub(location, mul(25, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2000)
								location := add(location, 8)
							}
						}
						case 14 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 16000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 16000)
								location := sub(location, mul(25, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 4000)
								location := add(location, 12)
							}
						}
						case 15 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 22000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 22000)
								location := sub(location, mul(25, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 6000)
								location := add(location, 16)
							}
						}
						case 16 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 30000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 30000)
								location := sub(location, mul(25, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 8000)
								location := add(location, 20)
							}
						}
						case 17 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 40000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 25)))) {
								funds := sub(funds, 40000)
								location := sub(location, mul(25, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10000)
								location := add(location, 24)
							}
						}
						case 18 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 10), and(gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 1)), gt(mul(location, sub(exp(2, 16), 1)), 1)))) {
								funds := sub(funds, 10)
								location := sub(location, mul(1, exp(2, 48)))
								location := sub(location, 1)
								location := add(location, mul(1, exp(2, 48)))
							}
						}
						case 19 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 12), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 1)))) {
								funds := sub(funds, 12)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 1)
								fundsPerBlock := add(fundsPerBlock, 2)
								location := add(location, mul(2, exp(2, 36)))
							}
						}
						case 20 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 16), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 1)))) {
								funds := sub(funds, 16)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 1)
								fundsPerBlock := add(fundsPerBlock, 4)
								location := add(location, mul(3, exp(2, 36)))
							}
						}
						case 21 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 22), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 2)))) {
								funds := sub(funds, 22)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 2)
								fundsPerBlock := add(fundsPerBlock, 6)
								location := add(location, mul(4, exp(2, 36)))
							}
						}
						case 22 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 30), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 2)))) {
								funds := sub(funds, 30)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 2)
								fundsPerBlock := add(fundsPerBlock, 8)
								location := add(location, mul(5, exp(2, 36)))
							}
						}
						case 23 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 40), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 2)))) {
								funds := sub(funds, 40)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 2)
								fundsPerBlock := add(fundsPerBlock, 10)
								location := add(location, mul(6, exp(2, 36)))
							}
						}
						case 24 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 100), and(gt(and(location, mul(exp(2, 36), sub(exp(2, 12), 1))), mul(exp(2, 36), 1)), gt(mul(location, sub(exp(2, 16), 1)), 4)))) {
								funds := sub(funds, 100)
								location := sub(location, mul(1, exp(2, 36)))
								location := sub(location, 4)
								location := add(location, mul(5, exp(2, 36)))
							}
						}
						case 25 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 120), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 4)))) {
								funds := sub(funds, 120)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 4)
								fundsPerBlock := add(fundsPerBlock, 20)
								location := add(location, mul(5, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 26 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 160), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 4)))) {
								funds := sub(funds, 160)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 4)
								fundsPerBlock := add(fundsPerBlock, 40)
								location := add(location, mul(10, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 27 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 220), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 8)))) {
								funds := sub(funds, 220)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 8)
								fundsPerBlock := add(fundsPerBlock, 60)
								location := add(location, mul(15, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 28 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 300), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 8)))) {
								funds := sub(funds, 300)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 8)
								fundsPerBlock := add(fundsPerBlock, 80)
								location := add(location, mul(20, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 29 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 400), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 8)))) {
								funds := sub(funds, 400)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 8)
								fundsPerBlock := add(fundsPerBlock, 100)
								location := add(location, mul(25, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 30 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 10000), and(gt(and(location, mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), sub(exp(2, add(10, mul(and(move256, exp(2, 20)), 2))), 1))), mul(exp(2, add(26, mul(and(move256, exp(2, 20)), 10))), 1)), gt(mul(location, sub(exp(2, 16), 1)), 16)))) {
								funds := sub(funds, 10000)
								location := sub(location, mul(1, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
								location := sub(location, 16)
								location := add(location, mul(100, mul(exp(2, 16), mul(exp(2, 10), and(move256, exp(2, 20))))))
							}
						}
						case 31 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 12000), and(gt(and(location, mul(exp(2, 16), sub(exp(2, 10), 1))), mul(exp(2, 10), 1)), gt(mul(location, sub(exp(2, 16), 1)), 16)))) {
								funds := sub(funds, 12000)
								location := sub(location, mul(1, exp(2, 16)))
								location := sub(location, 16)
								fundsPerBlock := add(fundsPerBlock, 2000)
								location := add(location, mul(200, exp(2, 16)))
							}
						}
						case 32 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 16000), and(gt(and(location, mul(exp(2, 16), sub(exp(2, 10), 1))), mul(exp(2, 10), 1)), gt(mul(location, sub(exp(2, 16), 1)), 32)))) {
								funds := sub(funds, 16000)
								location := sub(location, mul(1, exp(2, 16)))
								location := sub(location, 32)
								fundsPerBlock := add(fundsPerBlock, 4000)
								location := add(location, mul(300, exp(2, 16)))
							}
						}
						case 33 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 22000), and(gt(and(location, mul(exp(2, 16), sub(exp(2, 10), 1))), mul(exp(2, 10), 1)), gt(mul(location, sub(exp(2, 16), 1)), 32)))) {
								funds := sub(funds, 22000)
								location := sub(location, mul(1, exp(2, 16)))
								location := sub(location, 32)
								fundsPerBlock := add(fundsPerBlock, 6000)
								location := add(location, mul(400, exp(2, 16)))
							}
						}
						case 34 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 30000), and(gt(and(location, mul(exp(2, 16), sub(exp(2, 10), 1))), mul(exp(2, 10), 1)), gt(mul(location, sub(exp(2, 16), 1)), 48)))) {
								funds := sub(funds, 30000)
								location := sub(location, mul(1, exp(2, 16)))
								location := sub(location, 48)
								fundsPerBlock := add(fundsPerBlock, 8000)
								location := add(location, mul(500, exp(2, 16)))
							}
						}
						case 35 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 40000), and(gt(and(location, mul(exp(2, 16), sub(exp(2, 10), 1))), mul(exp(2, 10), 1)), gt(mul(location, sub(exp(2, 16), 1)), 48)))) {
								funds := sub(funds, 40000)
								location := sub(location, mul(1, exp(2, 16)))
								location := sub(location, 48)
								fundsPerBlock := add(fundsPerBlock, 10000)
								location := add(location, mul(600, exp(2, 16)))
							}
						}
						case 36 {
							if gt(experience, 0) {
								location := add(location, 40)
								devLeft := add(devLeft, 3)
							}
						}
						case 37 {
							if and(gt(experience, exp(2, 0)), gt(funds, 100)) {
								funds := sub(funds, 100)
								location := add(location, 40)
								devLeft := add(devLeft, 6)
							}
						}
						case 38 {
							if and(gt(experience, exp(2, 0)), gt(funds, 110)) {
								funds := sub(funds, 110)
								fundsPerBlock := add(fundsPerBlock, 10)
								location := add(location, 45)
								devLeft := add(devLeft, 6)
							}
						}
						case 39 {
							if and(gt(experience, exp(2, 0)), gt(funds, 130)) {
								funds := sub(funds, 130)
								fundsPerBlock := add(fundsPerBlock, 20)
								location := add(location, 45)
								devLeft := add(devLeft, 9)
							}
						}
						case 40 {
							if and(gt(experience, exp(2, 0)), gt(funds, 160)) {
								funds := sub(funds, 160)
								fundsPerBlock := add(fundsPerBlock, 30)
								location := add(location, 50)
								devLeft := add(devLeft, 9)
							}
						}
						case 41 {
							if and(gt(experience, exp(2, 0)), gt(funds, 200)) {
								funds := sub(funds, 200)
								fundsPerBlock := add(fundsPerBlock, 40)
								location := add(location, 50)
								devLeft := add(devLeft, 12)
							}
						}
						case 42 {
							if and(gt(experience, exp(2, 3)), gt(funds, 500)) {
								funds := sub(funds, 500)
								location := add(location, 60)
								devLeft := add(devLeft, 9)
							}
						}
						case 43 {
							if and(gt(experience, exp(2, 3)), gt(funds, 520)) {
								funds := sub(funds, 520)
								fundsPerBlock := add(fundsPerBlock, 20)
								location := add(location, 60)
								devLeft := add(devLeft, 12)
							}
						}
						case 44 {
							if and(gt(experience, exp(2, 3)), gt(funds, 560)) {
								funds := sub(funds, 560)
								fundsPerBlock := add(fundsPerBlock, 40)
								location := add(location, 65)
								devLeft := add(devLeft, 12)
							}
						}
						case 45 {
							if and(gt(experience, exp(2, 3)), gt(funds, 620)) {
								funds := sub(funds, 620)
								fundsPerBlock := add(fundsPerBlock, 60)
								location := add(location, 65)
								devLeft := add(devLeft, 15)
							}
						}
						case 46 {
							if and(gt(experience, exp(2, 3)), gt(funds, 700)) {
								funds := sub(funds, 700)
								fundsPerBlock := add(fundsPerBlock, 80)
								location := add(location, 70)
								devLeft := add(devLeft, 15)
							}
						}
						case 47 {
							if and(gt(experience, exp(2, 3)), gt(funds, 800)) {
								funds := sub(funds, 800)
								fundsPerBlock := add(fundsPerBlock, 100)
								location := add(location, 70)
								devLeft := add(devLeft, 20)
							}
						}
						case 48 {
							if and(gt(experience, exp(2, 9)), gt(funds, 2000)) {
								funds := sub(funds, 2000)
								location := add(location, 80)
								devLeft := add(devLeft, 20)
							}
						}
						case 49 {
							if and(gt(experience, exp(2, 9)), gt(funds, 2100)) {
								funds := sub(funds, 2100)
								fundsPerBlock := add(fundsPerBlock, 100)
								location := add(location, 80)
								devLeft := add(devLeft, 30)
							}
						}
						case 50 {
							if and(gt(experience, exp(2, 9)), gt(funds, 2300)) {
								funds := sub(funds, 2300)
								fundsPerBlock := add(fundsPerBlock, 200)
								location := add(location, 90)
								devLeft := add(devLeft, 30)
							}
						}
						case 51 {
							if and(gt(experience, exp(2, 9)), gt(funds, 2600)) {
								funds := sub(funds, 2600)
								fundsPerBlock := add(fundsPerBlock, 300)
								location := add(location, 90)
								devLeft := add(devLeft, 40)
							}
						}
						case 52 {
							if and(gt(experience, exp(2, 9)), gt(funds, 3000)) {
								funds := sub(funds, 3000)
								fundsPerBlock := add(fundsPerBlock, 400)
								location := add(location, 100)
								devLeft := add(devLeft, 40)
							}
						}
						case 53 {
							if and(gt(experience, exp(2, 9)), gt(funds, 3500)) {
								funds := sub(funds, 3500)
								fundsPerBlock := add(fundsPerBlock, 500)
								location := add(location, 100)
								devLeft := add(devLeft, 50)
							}
						}
						case 54 {
							if and(gt(experience, exp(2, 15)), gt(funds, 10000)) {
								funds := sub(funds, 10000)
								location := add(location, 120)
								devLeft := add(devLeft, 50)
							}
						}
						case 55 {
							if and(gt(experience, exp(2, 15)), gt(funds, 12000)) {
								funds := sub(funds, 12000)
								fundsPerBlock := add(fundsPerBlock, 2000)
								location := add(location, 120)
								devLeft := add(devLeft, 70)
							}
						}
						case 56 {
							if and(gt(experience, exp(2, 15)), gt(funds, 16000)) {
								funds := sub(funds, 16000)
								fundsPerBlock := add(fundsPerBlock, 4000)
								location := add(location, 130)
								devLeft := add(devLeft, 70)
							}
						}
						case 57 {
							if and(gt(experience, exp(2, 15)), gt(funds, 22000)) {
								funds := sub(funds, 22000)
								fundsPerBlock := add(fundsPerBlock, 6000)
								location := add(location, 130)
								devLeft := add(devLeft, 90)
							}
						}
						case 58 {
							if and(gt(experience, exp(2, 15)), gt(funds, 30000)) {
								funds := sub(funds, 30000)
								fundsPerBlock := add(fundsPerBlock, 8000)
								location := add(location, 140)
								devLeft := add(devLeft, 90)
							}
						}
						case 59 {
							if and(gt(experience, exp(2, 15)), gt(funds, 40000)) {
								funds := sub(funds, 40000)
								fundsPerBlock := add(fundsPerBlock, 10000)
								location := add(location, 140)
								devLeft := add(devLeft, 110)
							}
						}
						case 60 {
							if and(gt(experience, exp(2, 22)), gt(funds, 100000)) {
								funds := sub(funds, 100000)
								location := add(location, 160)
								devLeft := add(devLeft, 110)
							}
						}
						case 61 {
							if and(gt(experience, exp(2, 22)), gt(funds, 102000)) {
								funds := sub(funds, 102000)
								fundsPerBlock := add(fundsPerBlock, 2000)
								location := add(location, 160)
								devLeft := add(devLeft, 150)
							}
						}
						case 62 {
							if and(gt(experience, exp(2, 22)), gt(funds, 106000)) {
								funds := sub(funds, 106000)
								fundsPerBlock := add(fundsPerBlock, 4000)
								location := add(location, 170)
								devLeft := add(devLeft, 150)
							}
						}
						case 63 {
							if and(gt(experience, exp(2, 22)), gt(funds, 112000)) {
								funds := sub(funds, 112000)
								fundsPerBlock := add(fundsPerBlock, 6000)
								location := add(location, 170)
								devLeft := add(devLeft, 190)
							}
						}
						case 64 {
							if and(gt(experience, exp(2, 22)), gt(funds, 120000)) {
								funds := sub(funds, 120000)
								fundsPerBlock := add(fundsPerBlock, 8000)
								location := add(location, 180)
								devLeft := add(devLeft, 190)
							}
						}
						case 65 {
							if and(gt(experience, exp(2, 22)), gt(funds, 130000)) {
								funds := sub(funds, 130000)
								fundsPerBlock := add(fundsPerBlock, 10000)
								location := add(location, 180)
								devLeft := add(devLeft, 230)
							}
						}
						case 66 {
							if and(gt(experience, exp(2, 32)), gt(funds, 1000000)) {
								funds := sub(funds, 1000000)
								location := add(location, 200)
								devLeft := add(devLeft, 230)
							}
						}
						case 67 {
							if and(gt(experience, exp(2, 32)), gt(funds, 1400000)) {
								funds := sub(funds, 1400000)
								fundsPerBlock := add(fundsPerBlock, 400000)
								location := add(location, 200)
								devLeft := add(devLeft, 310)
							}
						}
						case 68 {
							if and(gt(experience, exp(2, 32)), gt(funds, 2200000)) {
								funds := sub(funds, 2200000)
								fundsPerBlock := add(fundsPerBlock, 800000)
								location := add(location, 220)
								devLeft := add(devLeft, 310)
							}
						}
						case 69 {
							if and(gt(experience, exp(2, 32)), gt(funds, 3400000)) {
								funds := sub(funds, 3400000)
								fundsPerBlock := add(fundsPerBlock, 1200000)
								location := add(location, 220)
								devLeft := add(devLeft, 390)
							}
						}
						case 70 {
							if and(gt(experience, exp(2, 32)), gt(funds, 5000000)) {
								funds := sub(funds, 5000000)
								fundsPerBlock := add(fundsPerBlock, 1600000)
								location := add(location, 240)
								devLeft := add(devLeft, 390)
							}
						}
						case 71 {
							if and(gt(experience, exp(2, 32)), gt(funds, 7000000)) {
								funds := sub(funds, 7000000)
								fundsPerBlock := add(fundsPerBlock, 2000000)
								location := add(location, 240)
								devLeft := add(devLeft, 470)
							}
						}
						case 72 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 15), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 15)
								location := sub(location, mul(10, exp(2, 48)))
							}
						}
						case 73 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 25), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 25)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10)
							}
						}
						case 74 {
							if and(gt(experience, exp(2, 0)), and(gt(funds, 40), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 40)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 15)
							}
						}
						case 75 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 60), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 60)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 20)
							}
						}
						case 76 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 85), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 85)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 25)
							}
						}
						case 77 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 115), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 115)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 30)
							}
						}
						case 78 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 100), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 100)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 100)
							}
						}
						case 79 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 200), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 200)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 200)
							}
						}
						case 80 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 500)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 300)
							}
						}
						case 81 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 900), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 900)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 400)
							}
						}
						case 82 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 1400), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 1400)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 500)
							}
						}
						case 83 {
							if and(gt(experience, exp(2, 6)), and(gt(funds, 2000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 2000)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 600)
							}
						}
						case 84 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 10)))) {
								funds := sub(funds, 500)
								location := sub(location, mul(10, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 500)
							}
						}
						case 85 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 1000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 1000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 500)
							}
						}
						case 86 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 2000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 2000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1000)
							}
						}
						case 87 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 3500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 3500)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1500)
							}
						}
						case 88 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 5500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 5500)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2000)
							}
						}
						case 89 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 8000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 8000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2500)
							}
						}
						case 90 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 3000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 3000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1000)
							}
						}
						case 91 {
							if and(gt(experience, exp(2, 12)), and(gt(funds, 5000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 5000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2000)
							}
						}
						case 92 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 8000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 8000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 3000)
							}
						}
						case 93 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 12000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 12000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 4000)
							}
						}
						case 94 {
							if and(gt(experience, exp(2, 16)), and(gt(funds, 17000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 17000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 5000)
							}
						}
						case 95 {
							if and(gt(experience, exp(2, 16)), and(gt(funds, 23000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 20)))) {
								funds := sub(funds, 23000)
								location := sub(location, mul(20, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 6000)
							}
						}
						case 96 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 10000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 10000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 5000)
							}
						}
						case 97 {
							if and(gt(experience, exp(2, 16)), and(gt(funds, 20000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 20000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10000)
							}
						}
						case 98 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 35000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 35000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 15000)
							}
						}
						case 99 {
							if and(gt(experience, exp(2, 20)), and(gt(funds, 55000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 55000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 20000)
							}
						}
						case 100 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 80000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 80000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 25000)
							}
						}
						case 101 {
							if and(gt(experience, exp(2, 23)), and(gt(funds, 110000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 110000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 30000)
							}
						}
						case 102 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 40000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 40000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10000)
							}
						}
						case 103 {
							if and(gt(experience, exp(2, 24)), and(gt(funds, 60000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 60000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 20000)
							}
						}
						case 104 {
							if and(gt(experience, exp(2, 26)), and(gt(funds, 90000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 90000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 30000)
							}
						}
						case 105 {
							if and(gt(experience, exp(2, 28)), and(gt(funds, 130000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 130000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 40000)
							}
						}
						case 106 {
							if and(gt(experience, exp(2, 30)), and(gt(funds, 180000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 180000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 50000)
							}
						}
						case 107 {
							if and(gt(experience, exp(2, 32)), and(gt(funds, 240000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 40)))) {
								funds := sub(funds, 240000)
								location := sub(location, mul(40, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 60000)
							}
						}
						case 108 {
							if gt(experience, exp(2, 0)) {
							}
						}
						case 109 {
							if gt(experience, exp(2, 0)) {
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 110 {
							if gt(experience, exp(2, 0)) {
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 111 {
							if gt(experience, exp(2, 0)) {
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 112 {
							if gt(experience, exp(2, 0)) {
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 113 {
							if gt(experience, exp(2, 0)) {
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 114 {
							if gt(experience, exp(2, 0)) {
								location := add(location, mul(1000, exp(2, 48)))
							}
						}
						case 115 {
							if gt(experience, exp(2, 0)) {
								location := add(location, mul(1100, exp(2, 48)))
							}
						}
						case 116 {
							if gt(experience, exp(2, 3)) {
								location := add(location, mul(1200, exp(2, 48)))
							}
						}
						case 117 {
							if gt(experience, exp(2, 3)) {
								location := add(location, mul(1300, exp(2, 48)))
							}
						}
						case 118 {
							if gt(experience, exp(2, 6)) {
								location := add(location, mul(1400, exp(2, 48)))
							}
						}
						case 119 {
							if gt(experience, exp(2, 6)) {
								location := add(location, mul(1500, exp(2, 48)))
							}
						}
						case 120 {
							if and(gt(experience, exp(2, 6)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 121 {
							if and(gt(experience, exp(2, 6)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 122 {
							if and(gt(experience, exp(2, 9)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 123 {
							if and(gt(experience, exp(2, 9)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 124 {
							if and(gt(experience, exp(2, 12)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 125 {
							if and(gt(experience, exp(2, 12)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 126 {
							if and(gt(experience, exp(2, 12)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 127 {
							if and(gt(experience, exp(2, 12)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 128 {
							if and(gt(experience, exp(2, 15)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 129 {
							if and(gt(experience, exp(2, 15)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 130 {
							if and(gt(experience, exp(2, 16)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 131 {
							if and(gt(experience, exp(2, 16)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 132 {
							if and(gt(experience, exp(2, 16)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 133 {
							if and(gt(experience, exp(2, 16)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 134 {
							if and(gt(experience, exp(2, 18)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 135 {
							if and(gt(experience, exp(2, 18)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 136 {
							if and(gt(experience, exp(2, 20)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 137 {
							if and(gt(experience, exp(2, 20)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 138 {
							if and(gt(experience, exp(2, 20)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 139 {
							if and(gt(experience, exp(2, 20)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 140 {
							if and(gt(experience, exp(2, 22)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 141 {
							if and(gt(experience, exp(2, 22)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 142 {
							if and(gt(experience, exp(2, 23)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 143 {
							if and(gt(experience, exp(2, 23)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 144 {
							if and(gt(experience, exp(2, 23)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 145 {
							if and(gt(experience, exp(2, 23)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 146 {
							if and(gt(experience, exp(2, 24)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 147 {
							if and(gt(experience, exp(2, 24)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 148 {
							if and(gt(experience, exp(2, 25)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 149 {
							if and(gt(experience, exp(2, 25)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 150 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 500)
								location := sub(location, mul(15, exp(2, 48)))
								devLeft := add(devLeft, 15)
							}
						}
						case 151 {
							if and(gt(experience, exp(2, 3)), and(gt(funds, 550), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 550)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 50)
								devLeft := add(devLeft, 20)
							}
						}
						case 152 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 650), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 650)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 100)
								devLeft := add(devLeft, 30)
							}
						}
						case 153 {
							if and(gt(experience, exp(2, 9)), and(gt(funds, 800), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 800)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 150)
								devLeft := add(devLeft, 45)
							}
						}
						case 154 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 1000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 1000)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 200)
								devLeft := add(devLeft, 65)
							}
						}
						case 155 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 1250), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 15)))) {
								funds := sub(funds, 1250)
								location := sub(location, mul(15, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 250)
								devLeft := add(devLeft, 90)
							}
						}
						case 156 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 3000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 3000)
								location := sub(location, mul(30, exp(2, 48)))
								devLeft := add(devLeft, 50)
							}
						}
						case 157 {
							if and(gt(experience, exp(2, 15)), and(gt(funds, 3500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 3500)
								location := sub(location, mul(30, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 500)
								devLeft := add(devLeft, 100)
							}
						}
						case 158 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 4500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 4500)
								location := sub(location, mul(30, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1000)
								devLeft := add(devLeft, 120)
							}
						}
						case 159 {
							if and(gt(experience, exp(2, 18)), and(gt(funds, 6000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 6000)
								location := sub(location, mul(30, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 1500)
								devLeft := add(devLeft, 150)
							}
						}
						case 160 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 8000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 8000)
								location := sub(location, mul(30, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2000)
								devLeft := add(devLeft, 190)
							}
						}
						case 161 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 10500), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 30)))) {
								funds := sub(funds, 10500)
								location := sub(location, mul(30, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2500)
								devLeft := add(devLeft, 240)
							}
						}
						case 162 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 10000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 10000)
								location := sub(location, mul(60, exp(2, 48)))
								devLeft := add(devLeft, 500)
							}
						}
						case 163 {
							if and(gt(experience, exp(2, 22)), and(gt(funds, 12000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 12000)
								location := sub(location, mul(60, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 2000)
								devLeft := add(devLeft, 550)
							}
						}
						case 164 {
							if and(gt(experience, exp(2, 24)), and(gt(funds, 16000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 16000)
								location := sub(location, mul(60, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 4000)
								devLeft := add(devLeft, 650)
							}
						}
						case 165 {
							if and(gt(experience, exp(2, 24)), and(gt(funds, 22000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 22000)
								location := sub(location, mul(60, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 6000)
								devLeft := add(devLeft, 800)
							}
						}
						case 166 {
							if and(gt(experience, exp(2, 26)), and(gt(funds, 30000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 30000)
								location := sub(location, mul(60, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 8000)
								devLeft := add(devLeft, 1000)
							}
						}
						case 167 {
							if and(gt(experience, exp(2, 26)), and(gt(funds, 40000), gt(and(location, mul(exp(2, 48), sub(exp(2, 16), 1))), mul(exp(2, 48), 60)))) {
								funds := sub(funds, 40000)
								location := sub(location, mul(60, exp(2, 48)))
								fundsPerBlock := add(fundsPerBlock, 10000)
								devLeft := add(devLeft, 1250)
							}
						}
						case 168 {
							if and(gt(experience, exp(2, 9)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 169 {
							if and(gt(experience, exp(2, 9)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 170 {
							if and(gt(experience, exp(2, 9)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 171 {
							if and(gt(experience, exp(2, 18)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 172 {
							if and(gt(experience, exp(2, 18)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 173 {
							if and(gt(experience, exp(2, 18)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
						case 174 {
							if and(gt(experience, exp(2, 6)), gt(funds, 50)) {
								funds := sub(funds, 50)
							}
						}
						case 175 {
							if and(gt(experience, exp(2, 6)), gt(funds, 51)) {
								funds := sub(funds, 51)
								fundsPerBlock := add(fundsPerBlock, 1)
							}
						}
						case 176 {
							if and(gt(experience, exp(2, 6)), gt(funds, 53)) {
								funds := sub(funds, 53)
								fundsPerBlock := add(fundsPerBlock, 2)
							}
						}
						case 177 {
							if and(gt(experience, exp(2, 15)), gt(funds, 56)) {
								funds := sub(funds, 56)
								fundsPerBlock := add(fundsPerBlock, 3)
							}
						}
						case 178 {
							if and(gt(experience, exp(2, 15)), gt(funds, 60)) {
								funds := sub(funds, 60)
								fundsPerBlock := add(fundsPerBlock, 4)
							}
						}
						case 179 {
							if and(gt(experience, exp(2, 15)), gt(funds, 65)) {
								funds := sub(funds, 65)
								fundsPerBlock := add(fundsPerBlock, 5)
							}
						}
                    }

                    //TODO
                    // if iszero(and(state, mul(move256, 31))) {
                    //     //removing
                    //     state := add(sub(state, move256), mul(move256, 32))
                    // }

                    switch div(div(and(move256, mul(exp(2, 18), sub(exp(2, 11), 1))), exp(2, 18)), 180)
                    case 0 {
                        mstore(
                            add(state, 0x20),
                            add(
                               and(mload(add(state, 0x20)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), mul(exp(2, 64), sub(exp(2, 64), 1)))),
                               mul(location, exp(2, 64))
                            )
                        )
                    }
                    case 1 {
                        mstore(
                            add(state, 0x20),
                            add(
                               and(mload(add(state, 0x20)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), sub(exp(2, 64), 1))),
                               location
                            )
                        )
                    }
                    case 2 {
                        mstore(
                            add(state, 0x40),
                            add(
                               and(mload(add(state, 0x40)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), mul(exp(2, 192), sub(exp(2, 64), 1)))),
                               mul(location, exp(2, 192))
                            )
                        )
                    }
                    case 3 {
                        mstore(
                            add(state, 0x40),
                            add(
                               and(mload(add(state, 0x40)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), mul(exp(2, 128), sub(exp(2, 64), 1)))),
                               mul(location, exp(2, 128))
                            )
                        )
                    }
                    case 4 {
                        mstore(
                            add(state, 0x40),
                            add(
                               and(mload(add(state, 0x40)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), mul(exp(2, 64), sub(exp(2, 64), 1)))),
                               mul(location, exp(2, 64))
                            )
                        )
                    }
                    default {
                        mstore(
                            add(state, 0x40),
                            add(
                               and(mload(add(state, 0x40)), sub(add(exp(2, 255), sub(exp(2, 255), 1)), sub(exp(2, 64), 1))),
                               location
                            )
                        )
                    }

                    //write move to state
                    mstore(
                        add(state, mul(0x20, add(4, div(and(mload(add(state, 20)), mul(exp(2, 133), sub(exp(2, 4), 1))), exp(2, 133))))),
                        add(
                            mload(add(state, mul(0x20, add(4, div(and(mload(add(state, 20)), mul(exp(2, 133), sub(exp(2, 4), 1))), exp(2, 133)))))),
                            mul(
                                add(mul(div(and(move256, mul(exp(2, 18), sub(exp(2, 11), 1))), exp(2, 18)), exp (2, 5)), 1),
                                exp(2, sub(240, mul(div(and(mload(add(state, 20)), mul(exp(2, 129), sub(exp(2, 4), 1))), exp(2, 129)), exp(2, 4))))
                            )
                        )
                    )

                    //update registry position
                    if gt(and(mload(add(state, 20)), mul(exp(2, 129), sub(exp(2, 4), 1))), mul(exp(2, 129), sub(exp(2, 4), 2))) {
                        mstore(
                            add(state, 0x20),
                            add(
                                mload(add(state, 0x20)),
                                exp(2, 133)
                            )
                        )
                    }

                    //update registry position
                    if lt(and(mload(add(state, 20)), mul(exp(2, 129), sub(exp(2, 4), 1))), mul(exp(2, 129), sub(exp(2, 4), 2))) {
                        mstore(
                            add(state, 0x20),
                            add(
                                mload(add(state, 0x20)),
                                exp(2, 129)
                            )
                        )
                    }

                    //hack
                    if lt(
                        incr,
                        28
                    ) {
                        if eq(
                            div(and(mload(move), mul(exp(2, mul(sub(24, incr), 8)), sub(exp(2, 32), 1))), exp(2, mul(sub(24, incr), 8))),
                            sub(exp(2, 32), 1)
                        ) {
                            incr := 32
                        }
                    }
                }

                incr := 0
            }

            mstore(
                add(state, 0x20),
                add(
                    add(
                        add(
                            add(
                                and(mload(add(state, 0x20)), sub(exp(2, 164), 1)),
                                mul(funds, exp(2, 216))
                            ),
                            mul(fundsPerBlock, exp(2, 204))
                        ),
                        mul(experience, exp(2, 180))
                    ),
                    mul(devLeft, exp(2, 168))
                )
            )
        }

        // states[msg.sender] = state;

        return state;
    }
}