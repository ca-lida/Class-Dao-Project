// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title MyToken - Custom ERC777 Token Contract with Voting Power Delegation
/// @dev This contract is based ERC777 token standard, including delegation of voting power
contract MyToken is ERC777, Ownable {
    uint256 public constant INITIAL_VOTING_POWER = 1;
    // store the voting power of each addresses
    mapping(address => uint256) public votingPower;

    /// @dev Emitted when a delegate is assigned
    /// @param from The address delegating the voting power
    /// @param to The address receiving the delegated voting power
    event Delegate(address indexed from, address indexed to);

    /// @dev Emitted when a vote is cast
    /// @param voter The address casting the vote
    /// @param amount The amount of voting power used for the vote
    event Vote(address indexed voter, uint256 amount);

    /// @dev Emitted when a voter gets rewards from voting 
    /// @param voter The address casting the vote/receiving the rewards
    /// @param amount The amount of token rewarded
    event RewardMinted(address indexed voter, uint256 amount);

    /// @dev Constructor to initialize the token.
    /// @param initialSupply The initial supply of tokens.
    /// @param defaultOperators The default operators for the token.
    /// @param initialOwner The initial owner of the contract.
    constructor(
        uint256 initialSupply,
        address[] memory defaultOperators,
        address initialOwner // Add initialOwner parameter
    ) ERC777("MyToken", "MTK", defaultOperators) Ownable(initialOwner) {
        _mint(msg.sender, initialSupply, "", "");
        votingPower[msg.sender] = initialSupply;
    }

    /// @dev Function to delegate voting power to another address (chosen by the token holder)
    /// @param to The address to delegate the voting power to
    function delegate(address to) external {
        require(to != address(0), "Invalid delegate address");
        require(to != msg.sender, "Cannot delegate to yourself");

        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        votingPower[to] += senderPower;
        votingPower[msg.sender] = 0;

        emit Delegate(msg.sender, to);
    }

    /// @dev Function to revoke previously delegated voting power.
    function revokeDelegate() external {
        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        // The token voting power is reset to its inital value
        votingPower[msg.sender] = INITIAL_VOTING_POWER;
        emit Delegate(msg.sender, address(0));
    }

    /// @dev Function to mint rewards for voters based on their voting power
    /// @param voter The address of the voter
    function mintRewards(address voter) external onlyOwner {
        require(voter != address(0), "Invalid voter address");

        uint256 voterPower = votingPower[voter];
        require(voterPower > 0, "voter has no voting power");

        // Determine reward amount based on voting power
        uint256 rewardAmount = voterPower * 10; // Arbitrarily set to 10

        // Mint tokens as rewards
        _mint(voter, rewardAmount, "", "");

        emit RewardMinted(voter, rewardAmount);
    }
}