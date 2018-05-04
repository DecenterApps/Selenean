pragma solidity ^0.4.22;

import "./CardMetadata.sol";
import "./Cards.sol";
import "./Booster.sol";
import "./Marketplace.sol";

/// @title Contract derived from Cards contract with custom implementation on Booster and Metadata
contract SeleneanCards is Cards {
    
    CardMetadata metadataContract;
    Booster boosterContract;
    Marketplace marketplaceContract;

    mapping(uint => CardMetadata.CardProperties) public metadata;

    modifier onlyBoosterContract() {
        require(msg.sender == address(boosterContract));
        _;
    }

    /// @notice create card with specific type and index 
    /// @param _owner address of new owner
    /// @param _metadataId id of metadata we are using
    function createCard(address _owner, uint _metadataId) public onlyBoosterContract returns(uint) {
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

    /// @notice get how many cards of specific type user has
    /// @param _user address of user
    /// @param _metadataId metadataId of card
    function numberOfCardsWithType(address _user, uint _metadataId) public view returns(uint _num) {
        uint len = tokensOwned[_user].length;
        for(uint i = 0; i<len; i++) {
            _num += (metadata[tokensOwned[_user][i]].id == _metadataId) ? 1 : 0;
        }
    }

    
    /// @notice adds booster address to contract only if it doesn't exist
    /// @param _boosterContract address of booster contract
    function addBoosterContract(address _boosterContract) public onlyOwner {
        // not required while on testnet
        // require(address(boosterContract) == 0x0);

        boosterContract = Booster(_boosterContract);
    }

    /// @notice adds metadata address to contract only if it doesn't exist
    /// @param _metadataContract address of metadata contract
    function addMetadataContract(address _metadataContract) public onlyOwner {
        // not required while on testnet
        // require(address(metadataContract) == 0x0);

        metadataContract = CardMetadata(_metadataContract);
    }
    
    /// @notice adds marketplace address to contract only if it doesn't already exist
    /// @param _marketplaceContract address of marketplace contract
    function addMarketplaceContract(address _marketplaceContract) public onlyOwner {
        // not required while on testnet
        // require(address(marketplaceContract) == 0x0);
        marketplaceContract = Marketplace(_marketplaceContract);
    }
    /// @notice approves Marketplace to take card ownership and transfers it (2 trsansactions)
    /// @param _cardId is id of card we are going to sell
    /// @param _price is price of card we are going to sell
    /// @param _acceptableExchange is array of card acceptable for exchange 
    function _approveAndTransfer(uint _cardId, uint _price, uint16[] _acceptableExchange) public {
        require(msg.sender == ownerOf(_cardId));
        approve(address(marketplaceContract), _cardId);
        marketplaceContract.sell(msg.sender, _cardId, _price, _acceptableExchange);
    }
    
    /// @notice function approves owner of card on marketplace
    /// @param _cardIdOnMarketplace is id of card on marketplace
    /// @param _myCardId is cardId I'm owner of
    function _approveAndExchange(uint _cardIdOnMarketplace, uint _myCardId) public {
        require(msg.sender == ownerOf(_myCardId));
        approve(address(marketplaceContract), _myCardId);
        marketplaceContract.exchangeCard(msg.sender, _cardIdOnMarketplace, _myCardId);
    }
}