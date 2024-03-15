// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import necessary OpenZeppelin contracts
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorStorage.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract MyGovernor is Governor, GovernorCountingSimple, GovernorStorage, GovernorVotes, GovernorVotesQuorumFraction {
    enum Category { Default, Special }
    // Simplified tracking for the latest category 
    Category private _lastProposalCategory = Category.Default;

    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {}

    // Dynamic voting delay based on category of proposal
    function votingDelay() public view override returns (uint256) {
        if (_lastProposalCategory == Category.Special) {
            return 7200; // e.g., Special category delay
        } else {
            return 3600; // e.g., Default category delay
        }
    }

    // Dynamic voting period based on category of proposal
    function votingPeriod() public view override returns (uint256) {
        if (_lastProposalCategory == Category.Special) {
            return 50400; // e.g., Special category period
        } else {
            return 25200; // e.g., Default category period
        }
    }

    // Proposal, but with category field and storage of it (to check carefully)
    function proposeWithCategory(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        Category category 
    ) public returns (uint256) {
        _lastProposalCategory = category; // Set the last proposal category
        return super.propose(targets, values, calldatas, description); // Use the base propose
    }

    // Calculate the voting power based on the square of the number of tokens held by each voter
    function calculateVotingPower(address voter) internal view returns (uint256) {
        uint256 balance = _token.balanceOf(voter);
        return balance * balance; // Square the balance for quadratic voting
    }

    // Override the _vote function to consider quadratic voting power
    function _vote(uint256 proposalId, address voter, bool support) internal override {
        uint256 votingPower = calculateVotingPower(voter);
        _voteInternal(proposalId, voter, support, votingPower);
        emit VoteEmitted(proposalId, voter, support, votingPower);
    }

    // Declare the _voteInternal function
    function _voteInternal(uint256 proposalId, address voter, bool support, uint256 votingPower) internal {
        // Call the appropriate vote function based on your governance module
        super._vote(proposalId, voter, support, votingPower);
    }
    
    // The following functions are overrides required by Solidity.

    // Dynamic quorum based on category of proposal
    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        if (_lastProposalCategory == Category.Special) {
            return super.quorum(blockNumber) * 2; // e.g., Double the quorum for Special category
        } else {
            return super.quorum(blockNumber); // Default quorum
        }
    }

    function _propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description, address proposer)
        internal
        override(Governor, GovernorStorage)
        returns (uint256)
    {
        return super._propose(targets, values, calldatas, description, proposer);
    }
}
