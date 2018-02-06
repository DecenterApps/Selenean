pragma solidity ^0.4.18;
import './PlayerStats.sol';

import '../Utils/Ownable.sol';

/// @title Handles matches between two players
/// @notice Players can play for free or deposit ether to the contract
/// @notice When the match ends funds are unlocked if the players agree on the result
/// @notice Only in case of a dispute does the server interveen 
contract Battle is Ownable {
    
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
    event MatchCanceled();
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
        bool disagree;
        mapping(address => address) votes;
    }
    
    mapping (address => bool) public inMatch;
    
    Match[] internal matches;
    
    uint public numMatches;
    
    address public owner;
    address public server;
    
    PlayerStats public statsContract;
    
    function Battle(address _server) public {
        owner = msg.sender;
        server = _server;
        numMatches = 0;
    }
    
    // A player can only start a match if he 
    function startMatch() external payable {
        require(inMatch[msg.sender] == false);
        
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
            ended: false,
            disagree: false
        }));
        
        inMatch[msg.sender] = true;
        
        MatchStarted();
        
        numMatches++;
    }
    
    function joinMatch(uint _matchId) external payable matchExists(_matchId) {
        require(inMatch[msg.sender] == false);
        require(matches[_matchId].player2.exists == false);
        require(matches[_matchId].ended == false);
        
        matches[_matchId].player2.playerAddress = msg.sender;
        matches[_matchId].player2.exists = true;
        matches[_matchId].player2.value = msg.value;
        matches[_matchId].startTime = now;
        
        MatchStarted();
    }
    
    // If the second player is set the game has started 
    // Only the players in the match can vote
    // And they can vote only once
    // TODO: startTime???
    function finishMatch(uint _matchId, address _winner) external matchExists(_matchId) {
        
        Player memory p1 = matches[_matchId].player1;
        Player memory p2 = matches[_matchId].player2;
        
        require(p2.exists == true);
        require(msg.sender == p2.playerAddress || msg.sender == p1.playerAddress);
        require(matches[_matchId].votes[msg.sender] == 0x0);
        
        // set the current vote of the player 
        matches[_matchId].votes[msg.sender] = _winner;
        
        address otherPlayersAddr = _getOtherPlayer(msg.sender, p1, p2);
        
        if (matches[_matchId].votes[otherPlayersAddr] == matches[_matchId].votes[msg.sender]) {
            bool winner = _getWhoWon(p1.playerAddress, _winner);
            
            _matchEnded(_matchId, p1, p2, winner);
            
        } else {
            if (matches[_matchId].votes[otherPlayersAddr] != 0x0 && 
                matches[_matchId].votes[msg.sender] != 0x0) {
                    MatchDisagreement();
                    matches[_matchId].disagree = true;
                }
            
        }
    }
    
    // Only if the second player hasn't joined can a user cancel the match
    function cancelMatch(uint _matchId) external matchExists(_matchId) {
        require(msg.sender == matches[_matchId].player1.playerAddress);
        require(matches[_matchId].player2.exists == false);
        
        matches[_matchId].ended = true;
        
        msg.sender.send(matches[_matchId].player1.value);
        
        MatchCanceled();
        
    }
    
    // Server calls if the 2 parties disagree
    function judge(uint _matchId, bool _whoWon) external onlyServer matchExists(_matchId) {
        require(matches[_matchId].disagree == true);
        
        Player memory p1 = matches[_matchId].player1;
        Player memory p2 = matches[_matchId].player2;
        
        _matchEnded(_matchId, p1, p2, _whoWon);
    }
    
    function() external payable {
        revert();
    }
    
    function addStatsContract(address _statsAddress) public onlyOwner {
        require(_statsAddress == 0x0);
        
        statsContract = PlayerStats(_statsAddress);
    }
    
    function getMatch(uint _matchId) public view 
            returns(address, uint, address, uint, uint, bool) {
        require(matches[_matchId].exists == true);
        
        Match memory currMatch = matches[_matchId];
        
        return (
            currMatch.player1.playerAddress,
            currMatch.player1.value,
            currMatch.player2.playerAddress,
            currMatch.player2.value,
            currMatch.startTime,
            currMatch.ended
        );
    }
    
    // Internal methods
    
    function _matchEnded(uint _matchId, Player _p1, Player _p2, bool _winner) internal {
        matches[_matchId].ended = true;
            
        // Reset inMatch for both players
        inMatch[_p1.playerAddress] = false;
        inMatch[_p2.playerAddress] = false;
        
        // TODO: who won?
        statsContract.setStats(_p1.playerAddress, _p2.playerAddress, _winner);
        
        _payout(_p1, _p2, _winner);
        
        MatchFinished();
    }
    
    function _getOtherPlayer(address msgSender, Player _p1, Player _p2) internal pure returns (address) {
        if (_p1.playerAddress == msgSender) {
            return _p2.playerAddress;
        } else {
            return _p1.playerAddress;
        }
    }
    
    function _getWhoWon(address _player1Address, address _winnersAddress) internal pure returns (bool) {
        if (_player1Address == _winnersAddress) {
            return true;
        } else {
            return false;
        }
    }
    
    function _payout(Player _p1, Player _p2,  bool _winner) internal {
        uint reward = _p1.value + _p2.value;
        
        if (_winner) {
            _p1.playerAddress.send(reward);
        } else {
            _p2.playerAddress.send(reward);
        }
    }
}