const fs = require('fs');
const Web3 = require('web3');
var Tx = require('ethereumjs-tx').Transaction;

let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8101'));

let compileOutDir = './build';
let contractName = 'FIXTokenCrowd';

let fromAddr = '0x60d1148b3b2ab38a5937dc30244a3b4c5ec6da52';
var gasLimit = 2200000;

let contractAddr = '0xbd0665b350FF4E650bED234BB72F42140Cc1d55D';
let params = web3.eth.abi.encodeParameters(
    ['address'],
    [contractAddr]
).slice(2);

let keystorepath = 'D:\\workspace\\fixtoken\\data0\\keystore\\UTC--2021-03-05T09-35-51.816544100Z--60d1148b3b2ab38a5937dc30244a3b4c5ec6da52';

let keystorefile = fs.readFileSync(keystorepath);
let keystoreObj = JSON.parse(keystorefile.toString());
let accountDec = web3.eth.accounts.decrypt(keystoreObj,'123');
let privateKey = accountDec.privateKey;
let compiledfspathPrefix = `${compileOutDir}/${contractName}`;
let abiFilePath = `${compiledfspathPrefix}.abi`;
let binFilePath = `${compiledfspathPrefix}.bin`;
let abiFile = fs.readFileSync(abiFilePath);
let binFile = fs.readFileSync(binFilePath);

let abiString = abiFile.toString();
let abiObj = JSON.parse(abiString);
let bytestring= '0x' + binFile.toString();
bytestring += params;
web3.eth.estimateGas({
    data: bytestring 
}).then((gasval)=>{
    if (gasLimit < gasval){
        return new Error(`gasLimit: ${gasLimit} less than gas estimate: ${gasval}`);
    }
    return gasLimit;
}).then((gasval)=>{
    rawTx = {
        from: fromAddr,
        data: bytestring,
        gas: gasval
    };
    return web3.eth.accounts.signTransaction(rawTx, privateKey);
}).then(({rawTransaction})=>{
    return web3.eth.sendSignedTransaction(rawTransaction);
}).then((data)=>{
    const {
        contractAddress,
        transactionHash,
        blockHash,
        blockNumber,
    } = data;
    console.log(`blockNumber: ${blockNumber}`);
    console.log(`blockHash: ${blockHash}`);
    console.log(`transactionHash: ${transactionHash}`);
    console.log(`contractAddress: ${contractAddress}`);
    console.log('--------------------------------------');
    console.log(`abi = ${abiString};`);
    console.log(`${contractName} = eth.contract(abi).at('${contractAddress}');`);
});
