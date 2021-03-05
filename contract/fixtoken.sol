// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./erc20_basic.sol";

contract FIXToken is ERC20Basic {
    
    uint256 public tokensSold;
    event Sold(uint256 amount);
    event Bought(uint256 amount);

    function buy() public payable {
         uint256 amountTobuy = msg.value;
         tokensSold += amountTobuy;
         uint256 dexBalance = balanceOf(address(this));
         require(amountTobuy > 0, "You need to send some ether");
         require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
         transfer(msg.sender, amountTobuy);
         emit Bought(amountTobuy);
    }

     function sell(uint256 amount) public  {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        transferFrom(msg.sender, address(this), amount);
        // msg.sender.transfer(amount);
        emit Sold(amount);
    }
    
}