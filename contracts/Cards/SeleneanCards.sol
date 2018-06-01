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

    mapping(uint => uint) _metadata;

    modifier onlyBoosterContract() {
        require(msg.sender == address(boosterContract));
        _;
    }
    modifier onlyMarketplaceContract() {
        require(msg.sender == address(marketplaceContract));
        _;
    }
    /// @notice create card with specific type and index
    /// @param _owner address of new owner
    /// @param _metadataId id of metadata we are using
    function createCard(address _owner, uint _metadataId) public onlyBoosterContract returns(uint) {
        require(_metadataId < metadataContract.getNumberOfCards());

        uint cardId = createCard(_owner);

        uint id;
//        uint rarity;
//        bytes32 ipfsHash;
//        uint8 ipfsHashFunction;
//        uint8 ipfsSize;
//        address artist;
        (id, , , , , ) = metadataContract.properties(_metadataId);

        _metadata[cardId] = id;

        return cardId;
    }

    /// @notice get how many cards of specific type user has
    /// @param _user address of user
    /// @param _metadataId metadataId of card
    function numberOfCardsWithType(address _user, uint _metadataId) public view returns(uint _num) {
        uint len = tokensOwned[_user].length;
        for(uint i = 0; i<len; i++) {
            _num += (_metadata[tokensOwned[_user][i]] == _metadataId) ? 1 : 0;
        }
    }

    function metadata(uint _cardId) public view returns (uint, uint, bytes32, uint8, uint8, address){
        return metadataContract.properties(_cardId);
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

    /// @notice approving card to be taken from specific address
    /// @param _to address that we give permission to take card
    /// @param _cardId we are willing to give
    function _approveByMarketplace(address _to, uint256 _cardId) public onlyMarketplaceContract {
        require(tokensForOwner[_cardId] != 0x0);
        if (_getApproved(_cardId) != 0x0 || _to != 0x0) {
            tokensForApproved[_cardId] = _to;
            emit Approval(msg.sender, _to, _cardId);
        }
    }

}