pragma solidity ^ 0.4 .18;

import "./SeleneanCards.sol";
import "./CardMetadata.sol";
import "./Ownable.sol";

contract BoosterTest is Ownable {

    SeleneanCards public seleneanCards;
    CardMetadata public metadataContract;


    uint public BOOSTER_PRICE = 10 ** 15; // 0.001 ether
    uint public OWNER_PERCENTAGE = 75;
    uint public CARD_ARTIST_PERCENTAGE = 5;
    uint public numberOfCardsInBooster = 5;

    mapping(address => uint) public withdrawBalance;
    mapping(uint => uint[]) public boosters;
    mapping(address => uint[]) public gameCards;
    mapping(address => uint[]) gameRarities;

    uint public numOfBoosters;
    uint hash;

    event BoosterBought(address user, uint boosterId);

    function BoosterTest(address _cardAddress) public {
        seleneanCards = SeleneanCards(_cardAddress);
        hash = uint(block.blockhash(block.number - 1));
    }

    /// @dev think is it ok to buy cards to contract (not sure why not)
    function buyBoosterTo(address _user) public payable returns(bool) {
        require(msg.value > BOOSTER_PRICE);
        require(gameCards[msg.sender].length > 20);

        uint boosterId = numOfBoosters;
        numOfBoosters++;

        uint numOfCardTypes = gameCards[msg.sender].length;

        assert(numOfCardTypes >= numberOfCardsInBooster);

        uint blockhashNum = uint(block.blockhash(block.number - 1));
        // hash(random hash), n(size of array we need)
        uint[] memory metadataIds = _random(blockhashNum, numberOfCardsInBooster);
        uint[] memory cardIds = new uint[](metadataIds.length);

        for (uint i = 0; i < metadataIds.length; i++) {
            cardIds[i] = seleneanCards.createCard(_user, metadataIds[i]);
            
            address artist = metadataContract.getArtist(metadataIds[i]);
            withdrawBalance[artist] += BOOSTER_PRICE * CARD_ARTIST_PERCENTAGE / 100;
        }

        boosters[boosterId] = cardIds;
        // all money from buy and reveal goes to owner (leaving reveal percentage if we decide to change process)
        withdrawBalance[owner] += BOOSTER_PRICE * OWNER_PERCENTAGE / 100 + BOOSTER_PRICE;

        BoosterBought(msg.sender, boosterId);
    }

    /// @dev cards should be sorted (its easier for us to determine if there is duplicates if they are sorted)
    /// TODO: implement check for duplicates
    function verifyCards(uint[] metadataIds) public returns(bool) {
        require(metadataIds.length > 20);

        gameCards[msg.sender] = new uint[](metadataIds.length);
        gameRarities[msg.sender] = new uint[](metadataIds.length);

        for (uint i = 0; i < metadataIds.length; i++) {
            require(metadataIds[i] < metadataContract.getNumberOfCards());

            uint rarity;
            (, rarity, , , , ) = metadataContract.properties(metadataIds[i]);

            gameCards[msg.sender][i] = metadataIds[i];
            if (i == 0) {
                gameRarities[msg.sender][i] = rarity;
            } else {
                gameRarities[msg.sender][i] = gameRarities[msg.sender][i - 1] + rarity;
            }
        }

        // we expect that average rarity in your cards is more than 650
        require(gameRarities[msg.sender][gameRarities[msg.sender].length - 1] > metadataIds.length * 700);

        return true;
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
        // not required while on testnet
        // require(address(metadataContract) == 0x0);

        metadataContract = CardMetadata(_metadataContract);
    }

    /// @notice withdraw method for anyone who owns money on contract
    function withdraw() public {
        uint balance = withdrawBalance[msg.sender];
        withdrawBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
    }

    /// @notice method that gets N random metadataIds
    /// @param _hash random hash used for random method
    /// @param _n size of array that we need
    function _random(uint _hash, uint _n) private view returns(uint[]) {
        uint[] memory metadataIds = new uint[](_n);
        uint _maxNum = gameRarities[msg.sender][gameRarities[msg.sender].length - 1] + 1;


        for (uint i = 0; i < _n; i++) {
            // balanceOf is used because you would get same cards if buyBooster called at same block
            _hash = uint(keccak256(_hash, i, numOfBoosters, seleneanCards.balanceOf(msg.sender), msg.sender));
            uint rand = _hash % _maxNum;
            metadataIds[i] = gameCards[msg.sender][_getCardByRarity(msg.sender, rand)];
        }

        return metadataIds;
    }

    function _getCardByRarity(address _game, uint _rarity) view private returns(uint) {
        require(_rarity <= gameRarities[_game][gameRarities[_game].length - 1]);

        uint right = gameRarities[_game].length - 1;
        uint left = 0;
        uint index = (right + left) / 2;

        while (left <= right) {
            index = (right + left) / 2;

            if (_rarity <= gameRarities[_game][index] && (index == 0 || _rarity > gameRarities[_game][index - 1])) {
                return index;
            }

            if (_rarity > gameRarities[_game][index] && _rarity <= gameRarities[_game][index + 1]) {
                return index + 1;
            }

            if (_rarity < gameRarities[_game][index]) {
                right = index - 1;
            } else {
                left = index;
            }
        }
    }

    function isContract(address addr) private view returns(bool) {
        uint size;
        assembly {
            size: = extcodesize(addr)
        }
        return size > 0;
    }
}