async function checkFirstTimeLogin(userAddress){
    let contractInstance = new web3.eth.Contract(conABI, userDataAddress)
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
conABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_name",
				"type": "string"
			}
		],
		"name": "registerUser",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_balance",
				"type": "uint256"
			},
			{
				"name": "_score",
				"type": "uint256"
			}
		],
		"name": "updateUserData",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_userAddress",
				"type": "address"
			}
		],
		"name": "userRegistered",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_user",
				"type": "address"
			}
		],
		"name": "checkFirstTimeLogin",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_user",
				"type": "address"
			}
		],
		"name": "getUserData",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "login",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "testAddr",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];
//24080ff93c58688a46a6f4bef983dc05df896e0e7080ad3703a7058404db6752
async function updateData(_balance, _score){
    console.log('updateData')
    let userAddress = await window.web3.eth.getAccounts()
    let contractInstance = new web3.eth.Contract(conABI, userDataAddress)
    let balance,score,address =await contractInstance.methods.getUserData(userAddress[0]).call()
    //Number(score) += _score;
    console.log("before ajax")
    let rawTx = {
        'from': userAddress[0],
        'to': userDataAddress,
        'data': contractInstance.methods.updateUserData(0, _score).encodeABI(),
        'gasLimit': 5500000
    }
  /*   let signed = await web3.eth.signTransaction(rawTx, userAddress[0])
    web3.eth.sendSignedTransaction(signed, function(err, result){
		if(!err){
			console.log('executed successully: ', result)
		}
	}) */
	//console.log(tx)
	console.log("address",userAddress[0])
    let updateTx =  contractInstance.methods.updateUserData(0, _score).send({from:userAddress[0],
        // gasLimit: 100000000,
        // to: userDataAddress
    }).then(console.log)
    $.ajax('http://localhost:3000/transfer', {
        type: 'POST',  // http method
        data: { to: userAddress[0],
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

