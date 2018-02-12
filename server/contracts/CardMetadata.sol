pragma solidity ^0.4.18;

/// @title Contract holding all metadata about token(card)
contract CardMetadata {

    uint numberOfRarityTypes = 4;

    struct CardProperties {
        uint power;
    }

    /// @notice this number must be same as numberOfRarityTypes
    CardProperties[][4] public properties;

    /// @notice method to add metadata types
    /// @param _power strength of card
    /// @param _type type(rarity) of card
    function addCardMetadata(uint _power, uint _type) public {
        require(_type < numberOfRarityTypes);

        properties[_type].push(CardProperties({
                    power: _power
                }));
    }

    /// @notice returns how many cards there are in specific type
    /// @param _type type of cards we are looking for
    function getNumberOfCards(uint _type) view public returns (uint) {
        return properties[_type].length;
    }
}