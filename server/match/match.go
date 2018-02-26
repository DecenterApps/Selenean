package main

// match keeps track of players in the game and broadcasts messages.
type Match struct {
	// Indicate weather player is in match
	inMatch map[*Player]bool

	// Match state
	state State

	// Inbound messages from the players.
	broadcast chan []byte

	// join requests from the player.
	join chan *Player

	// leave requests from player.
	leave chan *Player
}

func newMatch() *Match {
	return &Match{
		inMatch:   make(map[*Player]bool),
		broadcast: make(chan []byte),
		join:      make(chan *Player),
		leave:     make(chan *Player),
	}
}

// TODO: refactor
func getOponent(player Player) *Player {
	for _, playerInGame := range player.match.state.players {
		if player != *playerInGame {
			return playerInGame
		}
	}

	return nil
}

func (match *Match) run() {
	for {
		select {
		case player := <-match.join:
			match.inMatch[player] = true
		case player := <-match.leave:
			if _, ok := match.inMatch[player]; ok {
				delete(match.inMatch, player)
				close(player.send)
			}
		case message := <-match.broadcast:
			for player := range match.inMatch {
				select {
				case player.send <- message:
				default:
					close(player.send)
					delete(match.inMatch, player)
				}
			}
		}
	}
}
