const DecenterCards = artifacts.require("./DecenterCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");

const PlayerStats = artifacts.require("./PlayerStats.sol");
const Battle = artifacts.require("./Battle.sol");

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

	deployer.deploy(Battle, "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef").then(() => {
		return deployer.deploy(PlayerStats, Battle.address);
	});
};