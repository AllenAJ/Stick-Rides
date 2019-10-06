async function checkFirstTimeLogin(userAddress){
    let contractInstance = new web3.eth.Contract(userDataABI, userDataAddress)
    let isFirstTimeLogin =await contractInstance.methods.checkFirstTimeLogin(userAddress).call()//.then(value=>{return value})
/*         if(response == 0){
            console.log('callback')
            return (1)
        }else{
            return (0)
        }
    }) */
    /* let isFirstTimeLogin = await web3.eth.call({
        to :userDataAddress,
        data: contractInstance.methods.checkFirstTimeLogin(userAddress).encodeABI()
    }) */
    //console.log(isFirstTimeLogin)
    if(isFirstTimeLogin == 0){
        console.log('true')
        return (1) //frstLogin
    }else{
        console.log('false')
        return (0)
    }   
}

async function updateData(_balance, _score){
    let userAddress = await window.web3.eth.getAccounts()
    let contractInstance = new web3.eth.Contract(userDataABI, userDataAddress)
    let balance,score,address =await contractInstance.methods.getUserData(userAddress[0]).call()
    score += _score;
    let updateTx = await contractInstance.methods.updateUserData(0, score).send({to:userDataAddress})
    $.ajax('http://localhost:3000/transfer', {
        type: 'POST',  // http method
        data: { to: userDataAddress[0],
        amount: _balance },  // data to submit
        success: function (data, status, xhr) {
            //$('p').append('status: ' + status + ', data: ' + data);
            console.log(status), xhr
        },
        error: function (jqXhr, textStatus, errorMessage) {
            console.log(errorMessage)
               // $('p').append('Error' + errorMessage);
        }
    });
}

