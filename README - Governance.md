<<<<<<< HEAD
# Class-Dao-Project

Our DAO project, dubbed ClimateDAO, aims to simulate climate voting within the United Nations, akin to the Conference of the Parties (COP).

The COP serves as the primary decision-making body for both the Kyoto Protocol and the Paris Agreement. Its primary responsibility involves reviewing the national communications and emission inventories submitted by member Parties. Using this data, the COP evaluates the efficacy of the measures implemented by Parties and the progress towards achieving the Convention's ultimate objective.

The COP convenes annually, unless otherwise determined by the Parties.

It's crucial to note that agreements reached during COP are not legally binding, nor are Parties subject to sanctions for non-compliance.

In our approach, while we emulate aspects of COP, we introduce a quadratic voting system, so in this voters will have the oportunity to cast more votes for more important projects.

In our framework and similar to what happens in the COP we assume that there is a technical committee/chairman, with the necessary expertise in climate change, that submit proposals with the necessary objectives we need to accomplish in order to maintain the long term sustainability of the planet.

Then each country can vote in accordingly. For the purposes of this contract each country will be given a total of 100 tokens to cast in the amount and proposals it finds fit.

After everyone's voted the chairman will call for the end of the vote anounce the results and collect the remaining tokens in each country account.

We have included a function that allows countries to propose amendments to the draft proposals submited to votation. Important to underline as well that after chairman's submission there is a 24h period that no one can vote, this is the time for reflection.

Note:
By quadratic voting we understand: 
  1 vote costs 1 token
  2 votes cost 4 tokens
  3 votes cost 9 tokens
  
Quorum for approval is a simple majority (above 50%)

=======
# Class DAO Project - Dauphine 24 Digital Economics

The Role of this Decentralised Autonomous Organisation is to roleplay as a governance system for our version of a Model UN focused on funding/policy proposals that solve Climate Change.

Our Working is split between the Token team and Governance team. 

The token team has selected ERC 777 as the token of choice - with token transfer, token voting, and vote delegation.
The governance team has selected XXX for YYY as its governance control process. 
You can follow their branches for updates.

# Solidity Files -- currently just ideas from the example DAO

### Votes.sol

### GovernanceVotes.sol

### GovernorCountingSimple.sol & & GovernorVotesQuorumFraction.sol

### Governor.sol
>>>>>>> 1504220ed0294fdd9b5f82e54afa9c213b0577de
