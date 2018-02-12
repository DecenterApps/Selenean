package main

import "math/big"

type Card struct {
	Uid   big.Int `json:"uid"`
	Power int `json:"power"`
	played bool
}
