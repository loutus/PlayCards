// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "./game.sol";

contract Generator{

    Game public buyer;
    
    constructor(uint256 set_x, uint256 set_y) {
        buyer = new Game(set_x, set_y);
    }

    function resetBuyerContract(uint256 set_x, uint256 set_y) public{
        buyer = new Game(set_x, set_y);
    }
    
    
    function _signIn(string memory _username) public{
        buyer.signIn(_username);
    }
    
    function _buyCards(uint256 _numberOfCards) public {
        buyer.buyCards(_numberOfCards);
    }
    
    function _remaining() public view returns(uint256) {
        return buyer.cardsRemaining();
    }
}