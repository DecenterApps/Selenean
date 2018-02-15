const GiftToken = artifacts.require("./Match/GiftToken.sol");
const Booster = artifacts.require("./Match/Booster.sol");


contract('GiftToken', async (accounts) => {

    let booster, giftToken;

    before(async () => {
        booster = await Booster.deployed();
        giftToken = await GiftToken.deployed();

        await booster.addGiftTokenAddress(giftToken.address, {from: accounts[0]});
    });

    it("...should mint a user 1 Gift Token", async () => {
        const minted = await giftToken.mint(accounts[0], 1,  {from: accounts[0]});

        const balance = await giftToken.balanceOf(accounts[0]);

        assert.equal(balance.valueOf(), 1, "The user should have 1 token");
    });

    it("...should buy a booster with GiftToken", async () => {
        const boosterBought = await giftToken.buyBoosterWithToken();

        const balance = await booster.numOfBoosters.call();

        assert.equal(balance.valueOf(), 1, "The user should have 1 token");
    });

});
