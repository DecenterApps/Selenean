const Battle = artifacts.require("./Battle.sol");
const PlayerStats = artifacts.require("./PlayerStats.sol");

module.exports = function(deployer) {
  deployer.deploy(Battle);
  deployer.deploy(PlayerStats);
};