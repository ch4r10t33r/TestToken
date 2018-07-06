pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract TestToken {
    using SafeMath for uint;
    uint public totalSupply;
    string public symbol;
    uint public decimals;
    uint totalSold;
    uint tokenPrice = 0.0005 ether;

    mapping(address => uint) balances;

    constructor(string _symbol, uint8 _decimals, uint _totalSupply) public {
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        totalSold = 0;
    }

    function() payable external {
      require(totalSold <= totalSupply);
      require(msg.value >= tokenPrice);

      uint tokens = msg.value.div(tokenPrice);
      totalSold = totalSold.add(tokens);
      tokens = tokens.mul(1 * 10**decimals);
      balances[msg.sender] = balances[msg.sender].add(tokens);

      require(totalSold <= totalSupply);

      //fire the event notifying the transfer of tokens
      emit Transfer(0, msg.sender, tokens);

    }

    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }
    event Transfer(address indexed from, address indexed to, uint256 value);
}