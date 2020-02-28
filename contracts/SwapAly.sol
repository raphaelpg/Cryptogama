pragma solidity 0.5.12;

import "./SafeMath.sol";
import "./TokenERC20Aly.sol";
import "./TokenERC20Dai.sol";

/// @title Cryptogama swap contract
/// @author Raphael Pinto Gregorio
/// @notice Use this contract to swap ERC-20 tokens
/// @dev The owner of this contract need to get the approval from both token owners to be able to proceed the swap
contract SwapAly{
    address private _owner;
    uint256 private _sellerAllowance;

    event TokenExchanged(address indexed from, address indexed to, uint256 amountSold, uint256 amountBought);

    constructor () public {
        _owner = msg.sender;
    }

    modifier ownerOnly() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    function transferOwnership(address newOwner) external ownerOnly {
        require(msg.sender != address(0));
        _owner = newOwner;
    }

    /// @author Raphael Pinto Gregorio
    /// @notice return contract owner
    /// @dev basic function
    /// @return contract owner address
    function getOwner() external view returns(address){
        return _owner;
    }

    /// @author Raphael Pinto Gregorio
    /// @notice perform tokens swap between two owners 
    /// @dev swap tokens, owner of swap contract need the approval of both token owners, emit an event called TokenExchanged
    /// @param sellerAddress the address of the seller, sellerTokenAddress the address of the seller ERC-20, amountSeller the amount the seller wants to exchange, buyerAddress the buyer address, buyerTokenAddress the adress of the buyer ERC-20, amountBuyer the amount to be exchanged
    /// @return an event TokenExchanged containing the seller address, the buyer address, the amount sold and the amount bought in this order
    function swapToken(address sellerAddress, address sellerTokenAddress, uint256 amountSeller,  address buyerAddress, address buyerTokenAddress, uint256 amountBuyer) external ownerOnly returns(bool){
        TokenERC20Aly TokenSell = TokenERC20Aly(sellerTokenAddress);
        TokenERC20Dai TokenBuy = TokenERC20Dai(buyerTokenAddress);

        TokenSell.transfer(buyerAddress, amountSeller);
        TokenBuy.transfer(sellerAddress, amountBuyer);

        emit TokenExchanged(sellerAddress, buyerAddress, amountSeller, amountBuyer);
    }
}