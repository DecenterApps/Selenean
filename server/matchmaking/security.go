package matchmaking

import (
	"fmt"

	"github.com/ethereum/go-ethereum/crypto/secp256k1"
	"encoding/hex"
)

func verifySignature(msg, signature []byte) bool {
	pubkey, err := secp256k1.RecoverPubkey(msg, signature)

	if err != nil {
		fmt.Println(err)
	}

	return secp256k1.VerifySignature(pubkey, msg, signature[:64])
}

func secureRequest(signature string, address string) error {
	message, err := getMessage(address)

	msg, err := hex.DecodeString(message)

	sig, err := hex.DecodeString(signature)

	if err != nil {
		return err
	}

	if !verifySignature(msg, sig) {
		return err
	}

	_, err = invalidateMessage(address)

	if err != nil {
		return err
	}

	return nil
}
