// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import necessary OpenZeppelin contracts
import "node_modules/@openzeppelin/contracts/governance/Governor.sol";
import "node_modules/@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "node_modules/@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "node_modules/@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "node_modules/@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "node_modules/@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@openzeppelin/contracts/governance/utils/IVotes.sol";

contract Governance is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
    IVotes private _token; // Declared as a state variable

    event VoteEmitted(uint256 indexed proposalId, address indexed voter, bool support, uint256 votingPower);

    constructor(IVotes token, TimelockController timelock)
        Governor("Governance")
        GovernorSettings(7200 /* 1 day */, 50400 /* 1 week */, 0)
        GovernorVotes(token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(timelock)
    {
        _token = token; // Stored in the state variable
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

    function votingDelay()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    function _queueOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint48)
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _executeOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }
}
