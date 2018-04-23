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

type User struct {
	Id    int
	Email  string
	Address string
	Sent bool
}

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

var tmpl = template.Must(template.ParseGlob("view/*"))

func Index(w http.ResponseWriter, r *http.Request) {
	db := dbConn()
	selDB, err := db.Query("SELECT * FROM User ORDER BY id DESC")
	if err != nil {
		panic(err.Error())
	}
	emp := User{}
	res := []User{}
	for selDB.Next() {
		var id int
		var email, address string
		var sent bool
		err = selDB.Scan(&id, &email, &address, &sent)
		if err != nil {
			panic(err.Error())
		}
		emp.Id = id
		emp.Email = email
		emp.Address = address
		emp.Sent = sent
		res = append(res, emp)
	}
	tmpl.ExecuteTemplate(w, "Index", res)

	defer db.Close()
}


func New(w http.ResponseWriter, r *http.Request) {
	tmpl.ExecuteTemplate(w, "New", nil)
}

func Insert(w http.ResponseWriter, r *http.Request) {
	db := dbConn()
	if r.Method == "POST" {
		email := r.FormValue("email")
		err := emailx.Validate(email)
		if err == nil {
			address := r.FormValue("address")
			if len(address) != 42 {
				defer db.Close()
				http.Redirect(w, r, "/", 301)
				return
			}
			sent := true
			insForm, err := db.Prepare("INSERT INTO User(email, address, sent) VALUES(?,?,?)")
			if err != nil {
				panic(err.Error())
			}
			insForm.Exec(email, address, sent)
			log.Println(sent)
			log.Println("INSERT: User email: " + email + " | Address: " + address + " ")
		} else if err == emailx.ErrInvalidFormat {
			fmt.Println("Wrong format.")
		} else {
			fmt.Println("Unresolvable host.")
		}
	}
	defer db.Close()
	http.Redirect(w, r, "/", 301)
}

func main() {
	log.Println("Server started on: http://localhost:8080")
	http.HandleFunc("/", Index)
	http.HandleFunc("/new", New)
	http.HandleFunc("/insert", Insert)
	http.ListenAndServe(":8080", nil)
}