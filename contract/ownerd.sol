// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ownerd {
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,
         "Only owner can call this.");
         _;
    }
    
    function transferOwnership(address addr) public onlyOwner {
        require(addr != address(0),
        "Cannot transfer to all zero address.");
        owner = addr;
    }

}