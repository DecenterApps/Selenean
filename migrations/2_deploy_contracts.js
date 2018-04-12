const DecenterCards = artifacts.require("./SeleneanCards.sol");
const BoosterTest = artifacts.require("./BoosterTest.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");
const GiftToken = artifacts.require('./GiftToken');

module.exports = function(deployer) {
	deployer.deploy(CardMetadata)
	.then(() => deployer.deploy(DecenterCards))
	.then(() => deployer.deploy(BoosterTest, DecenterCards.address))
	.then(() => BoosterTest.deployed())
	.then((booster) => booster.addMetadataContract(CardMetadata.address))
	.then(() => DecenterCards.deployed())
	.then((cards) => {
		cards.addBoosterContract(BoosterTest.address);
		cards.addMetadataContract(CardMetadata.address);
		return true;
	});
};