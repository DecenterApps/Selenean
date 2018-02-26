package utility

import "encoding/json"

type MessageResponse struct {
	Ok      bool   `json:"ok"`
	Type    string `json:"type"`
	Message []byte `json:"key"`
}

func CreateMessageResponse(message []byte) []byte {
	messageStruct, _ := json.Marshal(&MessageResponse{true, "message", message})

	return messageStruct
}
