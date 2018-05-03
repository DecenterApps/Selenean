pragma solidity ^0.4.22;

import "../Utils/Ownable.sol";
import "./SeleneanCards.sol";

///Marketplace contract
contract Marketplace is Ownable{
    
    ///Struct that keeps info about one card on marketplace
    struct Ad {
        uint cardId;
        uint price;
        uint16[] acceptableExchange;
        address exchanger;
        uint timestamp;
        bool exists;
    }


    modifier onlySeleneanCards() {
        require(msg.sender == address(seleneanCards));
        _;
    }

    ///Number of active ads
    uint public numOfAds;

    ///Array that keeps cards on sale
    uint[] public cardsOnSale;

    event SellAd(address owner, uint cardId, uint16[] acceptableExchange, uint price);
    event Bought(uint cardId, address buyer, uint price);
    event Canceled(address owner, uint cardId);

    ///Mapping cardId -> card position in cardsOnSale array
    mapping(uint => uint) public positionOfCard;
    
    ///Mapping for cardId->Ad
    mapping(uint => Ad) public sellAds;
    
    SeleneanCards public seleneanCards;

    constructor(address _seleneanCards) public{
        seleneanCards = SeleneanCards(_seleneanCards);
        numOfAds = 0;
    }

    /// @notice Function to add card on marketplace
    /// @param _cardId is id of card
    /// @param _price is price for which we are going to sell card
    /// @param _acceptableExchange is array of cards where every card we'd accept in exchange for ours
    function sell(address _owner, uint _cardId, uint _price, uint16[] _acceptableExchange) public{
        require(msg.sender == address(seleneanCards));
        require(sellAds[_cardId].exists == false);
        
        sellAds[_cardId] = Ad({
            cardId : _cardId,
            price : _price,
            acceptableExchange : _acceptableExchange,
            exchanger : _owner,
            timestamp : block.timestamp,
            exists : true
        });
        
        numOfAds++;
        cardsOnSale.push(_cardId);
        positionOfCard[_cardId] = cardsOnSale.length - 1;
        seleneanCards.transferFrom(_owner,this,_cardId);
        //SellAd(msg.sender, _cardId, _acceptableExchange, _amount);
    }

    


    /// @notice Function to buy card from Marketplace with Ether
    /// @param _cardId is id of card we want to buy
    function buyWithEther(uint _cardId) public payable {
        require(sellAds[_cardId].exists == true);
        require(msg.value >= sellAds[_cardId].price);
        sellAds[_cardId].exists = false;
        numOfAds--;
        removeOrder(_cardId);
        seleneanCards.transfer(msg.sender, _cardId);
        sellAds[_cardId].exchanger.transfer(sellAds[_cardId].price);
    }

    /// @notice Function to exchange card from Marketplace with one we own
    /// @param _cardIdOnMarketplace is id of card on Marketplace
    /// @param _buyerCardId is id of card we'd like to give in exchange
    function exchangeCard(address _owner, uint _cardIdOnMarketplace, uint _buyerCardId) public onlySeleneanCards {
        require(sellAds[_cardIdOnMarketplace].exists == true);
        require(canCardsBeExchanged(_cardIdOnMarketplace, _buyerCardId) == true);
        sellAds[_cardIdOnMarketplace].exists = false;
        numOfAds--;
        removeOrder(_cardIdOnMarketplace);

        //transfer methods
        seleneanCards.transfer(_owner, _cardIdOnMarketplace);
        seleneanCards.transferFrom(_owner,sellAds[_cardIdOnMarketplace].exchanger, _buyerCardId);
    }


    /// @notice Function to cancel ad on marketplace
    /// @param _cardId is id of card you've posted and want to remove from Marketplace
    function cancel(uint _cardId) public {
        require(sellAds[_cardId].exists == true);
        require(sellAds[_cardId].exchanger == msg.sender);

        sellAds[_cardId].exists = false;
        numOfAds--;

        removeOrder(_cardId);
        seleneanCards.transfer(msg.sender,_cardId);
        
    }

    function getCardsOnSale() public view returns (uint[]){
        return cardsOnSale;
    }
    

    /// @notice Removes card from cardsOnSale list
    /// @param _cardId is id of card we want to remove
    function removeOrder(uint _cardId) internal {
        uint length = cardsOnSale.length;
        uint index = positionOfCard[_cardId];
        uint lastOne = cardsOnSale[length-1];

        cardsOnSale[index] = lastOne;
        positionOfCard[lastOne] = index;

        delete cardsOnSale[length-1];
        cardsOnSale.length--;
    }

    
    /// @notice Function to check if two cards can be exchanged
    /// @param _cardId1 is id of card on marketplace
    /// @param _cardId2 is id of card we would like to give in exchange for card on Marketplace
    function canCardsBeExchanged(uint _cardId1,uint _cardId2) public view returns (bool){
        uint metadataId = getCardMetadata(_cardId2);
        for(uint i=0; i<sellAds[_cardId1].acceptableExchange.length; i++){
            if(sellAds[_cardId1].acceptableExchange[i] == metadataId){
                return true;
            }
        }
        return false;
    }
    /// @notice Function returns metadataId for card
    /// @param _cardId is card which metadataId we'd like to get
    function getCardMetadata(uint _cardId) public view returns (uint){
        uint metadataId;
        (metadataId,,,,,) = seleneanCards.metadata(_cardId);
        return metadataId;
    }

}
