const DecenterCards = artifacts.require("./DecenterCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");
const GiftToken = artifacts.require('./GiftToken');

module.exports = function(deployer) {
	deployer.deploy(CardMetadata)
	.then(() => deployer.deploy(DecenterCards))
	.then(() => deployer.deploy(Booster, DecenterCards.address))
	.then(() => Booster.deployed())
	.then((booster) => booster.addMetadataContract(CardMetadata.address))
	.then(() => DecenterCards.deployed())
	.then((cards) => {
		cards.addBoosterContract(Booster.address);
		cards.addMetadataContract(CardMetadata.address);
		return true;
	});
};