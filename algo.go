package main

import (
	"fmt"
	"time"
)

//In this testing phase I'll suppose that their names are unique and use them as identifiers

type Player struct {
	name string
	points int
	radius float64//radius is going to increment every second since they arrived in queue
}

type Players struct {
	players []Player
}

/*Short description : If player2.pts + player2.radius - (player3.pts + player3.radius) > 0 means they can play match
						  If player2.pts + player2.radius - (player1.pts + player1.radius) < 0 means they can play match
*/
func validate(player1 Player, player2 Player) bool{
	//supposing that player2 has higher rank than player1
	if(float64(player1.points) + player1.radius >= float64(player2.points) - player2.radius){
		return true
	}
	return false;
}

//here I'm going to insert an element (in this case struct Player) into already sorted slice O(n)
func insert(newPlayer Player, players *Players)  {
	var length = len(players.players)
	var i int = length - 1
	players.players = append(players.players, newPlayer) //with intention to avoid memory bugs
	for i >= 0 && players.players[i].points > newPlayer.points {
		players.players[i+1] = players.players[i]
		i--
	}
	players.players[i+1].points = newPlayer.points

}

//Function which is going to increment radius
func incrementRadius(structPlayers Players) {
	players := structPlayers.players
	var i int = 0
	for (i < len(players)){
		players[i].radius += 0.5
		i++
	}
}

func removeIfCanPlay(structPlayers *Players) {
	var i int = 0
	for( i < len(structPlayers.players)-1){
		curr := structPlayers.players[i]
		next := structPlayers.players[i+1]

		if(validate(curr,next) || curr.radius >= 45){ //curr.radius >=40 je example ako recimo ceka vise od 90 sekundi da ga svakako sparimo.

			fmt.Println("We have found a new pair for game : ")
			fmt.Println("First player : ",curr)
			fmt.Println("Second player : ",next)

			structPlayers.players = append(structPlayers.players[:i],structPlayers.players[i+2:]...)
			//here I'm just removing players from list, in real implementation I'll make Match of those players and then remove them
			i-- //because there will be some players skipped since we are decreasing size of players
		}
		i++;
	}
}




//TODO: Implement timer logic and validation after every second + incrementingRadius every second
//TODO: Think about app logic and whenever radius becomes greater than some value ex.10, automatically pair him with one next to him in queue


func main() {

	players := Players{[]Player{{"Marko",10,0},{"Nenad",12,0},{"Stefan",15,0},
	{"Ivana",18,0},{"Nevena",20,0},
	{"Marina",21,0}}}
	newOne := Player{"Ivan",11,0}
	newTwo := Player{"Marko",16,0}

	insert(newOne, &players)
	insert(newTwo,&players)

	incrementRadius(players)
	fmt.Println(players)

	ticker := time.NewTicker(time.Millisecond*500)
	go func() {

		for t := range ticker.C{
			fmt.Println("Tick at: ",t)
			incrementRadius(players)
			removeIfCanPlay(&players)
			fmt.Println("List of players after this checking round: ",players)
			if(len(players.players) == 0){
				ticker.Stop()
				fmt.Println("We have matched all players, queue is empty.")
			}
		}
	}()
	time.Sleep(time.Millisecond*5000)
	ticker.Stop()
	fmt.Println(players)

}
