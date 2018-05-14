package main

import (
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"log"
	"net/http"
	"text/template"
)

var tmpl = template.Must(template.ParseGlob("view/*"))

func Index(w http.ResponseWriter, r *http.Request) {
	var res string = ""
	if r.Method == "GET" {
		tmpl.ExecuteTemplate(w, "Index", res)
	} else {
		db := dbConn()
		if r.Method == "POST" {
			email, address := getFormValues(r)

			validMail := validateMail(email)
			validAddress := validateAddress(address)

			if validMail == false {
				res := "Mail is not valid"
				tmpl.ExecuteTemplate(w, "Index", res)
				defer db.Close()
				return
			}

			if validAddress == false {
				res := "kETH address is not valid"
				tmpl.ExecuteTemplate(w, "Index", res)
				defer db.Close()
				return
			}

			if isUserRegistered(email, db) {
				if checkIfkEthersSent(email, db) {
					res = "Sorry, but requests are limited to one per email address"
				} else {
					token := findExistingTokenForUser(email, db)
					if token != "" {
						url := "faucet.selenean.com/sendEther?token=" + token
						fmt.Println("URL to get tokens : " + url)
					}
					_, err := sendMail(email, token)
					if err != nil {
						panic(err.Error())
					}
					res = "Confirmation URL has been resent to your email address"
				}
			} else {
				sent := false
				token := registerNewUser(email, address, sent, db)
				url := "faucet.selenean.com/sendEther?token=" + token
				fmt.Println("URL to get tokens : " + url)
				res = "Confirmation URL has been sent to " + email
			}

			tmpl.ExecuteTemplate(w, "Index", res)
			defer db.Close()
		}
	}
}

func sendEth(w http.ResponseWriter, r *http.Request) {
	token := r.FormValue("token")
	db := dbConn()
	res := sendAndUpdateStatus(db, token)
	tmpl.ExecuteTemplate(w, "Index", res)
	defer db.Close()
}

func main() {
	log.Println("Server started on: http://localhost:8080")
	http.HandleFunc("/sendEther", sendEth)
	http.HandleFunc("/", Index)
	http.ListenAndServe(":8080", nil)
}
