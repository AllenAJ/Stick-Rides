pragma solidity ^0.5.2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "https://github.com/maticnetwork/contracts/blob/master/contracts/child/misc/IParentToken.sol";
import "https://github.com/maticnetwork/contracts/blob/master/contracts/child/misc/LibTokenTransferOrder.sol";

contract ChildToken is Ownable {
  using SafeMath for uint256;

  // ERC721/ERC20 contract token address on root chain
  address public token;
  address public parent;
  address public parentOwner;

  mapping(bytes32 => bool) public disabledHashes;

  modifier isParentOwner() {
    require(msg.sender == parentOwner);
    _;
  }

  function deposit(address user, uint256 amountOrTokenId) public;
  function withdraw(uint256 amountOrTokenId) public;
  function setParent(address _parent) public;

  function ecrecovery(
    bytes32 hash,
    bytes memory sig
  ) public pure returns (address result) {
    bytes32 r;
    bytes32 s;
    uint8 v;
    if (sig.length != 65) {
      return address(0x0);
    }
    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := and(mload(add(sig, 65)), 255)
    }
    // https://github.com/ethereum/go-ethereum/issues/2053
    if (v < 27) {
      v += 27;
    }
    if (v != 27 && v != 28) {
      return address(0x0);
    }
    // get address out of hash and signature
    result = ecrecover(hash, v, r, s);
    // ecrecover returns zero on error
    require(result != address(0x0), "Error in ecrecover");
  }
}

contract ChildERC20 is ChildToken, ERC20, LibTokenTransferOrder, ERC20Detailed {

  event Deposit(
    address indexed token,
    address indexed from,
    uint256 amount,
    uint256 input1,
    uint256 output1
  );

  event Withdraw(
    address indexed token,
    address indexed from,
    uint256 amount,
    uint256 input1,
    uint256 output1
  );

  event LogTransfer(
    address indexed token,
    address indexed from,
    address indexed to,
    uint256 amount,
    uint256 input1,
    uint256 input2,
    uint256 output1,
    uint256 output2
  );

  constructor (address _owner, address _token, string memory _name, string memory _symbol, uint8 _decimals)
    public
    ERC20Detailed(_name, _symbol, _decimals) {
    require(_token != address(0x0) && _owner != address(0x0));
    parentOwner = _owner;
    token = _token;
  }

  function setParent(address _parent) public isParentOwner {
    require(_parent != address(0x0));
    parent = _parent;
  }

  /**
   * Deposit tokens
   *
   * @param user address for address
   * @param amount token balance
   */
  function deposit(address user, uint256 amount) public onlyOwner {
    // check for amount and user
    require(amount > 0 && user != address(0x0));

    // input balance
    uint256 input1 = balanceOf(user);

    // increase balance
    _mint(user, amount);

    // deposit events
    emit Deposit(token, user, amount, input1, balanceOf(user));
  }

  /**
   * Withdraw tokens
   *
   * @param amount tokens
   */
  function withdraw(uint256 amount) public {
    address user = msg.sender;
    // input balance
    uint256 input = balanceOf(user);

    // check for amount
    require(amount > 0 && input >= amount);

    // decrease balance
    _burn(user, amount);

    // withdraw event
    emit Withdraw(token, user, amount, input, balanceOf(user));
  }

  /// @dev Function that is called when a user or another contract wants to transfer funds.
  /// @param to Address of token receiver.
  /// @param value Number of tokens to transfer.
  /// @return Returns success of function call.
  function transfer(address to, uint256 value) public returns (bool) {
    if (parent != address(0x0) && !IParentToken(parent).beforeTransfer(msg.sender, to, value)) {
      return false;
    }
    _transferFrom(msg.sender, to, value);
    return true; // to be compliant with the standard ERC20.transfer function interface
  }

  function transferWithSig(bytes calldata sig, uint256 amount, bytes32 data, uint256 expiration, address to) external returns (address from) {
    require(amount > 0);
    require(expiration == 0 || block.number <= expiration, "Signature is expired");

    bytes32 dataHash = getTokenTransferOrderHash(
      msg.sender,
      amount,
      data,
      expiration
    );
    require(disabledHashes[dataHash] == false, "Sig deactivated");
    disabledHashes[dataHash] = true;

    from = ecrecovery(dataHash, sig);
    _transferFrom(from, to, amount);
  }

  /// @param from Address from where tokens are withdrawn.
  /// @param to Address to where tokens are sent.
  /// @param value Number of tokens to transfer.
  /// @return Returns success of function call.
  function _transferFrom(address from, address to, uint256 value) internal {
    uint256 input1 = balanceOf(from);
    uint256 input2 = balanceOf(to);
    _transfer(from, to, value);
    emit LogTransfer(
      token,
      from,
      to,
      value,
      input1,
      input2,
      balanceOf(from),
      balanceOf(to)
    );
  }
}
