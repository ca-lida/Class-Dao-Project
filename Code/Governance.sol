// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import necessary OpenZeppelin contracts
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorStorage.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract MyGovernor is Governor, GovernorCountingSimple, GovernorStorage, GovernorVotes, GovernorVotesQuorumFraction {
    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {}

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

    function votingDelay() public pure override returns (uint256) {
        return 7200; // 1 day
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // 1 week
    }
    
    // The following functions are overrides required by Solidity.

    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function _propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description, address proposer)
        internal
        override(Governor, GovernorStorage)
        returns (uint256)
    {
        return super._propose(targets, values, calldatas, description, proposer);
    }
}
