// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./erc20.sol";
import "./safe_math.sol";

contract FIXTokenContract is ERC20 { 
    using SafeMath for uint256;
    string public name = "FIXCoin";
    string public symbo = "FIX";
    uint8 public decimals = 6;
    uint256 private _initailSupply = 2000000000;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowed;

    constructor() {
        _totalSupply = _initailSupply * (10 ** decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) override public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) override public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 value) override public returns (bool) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }


    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) override public returns (bool) {
        require(to != address(0), "Cannot send to all zero address.");
        require(value <= _balances[msg.sender], "msg.sender balance is not enough.");

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint256 value) override public returns (bool) {
        require(value <= _balances[from], "from doesnt have enough balance.");
        require(value <= _allowed[from][msg.sender], "Allowance of msg.sender is not enough.");
        require(to != address(0), "Cannot send to all zero address.");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }
}
