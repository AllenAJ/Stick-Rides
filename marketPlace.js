async function createAuction(tokenId, startingPrice, endingPrice, NFTAddress, endingTime){
    try{
        let marketPlaceContract = new web3.eth.Contract(marketABI, marketContractAddress)
        let tx = await marketPlaceContract.methods.createAuction(tokenId, startingPrice, endingPrice, NFTAddress, endigTime)
        .send({from:userAddress[0]})
        return 'success'
    }catch(err){
        console.log(err)
        return 'error'
    }  

}
async function bid(tokenId, price, NFTAddress){
    try{
        let marketPlaceContract = new web3.eth.Contract(marketABI, marketContractAddress)
        let tx = await marketPlaceContract.methods.bid(tokenId, price, NFTAddress)
        .send({from:userAddress[0]})
        return 'success'
    }catch(err){
        console.log(err)
        return 'error'
    }  
}

async function checkAndEnd( NFTAddress, tokenId){
    try{
        let marketPlaceContract = new web3.eth.Contract(marketABI, marketContractAddress)
        let tx = await marketPlaceContract.methods.checkBidStatus(NFTAddress,tokenId)
        .send({from:userAddress[0]})
        return 'success'
    }catch(err){
        console.log(err)
        return 'error'
    }  
}

async function getData( tokenId, NFTAddress){
    try{
        let marketPlaceContract = new web3.eth.Contract(marketABI, marketContractAddress)
        let tx = await marketPlaceContract.methods.getData(NFTAddress,tokenId)
        .send({from:userAddress[0]})
        return 'success'
    }catch(err){
        console.log(err)
        return 'error'
    }  
}