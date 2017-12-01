var Lottery = artifacts.require("Lottery_6_Of_45_Light");

contract('lottery', function(accounts) {
    it("Проверка допустимости призовой комбинации", async () => {
    const lottery =  await Lottery.deployed();
    assert.equal(await lottery.isAllowablePrizeCombination([0,0,0,0,0,0]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,1,0,0,0,0]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,1,0,0,0,46]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,1,2,1,2,46]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,1,2,1,2,46]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,2,3,4,5,46]), false, "Недопустимая призовая комбинация");
    assert.equal(await lottery.isAllowablePrizeCombination([1,2,3,4,5,45]), true, "Допустимая призовая комбинация");
    });
});