// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/utils/math/Math.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ProposalVoting is Ownable {
    using Math for uint256;

    struct Proposal {
        uint256 votes;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public totalProposals;

    mapping(address => bool) public tokenOwners;
    address[] public tokenOwnerList; // Maintain a list of token owners
    mapping(address => mapping(uint256 => uint256)) public votesByVoter; // Mapping to store votes by each voter for each proposal
    mapping(address => uint256) public remainingTokens; // Remaining tokens each voter owns
    mapping(uint256 => uint256) public submissionTime; // Time of submission for each proposal
    IERC20 public token; // The ERC20 token contract

    uint256 public constant votingDelay = 24 hours;

    event ProposalSubmitted(uint256 indexed proposalId);
    event Voted(address indexed voter, uint256 indexed proposalId, uint256 votes);
    event VotingResult(uint256 indexed proposalId, uint256 votesFor, uint256 votesAgainst, bool passed);
    event TokensClaimed(address indexed owner, address indexed voter, uint256 amount);

    constructor(address[] memory _tokenOwners, address _tokenAddress) Ownable(msg.sender) {
        for (uint256 i = 0; i < _tokenOwners.length; i++) {
            tokenOwners[_tokenOwners[i]] = true;
            tokenOwnerList.push(_tokenOwners[i]); // Add token owner to the list
        }
        token = IERC20(_tokenAddress);
    }

    function submitProposalBatch(uint256[] memory proposalIds) external onlyOwner {
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < proposalIds.length; i++) {
            require(!proposals[proposalIds[i]].exists, "Proposal already exists");
            proposals[proposalIds[i]].exists = true;
            totalProposals++;
            submissionTime[proposalIds[i]] = currentTime;
            emit ProposalSubmitted(proposalIds[i]);
        }
    }

    function vote(uint256 proposalId, uint256 votes) external {
        require(tokenOwners[msg.sender], "Caller is not a token owner");
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(votes > 0 && votes <= 100, "Invalid number of votes");
        require(block.timestamp >= submissionTime[proposalId] + votingDelay, "Voting has not started yet");

        uint256 cost = votes.mul(votes); // Square the votes to calculate cost
        require(cost <= tokenBalanceOf(msg.sender), "Insufficient tokens");

        proposals[proposalId].votes = proposals[proposalId].votes.add(votes);
        votesByVoter[msg.sender][proposalId] = votesByVoter[msg.sender][proposalId].add(votes);

        // Deduct tokens from voter
        deductTokens(msg.sender, cost);

        emit Voted(msg.sender, proposalId, votes);
    }

    function endVoting() external onlyOwner {
        for (uint256 i = 0; i < totalProposals; i++) {
            uint256 votesFor = proposals[i].votes;
            uint256 votesAgainst = 100*(votesByVoter[msg.sender][i]) - votesFor; // Using standard multiplication
            bool passed = votesFor > votesAgainst && votesFor.mul(2) > 100; // Using standard multiplication
            emit VotingResult(i, votesFor, votesAgainst, passed);
        }
        // Calculate remaining tokens for each voter
        for (uint256 i = 0; i < tokenOwnerList.length; i++) {
            address voter = tokenOwnerList[i];
            uint256 remaining = tokenBalanceOf(voter);
            remainingTokens[voter] = remaining;
        }
    }

    // Allow the owner to claim remaining tokens of each voter
    function claimRemainingTokens() external onlyOwner {
        for (uint256 i = 0; i < tokenOwnerList.length; i++) {
            address voter = tokenOwnerList[i];
            uint256 remaining = remainingTokens[voter];
            require(remaining > 0, "No remaining tokens to claim");
            remainingTokens[voter] = 0;
            token.transfer(owner(), remaining);
            emit TokensClaimed(owner(), voter, remaining);
        }
    }

    // Get the token balance of an account
    function tokenBalanceOf(address account) internal view returns (uint256) {
        return token.balanceOf(account);
    }

    // Deduct tokens from an account
    function deductTokens(address account, uint256 amount) internal {
        token.transferFrom(account, address(this), amount);
    }
}
