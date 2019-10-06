var express = require('express');
var router = express.Router();
let Web3 = require('web3')
let Tx = require('ethereumjs-tx').Transaction
let abi = require('./abi.js').abi
let contractAddress = "0x2beb52212A3736fd2DC867a46dB1cCA370daDa0d"
/* GET home page. */
router.post('/transfer', async(req, res, next)=> {
  let to = req.body.to
  let amount = req.body.amount
  console.log('/transferAPI')
  let web3 = new Web3(new Web3.providers.HttpProvider('https://testnet2.matic.network'))
  let _from = web3.utils.toChecksumAddress("0x230e570395358db6433d1440669e2cfc48552f21")
  let contractInstance = new web3.eth.Contract(abi,contractAddress)
  let data = contractInstance.methods.transfer(to,amount).encodeABI()
  let nonce = await web3.eth.getTransactionCount(_from)
  let gasPrice = await web3.eth.getGasPrice()
  let key1 = Buffer.from('d8502652691cf51b43475a9d1d066c5c6c5301a5853bf5c96ea93136675e31a6', 'hex')
  let rawTx = {
    from: _from,
    to: contractAddress,
    nonce: nonce,
    data: data,
    //gasPrice: gasPrice,
    //gasLimit: 8000000
  }

  var txx = new Tx(rawTx);
  txx.sign(key1);

  var sTx =txx.serialize();


  web3.eth.sendSignedTransaction('0x' + sTx.toString('hex'), (err, hash) => {
      if (err) { console.log(err); return; }

      // Log the tx, you can explore status manually with eth.getTransaction()
      console.log('contract creation tx: ' + hash);
  });

});


module.exports = router;
