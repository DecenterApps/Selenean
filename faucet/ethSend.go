package main

import (
	"log"
	"math/big"
	"github.com/ethereum/go-ethereum/accounts/keystore"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	"time"
	"context"
)

func sendEther(reciever string) {
	address, _ := dotEnv()
	client, err := ethclient.Dial("https://kovan.decenter.com")
	if err != nil {
		log.Fatal(err)
	}

	ctx, _ := context.WithTimeout(context.Background(), 1000*time.Second)

	nonce, _ := client.NonceAt(ctx,common.HexToAddress(address),nil) //nil means latest block

	signer := types.NewEIP155Signer(big.NewInt(42))
	key, err := keystore.DecryptKey([]byte("{\"version\":3,\"id\":\"d812b892-51b7-45ab-88e2-18cb770318b5\",\"address\":\"508a7df8f0b42760da3e64ddc8aa937adcdfec16\",\"Crypto\":{\"ciphertext\":\"8e934c9ebc331862f4853d08eb738acb0ae57ea4dd4481ee8ceb8ce8bc7cd444\",\"cipherparams\":{\"iv\":\"ae44d692d004b1b1a53e0a2de43458f2\"},\"cipher\":\"aes-128-ctr\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"salt\":\"071cf7668bc21cdef9788354b113ee0ae66e8d390b34c0b4229f3939f9ecfd1a\",\"n\":8192,\"r\":8,\"p\":1},\"mac\":\"7c7b5a3da84f472486e81177dd807c714859f89302085cf27df91b211f54e87e\"}}"), "test12345");
	if err != nil {
		log.Fatal(err)
	}
	unsigned := types.NewTransaction(nonce, common.HexToAddress(reciever), big.NewInt(100000000000000000), 21000, big.NewInt(100000000000), nil)

	tx, err := types.SignTx(unsigned, signer, key.PrivateKey)

	client.SendTransaction(ctx, tx)

	if err != nil {
		log.Fatal(err)
	}
}


