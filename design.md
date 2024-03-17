# design.md


## I.Introduction

The project, named ClimateDAO, is designed to revolutionize the voting process on climate change funds and initiatives using blockchain technology. Our objective is to create a platform that is transparent, secure, and efficient.

We are using an extended version of ERC-20, and setting up a system like the Model United Nations. This setup is implemented through a Decentralized Autonomous Organization (DAO). It aims to ensure global participation. In this case, voting on crucial climate issues is conducted fairly, efficiently, and without any duplication.

ClimateDAO is inspired by the COP, which is the main group making big decisions about climate agreements like the Kyoto Protocol and the Paris Agreement. The COP looks at reports and data on emissions from countries to see how well everyone is doing in fighting climate change.

By leveraging a decentralized platform, ClimateDAO seeks to enhance the United Nations' efforts in climate change voting. It introduces incentives and fosters a culture where participants prioritize long-term environmental sustainability over immediate political benefits. This initiative aims to stimulate consensus on climate goals, reflecting the spirit of global cooperation and shared responsibility.



## II.Technical specifications and interactive diagrams

### 1.Contracts and Functions
Token Contract (extended ERC-20): This contract governs the issuance, transfer, and management of tokens.
Voting Contract: This contract manages all voting mechanisms, encompassing proposal creation, voting, and vote counting. It verifies token ownership through the token contract to prevent double voting.
MyToken contract: This is a smart contract based on the ERC-20 standard that is used to create and manage tokens called MyToken and supports the delegation of token voting rights. The contract provides voting rights delegation functions, and provides rewards for users who actively participate in voting.
Delegation function: In the MyToken contract, this function allows token holders to delegate their voting rights to others. It makes the voting process more flexible and secure. 


### 2.Core Components
Technical Committee: This is a committee with expertise in climate change. It is responsible for drafting proposals to achieve long-term sustainability goals for the planet.
Voting System: This is a modified voting mechanism implemented via the ERC-20 token standard. It introduces incentives to encourage high-quality proposals.

### 3.Functionality
Token Transfer: It utilizes the standard transfer function of ERC-20. It allows token holders to send and receive tokens safely and efficiently.
Token Voting: It Integrates with the voting contract. It enables token holders to cast votes on proposals. It uses ERC-20 hooks to verify token ownership and ensures that each token can only vote once per proposal.
Voting Delegation: Through the delegation contract, token holders can delegate their voting rights to another party. This is managed carefully to maintain transparency and prevent abuse.
Revoke Voting Delegation: token holders who previously delegated their vote, can revoke from the delegation.
Quadratic Voting: It implements a cost for voting that increases non-linearly with the number of votes. For example, 1 vote costs 1 token, 2 votes cost 4 tokens, 3 votes cost 9 tokens, etc.
Time Lock: It introduces a 24-hour locking period required before new proposals can be submitted for voting.
Technical Committee Proposals: In ClimateDAO, proposals on climate change are drafted by the Technical Committee. These proposals usually need a simple majority to pass. Proposals that involve economic sanctions require a two-thirds majority for approval. Moreover, if a quorum for the technical committee's proposal is not met, countries can create their own versions of the proposal with minor changes.



## III.Selected Token Criteria
The project leverages the flexibility, advanced features, and improved security mechanisms of the ERC-20 token standard. ERC-20 defines a set of common functions and events that make token interactions straightforward and predictable. ERC-20’s operators and hooks enable complex voting mechanisms and delegation systems that are critical to the project’s goals.

## IV.Selected governance process model
Taking inspiration from the Model United Nations, ClimateDAO operates through a DAO structure to enable a democratic and decentralized decision-making process.This allows token holders to propose, vote on, and fund initiatives related to climate change. It can ensure operations are transparent, secure, and aligned with community interests. 

Our system uses a special voting method called quadratic voting. It lets people give more votes to the projects they think are most important. It makes the way of making decisions more detailed and thoughtful.

Like the COP meetings, ClimateDAO has a technical committee who knows a lot about climate change. It put forward ideas to help our planet in the long run. Each country in the DAO gets to vote on these ideas, and every country has 100 tokens to use on the proposals they like the most. After everyone votes, the chairman tells everyone the outcomes and gathers any tokens left in each country's account.

An essential feature of our DAO is the ability for countries to propose amendments to draft proposals. It can foster a more interactive and responsive governance environment. Also, we have a rule where there is a 24-hour wait time after the chairman shares proposals before voting starts. It can make sure everyone thinks carefully about them. Our voting system makes it so that the more votes you want to give, the more it costs - like one vote costs one token, but two votes cost four tokens. This encourages people to vote wisely. To get a proposal passed, more than half of the votes (over 50%) need to agree. It helps make sure important projects get enough support.

## V.Reflection

### 1.Motivation
We decided to use a system like the COP meetings and the ERC-20 blockchain technology because we wanted something that works like real-world decisions but also uses the benefits of blockchain. ERC-20 offers advanced features for voting and delegation, and the simulation of the COP process through a DAO enhances community participation and decentralized governance. We also added special rewards and voting rules to make sure people think about good, long-lasting ideas.

### 2.Technical Difficulties
Using ERC-20 technology for our voting and delegation system is tough. We had to be very careful to count votes correctly and keep the voting process secure. Also, setting up rules like secondary voting and time locks (where you have to wait before you can vote) requires a lot of careful work. We need to be sure that tokens are used the right way and that we correctly figure out how much voting costs. Plus, making sure the proposals from our technical experts fit well with the voting rules needs a lot of attention. All these issues show that it's not easy to make a system that is safe, flexible, and can handle complicated voting methods.

### 3.Difficulty in interpersonal communication
Working together between the technical committee, token holders, and the governance team is really hard. We need to make sure everyone agrees on what technology to use and how to make decisions. It is also important to figure out how to change and judge proposals properly. Good talking and planning skills are very important to solve these problems.Talking often and giving feedback helps make sure the ideas are good and can change if needed. This helps everyone work together towards the same goals.


