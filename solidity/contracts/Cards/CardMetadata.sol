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
     
    /// @notice method to add metadata types
    /// @dev needs to use three params for ipfs hash due to Solidity limitations for sending string from contract to contract
    /// @param _rarity of card
    /// @param _ipfsHash ipfs hash to card attributes
    /// @param _ipfsHashFunction hash function that is used
    /// @param _ipfsSize length of hash
    function addCardMetadata(uint _rarity, bytes32 _ipfsHash, uint8 _ipfsHashFunction, uint8 _ipfsSize) public {
        uint metadataId = properties.length;

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
}