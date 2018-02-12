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
    
    event MatchCreated(uint indexed matchId, address player1, uint value, uint time);
    event MatchStarted(uint indexed matchId, address player2, uint value, uint time);
    event MatchVoted(uint indexed matchId, address player);
    event MatchCanceled(uint indexed matchId, address player, bool payment);
    event MatchFinished(uint indexed matchId, bool winner);
    event MatchDisagreement(uint indexed matchId);
    
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

    /// @dev Must be internal, public gives error in current version of solidity
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
    
    /// @notice A user should not send ether to the contract address, just in the methods
    function() external payable {
        revert();
    }

    /// @notice Starts a match for 1 player, the second can join this match
    /// @dev A user can only start a match if no active mathces are currentl active
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
        
        MatchCreated(numMatches, msg.sender, msg.value, now);
        
        numMatches++;
    }
    
    /// @notice A user can join a created match
    /// @dev You can only join only 1 match at a time
    /// @dev You can only join if there isn't a second player in the match
    /// @dev You can only join if the match is active
    /// @param _matchId The id of the match you want to join
    function joinMatch(uint _matchId) external payable matchExists(_matchId) {
        require(inMatch[msg.sender] == false);
        require(matches[_matchId].player2.exists == false);
        require(matches[_matchId].ended == false);
        
        matches[_matchId].player2.playerAddress = msg.sender;
        matches[_matchId].player2.exists = true;
        matches[_matchId].player2.value = msg.value;
        matches[_matchId].startTime = now;
        
        MatchStarted(_matchId, msg.sender, msg.value, now);
    }
    
    /// @notice Both players call this function with the result of the game in order to finish it
    /// @dev Only a match with both players joined, can be finalized
    /// @dev Only the players in the match can vote
    /// @dev Players can vote only once
    /// @param _matchId The id of the match being finalized
    /// @param _winner The address of the winner in the current match
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
                    MatchDisagreement(_matchId);
                    matches[_matchId].disagree = true;
            } else {
                MatchVoted(_matchId, msg.sender);
            }
            
        }
    }
    
    /// @notice Cancel a match you made
    /// @dev You can only cancel your own matches
    /// @dev Only if the second player hasn't joined can a user cancel the match
    /// @param _matchId The Id of the match being canceled
    function cancelMatch(uint _matchId) external matchExists(_matchId) {
        require(msg.sender == matches[_matchId].player1.playerAddress);
        require(matches[_matchId].player2.exists == false);
        
        matches[_matchId].ended = true;
        
        bool res = msg.sender.send(matches[_matchId].player1.value);
        
        MatchCanceled(_matchId, msg.sender, res);
        
    }
    
    /// @notice Server calls this method to resolve the game
    /// @dev It can only call if the 2 parties disagree or a timeout happens
    /// @dev A timeout of 1 hours is set, this may be changed in the future
    /// @param _matchId The id of the match to judge
    /// @param _whoWon true if the first has won, false if the second player has won
    function judge(uint _matchId, bool _whoWon) external onlyServer matchExists(_matchId) {
        require(matches[_matchId].disagree == true || (matches[_matchId].startTime + 1 hours) > now);
        
        Player memory p1 = matches[_matchId].player1;
        Player memory p2 = matches[_matchId].player2;
        
        _matchEnded(_matchId, p1, p2, _whoWon);
    }
    
    /// @notice Sets the stats contract only once
    /// @param _statsAddress The address of the stats contract
    function addStatsContract(address _statsAddress) public onlyOwner {
        require(address(statsContract) == 0x0);
        
        statsContract = PlayerStats(_statsAddress);
    }
    
    /// @notice Returns the match data for a given matchId
    /// @param _matchId The id of the match
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
    
    /// @notice Internal function implements the logic for ending a match
    /// @param _matchId The Id of the match to end
    /// @param _p1 The first player in the match
    /// @param _p2 The second player in the match
    /// @param _winner true if the first has won, false if the second player has won
    function _matchEnded(uint _matchId, Player _p1, Player _p2, bool _winner) internal {
        matches[_matchId].ended = true;
            
        // Reset inMatch for both players
        inMatch[_p1.playerAddress] = false;
        inMatch[_p2.playerAddress] = false;
        
        statsContract.setStats(_p1.playerAddress, _p2.playerAddress, _winner);
        
        _payout(_p1, _p2, _winner);
        
        MatchFinished(_matchId, _winner);
    }
    
    /// @notice Gets the other player in the match given the first players address
    /// @param _msgSender The address of the player we know
    /// @param _p1 First player
    /// @param _p2 Second player
    /// @return The address of the second player
    function _getOtherPlayer(address _msgSender, Player _p1, Player _p2) internal pure returns (address) {
        if (_p1.playerAddress == _msgSender) {
            return _p2.playerAddress;
        } else {
            return _p1.playerAddress;
        }
    }
    
    /// @notice Returns boolean value who won
    /// @param _player1Address The address of the first player
    /// @param _winnersAddress The address of the player who won
    /// @return Returns boolean value who won
    function _getWhoWon(address _player1Address, address _winnersAddress) internal pure returns (bool) {
        if (_player1Address == _winnersAddress) {
            return true;
        } else {
            return false;
        }
    }
    
    /// @notice Pays out the correct user who won
    /// @dev We use .send instead of .transfer() so our state doesn't get reverted if transfer fails
    /// @param _p1 The first player
    /// @param _p2 The second player
    /// @param _winner Boolean value who won
    function _payout(Player _p1, Player _p2,  bool _winner) internal {
        uint reward = _p1.value + _p2.value;
        
        bool res = false;

        if (reward > 0) {
            if (_winner) {
                res = _p1.playerAddress.send(reward);
            } else {
                res = _p2.playerAddress.send(reward);
            }
        }
    }
}