package main

import (
	"github.com/go-redis/redis"
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

func generateMessage(address string) (string, error) {
	client := redisClient()

	//TODO extract constant
	message := RandomString(32)

	//TODO extract constant
	_, err := client.SetNX(address, message, time.Duration(3000000000000)).Result()

	if err != nil {
		return "", err
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
	key, err := client.Get(address).Result()

	if err != nil {
		return "", err
	}

	return key, nil
}

func keyToMatch(key string) (*Match, error) {
	client := redisClient()

	//TODO extract constant
	key, err := client.Get(bytes.NewBufferString("key-" + key).String()).Result()

	if err != nil {
		return nil, err
	}

	var match Match

	err = json.Unmarshal([]byte(key), &match)

	if err != nil {
		return nil, err
	}

	return &match, nil
}
