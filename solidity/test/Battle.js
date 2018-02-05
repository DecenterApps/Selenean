const Battle = artifacts.require("./Battle.sol");


contract('Battle', async (accounts) => {

    let battle, userAddr1, userAddr2, channelId;

    before(async () => {
        battle = await Battle.deployed();
        userAddr1 = accounts[0];
        userAddr2 = accounts[1];
    });

    it('...should start a Match', async () => {

        

    });

});