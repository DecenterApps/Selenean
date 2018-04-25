const CardPackToken = artifacts.require("./Match/CardPackToken.sol");
const Booster = artifacts.require("./Match/Booster.sol");


contract('CardPackToken', async (accounts) => {

    let booster, cardPackToken;

    before(async () => {
        booster = await Booster.deployed();
        cardPackToken = await CardPackToken.deployed();

        await booster.addGiftToken(cardPackToken.address, {from: accounts[0]});
    });

    it("...should mint a user 1 CardPackToken", async () => {
        const minted = await cardPackToken.mint(accounts[0], 100000000,  {from: accounts[0]});

        const balance = await cardPackToken.balanceOf(accounts[0]);

        assert.equal(balance.valueOf(), 100000000, "The user should have 1.1 token");
    });

    it("...should buy a booster with CardPackToken", async () => {
        const boosterBought = await cardPackToken.buyBoosterWithToken();

        const balance = await booster.numOfBoosters.call();

        const balanceOfTokens = await cardPackToken.balanceOf(booster.address);

        assert.equal(balance.valueOf(), 1, "The user should have bought a booster");
    });

});
