// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/src/Test.sol";
import "Token.sol";

contract MyTokenTest is Test {
    MyToken myToken;
    ErrorsTest testContract;

    function setUp() public {
        myToken = new MyToken();
        testContract = new ErrorsTest();
    }

    // Test to check the initial balance of the deployer
    function testInitialBalance() public {
        Assert.equal(myToken.balanceOf(address(this)), 1000, "Initial balance is incorrect");
    }

    // Test to check the delegate function
    function testDelegate() public {
        address delegate = TestsAccounts.getAccount(1);
        myToken.delegate(delegate);
        Assert.equal(myToken.votingPower(delegate), 1000, "Delegation is incorrect");
    }

    // Test to check the revokeDelegate function
    function testRevokeDelegate() public {
        myToken.revokeDelegate();
        Assert.equal(myToken.votingPower(address(this)), 1, "Revocation is incorrect");
    }

    // Test to check the mintRewards function
    function testMintRewards() public {
        address voter = TestsAccounts.getAccount(2);
        myToken.delegate(voter);
        myToken.mintRewards(voter);
        Assert.equal(myToken.balanceOf(voter), 10000, "Minting rewards is incorrect");
    }
}


