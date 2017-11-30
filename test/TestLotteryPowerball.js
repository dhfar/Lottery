var LP = artifacts.require("LotteryPowerball");

contract('LotteryPowerballTests', function(accounts) {

    it("LotteryPowerball sucsess", async () => {
        const powerBall =  await LP.deployed()

        await powerBall.startLottery(100000, 10000);
        assert.equal(await powerBall.jackPot(), 100000, "Джек пот равен 100000");
        assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
        //console.log(await powerBall.isRunningLottery());
        var buyTicket = await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
        //console.log(buyTicket);
        assert.ok(buyTicket, true, "Билет 1, 2, 3, 4, 5, 6 приобретён");
        assert.ok(await powerBall.stopLottery(), true, "Розыгрыш завершен");
        assert.ok(await powerBall.setPrizeCombination(1, 2, 3, 4, 5, 6), true, "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
        //assert.ok(await powerBall.finishLottery(), true, "Розыгрыш проведен");
        assert.ok(await powerBall.setCountTicketWithPrizeCombinations(0,0,0,0,0,1), true, "Розыгрыш проведен");
        assert.ok(await powerBall.payPrize(0), true, "Розыгрыш проведен");
        var tiket = await powerBall.getTicket(1,0);
        //console.log(tiket);
        assert.equal(tiket[3], 100000, "Победитель получил 100000");
    });
});

contract('LotteryPowerballTicketTests', function(accounts) {
    it("testBuyTickets", async () => {
        const powerBall = await LP.deployed()

    await powerBall.startLottery(100000, 10000);
    assert.equal(await powerBall.jackPot(), 100000, "Джек пот равен 100000");
    assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");

    await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 5, 6 приобретён");

    await powerBall.buyTicket(1, 2, 3, 4, 5, 45);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 5, 45 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 69, 27);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 69, 27 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 70, 26);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 70, 26 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 70, 27);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 70, 27 не приобретён\"");

    await powerBall.buyTicket(0, 2, 3, 4, 5, 45);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 0, 2, 3, 4, 5, 45 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 70, 26);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 0, 2, 3, 4, 5, 0 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 70, 27);
    var lottery = await powerBall.getLottery(1);
    assert.equal(lottery[1], 1, "Билет 1, 2, 3, 4, 5, 0 не приобретён\"");

    await powerBall.buyTicket(1, 2, 3, 4, 69, 26);
    var lottery = await powerBall.getLottery(1);
    //console.log(lottery[1]);
    assert.equal(lottery[1], 2, "Билет 1, 2, 3, 4, 69, 26 приобретён");
});
});
