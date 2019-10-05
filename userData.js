async function checkFirstTimeLogin(userAddress){
    let contractInstance = new web3.eth.Contract(userDataABI, userDataAddress)
    let isFirstTimeLogin = await contractInstance.methods.checkFirstTimeLogin(userAddress).call()
    if(isFirstTimeLogin == false){
        return true //frstLogin
    }else{
        return false
    }   
}

