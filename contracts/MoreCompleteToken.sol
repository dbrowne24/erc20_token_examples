/*
* Example 2
* This is a more complete version of the minimum viable token created in example 1
* This is by no means a complete token. But it has more functionality than the first token
*/

pragma solidity ^0.4.24;

interface tokenRecipient {
  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
}

contract MoreCompleteToken {
  string public name;
  string public symbol;
  uint8 public decimals = 18;
  uint256 public totalSupply;
  // an array of balances
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;
  // this generates a public event on the blockchain that will notify clients of a transfer
  event Transfer(address indexed from, address indexed to, uint256 value);
  // notify clients of a token burn (deleting tokens from the totalSupply)
  event Burn(address indexed from, uint256 value);


  constructor MoreCompleteToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
    // update the total supply with the decimal amount
    totalSupply = initialSupply * 10 ** uint256(decimals);
    // give the creator of the contract the initialSupply
    balanceOf[msg.sender] = totalSupply;
    name = tokenName;
    symbol = tokenSymbol;
  }

  /*
  * Internal transfer can only be called by this contract
  */

  function _transfer(address _from, address _to, uint _value) internal {
    // prevent transfer to 0x0 address. Use burn() instead
    require(_to != 0x0);
    // check that the sender has enough
    require(balanceOf[_from] >= _value);
    // check for overflows
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    // save this for an assertion in the future
    uint previousBalances = balanceOf[_from] + balanceOf[_to];
    // subtract from the sender
    balanceOf[_from] -= _value;
    // add the same to the recipient
    balanceOf[_to] += _value;
    emit Transfer(_from, _to, _value);
    // assertions are used to find bugs in your code. They should never fail!
    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
  }

  /*
  * Transfer tokens
  *
  * Send '_value' tokens to '_to' from your account
  *
  * @param _to The address of the recipient
  * @param _value The amount to send
  */

  function transfer(address _to, uint256 _value) public {
    _transfer(msg.sender, _to, _value);
  }

  /*
  * Transfer tokens from other address
  * Send '_value' on behalf of '_from' to '_to'
  *
  * @param _from The address of the sender
  * @param _to The address of the recipient
  * @param _value The amount to spend
  *
  */

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    // check the allowance
    require(_value <= allowance[_from][msg.sender]);
    allowance[_from][msg.sender] -= _value;
    _transfer(_from, _to, _value);
    return true;
  }

  /*
  * Set allowance for other address
  * Allows '_spender' to spend no more than '_value' tokens
  *
  * @param _spender The address authorised to spend
  * @param _value The max amount that they can spend
  *
  */

  function approve(address _spender, uint256 _value) public returns(bool success) {
      allowance[msg.sender][_spender] = _value;
      return true;
  }

  /*
  * Set allowance for other address and notify
  *
  * Allows '_spender' to spend no more than '_value' tokens and then ping the contract about it
  *
  * @param _spender The address authorised to spend
  * @param _value max amount they can spend
  * @param _extraData Some extra information to send to the approved contract
  *
  */

  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
    tokenRecipient spender = tokenRecipient(_spender);
    if(approve(_spender, _value)) {
      spender.receiveApproval(msg.sender, _value, this, _extraData);
      return true;
    }
  }


  /**
  * Destroy Tokens
  *
  * Remove '_value' tokens from the system irreverseibly
  *
  * @param _value The amount of tokens to burn
  *
  */

  function burn(uint256 _value) public returns(bool success) {
    require(balanceOf[msg.sender] >= _value);
    balanceOf[msg.sender] -= _value;
    totalSupply -= _value;
    emit Burn(msg.sender, _value);
    return true;
  }

  /*
  * Destroy tokens from another account
  *
  * Remove '_value' tokens from the system irreverseibly on behalf of '_from'
  *
  * @param _from The address of the sender
  * @param _value The amount of money to burn
  *
  */

  function burnFrom(address _from, uint256 _value) public returns(bool success) {
    require(balanceOf[_from] >= value);
    require(_value <= allowance[_from][msg.sender]);
    balanceOf[_from] -= _value;
    allowance[_from][msg.sender] -= _value;
    totalSupply -= _value;
    emit Burn(_from, _value);
    return true;
  }

}
