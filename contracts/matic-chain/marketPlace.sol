pragma solidity 0.5.2;

contract NFTContract{
    function transferFrom(address _from, address _to, uint _tokenId)public;
}

contract ERC20Contract{
    function transferFrom(address _from, address _to, uint _price) public;
}

contract marketPlace {
    
    
    NFTContract NFT;
    ERC20Contract ERC20;
    address ERC20Address;
    
    struct AuctionData{
        uint tokenId;
        uint startingPrice;
        uint endingPrice;
        uint currentPrice;
        uint endTime;
        address currentOwner;
        address NFTAddress;
        address lastBidder;
        bool isValid;
    }
    
    mapping(address => mapping(uint => AuctionData)) auctionByTokenId;
    mapping(uint => bool) isAuctionValid;
    
    event AuctionCreated(address _NFTAddress, uint _tokenId, uint _startingPrice, uint _endTime);
    event Bid(address _NFTAddress, uint _tokenId, uint _price);
    event AuctionEnded(address _NFTAddress, uint _tokenId, address _newOwner, uint _price);
    
    constructor()public{}
    AuctionData auctionData;
    //Check whether the user has the particular ERC721 token[backend]
    function createAuction(uint _tokenId, uint _startingPrice, uint _endingPrice, address _NFTContractAddress,
    uint _endTimeInHours)public {
        
        auctionData.tokenId = _tokenId;
        auctionData.startingPrice = _startingPrice;
        auctionData.endingPrice = _endingPrice;
        auctionData.currentPrice = _startingPrice;
        auctionData.NFTAddress = _NFTContractAddress;
        auctionData.endTime = _endTimeInHours * 1 hours;
        isAuctionValid[_tokenId] = true;

        auctionByTokenId[_NFTContractAddress][_tokenId] = auctionData;
        emit AuctionCreated(_NFTContractAddress, _tokenId, _startingPrice, _endTimeInHours * 1 hours);
    }
    
    function bid(uint _tokenId, uint _price, address _NFTAddress)public {
       // AuctionData memory auctionData;
        auctionData = auctionByTokenId[_NFTAddress][_tokenId];
        require(auctionData.currentPrice < _price, "Bid is lower than the current price");
        auctionData.currentPrice = _price;
        auctionData.lastBidder = msg.sender;
        auctionByTokenId[_NFTAddress][_tokenId] = auctionData;
    }
    //id, price, lastBidder, NFTAddress, endTime, isValid
    function getData(uint _tokenId, address _NFTAddress)public view returns(uint, uint, address, address, uint, bool){
        AuctionData memory auctionData = auctionByTokenId[_NFTAddress][_tokenId];
        return (auctionData.tokenId,
            auctionData.currentPrice,
            auctionData.lastBidder,
            auctionData.NFTAddress,
            auctionData.endTime,
            auctionData.isValid
            
            );
    }
    
    function checkBidStatus(address _NFTAddress, uint _tokenId) public {
        NFT = NFTContract(_NFTAddress);
        ERC20 = ERC20Contract(ERC20Address);
        AuctionData memory auctionData = auctionByTokenId[_NFTAddress][_tokenId];
        if(auctionData.endTime < now){ // auction ended
            auctionData.isValid = false;
            auctionData.currentOwner = auctionData.lastBidder;
            auctionData.lastBidder = address(0);
            auctionByTokenId[_NFTAddress][_tokenId] = auctionData;
            NFT.transferFrom(auctionData.currentOwner, auctionData.lastBidder, auctionData.tokenId);
            ERC20.transferFrom(auctionData.lastBidder, auctionData.currentOwner, auctionData.currentPrice);
            
            emit AuctionEnded(auctionData.NFTAddress, auctionData.tokenId, auctionData.currentOwner, auctionData.currentPrice);
        }
    }
    
}
