package matchmaking

import (
	"encoding/hex"

	"github.com/go-redis/redis"
	"github.com/ethereum/go-ethereum/crypto/randentropy"
	"time"
	"bytes"
)

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

func hasActiveMatch(address string) (bool, error) {
	client := redisClient()

	//TODO extract constant
	result, err := client.Get(bytes.NewBufferString("match-" + address).String()).Result()

	if err != nil {
		return false, err
	}

	if result == "" {
		return true, nil
	}

	return false, nil
}
