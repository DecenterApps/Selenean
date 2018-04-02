pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Match/PlayerStats.sol";
import "../contracts/Match/Battle.sol";

contract TestPlayerStats {
    function testPlayerStatsDeployedContract() public {
        PlayerStats stats = PlayerStats(DeployedAddresses.PlayerStats());

        Assert.equal(stats.battleContract(), DeployedAddresses.Battle(), "Set battle contract in constructor");
    }

    function testEloCalculation() public returns(int, int) {
        PlayerStats stats = PlayerStats(DeployedAddresses.PlayerStats());

        int updatedMMR1;
        int updatedMMR2;

        (updatedMMR1, updatedMMR2) = stats.eloCalculation(2400, 2000, true);

        Assert.equal(updatedMMR1, 2403, "Check the updated result of the player who won");
        Assert.equal(updatedMMR2, 1998, "Check the updated result of the player who won");
    }
}