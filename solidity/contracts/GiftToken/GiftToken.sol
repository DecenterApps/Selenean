pragma solidity ^0.4.18;

import "./StandardToken.sol";
import "../Utils/Ownable.sol";
import "../Cards/Booster.sol";

contract GiftToken is StandardToken, Ownable {

    event Burn(address indexed burner, uint256 value);
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    string public name = "GiftToken"; 
    string public symbol = "GFT";
    uint public decimals = 8;

    Booster public booster;

    uint ONE_GIFT_TOKEN = 100000000;

    function GiftToken(address _booster) public {
        booster = Booster(_booster);
    }

    /// @notice A owner function for minting new tokens
    /// @param _to Address which will get the tokens
    /// @param _amount Amount of tokens the address will get
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }

    /// @notice Calls the Booster contract to buy 1 booster for 1 GiftToken
    /// @dev Check if the user has a balance of at least 1 token
    function buyBoosterWithToken() public {
        require(this.balanceOf(msg.sender) >= ONE_GIFT_TOKEN);

        approve(address(booster), ONE_GIFT_TOKEN);

        booster.buyBoosterWithToken(msg.sender);

    }

    /// @notice A function a owner can call to stop minting of tokens
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }

    /// @notice Private method to destroy the tokens
    /// @param _value The amount of tokens to burn
    function burn(uint256 _value) public {
        require(_value <= balances[msg.sender]);

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        Burn(burner, _value);
    }
}