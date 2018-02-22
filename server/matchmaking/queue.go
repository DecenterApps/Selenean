package matchmaking

import (
	"fmt"
	"time"
	"reflect"
)

type Broadcast struct {
	player  *Player
	message []byte
}

var queue *Queue

type Queue struct {
	// Registered players.
	players []*Player

	// Inbound messages from the players.
	broadcast chan Broadcast

	// Register requests from the players.
	register chan *Player

	// Unregister requests from players.
	unregister chan *Player
}

//TODO: singleton
func newQueue() *Queue {
	if queue != nil {
		return queue
	}

	return &Queue{
		broadcast:  make(chan Broadcast),
		register:   make(chan *Player),
		unregister: make(chan *Player),
		players:    nil,
	}
}

func (queue *Queue) run() {
	for {
		select {
		case player := <-queue.register:
			insert(player)
		case player := <-queue.unregister:
			remove(player)
		}
	}
}

//Method to validate if there is an intersection between two players (Slice where they are going to be is always going to be sorted)
func validate(player1 Player, player2 Player) bool {
	if player1.rank+player1.radius >= player2.rank-player2.radius {
		return true
	}
	return false
}

//Method to insert incoming players in queue and keep it sorted ascending
func insert(newPlayer *Player) {
	length := len(queue.players)
	i := length - 1
	queue.players = append(queue.players, newPlayer) //with intention to avoid memory bugs
	for i >= 0 && queue.players[i].rank > newPlayer.rank {
		queue.players[i+1] = queue.players[i]
		i--
	}
	queue.players[i+1] = newPlayer
}

func remove(player *Player) {

	startIndex := 0
	endIndex := len(queue.players) -1

	for startIndex <= endIndex {

		median := (startIndex + endIndex) / 2

		if player.rank < queue.players[median].rank {
			endIndex = median - 1
		} else {
			startIndex = median + 1
		}

	}
	if startIndex == len(queue.players) || reflect.DeepEqual(queue.players[startIndex],player) {
		//Raise an exception - like player not found or something like that
	} else {
		//This means we have found player
		queue.players = append(queue.players[:startIndex], queue.players[startIndex+1:]...)
		close(player.send)
	}

}

func incrementRadius() {
	for _, player := range queue.players{
		player.radius += 0.5
	}
}

//TODO: refactor
func (queue *Queue) matchPlayers() {
	for range time.NewTicker(time.Second).C {
		incrementRadius()

		fmt.Println("Matching...")
		i := 0
		for i < len(queue.players) - 1 {
			curr := queue.players[i]
			next := queue.players[i+1]
			fmt.Println(curr.address, curr.rank, curr.radius)
			fmt.Println(next.address, next.rank, next.radius)

			if validate(*curr, *next) {
				fmt.Println("We have found a new pair for game : ")
				fmt.Println("First player : ", curr)
				fmt.Println("Second player : ", next)

				queue.players = append(queue.players[:i], queue.players[i+2:]...)
				i-- //because there will be some players skipped since we are decreasing size of players
			}

			i++
		}
	}
}