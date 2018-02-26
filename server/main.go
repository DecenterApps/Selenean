package main

import (
	"log"
	"flag"
	"net/http"
	"fmt"
	"net/url"

	"github.com/koding/websocketproxy"
	"github.com/gorilla/websocket"
	"github.com/TCGFramework/server/utility"
)

func proxy() *websocketproxy.WebsocketProxy {
	backend := func(r *http.Request) *url.URL {if r.URL.Path == "/message" {
			return nil
		}

		u := url.URL{}
		key := r.URL.Query().Get("key")
		if len(key) != 0 {
			match, err := keyToMatch(key)

			if err != nil {
				fmt.Println(err)
				return &u
			}

			if match != nil {
				u.Scheme = "ws"
				u.Host = "localhost:8082"
				u.Fragment = r.URL.Fragment
				u.Path = r.URL.Path
				u.RawQuery = "id=" + match.Id + "&address=" + match.Address

				fmt.Println(r.URL.Scheme)
				return &u
			}
		}

		signature := r.URL.Query().Get("signature")
		address := r.URL.Query().Get("address")

		err := utility.SecureRequest(address, signature)

		if err != nil {
			log.Println(err)
			return &u
		}

		match, err := utility.HasActiveMatch(address)

		if err != nil {
			fmt.Println("3")
			fmt.Println(err)
			return &u
		}

		if len(match) != 0 {
			u.Scheme = "ws"
			u.Host = "localhost:8081"
			u.Fragment = r.URL.Fragment
			u.Path = r.URL.Path
			u.RawQuery = r.URL.RawQuery

			return &u
		}

		fmt.Println("5")
		u.Scheme = "ws"
		u.Host = "localhost:8081"
		u.Fragment = r.URL.Fragment
		u.Path = r.URL.Path
		u.RawQuery = r.URL.RawQuery

		fmt.Println(r.URL.Scheme)

		return &u
	}
	return &websocketproxy.WebsocketProxy{
		Backend: backend,
		Upgrader: &websocket.Upgrader{
			ReadBufferSize:  4096,
			WriteBufferSize: 4096,
		},
	}
}

func main() {
	flag.Parse()

	addr := flag.String("addr", ":8080", "http service address")

	err := http.ListenAndServe(*addr, proxy())
	if err != nil {
		log.Fatal("Listen and serve: ", err)
	}
}
