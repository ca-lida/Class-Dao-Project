Design.md


I.Introduction

Our project aims to use blockchain technology to create a transparent, secure and efficient platform for voting on climate change funds and initiatives. 

By adopting the ERC-777 token standard and a governance model inspired by Model United Nations and implemented through a Decentralized Autonomous Organization (DAO), we intend to facilitate global participation and ensure that voting on key issues is handled fairly and without duplication.


II.Technical specifications and interactive diagrams

1.Contracts and functions
Token Contract (ERC-777): This contract governs the issuance, transfer and management of tokens. It combines advanced features of ERC-777 such as operators and hooks for enhanced functionality and security.
Voting contract: It handles all voting mechanisms, including proposal creation, voting, and counting. It interacts with the token contract to verify token ownership and prevent double voting.
Delegation contract: It manages the delegation of voting rights among token holders. It can allow participants to delegate voting rights to representatives.

2.Functionality
Token transfer: It utilizes the standard transfer function of ERC-777 to allow token holders to send and receive tokens safely and efficiently.
Token Voting: It integrates with the voting contract to enable token holders to vote on proposals.The contract uses ERC-777 hooks to check token ownership and ensure that each token can only vote once per proposal.
Voting Delegation: Through a delegation contract, token holders can delegate their voting rights to another party. This process is carefully managed to ensure transparency and prevent abuse.

3. Charts
The interaction diagram will visually represent the process between the token contract, voting contract and delegation contract. 



III.Selected Token Criteria
The project leverages the flexibility, advanced features, and improved security mechanisms of the ERC-777 token standard. ERC-777’s operators and hooks enable more complex voting mechanisms and delegation systems that are critical to the project’s goals.



IV.Selected governance process model
The governance process is inspired by Model United Nations and implemented through a DAO structure. The model allows for a democratic and decentralized decision-making process. In this case, token holders can propose, vote and fund climate change-related initiatives.The DAO ensures that all operations are transparent, secure and in the interest of the community.



V.Reflection

1.Motivation
The decision to use ERC-777 and a Model United Nations inspired DAO was driven by the need for a secure, flexible and democratic system to manage voting on climate change initiatives. ERC-777 provides advanced features that facilitate voting and delegation, while the DAO structure facilitates community participation and decentralized governance.

2.Technical Difficulties
There are some challenges regarding integrating ERC-777 hooks with voting and delegation contracts. It particularly ensures accurate vote counting and secure delegation management. Additionally, we need to design and test carefully the management of the interactions between these contracts and the prevention of double voting.

3.Difficulty in interpersonal communication
Coordination between the token team and the governance team is really a challenge, especially in terms of aligning technical requirements with the goals of the governance model. Regular communication and compromise are essential to overcome these obstacles and ensure both teams are working toward a common goal.


