const Booster = artifacts.require("./Match/Booster.sol");
const DecenterCards = artifacts.require("./Match/SeleneanCards.sol");

contract('Booster', async (accounts) => {

    let booster, seleneanCards;

    before(async () => {
        booster = await Booster.deployed();
        seleneanCards = await SeleneanCards.deployed();
    });

    it("...Should buy booster", async () => { 
        booster.buyBooster({from: accounts[0], value: web3.toWei(0.001, 'ether')});
        booster.buyBooster({from: accounts[0], value: web3.toWei(0.001, 'ether')});

        let boosters = await booster.getMyBoosters({from: accounts[0]} );
        
        assert.equal(boosters.length >= 2, true, "We bought at least 2 boosters");
    });

    it("...Should reveal boosters", async () => { 
        let boosters = await booster.getMyBoosters({from: accounts[0]} );
        let numOfCards = await seleneanCards.balanceOf(accounts[0], {from: accounts[0]});

        for (i=0; i<booster.length; i++){
        	let exNumOfCards = numOfCards;
        	await booster.revealBooster(booster[i], {from: accounts[0]});
        	numOfCards = await seleneanCards.balanceOf(accounts[0], {from: accounts[0]});

        	assert.equal(exNumOfCards + booster.numberOfCardsInBooster(), numOfCards, "After reveal we should have X more cards");
        }
    });    

});