# Class-Dao-Project

# MyToken Contract

This is a Solidity smart contract for the creation and management of a token called MyToken (MTK) based on the ERC20 standard. The contract allows for delegation and revocation of voting power associated with tokens and includes functionalities for banning addresses from participating in voting.

## Features
-Implements ERC20 token standard.
-Extends Ownable contract from OpenZeppelin for access control.
- Allows delegation and revocation of voting power associated with tokens.
- Includes events for delegation, voting, reward minting, and address banning.
- Voters can receive rewards based on their voting power in the DAO.

## Contract Details

- MyToken: A custom ERC20 token contract with voting power delegation and banning of addresses.
- votingPower: A mapping that stores the voting power of each address.
- bannedAddresses: A mapping that stores whether an address is banned from voting.
- Delegate: An event that is emitted when voting power is delegated.
- Vote: An event that is emitted when a vote is cast.
- RewardMinted: An event that is emitted when rewards are minted for a voter.
- AddressBanned: An event that is emitted when an address is banned from voting.


