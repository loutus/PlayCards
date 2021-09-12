// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract game{

    struct User {
        bool signIn;
        string username;
        uint256[] cards;
    }

    struct Card {
        bool selected;
        address owner;
    }

    mapping(address => User) users;
    mapping(uint256 => Card) cards;

    uint256 public cardsRemaining;
    uint256 x;
    uint256 y;

    event SignIn(address index addr, string memory username);
    event Buy(address indexed buyer, uint256 cardNumber);

    constructor (uint256 _x, uint256 _y) {
        x = _x;
        y = _y;
        cardsRemaining = x * y;
    }

    function signIn(string memory _username) public {
        User storage user = users[msg.sender];

        require(!user.signIn, "you have signed in before");
        require(bytes(_username).length > 0, "set a username");

        user.signIn = true;
        user.username = _username;
    }

    function buyCard(uint256 cardNumber) public {
        User storage user = users[msg.sender];
        Card storage card = cards[cardNumber];

        require(user.signIn, "you have not sign in yet");
        require(cardsRemaining > 0, "all cards assigned");
        require(!card.selected, "card hase been selected before");

        user.cards.push(cardNumber);
        card.selected = true;
        card.owner = msg.sender;

    }
    


    function buyCards(uint256 numberOfCards) public returns(uint256[5] memory) {
        User storage user = users[msg.sender];
        // Card storage card = cards[cardNumber];
        
        require(user.signIn, "you have not sign in yet");
        require (numberOfCards > 0 , "buy some cards !!!");
        require(numberOfCards <= cardsRemaining, "not enough cards available. set lesser number.");
        require(numberOfCards <= 5, "you can only buy 5 cards.");


        //array of cards selected
        uint256[5] memory tokenIds;

        //first card will be selected by random
        uint256 lastCard = randomCard();
        tokenIds[0] = lastCard;

        //other cards will be selected near to last card
        for(uint i=1; i < numberOfCards; i++){
            lastCard = randomSide(lastCard);
            tokenIds[i] = lastCard;
        }

        return tokenIds;
    }


    function randomCard() public returns(uint256) {
        //request for a random index from existing cards
        uint256 randIndex = (randomHash() % cardsRemaining);

        //select from remaining cards
        uint256 counter = 0;
        uint256 selectedCard = 0;
        do {
            if (! cards[selectedCard].selected){
                counter ++;
            } 
            selectedCard ++;
        } while(counter <= randIndex);
        selectedCard --;

        //make sure the card would not be selected again
        cardsRemaining --;
        cards[selectedCard].selected = true;
        

        return selectedCard;
    }


    function randomSide(uint256 cardNum) public returns(uint256) {

        uint256[4] memory sidesAvailable;

        uint256 selectedCard;

        //available sides
        uint256 index = 0;
        //right side
        if (cardNum % x != x-1 && !cards[cardNum + 1].selected) {
            sidesAvailable[index] = cardNum + 1;
            index++;
        }
        //top side
        if (cardNum >= x && !cards[cardNum - x].selected) {
            sidesAvailable[index] = cardNum - x;
            index++;
        }
        //left side
        if (cardNum % x != 0 && !cards[cardNum - 1].selected) {
            sidesAvailable[index] = cardNum - 1;
            index++;
        }
        //bottom side
        if (cardNum < x*y - x && !cards[cardNum + x].selected) {
            sidesAvailable[index] = cardNum + x;
            index++;
        }


        if (index == 0){
            selectedCard = randomCard();
        } else if (index == 1) {
            selectedCard = sidesAvailable[0];
        } else {
            //request for a random index from available sides
            uint256 randIndex = (randomHash() % index);

            selectedCard = sidesAvailable[randIndex];
        }
        
        //make sure the card would not be selected again
        cardsRemaining --;
        cards[selectedCard].selected = true;
        
        
        return selectedCard;
    }


    function randomHash() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    }











    //////////////////////user getter functions

    function getUserName() public view returns(string memory) {
        require(users[msg.sender].signIn == true, "you have not signed in yet");
        return users[msg.sender].username;
    }
    function getUserCards() public view returns(uint256[] memory) {
        require(users[msg.sender].signIn == true, "you have not signed in yet");
        return users[msg.sender].cards;
    }



    /////////////////////card getter functions
    function getCardOwner(uint256 cardNumber) public view returns(address) {
        return cards[cardNumber].owner;
    }
    function cardHasSelected(uint256 cardNumber) public view returns(bool) {
        return cards[cardNumber].selected;
    }
}