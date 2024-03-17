
# Class DAO Project - Dauphine 2024 Digital Economics

The DE ClimateDAO project consists in deploying our own ERC standard onto the testnet. This work is realised in a one week period and is executed under the Software Development Life Cycle framework. All students work in the same repository and are divided into 3 groups, the DevOps, Governance, Token teams.


### 1. Project Description - ClimateDAO

The DAO serves as a governance system for a Model UN focused on Climate Change. Using ~~ERC 777 standard~~ ERC 20 with additional functionalities, it enables token transfer, voting, and delegation. The annual sessions assess climate progress without binding agreements. Participants allocate 100 tokens to vote on proposals. A 24-hour reflection period allows amendments. Approval requires a simple majority. Replicating UN COP, it employs Quadratic voting, which escalates token costs: 1 vote = 1 token, 2 votes = 4 tokens, 3 votes = 9 tokens, incentivizing focus on critical issues. ++ rewards

### 2. Installation and Execution

*Forge* is a state-of-the-art package for running tests, wrting codes and debugging it in Solidity environment.


#### 2.1 Download Forge
You can use *Forge* through a wider tool named *Foundry*. Here are the steps to install it into your computer. Open your terminal and follow these steps :

Create a new repository named Foundry:
```
mkdir foundry
```

Enter into this new repository:
```
cd foundry
```

Verify the connectivity of Foundry with our system:
```
curl -L https://foundry.paradigm.xyz | bash
```

Let Bash re-read the file:
```
source ~/.bashrc 
```

Install Foundry :
```
foundryup
```

More information about how to install Foundry are available [here](https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/14-foundry-setup/).


#### 2.2 Make tests with Forge

Here are some examples of how to run tests with *Forge* :

Run the tests:
```
forge test
```

Open a test in the debugger:
```
forge test --debug testSomething
```

Generate a gas report:
```
forge test --gas-report
```

Only run tests in `test/Contract.t.sol in the BigTest contract that start with testFail:
```
forge test --match-path test/Contract.t.sol --match-contract BigTest \ --match-test "testFail*"
```

List tests in desired format
```
forge test --list
forge test --list --json
forge test --list --json --match-test "testFail*" | tail -n 1 | json_pp
```

More information on the tests with Foundry are available [here](https://book.getfoundry.sh/reference/forge/forge-test)

#### 2.3 Summary of tests
While a list of basic tests have been provided for both contract, they do not test all required potential vulnerabilities, hence we do not recommend relying on them.

### 3. Contract Address
MyToken (MTK) : TOKEN CONTRACT (WITH 18 DECIMALS) 0x19B46757a8b27BA691e2997b06b2B262cDAA5286
MAX TOTAL SUPPLY 1,000 MTK

If you would likw to deploy it, you can use the following command

```
forge create --rpc-url https://ethereum-sepolia-rpc.publicnode.com --private-key YOURPRIVATEKEY --etherscan-api-key YOURETHERSCANAPIKEY --verify Token.sol:MyToken 

forge create --rpc-url https://ethereum-sepolia-rpc.publicnode.com --private-key YOURPRIVATEKEY --etherscan-api-key YOURETHERSCANAPIKEY --verify Governance.sol:ProposalVoting 
```
