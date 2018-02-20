package matchmaking

import (
	"log"
	"flag"
	"net/http"
	"fmt"
	"encoding/hex"
	"github.com/koding/websocketproxy"
	"bytes"
)

func message(w http.ResponseWriter, r *http.Request) {
	if r.Method == "OPTIONS" {
		return
	}

	if r.Method != "GET" {
		fmt.Println(r.Method)
		http.Error(w, "Method not allowed", 405)
		return
	}

	//TODO: check if valid address length
	//TODO: add ip to redis
	message, err := generateMessage(r.URL.Query().Get("address"))

	//TODO: handle
	if err != nil {
		fmt.Println(err)
		return
	}

	w.Write(createMessage(message))
	return
}

// serveWs handles peer turn.
func serveWs(w http.ResponseWriter, r *http.Request) {
	//TODO: check if valid address and signature length
	signature := r.URL.Query().Get("signature")
	address := r.URL.Query().Get("address")

	err := secureRequest(signature, address)

	if err != nil {
		log.Println(err)
		return
	}

	match, err := hasActiveMatch(address)

	url := fmt.Sprintf("%s://%s%s", "wss" , "localhost", r.RequestURI)
	fmt.Println(url)
	if match {
		//w.Write([]byte("Active match"))
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}

	player := newPlayer(conn, address)

	queue.register <- player

	go player.writePump()
}

func main() {
	flag.Parse()

	queue = newQueue()
	go queue.run()
	go queue.matchPlayers()

	http.HandleFunc("/ws", serveWs)
	http.HandleFunc("/message", message)

	addr := flag.String("addr", ":8081", "http service address")

	err := http.ListenAndServe(*addr, nil)
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}

