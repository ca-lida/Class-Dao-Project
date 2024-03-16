// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import necessary OpenZeppelin contracts
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorStorage.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyGovernor is Governor, GovernorCountingSimple, GovernorStorage, GovernorVotes, GovernorVotesQuorumFraction, AccessControl {
    enum Category { Default, Special }
    enum ProposalType { Initial, Following }
    // Simplified tracking for the latest category - not ideal
    Category private _lastProposalCategory = Category.Default;

    // Roles
    bytes32 public constant COMITEE_ROLE = keccak256("COMITEE_ROLE");
    bytes32 public constant COUNTRY_ROLE = keccak256("COUNTRY_ROLE");
    

    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); 
        _setupRole(COMITEE_ROLE, msg.sender); 
    }

    function votingDelay() public view override returns (uint256) {
        if (_lastProposalCategory == Category.Special) {
            return 7200; // e.g., Special category delay
        } else {
            return 3600; // e.g., Default category delay
        }
    }

    function votingPeriod() public view override returns (uint256) {
        if (_lastProposalCategory == Category.Special) {
            return 50400; // e.g., Special category period
        } else {
            return 25200; // e.g., Default category period
        }
    }

    enum ProposalType { Initial, Following }

    function proposeWithCategoryAndType(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        Category category,
        ProposalType proposalType
    ) public returns (uint256) {
        // Check roles and proposal type
        if (proposalType == ProposalType.Initial) {
            require(hasRole(COMITEE_ROLE, msg.sender), "Caller does not have COMITEE role");
        } else if (proposalType == ProposalType.Following) {
            require(hasRole(COUNTRY_ROLE, msg.sender), "Caller does not have COUNTRY role");
            require(category == Category.Default, "Following proposals must be Default category");
        }

        _lastProposalCategory = category;

        return super.propose(targets, values, calldatas, description);
    }

    // Function to grant COMITEE role
    function grantComiteeRole(address account) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        grantRole(COMITEE_ROLE, account);
    }

    // Function to revoke COMITEE role
    function revokeComiteeRole(address account) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        revokeRole(COMITEE_ROLE, account);
    }

    
    // The following functions are overrides required by Solidity.

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
