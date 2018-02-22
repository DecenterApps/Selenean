pragma solidity ^0.4.18;

import "./DecenterCards.sol";
import "./CardMetadata.sol";
import "../Utils/Ownable.sol";

contract Booster is Ownable {
    
    DecenterCards public decenterCards;
    CardMetadata public metadataContract;

    uint public BOOSTER_PRICE = 10 ** 15; // 0.001 ether
    uint public OWNER_PERCENTAGE = 15;

    uint public numberOfCardsInBooster = 5;
    uint public ownerBalance;

    mapping(uint => address) public boosterOwners;
    mapping(uint => uint) public blockNumbers;
    mapping(address => uint[]) public unrevealedBoosters;
    mapping(uint => uint[]) public boosters;

    uint public numOfBoosters;

    event BoosterBought(address user, uint boosterId);
    event BoosterRevealed(uint boosterId);
    
    function Booster(address _cardAddress) public {
        decenterCards = DecenterCards(_cardAddress);
    }
    
    /// @notice buy booster for BOOSTER_PRICE
    function buyBooster() public payable {
        require(msg.value >= BOOSTER_PRICE);

        uint boosterId = numOfBoosters;

        boosterOwners[boosterId] = msg.sender;
        blockNumbers[boosterId] = block.number;        

        unrevealedBoosters[msg.sender].push(boosterId);
        
        numOfBoosters++;

        ownerBalance += msg.value * OWNER_PERCENTAGE / 100;

        BoosterBought(msg.sender, boosterId);
    }

    /// @notice reveal booster you just bought, if you don't reveal it in first 100 blocks since buying, anyone can reveal it before 255 blocks pass
    /// @param _boosterId id of booster that is bought
    function revealBooster(uint _boosterId) public {
        require(blockNumbers[_boosterId] > block.number - 255);
        require(boosterOwners[_boosterId] == msg.sender || blockNumbers[_boosterId] < block.number - 100);

        uint numOfCardTypes = metadataContract.getNumberOfCards();

        assert(numOfCardTypes >= numberOfCardsInBooster);

        boosterOwners[_boosterId] = 0x0;

        _removeBooster(msg.sender, _boosterId);

        // hash(random hash), n(size of array we need), maxNum(max number that can be in array)
        uint blockhashNum = uint(block.blockhash(blockNumbers[_boosterId]));
        uint[] memory randomNumbers = _random(blockhashNum, numberOfCardsInBooster);
        
        uint[] memory cardIds = new uint[](randomNumbers.length);
        for (uint i=0; i<randomNumbers.length; i++) {
            cardIds[i] = decenterCards.createCard(msg.sender, randomNumbers[i]);
        }
        
        boosters[_boosterId] = cardIds;

        msg.sender.transfer(BOOSTER_PRICE * 15 / 100);
        
        BoosterRevealed(_boosterId);
    }

    /// @notice return unrevealed boosters for user 
    /// @return array of boosterIds
    function getMyBoosters() public view returns(uint[]) {
        return unrevealedBoosters[msg.sender];
    }
    
    /// @notice return cardIds from boosters
    /// @param _boosterId id of booster
    /// @return array of cardIds
    function getCardFromBooster(uint _boosterId) public view returns(uint[]) {
        return boosters[_boosterId];
    }
    

    /// @notice adds metadata address to contract only if it doesn't exist
    /// @param _metadataContract address of metadata contract
    function addMetadataContract(address _metadataContract) public onlyOwner {
        require(address(metadataContract) == 0x0);

        metadataContract = CardMetadata(_metadataContract);
    }

    /// @notice withdraw method for owner to pull ether
    /// @param _amount amount to be withdrawn
    function withdraw(uint _amount) public onlyOwner {
        owner.transfer(_amount);   
    }

    function _removeBooster(address _user, uint _boosterId) private {
        uint boostersLength = unrevealedBoosters[_user].length; 

        for (uint i=0; i<boostersLength; i++) {
            if (unrevealedBoosters[_user][i] == _boosterId) {
                uint booster = unrevealedBoosters[_user][boostersLength-1];
                unrevealedBoosters[_user][boostersLength-1] = unrevealedBoosters[_user][i];
                unrevealedBoosters[_user][i] = booster; 

                delete unrevealedBoosters[_user][boostersLength-1];
                unrevealedBoosters[_user].length--;

                break;
            }
        }
    }

    function _random(uint _hash, uint _n) private view returns (uint[]){
        uint[] memory randomNums = new uint[](_n);
        uint _maxNum = metadataContract.getMaxRandom() + 1;
        
        for (uint i=0; i<_n; i++) {
            _hash = uint(keccak256(_hash, i, numOfBoosters));
            uint rand = _hash % _maxNum;
            randomNums[i] = metadataContract.getCardFromRandom(rand);
        }
        
        return randomNums;
    }
}