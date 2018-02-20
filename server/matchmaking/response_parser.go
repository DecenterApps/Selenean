package matchmaking

import "encoding/json"

type Message struct {
	Ok bool `json:"ok"`
	Message []byte `json:"message"`
}

func createMessage(message []byte) []byte {
	messageStruct, _ := json.Marshal(&Message{true, message})
	return messageStruct
}
