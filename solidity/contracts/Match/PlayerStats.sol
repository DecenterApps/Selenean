pragma solidity ^0.4.18;

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
    
    mapping (address => Stat) players;
    
    address public battleContract;
    
    function PlayerStats(address _battleContract) public {
        battleContract = _battleContract;
    }
    
    function setStats(address _player, uint _win, uint _lose) public onlyBattle {
        
        if (players[_player].exists == true) {
            
        } else {
            players[_player] = (Stat({
                wins: _win,
                losses: _lose,
                MMR: calculateMMR(),
                exists: true
            }));
        }
    }
    
    // Black box for now, implement multiple MMR calculation algorithms
    function calculateMMR() internal pure returns(uint) {
        return 42;
    }
}