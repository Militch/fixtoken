// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address _owner) external view returns (uint256);
  function transfer(address _to, uint256 _value) external returns (bool);
  function allowance(address _owner, address _spender) external view returns (uint256);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
  function approve(address _spender, uint256 _value) external returns (bool);
  
  event Approval(address indexed owner, address indexed spender, uint256 value);  
  event Transfer(address indexed from, address indexed to, uint256 value);
}