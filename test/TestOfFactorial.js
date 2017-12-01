var Lottery = artifacts.require("Lottery_6_Of_45_Light");

contract('lottery', function(accounts) {

  it("Расчет факториалов", async () => {
    const lottery =  await Lottery.deployed()
    assert.equal(await lottery.factorial(0), 1, "Factorial of 0 should be 1");
    assert.equal(await lottery.factorial(2), 2, "Factorial of 2 should be 2");
    assert.equal(await lottery.factorial(3), 6, "Factorial of 3 should be 6");
    assert.equal(await lottery.factorial(10), 3628800, "Factorial of 10 should be 3628800");
    });
});
