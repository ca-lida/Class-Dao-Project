// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC777, Ownable {
    uint256 public constant INITIAL_VOTING_POWER = 1;
    mapping(address => uint256) public votingPower;

    event Delegate(address indexed from, address indexed to);
    event Vote(address indexed voter, uint256 amount);

    constructor(
        uint256 initialSupply,
        address[] memory defaultOperators,
        address initialOwner // Add initialOwner parameter
    ) ERC777("MyToken", "MTK", defaultOperators) Ownable(initialOwner) {
        _mint(msg.sender, initialSupply, "", "");
        votingPower[msg.sender] = initialSupply;
    }

    function delegate(address to) external {
        require(to != address(0), "Invalid delegate address");
        require(to != msg.sender, "Cannot delegate to yourself");

        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        votingPower[to] += senderPower;
        votingPower[msg.sender] = 0;

        emit Delegate(msg.sender, to);
    }

    function revokeDelegate() external {
        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        votingPower[msg.sender] = INITIAL_VOTING_POWER;
        emit Delegate(msg.sender, address(0));
    }
}
