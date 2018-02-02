pragma solidity ^0.4.18;

import "../Utils/Ownable.sol";
import "../Utils/ERC721.sol";

/// @title Standard ERC721 token based on cards
contract Cards is Ownable, ERC721 {

    mapping (uint => address) public tokensForOwner;
    mapping (uint => address) public tokensForApproved;
    mapping (address => uint[]) public tokensOwned;
    mapping (uint => uint) public tokenPosInArr;

    string public name;
    string public symbol;
    uint public numOfCards;
 
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Mint(address indexed _to, uint256 indexed _tokenId);
    
    function Cards() public {
        name = "Card";
        symbol = "CARD";
    }

    /// @notice create card for specific owner
    /// @dev should be changed to internal in future (will be called from derived contract)
    /// @param _owner address for new cards owner
    function createCard(address _owner) public returns(uint) {
        
        uint cardId = numOfCards;
        tokensForOwner[cardId] = _owner;
        tokensOwned[_owner].push(cardId);
        tokenPosInArr[cardId] = tokensOwned[_owner].length - 1;

        numOfCards++;

        Mint(_owner, cardId);

        return cardId;
    }
    
    /// @notice transfer card to another address
    /// @param _to address to whom we send card
    /// @param _cardId id of card we have that we send to another address
    function transfer(address _to, uint256 _cardId) public {
        require(tokensForOwner[_cardId] != 0x0);
        require(tokensForOwner[_cardId] == msg.sender);
        
        tokensForApproved[_cardId] = 0x0;

        removeCard(msg.sender, _cardId);
        addCard(_to, _cardId);
        
        Approval(msg.sender, 0, _cardId);
        Transfer(msg.sender, _to, _cardId);
    }
    
    /// @notice approving card to be taken from specific address
    /// @param _to address that we give permission to take card
    /// @param _cardId we are willing to give
    function approve(address _to, uint256 _cardId) public {
        require(tokensForOwner[_cardId] != 0x0);
        require(ownerOf(_cardId) == msg.sender);
        require(_to != msg.sender);
        
        if (_getApproved(_cardId) != 0x0 || _to != 0x0) {
            tokensForApproved[_cardId] = _to;
            Approval(msg.sender, _to, _cardId);
        }
    }
    
    /// @notice takes approved card from another user and sends it to some address
    /// @param _from address who currently posses card
    /// @param _to address we will send card to
    /// @param _cardId we are taking
    function transferFrom(address _from, address _to, uint256 _cardId) public {
        require(tokensForOwner[_cardId] != 0x0);
        require(_getApproved(_cardId) == msg.sender);
        require(ownerOf(_cardId) == _from);
        require(_to != 0x0);
        
        tokensForApproved[_cardId] = 0x0;
        
        removeCard(_from, _cardId);
        addCard(_to, _cardId);
        
        Approval(_from, 0, _cardId);
        Transfer(_from, _to, _cardId);        
    }
    
    function implementsERC721() public pure returns (bool) {
        return true;
    }
    
    function totalSupply() public view returns (uint256) {
        return numOfCards;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return tokensOwned[_owner].length;
    }
    
    function ownerOf(uint256 _cardId) public view returns (address) {
        return tokensForOwner[_cardId];
    }
    
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
        return tokensOwned[_owner][_index];
    }

    function getUserCards(address _owner) public view returns (uint[]) {
        return tokensOwned[_owner];
    }

    /// @notice add card with cardId to Owner
    /// @param _owner address of new owner
    /// @param _cardId of card for new owner
    function addCard(address _owner, uint _cardId) private {
        tokensForOwner[_cardId] = _owner;
        
        tokensOwned[_owner].push(_cardId);
        
        tokenPosInArr[_cardId] = tokensOwned[_owner].length - 1;
    }
    
    /// @notice remove card from one user
    /// @param _owner address of current owner
    /// @param _cardId of card that we are removing from user
    function removeCard(address _owner, uint _cardId) private {
        uint length = tokensOwned[_owner].length;
        uint index = tokenPosInArr[_cardId];
        uint swapToken = tokensOwned[_owner][length - 1];

        tokensOwned[_owner][index] = swapToken;
        tokenPosInArr[swapToken] = index;

        delete tokensOwned[_owner][length - 1];
        tokensOwned[_owner].length--;
    }
    
    function _getApproved(uint _cardId) private view returns (address) {
        return tokensForApproved[_cardId];
    }
}