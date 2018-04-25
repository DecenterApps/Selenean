package main

import (
	"database/sql"
	"log"
	"net/http"
	"text/template"
	_ "github.com/go-sql-driver/mysql"
	"github.com/goware/emailx"
	"fmt"
)
//User entity
type User struct {
	Id    int
	Email  string
	Address string
	Sent bool
	Token string
}

//Connection to database
func dbConn() (db *sql.DB) {
	dbDriver := "mysql"
	dbUser := "root"
	dbPass := "root"
	dbName := "goblog"
	db, err := sql.Open(dbDriver, dbUser+":"+dbPass+"@/"+dbName)
	if err != nil {
		panic(err.Error())
	}
	return db
}

//parsing templates
var tmpl = template.Must(template.ParseGlob("view/*"))


//index - home page
func Index(w http.ResponseWriter, r *http.Request) {
	var res string = ""
	if r.Method == "GET" {
		tmpl.ExecuteTemplate(w, "Index", res)
	} else {
		db := dbConn()
		if r.Method == "POST" {
			// Getting and validating email format
			email := r.FormValue("email")
			err := emailx.Validate(email)

			//If email's valid, --> we are generating Token

			if err == nil {
				address := r.FormValue("address")

				//validating address
				if len(address) != 42 {
					defer db.Close()
					return
				}
				var sent bool
				query := "SELECT sent FROM user WHERE email =" + "\""+ email + "\""
				selDb, _ := db.Query(query)
				//If there's already registered user with this email
				if selDb.Next() {
					selDb.Scan(&sent)
					//if sent flag is true means we have already sent ethers - otherwise we will send him again the same token
					if(sent) {
						res = "We have already sent you ethers!"
					} else {
						res = "We will send you confirmation link again!"
						query1 := "SELECT token FROM user WHERE email =" + "\""+ email + "\""
						var token string
						selDb1, _ := db.Query(query1)
						if selDb1.Next(){
							selDb1.Scan(&token)
							url := "faucet.selenean.com/sendEther?token=" + token
							fmt.Println("URL to get tokens : " + url)
						}
					}
				} else {
					token := tokenGenerator()
					//If this is new user, we will send him new
					insForm, err := db.Prepare("INSERT INTO user(email, address, sent, token) VALUES(?,?,?,?)")
					res = "We will send you confirmation link to" + email
					if err != nil {
						panic(err.Error())
					} else {
						insForm.Exec(email, address, sent, token)
						url := "localhost:8080/sendEther?token=" + token
						fmt.Println("URL to get tokens : " + url)
						res = "We have sent confirmation link for kEthers to : " + email
					}
				}

			} else if err == emailx.ErrInvalidFormat {
				fmt.Println("Wrong format.")
			} else {
				fmt.Println("Unresolvable host.")
			}
			tmpl.ExecuteTemplate(w, "Index", res)
		}
		defer db.Close()
	}
}

func sendEth(w http.ResponseWriter, r *http.Request)  {
	token := r.FormValue("token")
	db := dbConn()
	query := "SELECT * FROM user WHERE token =" + "\""+ token + "\""
	selDB, err := db.Query(query)
	var res string
	if selDB.Next() {
		var id int
		var email, address string
		var sent bool
		err = selDB.Scan(&id, &email, &address, &sent, &token)
		if sent == false {
			sendEther(address) // we are sending ether and update-ing it as a true
			update, err := db.Prepare("UPDATE user SET sent=1 WHERE token =" + "\""+ token + "\" ")
			if(err != nil){
				panic(err.Error())
			} else {
				update.Exec()
			}
			res = "Hello! kEthers are sent to address : "+ address
		} else {
			res = "You have already recieved ethers!"
		}
		//fmt.Println(address)
		//fmt.Println("Token : " + token)
	} else {
		res = "Token doesn't exist!"
	}
	if err != nil {
		panic(err.Error())
	}
	//fmt.Println(res)
	tmpl.ExecuteTemplate(w, "Index", res)
}

func main() {
	log.Println("Server started on: http://localhost:8080")
	http.HandleFunc("/sendEther",sendEth)
	http.HandleFunc("/", Index)
	http.ListenAndServe(":8080", nil)
}