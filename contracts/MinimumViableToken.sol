/*
* Example 1
* This is the minimum viable token on Ethereum.
*
*/
pragma solidity ^0.4.24;

contract MinimumViableToken {
  /* an array with all the balances */
  mapping (address => uint256) public balanceOf;


  /* Initialize the contract and send the initial supply of tokens to the creator */
  constructor MinimumViableToken(uint256 initialSupply) public {
    balanceOf[msg.sender] = initialSupply;
  }


  /* function to send coins to a different address */
  function transfer(address _to, uint256 _value) public {
    require(balanceOf[msg.sender] >= _value);
    // stop the sender sending negative coins
    require(blanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
  }
}
