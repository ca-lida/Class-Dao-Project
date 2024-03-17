// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/utils/math/Math.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ProposalVoting
 * @dev Contract for submitting and voting on proposals using a token-based voting system.
 */
contract ProposalVoting is Ownable, AccessControl {
    using Math for uint256;

    struct Proposal {
        uint256 votes_for; // Total number of votes received for the proposal
        uint256 votes_against; // Total number of votes received against the proposal
        address banned_address; // Address banned for this vote
        uint256 quorum; // Quorum needed for the proposal to be accepted
        bool exists; // Flag indicating whether the proposal exists
        string title; /// @dev Title of the proposal
        string Summary; /// @dev Short description of the proposal
        uint256 parentProposalId; /// @dev 0 for inital proposals
    }

    /// @dev Define the "COUNTRY" role
    bytes32 public constant COUNTRY_ROLE = keccak256("COUNTRY");

    mapping(uint256 => Proposal) public proposals; // Mapping of proposal IDs to Proposal struct
    uint256 public totalProposals; // Total number of proposals submitted

    mapping(address => bool) public tokenOwners; // Mapping of addresses owning voting tokens
    address[] public tokenOwnerList; // List of addresses owning voting tokens
    mapping(address => mapping(uint256 => uint256)) public votesByVoter; // Mapping of votes by each voter for each proposal
    mapping(address => uint256) public remainingTokens; // Remaining tokens each voter owns
    mapping(uint256 => uint256) public submissionTime; // Time of submission for each proposal
    IERC20 public token; // The ERC20 token contract

    uint256 public constant votingDelay = 24 hours; // Delay before voting starts after proposal submission

    event ProposalSubmitted(uint256 indexed proposalId);
    event Voted(address indexed voter, uint256 indexed proposalId, uint256 votes);
    event VotingResult(uint256 indexed proposalId, uint256 votesFor, uint256 votesAgainst, bool passed);
    event TokensClaimed(address indexed owner, address indexed voter, uint256 amount);
    event RewardMinted(address indexed voter, uint256 rewardAmount);

    /**
     * @dev Initializes the contract with the initial token owners, admin role and the ERC20 token contract address.
     * @param _tokenOwners List of addresses initially owning voting tokens
     * @param _tokenAddress Address of the ERC20 token contract
     */
    constructor(address[] memory _tokenOwners, address _tokenAddress) Ownable(msg.sender) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); 
        for (uint256 i = 0; i < _tokenOwners.length; i++) {
            tokenOwners[_tokenOwners[i]] = true;
            tokenOwnerList.push(_tokenOwners[i]); // Add token owner to the list
        }
        token = IERC20(_tokenAddress);
    }

    /**
     * @dev Submits a batch of proposals by IDs and some info.
     * @param proposalIds Array of proposal IDs to be submitted
     * @param proposalTypes Array of proposal types to be submitted true = sanction type, false = normal type
     * @param bannedCountries Array of the country aimed by each sanction type proposal, empty when a normal type 
     * @param titles Array of titles for the proposals
     * @param summaries Array of summaries for the proposals
     */
    function submitProposalBatch(
        uint256[] memory proposalIds, 
        bool[] memory proposalTypes, 
        address[] memory bannedCountries,
        string[] memory titles,
        string[] memory summaries) external onlyOwner {
        require(proposalIds.length == proposalTypes.length, "The number of Ids and Types do not correspond");
        require(proposalIds.length == titles.length, "Mismatch between IDs and titles count");
        require(proposalIds.length == summaries.length, "Mismatch between IDs and summaries count");

        uint256 bannedCountryIndex = 0;

        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < proposalIds.length; i++) {
            require(!proposals[proposalIds[i]].exists, "Proposal already exists");

            proposals[proposalIds[i]] = Proposal({
                votes_for: 0,
                votes_against: 0,
                banned_address: address(0), 
                quorum: proposalTypes[i] ? 70 : 50, /// @notice Sanction type proposals have a higher quorum
                exists: true,
                title: titles[i],
                Summary: summaries[i],
                parentProposalId: 0 ///@dev Initial proposals have no parent
            });

            /// @dev Only assign a banned address for sanction type proposals
            if (proposalTypes[i]) {
                require(bannedCountryIndex < bannedCountries.length, "Insufficient bannedCountries provided");
                address bannedCountry = bannedCountries[bannedCountryIndex++];
                require(tokenOwners[bannedCountry], "Unknown Country address");
                proposals[proposalIds[i]].banned_address = bannedCountry;
            }

            submissionTime[proposalIds[i]] = currentTime;
            totalProposals++;
            emit ProposalSubmitted(proposalIds[i]);
        }

    /**
     * @dev Allows COUNTRY to make proposals (child proposal) after initial proposal by expert comitee
     * @param parentProposalId ID of the parent proposal 
     * @param title Title of the proposal
     * @param summary Summary of the child proposal
     */
    function submitFollowUpProposal(uint256 parentProposalId, string memory title, string memory summary) external {
        require(hasRole(COUNTRY_ROLE, msg.sender), "Caller does not have COUNTRY role");
        require(proposals[parentProposalId].exists, "Parent proposal does not exist");
        
        uint256 proposalId = totalProposals++; /// @dev Use totalProposals as the new proposal ID
        Proposal storage proposal = proposals[proposalId];
        proposal.exists = true;
        proposal.quorum = 50; /// @dev Follow-up proposals have a fixed quorum of 50 as they're "normal" proposals
        proposal.title = title;
        proposal.Summary = summary;
        proposal.parentProposalId = parentProposalId;
        
        submissionTime[proposalId] = block.timestamp;
        emit ProposalSubmitted(proposalId);
    }

    /**
     * @dev Allows a token owner to vote on a proposal. Only COUNTRY Roles.
     * @param proposalId ID of the proposal to vote on
     * @param votes Number of votes to cast
     * @param against Votes casted against the prosal if true and for the proposal if false
     */
    function vote(uint256 proposalId, uint256 votes, bool against) external {
        require(tokenOwners[msg.sender] || hasRole(COUNTRY_ROLE, msg.sender), "Caller is not authorized to vote");
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(msg.sender == proposals[proposalId].banned_address, "You are banned from the proposal's vote");
        require(votes > 0 && votes <= 100, "Invalid number of votes");
        require(block.timestamp >= submissionTime[proposalId] + votingDelay, "Voting has not started yet");
        require(votesByVoter[msg.sender][proposalId] > 0, "You have already voted for this proposal");
        uint256 cost = votes.mul(votes); // Square the votes to calculate cost
        require(cost <= tokenBalanceOf(msg.sender), "Insufficient tokens");
        // Adds the votes to the correct category
        if (against) {
            proposals[proposalId].votes_against += votes;
        } else {
            proposals[proposalId].votes_for += votes;
        }
        // 
        votesByVoter[msg.sender][proposalId] += votes;

        // Deduct tokens from voter
        deductTokens(msg.sender, cost);

        emit Voted(msg.sender, proposalId, votes);
    }

    /**
     * @dev Ends voting for all proposals and calculates the results.
     */
    function endVoting() external onlyOwner {
        for (uint256 i = 0; i < totalProposals; i++) {
            bool passed = false;
            if ((proposals[i].votes_for + proposals[i].votes_against) > 0){
                bool passed = (100 * proposals[i].votes_for / (proposals[i].votes_for + proposals[i].votes_against)) >= proposals[i].quorum; // calculate the result for the quorum
            } else {
                passed = false; // In the case no one voted for a proposal it is rejected by default
            }

            emit VotingResult(i, proposals[i].votes_for, proposals[i].votes_against, passed);
        }
        // Calculate remaining tokens for each voter
        for (uint256 i = 0; i < tokenOwnerList.length; i++) {
            address voter = tokenOwnerList[i];
            uint256 remaining = tokenBalanceOf(voter);
            remainingTokens[voter] = remaining;
        }

        // Mint rewards for all voters with the COUNTRY role
        for (uint256 i = 0; i < tokenOwnerList.length; i++) {
            address voter = tokenOwnerList[i];
            if (hasRole(COUNTRY_ROLE, voter)) {
                
                uint256 voterPower = votingPower[voter];
                uint256 rewardAmount = voterPower * 10; // Example calculation for reward amount
                token.mintRewards(voter, rewardAmount); 

                emit RewardMinted(voter, rewardAmount);
            }
        }
    }

    /**
     * @dev Allows the owner to claim remaining tokens of each voter.
     */
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

    /**
     * @dev Retrieves the token balance of an account.
     * @param account Address of the account
     * @return The token balance of the account
     */
    function tokenBalanceOf(address account) internal view returns (uint256) {
        return token.balanceOf(account);
    }

    /**
     * @dev Deducts tokens from an account.
     * @param account Address of the account
     * @param amount Amount of tokens to deduct
     */
    function deductTokens(address account, uint256 amount) internal {
        token.transferFrom(account, address(this), amount);
    }
}
