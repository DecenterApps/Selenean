package main

import (
	"encoding/json"
	"github.com/ethereum/go-ethereum/crypto/randentropy"
	"encoding/hex"
	"bytes"
	"strconv"
)

type State struct {
	players	   [2]*Player
	pubkeys	   map[Player]string
	step       map[Player]int
	cards      map[Player][]Card
	health     map[Player]int
	lastTurn   *Card
	msg 	   []byte
	validators []Validator
}

func (state State) MarshalJSON() ([]byte, error) {
	lastTurn, _ := json.Marshal(state.lastTurn)

	if state.step[*state.players[0]] == state.step[*state.players[1]] {
		return bytes.NewBufferString(`{"type":"turn","players":[{"pubkey":"` + state.pubkeys[*state.players[0]] + `", "step":` + strconv.Itoa(state.step[*state.players[0]]) + `, "health":` + strconv.Itoa(state.health[*state.players[0]]) + `},{"pubkey":"` + state.pubkeys[*state.players[1]] + `", "step":` + strconv.Itoa(state.step[*state.players[1]]) + `, "health":` + strconv.Itoa(state.health[*state.players[1]]) + `, "lastTurn":` + string(lastTurn) + `}]}`).Bytes(), nil
	} else {
		return bytes.NewBufferString(`{"type":"turn","players":[{"pubkey":"` + state.pubkeys[*state.players[0]] + `", "step":` + strconv.Itoa(state.step[*state.players[0]]) + `, "health":` + strconv.Itoa(state.health[*state.players[0]]) + `, "lastTurn":` + string(lastTurn) + `},{"pubkey":"` + state.pubkeys[*state.players[1]] + `", "step":` + strconv.Itoa(state.step[*state.players[1]]) + `, "health":` + strconv.Itoa(state.health[*state.players[1]]) + `}]}`).Bytes(), nil
	}
}

func newState(players [2]*Player) *State {
	step := make(map[Player]int)
	step[*players[0]] = 0
	step[*players[1]] = 0

	health := make(map[Player]int)
	health[*players[0]] = 100
	health[*players[1]] = 100

	ownershipValidator := OwnershipValidator{&ValidatorStruct{0, 0}}
	deckValidator := DeckValidator{&ValidatorStruct{10, 10}}
	turnValidator := TurnValidator{&ValidatorStruct{1, 9}}

	validators := []Validator{turnValidator, deckValidator, ownershipValidator}

	msg := []byte(hex.EncodeToString(randentropy.GetEntropyCSPRNG(32)))

	return &State{
		players:    players,
		pubkeys:  	make(map[Player]string),
		step:       step,
		health:     health,
		cards:  	make(map[Player][]Card),
		validators: validators,
		msg: 		msg,
	}
}

func turn(player Player, state State, message []byte) ([]byte, error) {
	for _, validator := range state.validators {
		if validator.isValidatorActive(player, state) {
			validator.validate(player, &state, message)

		}
	}

	return json.Marshal(state)
}
