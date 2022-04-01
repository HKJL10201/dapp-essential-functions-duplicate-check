pragma solidity ^0.4.17;

contract Auction {
    struct Item {
        uint256 itemId; // id of the item
        uint256[4] itemTokens; //tokens bid in favor of the item
    }

    struct Person {
        uint256 remainingTokens; // tokens remaining with bidder
        uint256 personId; // it serves as tokenId as well
        address addr; //address of the bidder
    }

    mapping(address => Person) tokenDetails; //address to person
    Person[4] bidders; //Array containing 4 person objects

    Item items; //item object
    address public winners; //address of winner
    Person public beneficiary; //owner of the smart contract

    uint256 public auctionClose;
    uint256 topBid;
    address topBidders;
    mapping(address => uint256) returnsPending; // # tokens pending to be returned to each person
    uint256 bidderCount = 0; //counter

    bool auctionComplete;
    bool winnersDeclared;

    modifier onlyowner(address _adr) {
        require(_adr == beneficiary.addr);
        _;
    }

    modifier onlybidders(address _addr) {
        require(_addr != beneficiary.addr);
        _;
    }

    //functions
    function Auction(uint256 _biddingTime) public payable {
        //constructor

        //Part 1 Task 1. Initialize beneficiary with address of smart contracts owner
        beneficiary.addr = msg.sender;
        auctionClose = now + _biddingTime;
        //Hint. In the constructor,"msg.sender" is the address of the owner.

        uint256[4] memory emptyArray;
        items = Item({itemId: 0, itemTokens: emptyArray});
        //** End code here**/
    }

    function register() public payable onlybidders(msg.sender) {
        require(now <= auctionClose);
        uint256 newRegister = 0;
        for (uint256 b = 0; b < bidderCount; b++) {
            if (bidders[b].addr == msg.sender) newRegister++;
        }

        require(newRegister == 0);
        bidders[bidderCount].personId = bidderCount;
        bidders[bidderCount].addr = msg.sender;

        //Part 1 Task 3. Initialize the address of the bidder
        /*Hint. Here the bidders[bidderCount].addr should be initialized with address of the registrant.*/
        bidders[bidderCount].remainingTokens = 5; // only 5 tokens
        tokenDetails[msg.sender] = bidders[bidderCount];
        bidderCount++;
    }

    function bid(uint256 _count) public payable {
        require(now <= auctionClose);
        /*
        Two conditions below:
        1. If the number of tokens remaining with the bidder is <
            count of tokens bid, revert
        2. If there are no tokens remaining with the bidder,
            revert.
        Hint: "tokenDetails[msg.sender].remainingTokens" gives the
        details of the number of tokens remaining with the bidder.
        */

        if (
            tokenDetails[msg.sender].remainingTokens < _count ||
            tokenDetails[msg.sender].remainingTokens == 0
        ) revert();
        if (_count != 0) returnsPending[msg.sender] += _count;

        /*Part 1 Task 5. Decrement the remainingTokens by the number of tokens bid
        Hint. "tokenDetails[msg.sender].remainingTokens" should be decremented by "_count". */

        tokenDetails[msg.sender].remainingTokens -= _count;
        bidders[tokenDetails[msg.sender].personId]
            .remainingTokens = tokenDetails[msg.sender].remainingTokens; //updating the same balance in bidders map.

        items.itemTokens[tokenDetails[msg.sender].personId] = _count;
    }

    function max(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? a : b;
    }

    function revealWinners() private returns (bool) {
        topBid = items.itemTokens[0];
        topBidders = bidders[0].addr;
        for (uint256 i = 1; i < bidderCount; i++) {
            topBid = max(topBid, items.itemTokens[i]);
            if (topBid == items.itemTokens[i]) topBidders = bidders[i].addr;
        }

        winners = topBidders;
        for (uint256 t = 0; t < bidderCount; t++) {
            if (bidders[t].addr != winners) {
                bidders[t].remainingTokens += returnsPending[bidders[t].addr];
                tokenDetails[bidders[t].addr].remainingTokens = bidders[t]
                    .remainingTokens;
            }
        }
        return true;
    }

    function withdraw() public onlybidders(msg.sender) returns (bool) {
        require(now <= auctionClose);
        uint256 bidAmount = returnsPending[msg.sender];
        if (bidAmount > 0) {
            returnsPending[msg.sender] = 0;
            items.itemTokens[tokenDetails[msg.sender].personId] -= bidAmount;
            tokenDetails[msg.sender].remainingTokens += bidAmount;
            bidders[tokenDetails[msg.sender].personId]
                .remainingTokens = tokenDetails[msg.sender].remainingTokens;
        }
        return true;
    }

    function auctionClose() public onlyowner(msg.sender) {
        //Have to be called by beneficiary after auction time is completed

        //1. conditions
        require(now >= auctionClose); //auction did not end yet
        require(!auctionComplete); //function shouldn't already been called

        //2. Effects
        auctionComplete = true;
        winnersDeclared = revealWinners();

        //3. Interactions
        if (winnersDeclared) beneficiary.remainingTokens = topBid;
    }

    function getPersonDetails(uint256 id)
        public
        constant
        returns (
            uint256,
            uint256,
            address
        )
    {
        return (
            bidders[id].remainingTokens,
            bidders[id].personId,
            bidders[id].addr
        );
    }
}
