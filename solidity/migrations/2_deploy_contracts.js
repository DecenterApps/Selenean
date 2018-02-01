const Battle = artifacts.require("./Battle.sol");
const PlayerStats = artifacts.require("./PlayerStats.sol");
const DecenterCards = artifacts.require("./DecenterCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");

module.exports = function(deployer) {
  deployer.deploy(Battle);
  deployer.deploy(PlayerStats);
  deployer.deploy(CardMetadata);
  deployer.deploy(DecenterCards);
};