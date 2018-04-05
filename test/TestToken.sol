pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Cards/SeleneanCards.sol";
import "../contracts/Cards/CardMetadata.sol";

contract TestToken {
  function testInitialNumberOfCardsDeployedContract() public {
    SeleneanCards token = SeleneanCards(DeployedAddresses.SeleneanCards());

    Assert.equal(token.numOfCards(), 0, "Should be no cards when deploying.");
  }

  function testInitialAddingFirstCard() public {
    SeleneanCards token = SeleneanCards(DeployedAddresses.SeleneanCards());

    uint cardId = token.createCard(this);

    Assert.equal(cardId, 0, "CardId should be 0 for first created card");
    Assert.equal(token.numOfCards(), 1, "Should be exactly one card when we add one.");
  }

  function testAddingCardMetadata() public {
    CardMetadata data = CardMetadata(DeployedAddresses.CardMetadata());
  	
  	data.addCardMetadata(1, "kljafskjlasfdhlkjdsaf", 1, 2,0x12345);

  	Assert.equal(data.getNumberOfCards(), 1, "Should be exactly one property.");
  }

  function testTransferingCard() public {
  	SeleneanCards token = SeleneanCards(DeployedAddresses.SeleneanCards());

	  uint cardId = token.createCard(this);

    Assert.equal(token.ownerOf(cardId), this, "This should be owner of newly created card.");

    token.transfer(0x0, cardId);

    Assert.equal(token.ownerOf(cardId), 0x0, "0x0 should be owner of newly created card.");
  }
  
  // not using deployed contracts
  function testInitialAddingFirstCardWithProperties() public {
  	// using new so we can test onlyOwner methods
    SeleneanCards token = new SeleneanCards();
    CardMetadata data = new CardMetadata();
    token.addMetadataContract(address(data));

    data.addCardMetadata(10, "0", 1, 2,0x12345);
	  data.addCardMetadata(5, "0", 1, 2,0x12345);
    data.addCardMetadata(1, "0", 1, 2,0x12345);
    data.addCardMetadata(12, "1", 1, 2,0x12345);

    Assert.equal(data.getNumberOfCards(), 4, "Should be exactly four properties.");

    uint cardId1 = token.createCard(this, 0);

    Assert.equal(token.numOfCards(), 1, "Should be exactly one created card with properties.");
  
    uint id1;
    uint rarity1;
    bytes32 ipfsHash1;
    uint8 ipfsHashFunction1;
    uint8 ipfsSize1;
    address artist1;
	  (id1, rarity1, ipfsHash1, ipfsHashFunction1, ipfsSize1,artist1) = token.metadata(cardId1);
	  Assert.equal(cardId1, 0, "First card should have 0 id");
  	Assert.equal(rarity1, 10, "Power should be 10");


  }
}