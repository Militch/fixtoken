// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ownerd {
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    
}