pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Cards/DecenterCards.sol";
import "../contracts/Cards/CardMetadata.sol";

contract TokenTest {
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
  	
  	data.addCardMetadata(1, 0);

  	Assert.equal(data.getNumberOfCards(0), 1, "Should be exactly one property.");
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

    data.addCardMetadata(10, 0);
	data.addCardMetadata(5, 0);
    data.addCardMetadata(1, 0);
    data.addCardMetadata(12, 1);

    Assert.equal(data.getNumberOfCards(0), 3, "Should be exactly four properties for 0 type.");
  	Assert.equal(data.getNumberOfCards(1), 1, "Should be exactly one property for 1 type.");

    uint cardId1 = token.createCard(this, 0, 0);
    uint cardId2 = token.createCard(this, 1, 0);

    Assert.equal(token.numOfCards(), 2, "Should be exactly one created card with properties.");
  
  	// returns tupple with just one uint (power)
	uint power1 = token.metadata(cardId1);
	Assert.equal(cardId1, 0, "First card should have 0 id");
  	Assert.equal(power1, 10, "Power should be 10");

	uint power2 = token.metadata(cardId2);
	Assert.equal(cardId2, 1, "First card should have 1 id");
  	Assert.equal(power2, 12, "Power should be 12");

  }
}