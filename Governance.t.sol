pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "Token.sol";
import {ProposalVoting} from "Governance.sol";

contract TestProposalVoting {
    ProposalVoting proposalVoting;

    // This function runs before each test case to set up the contract
    function beforeEach() public {
        proposalVoting = new ProposalVoting();
    }

    // Test for initial setup of the contract
    function testInitialSetup() public {
        uint expected = 0;
        assertEq(proposalVoting.totalProposals(), expected, "Initial total proposals should be 0");
    }

    // Test for submitting a batch of proposals
    function testSubmitProposalBatch() public {
        uint256[] memory proposalIds = new uint256[](1);
        proposalIds[0] = 1;
        bool[] memory proposalTypes = new bool[](1);
        proposalTypes[0] = true;
        address[] memory bannedCountries = new address[](1);
        bannedCountries[0] = address(0);
        string[] memory titles = new string[](1);
        titles[0] = "Test Proposal";
        string[] memory summaries = new string[](1);
        summaries[0] = "Test Summary";

        proposalVoting.submitProposalBatch(proposalIds, proposalTypes, bannedCountries, titles, summaries);

        uint expected = 1;
        assertEq(proposalVoting.totalProposals(), expected, "Total proposals should be 1 after submitting a proposal");
    }

    // Test for submitting a follow-up proposal
    function testSubmitFollowUpProposal() public {
        proposalVoting.submitFollowUpProposal(1, "Follow Up Proposal", "Follow Up Summary");

        uint expected = 2;
        assertEq(proposalVoting.totalProposals(), expected, "Total proposals should be 2 after submitting a follow-up proposal");
    }

    // Test for voting on a proposal
    function testVote() public {
        proposalVoting.vote(1, 10, false);

        uint expectedVotesFor = 10;
        assertEq(proposalVoting.proposals(1).votes_for, expectedVotesFor, "Votes for proposal 1 should be 10 after voting");
    }

    // Test for ending the voting period
    function testEndVoting() public {
        proposalVoting.endVoting();

        uint expectedVotesFor = 10;
        assertEq(proposalVoting.proposals(1).votes_for, expectedVotesFor, "Votes for proposal 1 should still be 10 after ending voting");
    }

    // Test for claiming remaining tokens
    function testClaimRemainingTokens() public {
        proposalVoting.claimRemainingTokens();

        uint expectedRemainingTokens = 0;
        assertEq(proposalVoting.remainingTokens(msg.sender), expectedRemainingTokens, "Remaining tokens should be 0 after claiming remaining tokens");
    }
}
