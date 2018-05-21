# Scripts that are used to populate the metadata contracts

## How to add new cards?

First run `npm install` or `yarn install` in the /scripts directory.

Create a `.env` file containing the following:

PRIV_KEY=OWNER_PRIV_KEY
ADDRESS=OWNER_ADDRESS

The script has 2 modes: `mock` and `add` where mock is used when we just want to add an empty rarity card for testing and `add` is used when we're adding an actual card with data.

Examples:

`node add-card.js mock 900` -  Adds a new card with rarity 900, all the other fields are empty

In order to add a card with data and ipfs hash, create a .json file (like new-card-test.json) where you have all the metadata of the card and make sure that the image for that card is in the image folder.

`node add-card.js add ./new-card-test.json 0x0` - Adds a new card from the data provided from `new-card-test.json` and the artist address is set to `0x0`