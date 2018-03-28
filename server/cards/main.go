package main

import (
	"net/http"
	"github.com/gorilla/mux"
	"encoding/json"
	"log"
	"gopkg.in/mgo.v2/bson"
)


var dao = CardsDAO{}


func respondWithError(w http.ResponseWriter, code int, msg string) {
	respondWithJson(w, code, map[string]string{"error": msg})
}

func respondWithJson(w http.ResponseWriter, code int, payload interface{}) {
	response, _ := json.Marshal(payload)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}


func AllCardsEndPoint(w http.ResponseWriter, r *http.Request) {
	movies, err := dao.FindAll()
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	respondWithJson(w, http.StatusOK, movies)

}

// GET a card by its ID
func FindCardEndpoint(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	movie, err := dao.FindById(params["id"])
	if err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid Movie ID")
		return
	}
	respondWithJson(w, http.StatusOK, movie)
}

// POST a new card
func CreateCardEndpoint(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	var card Card
	card.ID = bson.NewObjectId()
	if err := json.NewDecoder(r.Body).Decode(&card); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		log.Println(err)
		log.Println(&card)
		return
	}
	if err := dao.Insert(card); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	respondWithJson(w, http.StatusCreated, card)
}

// PUT update an existing card
func UpdateCardEndPoint(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	var card Card
	if err := json.NewDecoder(r.Body).Decode(&card); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	if err := dao.Update(card); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	respondWithJson(w, http.StatusOK, map[string]string{"result": "success"})
}

// DELETE an existing card
func DeleteCardEndPoint(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	var card Card
	if err := json.NewDecoder(r.Body).Decode(&card); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	if err := dao.Delete(card); err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	respondWithJson(w, http.StatusOK, map[string]string{"result": "success"})
}

func init() {
	dao.Server = "localhost"
	dao.Database = "cards"
	dao.Connect()
}
func main() {
	r := mux.NewRouter()
	r.HandleFunc("/cards", AllCardsEndPoint).Methods("GET")
	r.HandleFunc("/cards", CreateCardEndpoint).Methods("POST")
	r.HandleFunc("/cards", UpdateCardEndPoint).Methods("PUT")
	r.HandleFunc("/cards", DeleteCardEndPoint).Methods("DELETE")
	r.HandleFunc("/cards/{id}", FindCardEndpoint).Methods("GET")
	if err := http.ListenAndServe(":8084", r); err != nil {
		log.Fatal(err)
	}
}