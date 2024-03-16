Design.md


I.Introduction

The project, named ClimateDAO, is designed to revolutionize the voting process on climate change funds and initiatives using blockchain technology. Our objective is to create a platform that is transparent, secure, and efficient.

We are using a special kind of blockchain token, called ERC-777, and setting up a system like the Model United Nations. This setup is implemented through a Decentralized Autonomous Organization (DAO). It aims to ensure global participation. In this case, voting on crucial climate issues is conducted fairly, efficiently, and without any duplication.

ClimateDAO is inspired by the COP, which is the main group making big decisions about climate agreements like the Kyoto Protocol and the Paris Agreement. The COP looks at reports and data on emissions from countries to see how well everyone is doing in fighting climate change.

By leveraging a decentralized platform, ClimateDAO seeks to enhance the United Nations' efforts in climate change voting. It introduces incentives and fosters a culture where participants prioritize long-term environmental sustainability over immediate political benefits. This initiative aims to stimulate consensus on climate goals, reflecting the spirit of global cooperation and shared responsibility.



II.Technical specifications and interactive diagrams

1.Contracts and Functions
Token Contract (ERC-777): This contract governs the issuance, transfer, and management of tokens. It uses advanced features of ERC-777, like operators and hooks, for enhanced functionality and security.
Voting Contract: This contract manages all voting mechanisms, encompassing proposal creation, voting, and vote counting. It verifies token ownership through the token contract to prevent double voting.
Delegation Contract: This contract oversees the delegation of voting rights among token holders.It enables participants to delegate their voting rights to representatives.

2.Core Components
Technical Committee: This is a committee with expertise in climate change. It is responsible for drafting proposals to achieve long-term sustainability goals for the planet.
Voting System: This is a modified voting mechanism implemented via the ERC-777 token standard. It introduces incentives to encourage high-quality proposals.

3.Functionality
Token Transfer: It utilizes the standard transfer function of ERC-777. It can allow token holders to send and receive tokens safely and efficiently.
Token Voting: It Integrates with the voting contract. It enables token holders to cast votes on proposals. It uses ERC-777 hooks to verify token ownership and ensures that each token can only vote once per proposal.
Voting Delegation: Through the delegation contract, token holders can delegate their voting rights to another party. This is managed carefully to maintain transparency and prevent abuse.
Quadratic Voting: It implements a cost for voting that increases non-linearly with the number of votes. For example, 1 vote costs 1 token, 2 votes cost 4 tokens, 3 votes cost 9 tokens, etc.
Time Lock: It introduces a 24-hour locking period required before new proposals can be submitted for voting.
Technical Committee Proposals: They are proposals drafted by the Technical Committee.They typically require a simple majority to pass. Proposals involving economic sanctions require a two-thirds majority for approval.


III.Selected Token Criteria
The project leverages the flexibility, advanced features, and improved security mechanisms of the ERC-777 token standard. ERC-777’s operators and hooks enable more complex voting mechanisms and delegation systems that are critical to the project’s goals.



IV.Selected governance process model
The governance process is inspired by Model United Nations and implemented through a DAO structure. The model allows for a democratic and decentralized decision-making process. In this case, token holders can propose, vote and fund climate change-related initiatives.The DAO ensures that all operations are transparent, secure and in the interest of the community.



V.Reflection

1.Motivation
We decided to use a system like the COP meetings and the ERC-777 blockchain technology because we wanted something that works like real-world decisions but also uses the benefits of blockchain. The ERC-777 helps us with smart ways to vote and delegate votes, and making it work like the COP helps everyone get involved and manage things together. We also added special rewards and voting rules to make sure people think about good, long-lasting ideas.

2.Technical Difficulties
Using ERC-777 technology for our voting and delegation system is tough. We had to be very careful to count votes correctly and keep the voting process secure. Also, setting up rules like secondary voting and time locks (where you have to wait before you can vote) requires a lot of careful work. We need to be sure that tokens are used the right way and that we correctly figure out how much voting costs. Plus, making sure the proposals from our technical experts fit well with the voting rules needs a lot of attention. All these issues show that it's not easy to make a system that is safe, flexible, and can handle complicated voting methods.

3.Difficulty in interpersonal communication
Working together between the technical committee, token holders, and the governance team is really hard. We need to make sure everyone agrees on what technology to use and how to make decisions. It is also important to figure out how to change and judge proposals properly. Good talking and planning skills are very important to solve these problems.Talking often and giving feedback helps make sure the ideas are good and can change if needed. This helps everyone work together towards the same goals.


