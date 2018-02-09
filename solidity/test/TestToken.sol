pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Cards/DecenterCards.sol";
import "../contracts/Cards/CardMetadata.sol";

contract TestToken {
  function testInitialNumberOfCardsDeployedContract() public {
    DecenterCards token = DecenterCards(DeployedAddresses.DecenterCards());

    Assert.equal(token.numOfCards(), 0, "Should be no cards when deploying.");
  }

  function testInitialAddingFirstCard() public {
    DecenterCards token = DecenterCards(DeployedAddresses.DecenterCards());

    uint cardId = token.createCard(this);

    Assert.equal(cardId, 0, "CardId should be 0 for first created card");
    Assert.equal(token.numOfCards(), 1, "Should be exactly one card when we add one.");
  }

  function testAddingCardMetadata() public {
    CardMetadata data = CardMetadata(DeployedAddresses.CardMetadata());
  	
  	data.addCardMetadata(1, "kljafskjlasfdhlkjdsaf", 1, 2);

  	Assert.equal(data.getNumberOfCards(), 1, "Should be exactly one property.");
  }

  function testTransferingCard() public {
  	DecenterCards token = DecenterCards(DeployedAddresses.DecenterCards());

	  uint cardId = token.createCard(this);

    Assert.equal(token.ownerOf(cardId), this, "This should be owner of newly created card.");

    token.transfer(0x0, cardId);

    Assert.equal(token.ownerOf(cardId), 0x0, "0x0 should be owner of newly created card.");
  }
  
  // not using deployed contracts
  function testInitialAddingFirstCardWithProperties() public {
  	// using new so we can test onlyOwner methods
    DecenterCards token = new DecenterCards();
    CardMetadata data = new CardMetadata();
    token.addMetadataContract(address(data));

    data.addCardMetadata(10, "0", 1, 2);
	  data.addCardMetadata(5, "0", 1, 2);
    data.addCardMetadata(1, "0", 1, 2);
    data.addCardMetadata(12, "1", 1, 2);

    Assert.equal(data.getNumberOfCards(), 4, "Should be exactly four properties.");

    uint cardId1 = token.createCard(this, 0);
    uint cardId2 = token.createCard(this, 3);

    Assert.equal(token.numOfCards(), 2, "Should be exactly one created card with properties.");
  
    uint id1;
    uint rarity1;
    bytes32 ipfsHash1;
    uint8 ipfsHashFunction1;
    uint8 ipfsSize1;
	  (id1, rarity1, ipfsHash1, ipfsHashFunction1, ipfsSize1) = token.metadata(cardId1);
	  Assert.equal(cardId1, 0, "First card should have 0 id");
  	Assert.equal(rarity1, 10, "Power should be 10");

    uint id2;
    uint rarity2;
    bytes32 ipfsHash2;
    uint8 ipfsHashFunction2;
    uint8 ipfsSize2;
  	(id2, rarity2, ipfsHash2, ipfsHashFunction2, ipfsSize2) = token.metadata(cardId2);
	  Assert.equal(cardId2, 1, "First card should have 1 id");
  	Assert.equal(rarity2, 12, "Power should be 12");

  }
}