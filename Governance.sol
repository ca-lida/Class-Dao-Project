// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/**
 * @title Governance Contract
 * @dev This contract implements a governance system using the OpenZeppelin Governor framework.
 */
contract Governance is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
    
    /**
     * @dev Contract constructor
     * @param _token Address of the token contract used for voting
     * @param _timelock Address of the timelock controller contract
     */
    constructor(IVotes _token, TimelockController _timelock)
        Governor("Governance")
        GovernorSettings(1 /* 1 block */, 50400 /* 1 week */, 0)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
    {}

    // The following functions are overrides required by Solidity.

    /**
     * @dev Retrieve the voting delay period
     * @return The voting delay period in blocks
     */
    function votingDelay()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    /**
     * @dev Retrieve the voting period
     * @return The voting period in blocks
     */
    function votingPeriod()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    /**
     * @dev Retrieve the quorum required for voting
     * @param blockNumber The block number at which to retrieve the quorum
     * @return The quorum required for voting at the specified block number
     */
    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    /**
     * @dev Get the state of a proposal
     * @param proposalId The ID of the proposal
     * @return The state of the proposal
     */
    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    /**
     * @dev Check if a proposal needs to be queued before execution
     * @param proposalId The ID of the proposal
     * @return True if the proposal needs to be queued, false otherwise
     */
    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    /**
     * @dev Get the proposal threshold
     * @return The proposal threshold
     */
    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    /**
     * @dev Queue operations for execution after the time lock
     * @param proposalId The ID of the proposal
     * @param targets The addresses of the contracts to be called
     * @param values The values to be passed to the contract calls
     * @param calldatas The data to be passed to the contract calls
     * @param descriptionHash The hash of the proposal description
     * @return The queue ID of the operations
     */
    function _queueOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint48)
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Execute operations after the time lock
     * @param proposalId The ID of the proposal
     * @param targets The addresses of the contracts to be called
     * @param values The values to be passed to the contract calls
     * @param calldatas The data to be passed to the contract calls
     * @param descriptionHash The hash of the proposal description
     */
    function _executeOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Cancel operations for a proposal
     * @param targets The addresses of the contracts to be called
     * @param values The values to be passed to the contract calls
     * @param calldatas The data to be passed to the contract calls
     * @param descriptionHash The hash of the proposal description
     * @return The ID of the canceled proposal
     */
    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Get the executor address
     * @return The address of the executor
     */
    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }
}