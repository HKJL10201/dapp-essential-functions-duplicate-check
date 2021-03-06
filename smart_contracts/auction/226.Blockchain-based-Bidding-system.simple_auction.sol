pragma solidity ^0.4.0;

contract SimpleAuction {
  // Parameters of the auction. Times are either
  // absolute unix timestamps (seconds since 1970-01-01)
  // or time periods in seconds.
  address public beneficiary;
  uint public auctionStart;
  uint public biddingTime;

  // Current state of the auction.
  address public highestBidder;
  uint public highestBid;

  // Allowed withdrawals of previous bids
  mapping(address => uint) pendingReturns;

  // Set to true at the end, disallows any change
  bool ended;

  // Events that will be fired on changes.
  event HighestBidIncreased(address bidder, uint amount);
  event AuctionEnded(address winner, uint amount);

  // The following is a so-called natspec comment,
  // recognizable by the three slashes.
  // It will be shown when the user is asked to
  // confirm a transaction.

  /// Create a simple auction with `_biddingTime`
  /// seconds bidding time on behalf of the
  /// beneficiary address `_beneficiary`.
  function SimpleAuction(
      uint  _biddingTime,
      address _beneficiary
  ) {
    beneficiary = _beneficiary;
    auctionStart = now;
    biddingTime = _biddingTime;
  }

  /// Bid on the auction with the value sent
  /// together with this transaction.
  /// The value will only be refunded if the
  /// auction is not won.
  function bid() payable {
    // No arguments are necessary, all
    // information is already part of
    // the transaction. The keyword payable
    // is required for the function to
    // be able to receive Ether.
    if (now > auctionStart + biddingTime) {
      // Revert the call if the bidding
      // period is over.
      throw;
    }
    if (msg.value <= highestBid) {
      // If the bid is not higher, send the
      // money back.
      throw;
    }
    if (highestBidder != 0) {
      // Sending back the money by simply using
      // highestBidder.send(highestBid) is a security risk
      // because it can be prevented by the caller by e.g.
      // raising the call stack to 1023. It is always safer
      // to let the recipient withdraw their money themselves.
      pendingReturns[highestBidder] += highestBid;
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
    HighestBidIncreased(msg.sender, msg.value);
  }

  /// Withdraw the bid that was topped by a higher bidder
  function withdraw() returns (bool) {
    var amount = pendingReturns[msg.sender];
    if (amount > 0) {
      // It is important to set this to zero because the recipient
      // can call this function again as part of the receiving call
      // before `send` returns.
      pendingReturns[msg.sender] = 0;

      if (!msg.sender.send(amount)) {
        // No need to call throw here, just reset the amount owing
        pendingReturns[msg.sender] = amount;
        return false;
      }
    }
    return true;
  }

  /// End the auction and send the highest bid
  /// to the beneficiary.
  function auctionEnd() {
    

    // 1. Conditions
    if (now <= auctionStart + biddingTime)
      throw; // auction did not end yet
    if (ended)
      throw; // this function has already been called

    // 2. Effects
    ended = true;
    AuctionEnded(highestBidder, highestBid);

    // 3. Interaction
    if (!beneficiary.send(highestBid))
      throw;
  }
}
