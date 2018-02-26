package main

import "encoding/json"

type Response struct {
	Ok bool `json:"ok"`
	Key string `json:"key"`
	Type string `json:"type"`
}

func createResponse(key string) []byte {
	messageStruct, _ := json.Marshal(&Response{true, key, "created-match"})

	return messageStruct
}
