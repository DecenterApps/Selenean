const PlayerStats = artifacts.require("./Match/PlayerStats.sol");
const Battle = artifacts.require("./Match/Battle.sol");

const getBalance = (addr) => {
    return new Promise((resolve, reject) => {
        web3.eth.getBalance(addr,(err, res) => {
            resolve(res.valueOf());
        });
    });
};

contract('Battle', async (accounts) => {

    let playerStats, battle, matchId, balance1, balance2;

    before(async () => {
        playerStats = await PlayerStats.deployed();
        battle = await Battle.deployed();

        await battle.addStatsContract(playerStats.address, {from: accounts[0]});

        balance1 = await getBalance(accounts[0]);
        balance1 = parseInt(web3.fromWei(balance1, 'ether'));
    });

    it("...Should starts a match as a user", async () => { 
        const match = await battle.startMatch({from: accounts[0], value: web3.toWei(1, 'ether')});

        matchId = match.logs[0].args.matchId.valueOf();


        assert.equal(matchId, 0, "Correct Match Id");
    });

    it("...Should join in to the match as a different user", async () => {
        const match = await battle.joinMatch(matchId, {from: accounts[1], value: web3.toWei(1, 'ether')});

        assert.equal(match.logs[0].event, 'MatchStarted', "The second player has entered the match");
    });

    it("...Should call the finish game function for the first player", async () => {
        const result = await battle.finishMatch(matchId, accounts[0], {from: accounts[0]});

        assert.equal(result.logs[0].event, 'MatchVoted', "First player voted and said that he won");
    });

    it("...Should call the finish game function for the second player", async () => {
        const result = await battle.finishMatch(matchId, accounts[0], {from: accounts[1]});

        assert.equal(result.logs[0].event, 'MatchFinished', "Second player voted and said that the first won");
    });

    it("...MMR of both players should be updated", async () => {
        const stats = await playerStats.players(accounts[0]);
        const stats2 = await playerStats.players(accounts[1]);

        const MMR1 = stats[2].valueOf();
        const MMR2 = stats2[2].valueOf();

        assert.equal(MMR1, 1016, "Stats for the first player");
        assert.equal(MMR2, 1000, "Stats for the second player");
    });

    it("...Player 1 should have 1 eth more", async () => {
        balance2 = await getBalance(accounts[0]);
        balance2 = parseInt(web3.fromWei(balance2, 'ether'));

        assert.equal(balance2 - balance1, 1, "Player1 has won 1 eth");
    });

    it("...The match should be closed", async () => {
        const matchData = await battle.getMatch(matchId);

        assert.equal(matchData[5], true, "Match ended should be set true");
    });

    it("...Should start and disagree in a match", async () => {
        const currMatch = await battle.startMatch({from: accounts[0], value: 4000000000});

        const _matchId = currMatch.logs[0].args.matchId.valueOf();

        await battle.joinMatch(_matchId, {from: accounts[1], value: 4000000000});

         await battle.finishMatch(_matchId, accounts[0], {from: accounts[0]});
         const res = await battle.finishMatch(_matchId, accounts[1], {from: accounts[1]});

         assert.equal(res.logs[0].event, 'MatchDisagreement');

    });

    it("...Should call a server judge method", async () => {
        const currMatch = await battle.judge(1, true, {from: accounts[2]});

        assert.equal(currMatch.logs[0].event, 'MatchFinished');
    });

    it("...Should start and cancel a match", async () => {
        const _currMatch = await battle.startMatch({from: accounts[0], value: 4000000000});

        const _matchId = _currMatch.logs[0].args.matchId.valueOf();

        const canceled = await battle.cancelMatch(_matchId, {from: accounts[0]});

        assert.equal(canceled.logs[0].event, 'MatchCanceled');
    });
});

