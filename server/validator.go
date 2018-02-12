package main

import (
	"fmt"
	"encoding/hex"

	"github.com/ethereum/go-ethereum/crypto/secp256k1"
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

	signatureDecoded, _ := hex.DecodeString(ownership.Signature)
	msgDecoded, _ := hex.DecodeString(string(state.msg))

	if !VerifySignature(msgDecoded, signatureDecoded) {
		fmt.Printf("Signature is not valid")
		return false
	}

	if !VerifyCardsOwnership(ownership.Pubkey, ownership.Cards) {
		fmt.Printf("Player doesn't own every card")
		return false
	}

	for _, card := range ownership.Cards {
		state.cards[player] = append(state.cards[player], card)
	}

	state.step[player]++
	state.pubkeys[player] = ownership.Pubkey

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

func VerifySignature(msg, signature []byte) bool {
	pubkey, err := secp256k1.RecoverPubkey(msg, signature)

	if err != nil {
		fmt.Println(err)
	}

	return secp256k1.VerifySignature(pubkey, msg, signature[:64])
}

func VerifyCardsOwnership(pubkey string, cards []Card) bool {
	client, err := getClient()

	if err != nil {
		fmt.Println(err)
		return false
	}

	cardsContract, err := NewCards(common.HexToAddress("0x56c4784ae8ea17f481adcd922a509b967c14e2a2"), client)

	for _, card := range cards {
		address, _ := cardsContract.OwnerOf(&bind.CallOpts{Pending: true}, &card.Uid)

		if address != common.HexToAddress(pubkey) {
			fmt.Println("Player doesn't own card")
			return false
		}
	}

	return true
}

func getClient() (client *ethclient.Client, err error) {
	return ethclient.Dial("http://ropsten.decenter.com")
}
