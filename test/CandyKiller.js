var CD = artifacts.require("CandyKiller");

contract('CreateCandyColony', function(accounts) {
    it("Тест: Создание колонии", async () => {
        const CandyKiller =  await CD.deployed()
        var createCandyColony = await CandyKiller.createCandyColony();
        console.log(createCandyColony["logs"]);
});
});