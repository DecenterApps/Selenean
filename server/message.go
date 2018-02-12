package main

import (
	"encoding/json"
	"fmt"
)

type Ownership struct {
	Pubkey           string
	Signature        string
	Cards            []Card
	ShuffleCardsHash string
}

type Init struct {
	Type string `json:"type"`
	Msg []byte `json:"msg"`
}

func extractOwnership(message []byte) Ownership {
	var ownership Ownership

	err := json.Unmarshal(message, &ownership)

	if err != nil {
		fmt.Printf("%+v\n", err)
	}

	return ownership
}

func extractCard(message []byte) *Card {
	var card Card

	err := json.Unmarshal(message, &card)

	fmt.Println(card)

	if err != nil {
		fmt.Printf("%+v\n", err)
	}

	return &card
}

func createInitMessage(msg []byte) []byte {
	message, _ := json.Marshal(&Init{"init", msg})
	return message
}
