pragma solidity ^0.4.18;
import './PlayerStats.sol';

// Handles matches between two players
// Players can play for free or deposit ether to the contract
// When the match ends funds are unlocked if the players agree on the result
// Only in case of a dispute does the server interveen 
contract Battle {
    
    modifier onlyServer {
        require(msg.sender == server);
        _;
    }
    
    modifier matchExists(uint _matchId) {
        require(matches[_matchId].exists == true);
        _;
    }
    
    event MatchCreated();
    event MatchStarted();
    event MatchFinished();
    event MatchDisagreement();
    
    struct Player {
        address playerAddress;
        uint value;
        bool exists;
    }
    
    struct Match {
        Player player1;
        Player player2;
        uint startTime;
        bool exists;
        bool ended;
        mapping(address => address) votes;
    }
    
    // struct Match {
    //     address player1;
    //     address player2;
    //     uint startTime;
    //     uint value;
    //     bool player1Voted;
    //     bool player2Voted;
    //     bool win; // false for player1, true for player2
    //     bool exists;
    // }
    
    Match[] matches;
    
    uint numMatches;
    
    address public owner;
    address public server;
    
    function Battle(address _server) public {
        owner = msg.sender;
        server = _server;
        numMatches = 0;
    }
    
    // A player can only start a match if he 
    function startMatch() external payable {
        matches.push(Match({
            player1: Player({
                playerAddress: msg.sender,
                value: msg.value,
                exists: true
            }),
            player2: Player({
                playerAddress: 0x0,
                value: 0,
                exists: false
            }),
            startTime: now,
            exists: true,
            ended: false
        }));
        
        // matches.push(Match({
        //     player1: msg.sender,
        //     player2: 0x0,
        //     startTime: now,
        //     value: msg.value,
        //     player1Voted: false,
        //     player2Voted: false,
        //     win: false,
        //     exists: true
        // }));
        
        MatchStarted();
        
        numMatches++;
    }
    
    // function joinMatch(uint _matchId) external payable matchExists(_matchId) {
    //     require(matches[_matchId].player2 == 0x0);
    //     require(msg.value >= matches[_matchId].value);
        
    //     matches[_matchId].player2 = msg.sender;

    //     MatchStarted();
    // }
    
    function joinMatch(uint _matchId) external payable matchExists(_matchId) {
        require(matches[_matchId].player2.exists == false);
        
        matches[_matchId].player2.playerAddress = msg.sender;
        matches[_matchId].player2.exists = true;
        matches[_matchId].player2.value = msg.value;
        
        MatchStarted();
    }
    
    // If the second player is set the game has started 
    // Only the players in the match can vote
    // And they can vote only once
    // TODO: some time limit?
    function finishMatch(uint _matchId, address _winner) external matchExists(_matchId) {
        
        Player memory p1 = matches[_matchId].player1;
        Player memory p2 = matches[_matchId].player2;
        
        require(p2.exists == true);
        require(msg.sender == p2.playerAddress || msg.sender == p1.playerAddress);
        require(matches[_matchId].votes[msg.sender] == 0x0);
        
        matches[_matchId].votes[msg.sender] = _winner;
        
        address otherPlayersAddr = _getOtherPlayer(msg.sender, p1, p2);
        
        if (matches[_matchId].votes[otherPlayersAddr] == matches[_matchId].votes[msg.sender]) {
            matches[_matchId].ended = true;
            MatchFinished();
        } else {
            if (matches[_matchId].votes[otherPlayersAddr] != 0x0 && 
                matches[_matchId].votes[msg.sender] != 0x0) {
                    MatchDisagreement();
                }
            
        }
    }
    
    // For the channel to be finished both players must be in the match 
    // Only those 2 players can call finish game
    // Each player can vote only once
    // function finishMatch(uint _matchId, address _winner) external matchExists(_matchId) {
    //     Match memory currMatch = matches[_matchId];
        
    //     require(currMatch.player1 != 0x0 && currMatch.player2 != 0x0);
    //     require(msg.sender == currMatch.player1 || msg.sender == currMatch.player2);
        
    //     if (msg.sender == currMatch.player1) {
    //         currMatch.player1Voted = true;
    //     } else {
    //         currMatch.player2Voted = true;
    //     }
        
        
        
        
    // }
    
    // Only if the second player hasn't joined can a user cancel the match
    function cancelMatch(uint _matchId) external matchExists(_matchId) {
        
    }
    
    // Server calls if the 2 parties disagree
    function judge(uint _matchId) external onlyServer matchExists(_matchId) {
        //matches[_matchId].ended = true;
    }
    
    function() external payable {
        revert();
    }
    
    // Internal methods
    function _getOtherPlayer(address msgSender, Player p1, Player p2) internal pure returns (address) {
        if (p1.playerAddress == msgSender) {
            return p2.playerAddress;
        } else {
            return p1.playerAddress;
        }
    }
    
    
}