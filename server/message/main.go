package main

import (
	"fmt"
	"flag"
	"net/http"
	"log"

	"../utility"
	"encoding/hex"
	"github.com/ethereum/go-ethereum/crypto/randentropy"
)

func message(w http.ResponseWriter, r *http.Request) {
	//TODO constant
	message := []byte(hex.EncodeToString(randentropy.GetEntropyCSPRNG(32)))

	//TODO: check if valid address length
	//TODO: add ip to redis
	set, err := utility.SetMessage(r.URL.Query().Get("address"), message)

	//TODO: handle
	if err != nil {
		fmt.Println(err)
		return
	}

	//TODO handle
	if !set {
		w.Write([]byte("no"))
		return
	}

	w.Write(utility.CreateMessageResponse(message))
	return
}

func main() {
	flag.Parse()

	http.HandleFunc("/message", message)

	addr := flag.String("addr", ":8083", "http service address")

	err := http.ListenAndServe(*addr, nil)
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}

