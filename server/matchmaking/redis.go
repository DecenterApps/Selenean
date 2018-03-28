package main

import (
	"encoding/hex"

	"github.com/go-redis/redis"
	"github.com/ethereum/go-ethereum/crypto/randentropy"
	"time"
	"bytes"
	"encoding/json"
)

type Match struct {
	Id string `json:"id"`
	Host string `json:"host"`
	Address string `json:"address"`
}

var client *redis.Client

func redisClient() *redis.Client {
	if client != nil {
		return client
	}

	return redis.NewClient(&redis.Options{
		Addr: "localhost:6379",
	})
}

func generateMessage(address string) ([]byte, error) {
	client := redisClient()

	//TODO extract constant
	message := []byte(hex.EncodeToString(randentropy.GetEntropyCSPRNG(32)))

	//TODO extract constant
	_, err := client.SetNX(address, message, time.Duration(300000000000)).Result()

	if err != nil {
		return nil, err
	}

	return message, nil
}

func getMessage(address string) (string, error) {
	client := redisClient()

	result, err := client.Get(address).Result()

	if err != nil {
		return "", err
	}

	return result, nil
}

func invalidateMessage(address string) (bool, error) {
	client := redisClient()

	_, err := client.Set(address, "", 0).Result()

	if err != nil {
		return false, err
	}

	return true, nil
}

func hasActiveMatch(address string) (string, error) {
	client := redisClient()

	//TODO extract constant
	key, err := client.Get(bytes.NewBufferString("match-" + address).String()).Result()

	if err != nil {
		return "", err
	}

	return key, nil
}

func getHost() (string) {
	return "http://localhost:8082"
}

func BindAddressKeysToMatchId(match Match, address1Key string, address2Key string, address1 string, address2 string) (error) {
	match.Address = address1
	match1Json, err := json.Marshal(match)

	if err != nil {
		return err
	}

	match.Address = address2

	match2Json, err := json.Marshal(match)

	if err != nil {
		return err
	}

	BindAddressKeyToMatchId(match1Json, address1Key, "key")

	if err != nil {
		return err
	}

	BindAddressKeyToMatchId(match1Json, address1Key, "address")

	if err != nil {
		return err
	}

	BindAddressKeyToMatchId(match2Json, address2Key, "key")

	if err != nil {
		return err
	}

	BindAddressKeyToMatchId(match2Json, address2Key, "address")

	if err != nil {
		return err
	}

	return nil
}

func BindAddressKeyToMatchId(matchJson []byte, addressKey string, prefix string) error {
	client := redisClient()

	//TODO extract constant
	_, err := client.Set(prefix + "-" + addressKey , matchJson, time.Duration(2000000000000)).Result()

	if err != nil {
		return err
	}

	return nil
}
