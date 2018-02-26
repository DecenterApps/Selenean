package main

import (
	"fmt"
	"log"
	"time"

	"github.com/gorilla/websocket"
	"bytes"
)

const (
	// Time allowed to write a message to the peer.
	writeWait = 10 * time.Second

	// Time allowed to read the next pong message from the peer.
	pongWait = 60 * time.Second

	// Send pings to peer with this period. Must be less than pongWait.
	pingPeriod = (pongWait * 9) / 10

	// Maximum message size allowed from peer.
	maxMessageSize = 2048
)

var (
	newline = []byte{'\n'}
	space   = []byte{' '}
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  4096,
	WriteBufferSize: 4096,
}

// Player is a middleman between the websocket connection and match.
type Player struct {
	address string

	match *Match

	// The websocket connection.
	conn *websocket.Conn

	// Buffered channel of outbound messages.
	send chan []byte
}

func newPlayer(match *Match, address string, ) *Player {
	return &Player{
		address: address,
		match:   match,
		conn:    nil,
		send:    make(chan []byte, 256),
	}
}

// readPump pumps messages from the websocket connection to the match in goroutine.
func (player *Player) readPump() {
	defer func() {
		player.match.leave <- player
		//let the player know if opponent has disconnected
		getOponent(*player).match.broadcast <- []byte(`{"type":"opponent-disconnect"}`)
		player.conn.Close()
	}()
	player.conn.SetReadLimit(maxMessageSize)
	player.conn.SetReadDeadline(time.Now().Add(pongWait))
	player.conn.SetPongHandler(func(string) error { player.conn.SetReadDeadline(time.Now().Add(pongWait)); return nil })
	for {
		_, message, err := player.conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}
		message = bytes.TrimSpace(bytes.Replace(message, newline, space, -1))

		response, err := turn(*player, player.match.state, message)

		if err != nil {
			log.Printf("error validating step: %v", err)
			break
		}

		fmt.Println(message)

		player.match.broadcast <- response
	}
}

// writePump pumps messages from the match to the websocket connection in goroutine.
func (player *Player) writePump() {
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		player.conn.Close()
	}()
	for {
		select {
		case message, ok := <-player.send:
			player.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				// The match closed the channel.
				player.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := player.conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}

			w.Write(message)

			// Add queued chat messages to the current websocket message.
			n := len(player.send)
			for i := 0; i < n; i++ {
				w.Write(newline)
				w.Write(<-player.send)
			}

			if err := w.Close(); err != nil {
				return
			}
		case <-ticker.C:
			player.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := player.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}
