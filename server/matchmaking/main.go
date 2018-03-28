package main

import (
	"log"
	"flag"
	"net/http"
)

func ws(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}

	player := newPlayer(conn, r.URL.Query().Get("address"))

	queue.register <- player

	go player.readPump()
	go player.writePump()
}

func main() {
	flag.Parse()

	queue = newQueue()
	go queue.run()
	go queue.matchPlayers()

	http.HandleFunc("/ws", ws)

	addr := flag.String("addr", ":8081", "http service address")

	err := http.ListenAndServe(*addr, nil)
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}

