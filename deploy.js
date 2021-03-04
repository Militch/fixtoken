const fs = require('fs');
const Web3 = require('web3');
var Tx = require('ethereumjs-tx').Transaction;

let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8101'));

let compileOutDir = './build';
let contractName = 'FIXTokenContract';

let fromAddr = '0xd73d7696979f8ff1776f7e679826a05a415da1e1';
var gasLimit = 1000000;

let keystorepath = 'D:\\workspace\\fixtoken\\data0\\keystore\\UTC--2021-03-04T22-37-31.199253800Z--d73d7696979f8ff1776f7e679826a05a415da1e1';

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
