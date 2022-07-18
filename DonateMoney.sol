// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract DonateMoney {
    mapping (address => uint256) balances;
    event Memo(
        address indexed sender,
        string message,
        uint256 timestamp,
        string name);
    
    struct MemoData {
        address sender;
        string message;
        uint256 timestamp;
        string name;
    } 

    MemoData[] memoList;
    address payable owner;
    address payable withDrawer;

    constructor() payable {
        owner = payable (msg.sender);
        withDrawer = payable (msg.sender);
    }

    //send money function
    function sendMoney(string memory _name, string memory _message) public payable {
            require(msg.value > 0, "Send more than 0 ether");
            memoList.push(MemoData(
                msg.sender,
                _message,
                block.timestamp,
                _name
            ));

            emit Memo(
               msg.sender,
                _message,
                block.timestamp,
                _name 
            );
    }

    //allow owner to withdraw money sent 
    function withDraw() public payable {
        require(withDrawer == msg.sender, "Only owner of the smart contract can withdraw");
        withDrawer.transfer(address(this).balance);
    }

    //return all memos received 
    function getAllMemos() public view returns(MemoData[] memory memos) {
        memos = memoList;
    }

    //transfer ownership 
    function transferOwnership(address newAdd) public payable {
        require(owner == msg.sender, "Only owner has this privilege to transfer ownership");
        withDrawer = payable (newAdd);
    }
}
