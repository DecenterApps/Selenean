package main

import (
	"fmt"

	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"math/rand"
)

type Validator interface {
	validate(player Player, state *State, message []byte) bool
	isValidatorActive(player Player, state State) bool
}

type ValidatorStruct struct {
	startTurn int
	endTurn   int
}

type OwnershipValidator struct {
	abstractValidator *ValidatorStruct
}

type TurnValidator struct {
	abstractValidator *ValidatorStruct
}

type DeckValidator struct {
	abstractValidator *ValidatorStruct
}

func (ownershipValidator OwnershipValidator) isValidatorActive(player Player, state State) bool {
	return state.step[player] >= ownershipValidator.abstractValidator.startTurn && state.step[player] <= ownershipValidator.abstractValidator.endTurn
}

func (deckValidator DeckValidator) isValidatorActive(player Player, state State) bool {
	return state.step[player] >= deckValidator.abstractValidator.startTurn && state.step[player] <= deckValidator.abstractValidator.endTurn
}

func (turnValidator TurnValidator) isValidatorActive(player Player, state State) bool {
	return state.step[player] >= turnValidator.abstractValidator.startTurn && state.step[player] <= turnValidator.abstractValidator.endTurn
}

func (ownershipValidator OwnershipValidator) validate(player Player, state *State, message []byte) bool {
	ownership := extractOwnership(message)

	if !VerifyCardsOwnership(player.address, ownership.Cards) {
		fmt.Printf("Player doesn't own every card")
		return false
	}

	state.cardsValidated[player] = true

	for _, card := range ownership.Cards {
		state.cards[player] = append(state.cards[player], card)
	}

	state.step[player]++

	return true
}

func (deckValidator DeckValidator) validate(player Player, state *State, message []byte) bool {
	return true
}

func (turnValidator TurnValidator) validate(player Player, state *State, message []byte) bool {
	cardTurn := extractCard(message)

	for _, card := range state.cards[player] {
		if cardTurn.Uid.Cmp(&card.Uid) == 0 && cardTurn.Power == card.Power && card.played == false {
			fmt.Println(*getOponent(player))
			state.health[*getOponent(player)] -= card.Power * (rand.Intn(1) + 1)

			state.lastTurn = &card
			state.step[player]++
			card.played = true

			return true
		}
	}

	fmt.Println("Card played or not in deck")

	return false
}

func VerifyCardsOwnership(address string, cards []Card) bool {
	client, err := getClient()

	if err != nil {
		fmt.Println(err)
		return false
	}

	cardsContract, err := NewCards(common.HexToAddress("0x67cfb193bb554851d0a42e75165ede6954fea248"), client)

	for _, card := range cards {
		ownerOfCard, _ := cardsContract.OwnerOf(&bind.CallOpts{Pending: true}, &card.Uid)

		if ownerOfCard != common.HexToAddress(address) {
			fmt.Println("Player doesn't own card", address)
			return false
		}
	}

	return true
}

func getClient() (client *ethclient.Client, err error) {
	return ethclient.Dial("http://ropsten.decenter.com")
}