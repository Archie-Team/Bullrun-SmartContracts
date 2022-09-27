// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Transfers is ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Transaction {
        string tid;
        uint256 amount;
        string operation;
        address userAddress;
        string currency;
    }
    address public BUSD;
    address public owner;
    bool pause;
    mapping(string => Transaction) private depositTransactions;
    mapping(string => Transaction) private withdrawTransactions;

    event TransactionCreated(
        string tid,
        uint256 amount,
        bool submited,
        string message,
        string currency
    );

    constructor() {
        BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; 
        owner = 0xC03d0aF74cf3d08D92A236F0691CbAb0b8C8830d;
        pause = false;
    }

    modifier isPause() {
        require(pause == false, "the contract has been paused");
        _;
    }

    modifier findDeposit_TX(string calldata _tid) {
        require(
            depositTransactions[_tid].amount != 0,
            "Deposit transactions not found"
        );
        _;
    }

    modifier isValidDeposit_TX(string calldata _tid) {
        require(
            depositTransactions[_tid].amount == 0,
            "Deposit transaction already exists"
        );
        _;
    }

    modifier isValidWithdraw_TX(string calldata _tid) {
        require(
            withdrawTransactions[_tid].amount == 0,
            "Withdrawal transaction already exists"
        );
        _;
    }

    modifier enoughDeposit(uint256 _amount) {
        uint256 balance = IERC20(BUSD).balanceOf(msg.sender);
        uint256 amount = _amount * 10**18;
        require(
            balance >= amount && amount != 0,
            "You dont have enough balance"
        );
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner of this contract");
        _;
    }

    function deposit(string calldata _tid, uint256 _amount)
        external
        isPause
        enoughDeposit(_amount)
        isValidDeposit_TX(_tid)
        nonReentrant
    {
        SafeERC20.safeTransferFrom(
            IERC20(BUSD),
            msg.sender,
            address(this),
            _amount * 10**18
        );
        Transaction memory newTransaction = Transaction(
            _tid,
            _amount,
            "inc",
            msg.sender,
            "BUSD"
        );
        depositTransactions[_tid] = newTransaction;
        emit TransactionCreated(_tid, _amount, true, "Confirmed" , "BUSD");
    }

    function getDepositTransaction(string calldata _tid)
        external
        view
        findDeposit_TX(_tid)
        returns (Transaction memory)
    {
        return depositTransactions[_tid];
    }
    
    function withdraw(string calldata _tid, uint256 _amount , address _receiver)
        public
        isPause
        isValidWithdraw_TX(_tid)
        nonReentrant
        onlyOwner
    {
        Transaction memory newTransaction = Transaction(
            _tid,
            _amount,
            "dec",
            _receiver,
            "BUSD"
        );
        withdrawTransactions[_tid] = newTransaction;
        SafeERC20.safeTransfer(
            IERC20(BUSD),
            _receiver,
            _amount
        );
        emit TransactionCreated(_tid, _amount, true, "Confirmed" , "BUSD");
    }

    function contractBUSDs() external view returns (uint256) {
        uint256 balance = IERC20(BUSD).balanceOf(address(this));
        return balance;
    }

    function enablePause() external onlyOwner {
        pause = true;
    }

    function disablePause() external onlyOwner {
        pause = false;
    }

    function withdrawBUSD(address receiver , uint256 _amount) public onlyOwner {
        SafeERC20.safeTransfer(
            IERC20(BUSD),
            receiver,
            _amount
        );
    }
}