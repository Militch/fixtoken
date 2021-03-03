// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

abstract contract ERC20 {

    // 返回代币发行总数
    function totalSupply() public view returns (uint256);

    // 获取指定账户 _who 的余额
    function balanceOf(address _who) public view returns (uint256);

    // 转账指定金额 _value 至目标账户 _to
    function transfer(address _to, uint256 _value) public returns (bool);
    
    // 从 _from 地址转账指定金额 _value 至目标地址 _to
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    // 授权指定 _spender 转账的额度 _value
    function approve(address _spender, uint256 _value) public returns (bool);

    // 查询 _owner 授权给 _spender 的额度
    function allowance(address _owner, address _spender) public view returns (uint256);

    // 转账事件
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    // 授权额度事件
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}