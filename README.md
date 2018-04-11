
# Selenean
Selenean is a decentralized platform aiming to take blockchain-based collectible games to the next level. The main purpose of Selenean is to connect collectible game developers and artists along with digital asset collectors/traders into a single ecosystem that benefits all participants. This is achieved through a fair and well-balanced incentive system based on Ethereum smart contracts along with a set of tools, guidelines and open source libraries that can be used to facilitate development of blockchain-based games.

### Contracts 
  - Decenter Cards
  - Booster
  - CardMetadata
  - Cards
  

### DecenterCards (ERC721, Ownable)
This contract is used for creating new cards. It's directly connected with Booster and CardMetadata contract since every card has it's own metadata. 
### Booster (Ownable)
This contract alows you to buy (with ether/gift token) and reveal booster.
### Card Metadata (Ownable)
This contract is used for creating (adding) new metadata types for cards. 
### Deployment using remix

```sh
Deploy CardMetadata.sol contract
Deploy DecenterCards.sol contract
Deploy Booster.sol contract with address of previously deployed "DecenterCards.sol" contract
```

```sh
Call methods "addMetadataContract" inside "DecenterCards.sol and Booster.sol" with address of 
"CardMetadata.sol" which is previously depoyed.
```

```sh
Call method "addBoosterContract" in "DecenterCards.sol" with address of previously deployed "Booster.sol"
```
### Deployment using truffle
Kovan testnet
```
$ truffle migrate --network=kovan
```
Local testnet
```
$ truffle migrate
```



