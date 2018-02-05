const DecenterCards = artifacts.require("./DecenterCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");

const PlayerStats = artifacts.require("./PlayerStats.sol");
const Battle = artifacts.require("./Battle.sol");

module.exports = function(deployer) {
  deployer.deploy(CardMetadata);
  deployer.deploy(DecenterCards);

  deployer.deploy(Battle);
  deployer.deploy(PlayerStats);
};