pragma solidity ^0.4.18;

/// @title Contract holding all metadata about token(card)
contract CardMetadata {

    struct CardProperties {
        uint id;
        uint rarity;
        bytes32 ipfsHash;
        uint8 ipfsHashFunction;
        uint8 ipfsSize;
    }

    CardProperties[] public properties;  
    uint[] public rarities;
     
    /// @notice method to add metadata types
    /// @dev needs to use three params for ipfs hash due to Solidity limitations for sending string from contract to contract
    /// @param _rarity of card
    /// @param _ipfsHash ipfs hash to card attributes
    /// @param _ipfsHashFunction hash function that is used
    /// @param _ipfsSize length of hash
    function addCardMetadata(uint _rarity, bytes32 _ipfsHash, uint8 _ipfsHashFunction, uint8 _ipfsSize) public {
        uint metadataId = properties.length;
        
        if (metadataId == 0) {
            rarities.push(_rarity);
        } else {
            rarities.push(_rarity + rarities[metadataId-1]);
        } 

        properties.push(CardProperties({
                    ipfsHash: _ipfsHash,
                    ipfsHashFunction: _ipfsHashFunction,
                    ipfsSize: _ipfsSize,
                    rarity: _rarity,
                    id: metadataId
                }));
    }

    /// @notice returns how many cards there are 
    function getNumberOfCards() view public returns (uint) {
        return properties.length;
    }
    
    function getMaxRandom() view public returns (uint) {
        return rarities[rarities.length - 1];
    }
    
    function getCardFromRandom(uint _randNum) view public returns (uint) {
        require(_randNum <= rarities[rarities.length-1]);
        
        uint right = rarities.length - 1;
        uint left = 0;
        uint index = (right + left) / 2;
        
        while (left <= right) {
            index = (right + left) / 2;
            
            /// if it is between right (including) and left we found it
            if (_randNum <= rarities[index] && (_randNum > rarities[index-1] || index == 0)) {
                return index;
            }
            
            if (_randNum > rarities[index] && _randNum < rarities[index+1]) {
                return index+1;
            }
            
            if (_randNum < rarities[index]) {
                right = index - 1;
            } else {
                left = index;
            }
        }
    }
}