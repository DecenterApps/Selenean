pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Cards/DecenterCards.sol";
import "../contracts/Cards/CardMetadata.sol";
import "../contracts/Cards/Booster.sol";

contract TestBooster {

	uint public BOOSTER_PRICE = 10 ** 15;

	function testBuyBooster() public {
		Booster booster = Booster(DeployedAddresses.Booster());


	}
}