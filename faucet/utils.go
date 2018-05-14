package main

import (
	"fmt"
	"crypto/rand"
	"github.com/joho/godotenv"
	"os"
	"log"
	"github.com/goware/emailx"
	"net/http"
	m "github.com/keighl/mandrill"

)

func sendMail(email string, token string) (response []*m.Response, err error) {
	err = godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	client := m.ClientWithKey(os.Getenv("API_KEY"))

	message := &m.Message{}
	message.AddRecipient(email, "name", "to")
	message.FromEmail = "faucet@selenean.com"
	message.FromName = "Selenean Faucet"
	message.Subject = "Please confirm your email address"
	url := "https://faucet.selenean.com/sendEther?token=" + token
	message.HTML = "Please click on the link below to confirm your email address: <br> <a href=\"" + url + "\">" + url + "</a>"
	message.Text = "Please paste this URL into browser to confirm your email address: " + url

	return client.MessagesSend(message)
}

func tokenGenerator() string {
	b := make([]byte, 16)
	rand.Read(b)
	return fmt.Sprintf("%x", b)
}

func dotEnv() (string, string){
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	address := os.Getenv("ADDRESS")
	privKey := os.Getenv("PRIV_KEY")

	return address, privKey
}

func validateMail(email string) (bool){
	err := emailx.Validate(email)
	if err != nil {
		return false
	}
	return true
}

func validateAddress(address string) (bool){
	if len(address) != 42 {
		return false
	}
	return true
}

func getFormValues(r *http.Request) (string,string) {
	email := r.FormValue("email")
	address := r.FormValue("address")
	return email,address
}