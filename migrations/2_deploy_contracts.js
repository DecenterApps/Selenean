const SeleneanCards = artifacts.require("./SeleneanCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");
const GiftToken = artifacts.require('./GiftToken');
const Marketplace = artifacts.require("./Marketplace.sol");

module.exports = function(deployer) {
	deployer.deploy(CardMetadata)
	.then(() => deployer.deploy(SeleneanCards))
	.then(() => deployer.deploy(Marketplace, SeleneanCards.address))
	.then(() => deployer.deploy(Booster, SeleneanCards.address))
	.then(() => Booster.deployed())
	.then((booster) => booster.addMetadataContract(CardMetadata.address))
	.then(() => SeleneanCards.deployed())
	.then((cards) => cards.addBoosterContract(Booster.address))
	.then(() => SeleneanCards.deployed())
	.then((cards) => cards.addMetadataContract(CardMetadata.address))
	.then(() => true);
};
