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
    /// @param _metadataType type(rarity) of metadata 
    /// @param _index index of metadata in that specific type
    function createCard(address _owner, uint _metadataType, uint _index) public returns(uint) {
        require(_index < metadataContract.getNumberOfCards(_metadataType));

        uint cardId = createCard(_owner);
        
        uint power = metadataContract.properties(_metadataType, _index);
        metadata[cardId] = CardMetadata.CardProperties({
                power: power
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