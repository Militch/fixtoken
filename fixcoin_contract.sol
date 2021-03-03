// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// import "./erc20.sol";
import "./safe_math.sol";

contract FIXCoinContract { // is ERC20 {
    
    using SafeMath for uint256;
    // 代币名称
    string public name = "FixCoin";

    // 代币代号
    string public symbo = "FIX";

    // 小数位数
    uint8 public decimals = 18;

    // 初始供应量
    uint256 public _initailSupply = 2000000000;

    // 总供应量
    uint256 public _totalSupply;

    // 地址映射池
    mapping (address => uint256) public balances;

    // 控制权映射池
    mapping (address => mapping(address => uint256)) internal allowed;

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

    // 构造函数
    constructor() {
        _totalSupply = _initailSupply * (10 ** decimals);
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // 代币发行总数

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // 获取指定账户 _owner 余额
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    /** 
     * Make a Transfer.
     * @dev This operation will deduct the msg.sender's balance.
     * @param _to address The address the funds go to.
     * @param _value uint256 The amount of funds.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Cannot send to all zero address.");
        require(_value <= balances[msg.sender], "msg.sender balance is not enough.");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    
    // 转账交易
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        require(_value <= balances[_from], "_from doesnt have enough balance.");
        require(_value <= allowed[_from][msg.sender], "Allowance of msg.sender is not enough.");
        require(_to != address(0), "Cannot send to all zero address.");

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }


    // 授权指定 _spender 转账的额度 _value
    function approve(address _spender, uint256 _value) public returns (bool){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // 查询 _owner 授权给 _spender 的额度
    function allowance(address _owner, address _spender) public view returns (uint256){
        return allowed[_owner][_spender];
    }
}