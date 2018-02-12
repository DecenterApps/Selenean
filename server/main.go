package main

import (
	"log"
	"flag"
	"net/http"
)

//serveHome handles home page, remove after
func serveHome(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.Error(w, "Not found", 404)
		return
	}
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", 405)
		return
	}
	http.ServeFile(w, r, "home.html")
}

// serveWs handles peer turn.
func serveWs(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}

	var player *Player

	if waitingPlayer != nil {
		player = &Player{match: waitingPlayer.match, conn: conn, send: make(chan []byte, 256)}
		waitingPlayer.match.players[1] = player
		player.match.state = *newState(player.match.players)
		waitingPlayer = nil
	} else {
		match := newMatch()
		go match.run()

		player = &Player{match: match, conn: conn, send: make(chan []byte, 256)}
		match.players[0] = player
		waitingPlayer = player
	}

	player.match.join <- player

	// Start goroutines for two way communication.
	go player.writePump()
	go player.readPump()

	if len(player.match.state.msg) != 0 {
		player.match.broadcast <- createInitMessage(player.match.state.msg)
	}
}


func main() {
	flag.Parse()

	http.HandleFunc("/", serveHome)
	http.HandleFunc("/ws", serveWs)

	addr := flag.String("addr", ":8080", "http service address")

	err := http.ListenAndServe(*addr, nil)
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}
