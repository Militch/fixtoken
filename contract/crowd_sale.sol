// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./erc20_token.sol";
import "./ownerd.sol";

contract CrowdSale is Ownerd {
    
    uint256 public tokensSold;
    ERC20 public token;

    uint256 public price;
    
    bool private _active = false;
    event Sold(uint256 amount);
    event Bought(uint256 amount);

    constructor(address tokenAddress) {
        token = ERC20Token(tokenAddress);
    }

    receive() external payable {
        buy();
    }
    fallback() external {}

    function totalAmount() public view returns (uint256) {
        return token.balanceOf(address(this));
    }


    modifier whenSaleIsActive(){
        require(isActive(),
         "Crowd sale is not active");
         _;
    }

    function buy() public payable whenSaleIsActive {
         uint256 amountTobuy = msg.value;
         uint256 dexBalance = token.balanceOf(address(this));
         require(amountTobuy > 0, "You need to send some ether");
         require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
         token.transfer(msg.sender, amountTobuy);
         tokensSold += amountTobuy;
         emit Bought(amountTobuy);
    }

     function sell(uint256 amount) public  {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
        emit Sold(amount);
    }
    
    function isActive() public view returns (bool){
        return _active;
    }

    function setActive(bool active) public onlyOwner returns (bool) {
        _active = active;
        return true;
    }

    function setPrice(uint256 _price) public onlyOwner returns (bool) {
        price = _price;
        return true;
    }
}