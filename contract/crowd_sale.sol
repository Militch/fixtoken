// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./erc20_token.sol";
import "./ownerd.sol";

contract CrowdSale is Ownerd {
    using SafeMath for uint256;
    // 总销量
    uint256 public fundsSoldTotal = 0;
    // 总募集
    uint256 public fundsRaisedTotal = 0;
    // 代币引用
    ERC20 public token;
    // 价格
    uint256 public price = 0;
    // 目标众筹数量
    uint256 public targetFunds = 0;
    // 开始时间
    uint256 public startTime;
    // 结束时间
    uint256 public endTime;

    // 已销售记录
    mapping(address => uint256) private _raises;
    mapping(address => uint256) private _sold;

    // 购买事件
    event Bought(
        address indexed owner,
        uint256 amount,
        uint256 raise
    );

    // 提现事件
    event Withdrawn(
        address indexed from,
        uint256 raise
    );
    // 退款事件
    event Refunded(
        address indexed from,
        uint256 amount,
        uint256 raise
    );

    constructor(
        address tokenAddress,
        uint256 _targetFunds,
        uint256 _price,
        uint256 _startTime,
        uint256 _endTime) {
        token = ERC20Token(tokenAddress);
        targetFunds = _targetFunds * (10 ** uint256(token.decimals()));
        price =  _price;
        require(_startTime > 0, "startTime must be greater than to zero");
        require(_endTime > 0, "endTime must be greater than to zero");
        require(_startTime <= _endTime, "startTime must be less than or equal to endTime");
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

    modifier whenSaleIsFinished(){
        require(isFinished(), 
        "Crowd sale is not finished");
         _;
    }

    modifier whenSaleIsUncompleted(){
        require(isUncompleted(), 
        "Crowd sale is uncompleted");
         _;
    }

    function isActive() public view returns (bool){
        uint256 currentTime = block.timestamp;
        return (
            currentTime >= startTime && // 当前时间必须大于或等于开始时间
            currentTime <= endTime && // 且当前时间不能小于结束时间
            !isSalesCompleted() // 销售计划未完成
        );
    }

    function isFinished() public view returns (bool){
        uint256 currentTime = block.timestamp;
        return (
            currentTime > endTime && // 且当前时间必须大于结束时间
            isSalesCompleted() // 销售计划必须已完成
        );
    }

    function isUncompleted() public view returns (bool){
        uint256 currentTime = block.timestamp;
        return (
            currentTime > endTime && // 且当前时间必须大于结束时间
            !isSalesCompleted() // 销售计划为完成
        );
    }

    function buy() public payable whenSaleIsActive {
         uint256 amountTobuy = msg.value;
         uint256 tokenDecimal = token.decimals();
         amountTobuy = amountTobuy.div(price).mul(10 ** tokenDecimal);
         uint256 dexBalance = token.balanceOf(address(this));
         require(amountTobuy > 0, "You need to send some ether");
         require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
         token.transfer(msg.sender, amountTobuy);
         fundsSoldTotal = fundsSoldTotal.add(amountTobuy);
         fundsRaisedTotal = fundsRaisedTotal.add(msg.value);
         _raises[msg.sender] = _raises[msg.sender].add(msg.value);
         _sold[msg.sender] = _sold[msg.sender].add(amountTobuy);
         emit Bought(msg.sender, msg.value , amountTobuy);
    }


    // 退款
    function refund() public whenSaleIsUncompleted returns (bool) {
        uint256 raisesAmount = _raises[msg.sender];
        uint256 soldAmount = _sold[msg.sender];
        require(raisesAmount > 0, "You need to sell at least some tokens");
        payable(msg.sender).transfer(raisesAmount);
        _raises[msg.sender] = 0;
        _sold[msg.sender] = 0;
        emit Refunded(msg.sender, raisesAmount, soldAmount);
        return true;
    }
    
    // 提现
    function withdraw() public onlyOwner whenSaleIsFinished returns (bool) {
        payable(owner).transfer(fundsRaisedTotal);
        emit Withdrawn(owner, fundsRaisedTotal);
        return true;
    }

    
    function isSalesCompleted() public view returns (bool) {
        return (fundsSoldTotal >= targetFunds);
    }

    function setStartTime(uint256 _time)  public onlyOwner returns (bool) {
        startTime = _time;
        return true;
    }
    function setEndTime(uint256 _time)  public onlyOwner returns (bool) {
        endTime = _time;
        return true;
    }

    function setPrice(uint256 _price) public onlyOwner returns (bool) {
        price = _price;
        return true;
    }
}