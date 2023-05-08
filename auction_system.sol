pragma solidity ^0.8.0;

contract Auction {
    address public owner;
    uint256 public startBlock;
    uint256 public endBlock;
    string public item;
    uint256 public highestBid;
    address public highestBidder;
    bool public ended;
    
    event NewHighestBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);
    
    constructor(uint256 _startBlock, uint256 _endBlock, string memory _item) {
        owner = msg.sender;
        startBlock = _startBlock;
        endBlock = _endBlock;
        item = _item;
    }
    
    function placeBid() public payable {
        require(block.number >= startBlock && block.number <= endBlock);
        require(msg.value > highestBid);
        
        if (highestBidder != address(0)) {
            highestBidder.transfer(highestBid);
        }
        
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit NewHighestBid(msg.sender, msg.value);
    }
    
    function endAuction() public {
        require(msg.sender == owner);
        require(block.number > endBlock);
        require(!ended);
        
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        
        owner.transfer(highestBid);
    }
}
