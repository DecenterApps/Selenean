const DecenterCards = artifacts.require("./DecenterCards.sol");
const Booster = artifacts.require("./Booster.sol");
const CardMetadata = artifacts.require("./CardMetadata.sol");

const PlayerStats = artifacts.require("./PlayerStats.sol");
const Battle = artifacts.require("./Battle.sol");
const GiftToken = artifacts.require('./GiftToken');

module.exports = function(deployer) {
  deployer.deploy(CardMetadata);
  deployer.deploy(DecenterCards);

  deployer.deploy(Booster).then(() => {
    deployer.deploy(GiftToken, Booster.address);
  });

  deployer.deploy(Battle, "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef").then(() => {
    return deployer.deploy(PlayerStats, Battle.address);
  });
};