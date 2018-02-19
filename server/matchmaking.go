package main

import "fmt"

//Method to validate if there is an intersection between two players (Slice where they are going to be is always going to be sorted)
func validate(player1 Player, player2 Player) bool{
	if (player1.rank + player1.radius >= player2.rank - player2.radius){
		return true
	}
	return false
}

//Method to insert incoming players in queue and keep it sorted ascending
func insert(newPlayer Player, waitingPlayers *WaitingPlayers) {
	var length = len(waitingPlayers.waitingPlayers)
	var i int = length - 1
	waitingPlayers.waitingPlayers = append(waitingPlayers.waitingPlayers, newPlayer) //with intention to avoid memory bugs
	for i >= 0 && waitingPlayers.waitingPlayers[i].rank > newPlayer.rank {
		waitingPlayers.waitingPlayers[i+1] = waitingPlayers.waitingPlayers[i]
		i--
	}
	waitingPlayers.waitingPlayers[i+1].rank = newPlayer.rank
}


func incrementRadius(waitingPlayers *WaitingPlayers) {
	var i int= 0
	for (i < len(waitingPlayers.waitingPlayers)){
		waitingPlayers.waitingPlayers[i].radius += 0.5
		i++
	}
}

func matchPlayers(waitingPlayers *WaitingPlayers) {
	var i int = 0
	for(i < len(waitingPlayers.waitingPlayers) -1){
		curr := waitingPlayers.waitingPlayers[i]
		next := waitingPlayers.waitingPlayers[i+1]

		if(validate(curr,next) || curr.radius >= 45){
			fmt.Println("We have found a new pair for game : ")
			fmt.Println("First player : ",curr)
			fmt.Println("Second player : ",next)

			waitingPlayers.waitingPlayers= append(waitingPlayers.waitingPlayers[:i],waitingPlayers.waitingPlayers[i+2:]...)
			i--;	//because there will be some players skipped since we are decreasing size of players
		}
		i++

	}
}

