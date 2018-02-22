package main

import (
	"encoding/json"
	"fmt"
)

type Ownership struct {
	Cards            []Card
}

type Message struct {
	Ok bool `json:"ok"`
	Message []byte `json:"message"`
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