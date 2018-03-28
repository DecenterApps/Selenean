package main

import (
	"log"
	"flag"
	"net/http"
	"fmt"
)

var matches map[string]*Match

func create(w http.ResponseWriter, r *http.Request) {
	key := r.URL.Query().Get("key")

	address1 := r.URL.Query().Get("address1")
	address2 := r.URL.Query().Get("address2")

	match := newMatch()

	player1 := newPlayer(match, address1)
	player2 := newPlayer(match, address2)

	state := newState([2]*Player{player1, player2})

	match.state = *state
	matches[key] = match

	go match.run()
}

func ws(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	address := r.URL.Query().Get("address")

	fmt.Println(id, address)

	match := matches[id]

	if match == nil {
		//TODO error handling
		fmt.Print("Match doesnt exist")
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)

	if err != nil {
		log.Println(err)
		return
	}

	var player *Player

	for _, playerInMatch := range match.state.players {
		//TODO handle if no match
		if playerInMatch.address == address {
			player = playerInMatch
			player.conn = conn

			match.join <- player
		}
	}

	go player.writePump()
	go player.readPump()

	//stateJson, err := json.Marshal(match.state)
	//
	//if err != nil {
	////TODO handle error
	//	fmt.Println(err)
	//	return
	//}
	//player.match.broadcast <- stateJson
}

func main() {
	flag.Parse()

	http.HandleFunc("/create", create)
	http.HandleFunc("/ws", ws)

	addr := flag.String("addr", ":8082", "http service address")

	matches = make(map[string]*Match)

	err := http.ListenAndServe(*addr, nil)
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}
