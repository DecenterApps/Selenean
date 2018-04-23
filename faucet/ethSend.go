package main
//
//import (
//	"fmt"
//	"github.com/joho/godotenv"
//	"log"
//	"os"
//	"github.com/regcostajr/go-web3"
//	"github.com/regcostajr/go-web3/providers"
//	"math/big"
//	"github.com/ethereum/go-ethereum/accounts/keystore"
//	"github.com/ethereum/go-ethereum/common"
//	"github.com/ethereum/go-ethereum/core/types"
//)
//
//func dotEnv() (string, string){
//	err := godotenv.Load()
//	if err != nil {
//		log.Fatal("Error loading .env file")
//	}
//	address := os.Getenv("ADDRESS")
//	privKey := os.Getenv("PRIV_KEY")
//
//	return address, privKey
//}
//
//func main() {
//
//	address, privkey := dotEnv()
//	fmt.Println(address)
//	fmt.Println(privkey)
//
//	var connection = web3.NewWeb3(providers.NewHTTPProvider("kovan.decenter.com", 10, false))
//	fmt.Println(connection.ClientVersion())
//
//
//	signer := types.NewEIP155Signer(big.NewInt(18))
//	key,_ := keystore.DecryptKey([]byte("{\"version\":3,\"id\":\"d812b892-51b7-45ab-88e2-18cb770318b5\",\"address\":\"508a7df8f0b42760da3e64ddc8aa937adcdfec16\",\"Crypto\":{\"ciphertext\":\"8e934c9ebc331862f4853d08eb738acb0ae57ea4dd4481ee8ceb8ce8bc7cd444\",\"cipherparams\":{\"iv\":\"ae44d692d004b1b1a53e0a2de43458f2\"},\"cipher\":\"aes-128-ctr\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"salt\":\"071cf7668bc21cdef9788354b113ee0ae66e8d390b34c0b4229f3939f9ecfd1a\",\"n\":8192,\"r\":8,\"p\":1},\"mac\":\"7c7b5a3da84f472486e81177dd807c714859f89302085cf27df91b211f54e87e\"}}"), "test12345");
//	tx, err := types.SignTx(types.NewTransaction(0, common.StringToAddress("0xf67cDA56135d5777241DF325c94F1012c72617eA"), big.NewInt(10000000), 21000, big.NewInt(1000000000), nil), signer, key.PrivateKey)
//	if err != nil {
//		fmt.Println(err)
//	}
//	coinbase, _ := connection.Eth.GetCoinbase()
//	fmt.Println(coinbase)
//	from, err := types.Sender(signer, tx)
//	fmt.Println(from)
//	fmt.Println(tx)
//
//
//
//
//}