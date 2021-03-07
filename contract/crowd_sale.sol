// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./erc20_token.sol";
import "./ownerd.sol";

contract CrowdSale is Ownerd {
    
    uint256 public tokensSold;
    ERC20 public token;

    uint256 public price;
    uint256 public targetFunds;
    uint256 private startTime;
    uint256 private endTime;

    event Sold(uint256 amount);
    event Bought(uint256 amount);

    constructor(
        address tokenAddress,
        uint256 _targetFunds,
        uint256 _price,
        uint256 _startTime,
        uint256 _endTime) {
        token = ERC20Token(tokenAddress);
        targetFunds = _targetFunds * (10 ** uint256(token.decimals()));
        price = _price * (10 ** uint256(token.decimals()));
        require(_startTime == 0, "startTime cannot be 0");
        require(_endTime == 0, "endTime cannot be 0");
        require(_startTime <= endTime, "startTime must be less than or equal to endTime");
        startTime = _startTime;
        endTime = _endTime;
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
         amountTobuy = amountTobuy * price;
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
    // 提现
    function withdraw() public {

    }

    function isActive() public view returns (bool){
        uint256 currentTime = block.timestamp;
        return (
            currentTime >= startTime && // 当前时间必须大于或等于开始时间
            currentTime <= endTime && // 且当前时间不能小于结束时间
            !isCompleted() // 销售计划未完成
        );
    }

    function isCompleted() public view returns (bool) {
        return (tokensSold >= targetFunds);
    }

    function setPrice(uint256 _price) public onlyOwner returns (bool) {
        price = _price;
        return true;
    }
}