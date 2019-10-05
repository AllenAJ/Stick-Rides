pragma solidity ^0.5.2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/maticnetwork/contracts/blob/master/contracts/child/misc/IParentToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
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

contract ChildERC721 is ChildToken, LibTokenTransferOrder, ERC721Full {

  event Deposit(
    address indexed token,
    address indexed from,
    uint256 tokenId
  );

  event Withdraw(
    address indexed token,
    address indexed from,
    uint256 tokenId
  );

  event LogTransfer(
    address indexed token,
    address indexed from,
    address indexed to,
    uint256 tokenId
  );

  constructor (address _owner, address _token, string memory name, string memory symbol)
    public
    ERC721Full(name, symbol)
  {
    require(_token != address(0x0) && _owner != address(0x0));
    parentOwner = _owner;
    token = _token;
  }

  function setParent(address _parent) public isParentOwner {
    require(_parent != address(0x0));
    parent = _parent;
  }

  /**
   * @notice Deposit tokens
   * @param user address for deposit
   * @param tokenId tokenId to mint to user's account
   */
  function deposit(address user, uint256 tokenId) public onlyOwner {
    require(user != address(0x0));
    _mint(user, tokenId);
    emit Deposit(token, user, tokenId);
  }

  /**
   * @notice Withdraw tokens
   * @param tokenId tokenId of the token to be withdrawn
   */
  function withdraw(uint256 tokenId) public {
    require(ownerOf(tokenId) == msg.sender);
    _burn(msg.sender, tokenId);
    emit Withdraw(token, msg.sender, tokenId);
  }

  /**
   * @dev Overriding the inherited method so that it emits LogTransfer
   */
  function transferFrom(address from, address to, uint256 tokenId) public {
    if (parent != address(0x0) && !IParentToken(parent).beforeTransfer(msg.sender, to, tokenId)) {
      return;
    }
    _transferFrom(from, to, tokenId);
  }

  function transferWithSig(bytes calldata sig, uint256 tokenId, bytes32 data, uint256 expiration, address to) external returns (address) {
    require(expiration == 0 || block.number <= expiration, "Signature is expired");

    bytes32 dataHash = getTokenTransferOrderHash(
      msg.sender,
      tokenId,
      data,
      expiration
    );
    require(disabledHashes[dataHash] == false, "Sig deactivated");
    disabledHashes[dataHash] = true;

    // recover address and send tokens
    address from = ecrecovery(dataHash, sig);
    _transferFrom(from, to, tokenId);
    require(
      _checkOnERC721Received(from, to, tokenId, ""),
      "_checkOnERC721Received failed"
    );
    return from;
  }

  function _transferFrom(address from, address to, uint256 tokenId) internal {
    super._transferFrom(from, to, tokenId);
    emit LogTransfer(
      token,
      from,
      to,
      tokenId
    );
  }
}
