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
	matches[key] = match

	player1 := newPlayer(match, address1)
	player2 := newPlayer(match, address2)

	match.players = [2]*Player{player1, player2}
}

func ws(w http.ResponseWriter, r *http.Request) {
	key := r.URL.Query().Get("key")
	address := r.URL.Query().Get("address")

	match := matches[key]

	if match != nil {
		//TODO error handling
		fmt.Print("Match doesnt exist")
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)

	var player *Player

	for _, playerInMatch := range match.players {
		//TODO handle if no match
		if playerInMatch.address == address {
			player = playerInMatch
			player.conn = conn

			match.join <- player
		}
	}

	if player == nil {
		//TODO error handling
		fmt.Print("Player not in match")
		return
	}

	if err != nil {
		log.Println(err)
		return
	}

	go player.writePump()
	go player.readPump()
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
