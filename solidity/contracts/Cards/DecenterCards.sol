pragma solidity ^0.4.18;

import "./CardMetadata.sol";
import "./Cards.sol";
import "./Booster.sol";

/// @title Contract derived from Cards contract with custom implementation on Booster and Metadata
contract DecenterCards is Cards {
    
    CardMetadata metadataContract;
    Booster boosterContract;

    mapping(uint => CardMetadata.CardProperties) public metadata;

    modifier onlyBoosterContract() {
        require(msg.sender == address(boosterContract));
        _;
    }

    /// @notice create card with specific type and index 
    /// @dev should be onlyBooster after we finish boosterContract
    /// @param _owner address of new owner
    /// @param _metadataId id of metadata we are using
    function createCard(address _owner, uint _metadataId) public returns(uint) {
        require(_metadataId < metadataContract.getNumberOfCards());

        uint cardId = createCard(_owner);
        
        uint id;
        uint rarity;
        bytes32 ipfsHash;
        uint8 ipfsHashFunction;
        uint8 ipfsSize;
        address artist;

        (id, rarity, ipfsHash, ipfsHashFunction, ipfsSize, artist) = metadataContract.properties(_metadataId);
        
        metadata[cardId] = CardMetadata.CardProperties({
                id: id,
                rarity: rarity,
                ipfsHash: ipfsHash,
                ipfsHashFunction: ipfsHashFunction,
                ipfsSize: ipfsSize,
                artist: artist
            });

        return cardId;
    }

    /// @notice adds booster address to contract only if it doesn't exist
    /// @param _boosterContract address of booster contract
    function addBoosterContract(address _boosterContract) public onlyOwner {
        require(address(boosterContract) == 0x0);

        boosterContract = Booster(_boosterContract);
    }

    /// @notice adds metadata address to contract only if it doesn't exist
    /// @param _metadataContract address of metadata contract
    function addMetadataContract(address _metadataContract) public onlyOwner {
        require(address(metadataContract) == 0x0);

        metadataContract = CardMetadata(_metadataContract);
    }
}