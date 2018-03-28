package main

import (
	"encoding/json"
	"bytes"
	"strconv"
	"time"
)

type State struct {
	players        [2]*Player
	step           map[Player]int
	cards          map[Player][]Card
	cardsValidated map[Player]bool
	health         map[Player]int
	lastTurn       *Card
	//TODO move to match
	validators     []Validator
	timer		   time.Timer
}

//TODO must refactor
func (state State) MarshalJSON() ([]byte, error) {
	lastTurn, _ := json.Marshal(state.lastTurn)

	if state.step[*state.players[0]] == state.step[*state.players[1]] {
		return bytes.NewBufferString(`{"type":"` + stepToType(state) + `","players":[{"address":"` + state.players[0].address + `", "step":` + strconv.Itoa(state.step[*state.players[0]]) + `, "health":` + strconv.Itoa(state.health[*state.players[0]]) + `, "cardsValidated":` + strconv.FormatBool(state.cardsValidated[*state.players[0]]) + `},{"address":"` + state.players[1].address + `", "step":` + strconv.Itoa(state.step[*state.players[1]]) + `, "health":` + strconv.Itoa(state.health[*state.players[1]]) + `, "lastTurn":` + string(lastTurn) + `, "cardsValidated":` + strconv.FormatBool(state.cardsValidated[*state.players[1]]) + `}]}`).Bytes(), nil
	} else {
		return bytes.NewBufferString(`{"type":"` + stepToType(state) + `","players":[{"address":"` + state.players[0].address + `", "step":` + strconv.Itoa(state.step[*state.players[0]]) + `, "health":` + strconv.Itoa(state.health[*state.players[0]]) + `, "lastTurn":` + string(lastTurn) + `, "cardsValidated":` + strconv.FormatBool(state.cardsValidated[*state.players[0]]) + `},{"address":"` + state.players[1].address + `", "step":` + strconv.Itoa(state.step[*state.players[1]]) + `, "health":` + strconv.Itoa(state.health[*state.players[1]]) + `, "cardsValidated":` + strconv.FormatBool(state.cardsValidated[*state.players[1]]) + `}]}`).Bytes(), nil
	}
}

func stepToType(state State) string {
	return "turn"
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

	return &State{
		players:        players,
		step:           step,
		health:         health,
		cards:          make(map[Player][]Card),
		cardsValidated: make(map[Player]bool),
		validators:     validators,
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
