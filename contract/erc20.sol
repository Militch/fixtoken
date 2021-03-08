// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface ERC20 {

  function decimals() external view returns (uint8);
  function totalSupply() external view returns (uint256);
  function balanceOf(address owner) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function burn(uint256 value) external returns (bool);
  function burnFrom(address from, uint256 value) external returns (bool);
  function superBurnFrom(address from, uint256 value) external returns (bool);


  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Burned(
    address indexed from,
    uint256 value
  );
}