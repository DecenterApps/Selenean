pragma solidity ^0.4.18;

/// @title Contract for storing and calculating players stats 
contract PlayerStats {
    
    modifier onlyBattle {
        require(msg.sender == battleContract);
        _;
    }
    
    struct Stat {
      uint wins;
      uint losses;
      uint MMR;
      bool exists;
    }
    
    mapping (address => Stat) public players;
    
    address public battleContract;
    
    /// @dev this are constants in MMR calculation 
    uint public K_FACTOR = 32;
    uint public STD_RATING_POINTS = 400;
    
    /// @param _battleContract address of the Battle contract 
    function PlayerStats(address _battleContract) public {
        battleContract = _battleContract;
    }
    
    /// @notice Adds new stats for players when they finish a game
    /// @dev It's only callable for the Battle contract
    /// @param _player1 Address of the first player
    /// @param _player2 Address of the second player
    /// @param _result of the match, true = first player won, false the second won
    function setStats(address _player1, address _player2, bool _result) public onlyBattle {
        
        firstTimeInit(_player1);
        firstTimeInit(_player2);
        
        uint oldMmr1 = players[_player1].MMR;
        uint oldMmr2 = players[_player2].MMR;
        
        int updatedMmr1;
        int updatedMmr2;
        
        (updatedMmr1, updatedMmr2) = eloCalculation(oldMmr1, oldMmr2, _result);
        
        if (_result) {
            players[_player1].wins++;
            players[_player2].losses++;
        } else {
            players[_player2].wins++;
            players[_player1].losses++;
        }
        
        players[_player1].MMR = uint(updatedMmr1);
        players[_player2].MMR = uint(updatedMmr2);
        
    }
    
    /// @notice Clasic ELO algorithm implemented in solidity
    /// @dev numbers had to be multiplied by 100 to avoid floating point numbers
    /// @param _player1Rank Current MMR of the first player
    /// @param _player2Rank Current MMR of the second player
    /// @param _result of the match, true = first player won, false the second won
    /// @return Tuple of the players updated MMRs
    function eloCalculation(uint _player1Rank, uint _player2Rank, bool _result) public view returns(int, int) {
        uint r1 = 10**(_player1Rank / STD_RATING_POINTS);
        uint r2 = 10**(_player2Rank / STD_RATING_POINTS);
        
        int first = 0;
        int second = 0;
        
        if (_result) {
            first = 100;
        } else {
            second = 100;
        }
        
        uint e1 = (r1 * 100) / (r1 + r2);
        uint e2 = (r2 * 100) / (r1 + r2);
        
        int updatedScore1 = ((int(K_FACTOR) * 100) * (first - int(e1)));
        int updatedScore2 = ((int(K_FACTOR) * 100) * (second - int(e2)));
        
        int finalScore1 = int(_player1Rank) + updatedScore1/10000;
        int finalScore2 = int(_player2Rank) + updatedScore2/10000;
        
        return (finalScore1, finalScore2);
    }
    
    /// @notice Sets the default values in a struct if it hasn't been set
    /// @param _player The address of the player
    function firstTimeInit(address _player) private {
        if (players[_player].exists == false) {
            players[_player].MMR = 1000;
            players[_player].exists = true;
        }
    }
}