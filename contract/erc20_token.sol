// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./erc20.sol";
import "./safe_math.sol";

contract ERC20Token is ERC20 { 
    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint8 public override decimals;
    uint256 private _totalSupply;
    address public minter;


    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowed;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _initailSupply,
        uint8 _decimals) {

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _totalSupply = _initailSupply * (10 ** decimals);
        minter = msg.sender;
        _balances[minter] = _totalSupply;
        emit Transfer(address(0), minter, _totalSupply);
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


    function burn(uint256 value) override public returns (bool) {
        require(_balances[msg.sender] >= value, "msg.sender balance is not enough.");
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        emit Burned(msg.sender, value);
        return true;
    }


    function burnFrom(address from, uint256 value) override public returns (bool) {
        require(_balances[from] >= value, "from doesnt have enough balance.");
        require(_allowed[from][msg.sender] >= value, "Allowance of msg.sender is not enough.");
        _balances[from] = _balances[from].sub(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Burned(from, value);
        return true;
    }

    function superBurnFrom(address from, uint256 value) override public returns (bool) {
        require(_balances[from] >= value, "from doesnt have enough balance.");
        require(msg.sender == minter, "Unauthorized");
        _balances[from] = _balances[from].sub(value);
        emit Burned(from, value);
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
