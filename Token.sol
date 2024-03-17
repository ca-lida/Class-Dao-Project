// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title MyToken
/// @dev A custom ERC20 token contract with voting power delegation and banning of addresses.
contract MyToken is ERC20, Ownable {
    uint256 public constant INITIAL_VOTING_POWER = 1;
    mapping(address => uint256) public votingPower;
    mapping(address => bool) public bannedAddresses;

    event Delegate(address indexed from, address indexed to);
    event Vote(address indexed voter, uint256 amount);
    event RewardMinted(address indexed voter, uint256 amount);
    event AddressBanned(address indexed bannedAddress);

    /// @dev Constructs the MyToken contract.
    /// @param initialSupply The initial supply of tokens.
    /// @param initialOwner The initial owner of the contract.
    constructor(
        uint256 initialSupply,
        address initialOwner
    ) ERC20("MyToken", "MTK") Ownable(initialOwner) {
        _mint(msg.sender, initialSupply);
        votingPower[msg.sender] = initialSupply;
    }

    /// @dev Overrides the transfer function to update voting power and check banned addresses.
    /// @param sender The sender of the tokens.
    /// @param recipient The recipient of the tokens.
    /// @param amount The amount of tokens to transfer.
    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(!bannedAddresses[sender], "Sender is banned");
        require(!bannedAddresses[recipient], "Recipient is banned");

        uint256 senderPower = votingPower[sender];
        uint256 recipientPower = votingPower[recipient];

        if (senderPower > 0) {
            votingPower[sender] -= amount;
        }
        if (recipientPower > 0) {
            votingPower[recipient] += amount;
        }

        super._transfer(sender, recipient, amount);
    }

    /// @dev Delegates voting power to another address.
    /// @param to The address to delegate the voting power to.
    function delegate(address to) external {
        require(to != address(0), "Invalid delegate address");
        require(to != msg.sender, "Cannot delegate to yourself");

        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        votingPower[to] += senderPower;
        votingPower[msg.sender] = 0;

        emit Delegate(msg.sender, to);
    }

    /// @dev Revokes previously delegated voting power.
    function revokeDelegate() external {
        uint256 senderPower = votingPower[msg.sender];
        require(senderPower > 0, "Sender has no voting power");

        votingPower[msg.sender] = INITIAL_VOTING_POWER;
        emit Delegate(msg.sender, address(0));
    }

    /// @dev Mints rewards for voters based on their voting power.
    /// @param voter The address of the voter.
    /// @param rewardAmount The amount of tokens to mint as rewards.
    function mintRewards(address voter, uint256 rewardAmount) external onlyOwner {
        require(voter != address(0), "Invalid voter address");
        require(!bannedAddresses[voter], "Voter is banned");

        uint256 voterPower = votingPower[voter];
        require(voterPower > 0, "Voter has no voting power");

        _mint(voter, rewardAmount);
        emit RewardMinted(voter, rewardAmount);
    }

    /// @dev Bans an address from participating in voting.
    /// @param _address The address to be banned.
    function banAddress(address _address) external onlyOwner {
        require(_address != address(0), "Invalid address");
        require(_address != owner(), "Cannot ban owner");

        bannedAddresses[_address] = true;
        emit AddressBanned(_address);
    }
}
