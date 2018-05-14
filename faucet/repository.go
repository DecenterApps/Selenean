package main

import (
	"database/sql"
	"github.com/joho/godotenv"
	"os"
	"log"
)

//Connection to database

func dbConn() (db *sql.DB) {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	dbDriver := os.Getenv("DB_DRIVER")
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")

	db, err = sql.Open(dbDriver, dbUser+":"+dbPass+"@/"+dbName)
	if err != nil {
		panic(err.Error())
	}
	return db
}

func findExistingTokenForUser(email string, db *sql.DB) (string) {
	query1 := "SELECT token FROM user WHERE email =" + "\""+ email + "\""
	token := ""
	selDb, _ := db.Query(query1)
	if selDb.Next() {
		selDb.Scan(&token);
	}
	return token;
}

func registerNewUser(email string, address string, sent bool, db *sql.DB) (string) {
	token := tokenGenerator()
	insForm, err := db.Prepare("INSERT INTO user(email, address, sent, token) VALUES(?,?,?,?)")
	if err != nil {
		panic(err.Error())
	} else {
		insForm.Exec(email,address,sent,token)
	}
	return token
}


func isUserRegistered(email string, db *sql.DB) (bool){
	query := "SELECT * FROM user WHERE email =" + "\""+ email + "\""
	selDb, _ := db.Query(query)
	if selDb.Next() {
		return true
	}
	return false
}


func checkIfkEthersSent(email string, db *sql.DB) (bool){
	query := "SELECT sent FROM user WHERE email =" + "\""+ email + "\""
	selDb, _ := db.Query(query)
	var sent bool
	if selDb.Next() {
		selDb.Scan(&sent)
		return sent
	}
	return false
}


func sendAndUpdateStatus(db *sql.DB, token string) (string) {
	query := "SELECT * FROM user WHERE token =" + "\"" + token + "\""
	selDB, err := db.Query(query)
	var res string
	if selDB.Next() {
		var id int
		var email, address string
		var sent bool
		err = selDB.Scan(&id, &email, &address, &sent, &token)
		if err != nil {
			panic(err.Error())
		}
		if sent == false {
			sendEther(address) // we are sending ether and updating sent status
			update, err := db.Prepare("UPDATE user SET sent=1 WHERE token =" + "\"" + token + "\" ")
			if err == nil {
				update.Exec()
			} else {
				panic(err.Error())
			}
			res = "0.1 Kovan ETH has been sent to address " + address
		} else {
			res = "Sorry, but requests are limited to one per email address"
		}
	} else {
		res = "Token doesn't exist"
	}
	return res
}
