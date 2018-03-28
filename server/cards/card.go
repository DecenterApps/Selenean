package main

import (
	"gopkg.in/mgo.v2/bson"
	"gopkg.in/mgo.v2"
	"log"
)

//curl -sSX POST -d '{"title":"first_card","dev":1,"sec":2,"inf":1,"image":"path do slike","cost":120,"cards_type":123}' http://localhost:3000/cards
type Card struct {
	ID	bson.ObjectId	`bson:"_id"` //will pull ID from Contract
	Title string `bson:"title"`
	Dev int `bson:"dev"`
	Sec int `bson:"sec"`
	Inf int `bson:"inf"`
	Image string `bson:"image"`
	Cost int `bson:"cost"`
	CardsType int `bson:"cards_type"`
}


type CardsDAO struct {
	Server string
	Database string
}

var db *mgo.Database

const (
	COLLECTION = "cards"
)

// Establish a connection to database
func (m *CardsDAO) Connect() {
	session, err := mgo.Dial(m.Server)
	if err != nil {
		log.Fatal()
	}
	db = session.DB(m.Database)
}

// Find list of cards
func (m *CardsDAO) FindAll() ([]Card, error) {
	var cards []Card
	err := db.C(COLLECTION).Find(bson.M{}).All(&cards)
	return cards, err
}

// Find a card by id
func (m *CardsDAO) FindById(id string) (Card, error) {
	var card Card
	err := db.C(COLLECTION).FindId(bson.ObjectIdHex(id)).One(&card)
	return card, err
}

// Insert a card into database
func (m *CardsDAO) Insert(card Card) error {
	err := db.C(COLLECTION).Insert(&card)
	return err
}

// Delete an existing card
func (m *CardsDAO) Delete(card Card) error {
	err := db.C(COLLECTION).Remove(&card)
	return err
}

// Update an existing card
func (m *CardsDAO) Update(card Card) error {
	err := db.C(COLLECTION).UpdateId(card.ID, &card)
	return err
}