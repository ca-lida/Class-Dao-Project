const MyToken = artifacts.require("MyToken");

/**
 * Contract tests for MyToken.
 */
contract("MyToken", (accounts) => {
  let myToken;
  const initialSupply = 1000;
  const defaultOperators = [];
  const initialOwner = accounts[0];

  beforeEach(async () => {
    myToken = await MyToken.new(initialSupply, defaultOperators, initialOwner);
  });

  /**
   * Test case: should mint initial supply to the owner.
   */
  it("should mint initial supply to the owner", async () => {
    const balance = await myToken.balanceOf(initialOwner);
    assert.equal(balance.toString(), initialSupply.toString());
  });

  /**
   * Test case: should delegate voting power.
   */
  it("should delegate voting power", async () => {
    await myToken.delegate(accounts[1], { from: initialOwner });
    const votingPower = await myToken.votingPower(accounts[1]);
    assert.equal(votingPower.toString(), initialSupply.toString());
  });

  /**
   * Test case: should revoke delegated voting power.
   */
  it("should revoke delegated voting power", async () => {
    await myToken.delegate(accounts[1], { from: initialOwner });
    await myToken.revokeDelegate({ from: initialOwner });
    /**
     * Retrieves the voting power of the initial owner.
     *
     * @param {string} initialOwner - The address of the initial owner.
     * @returns {Promise<number>} The voting power of the initial owner.
     */
    const votingPower = await myToken.votingPower(initialOwner);
    assert.equal(votingPower.toString(), "1");
  });

  /**
   * Test case: should mint rewards for voters.
   */
  it("should mint rewards for voters", async () => {
    await myToken.delegate(accounts[1], { from: initialOwner });
    await myToken.mintRewards(accounts[1], { from: initialOwner });
    const balance = await myToken.balanceOf(accounts[1]);
    assert.equal(balance.toString(), (initialSupply * 10).toString());
  });
});