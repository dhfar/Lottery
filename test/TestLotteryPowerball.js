const LP = artifacts.require("LotteryPowerball");

contract('LotteryPowerballTests', function(accounts) {
    
    it("LotteryPowerball success", async () => {
        const powerBall =  await LP.deployed()

        await powerBall.startLottery(100000, 10000);
        const jackPot = await powerBall.jackPot();
        const regularPrize = await powerBall.regularPrize();
        assert.equal(jackPot.toNumber(), 100000, "Джек пот равен 100000");
        assert.equal(regularPrize.toNumber(), 10000, "Призовой фонд равен 10000");
        
        
        const buyTicket = await powerBall.buyTicket.call(1, 2, 3, 4, 5, 6);
        
        assert.isTrue(buyTicket, "Билет 1, 2, 3, 4, 5, 6 приобретён"); // Contract returning?
        assert.isTrue(await powerBall.stopLottery.call(), "Розыгрыш завершен");
        
        assert.isTrue(await powerBall.setPrizeCombination.call(1, 2, 3, 4, 5, 6), "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
        
        assert.isTrue(await powerBall.setCountTicketWithPrizeCombinations.call(0,0,0,0,0,1), "Розыгрыш проведен");
        assert.isTrue(await powerBall.payPrize.call(0), "Розыгрыш проведен");
        const ticket = await powerBall.getTicket.call(1,0);
        //console.log(ticket);
        console.log(ticket[3]);
        console.log(ticket[3].toNumber());
        assert.equal(ticket[3].toNumber(), 100000, "Победитель получил 100000");
        assert.isTrue(await powerBall.finishLottery(), 'Лотерея завершена');
    });
});


contract('LotteryPowerballTwoTests', function(accounts) {
    it("LotteryPowerball success", async () => {
        const powerBall =  await LP.deployed()

        await powerBall.startLottery(100000, 10000);
        assert.equal(await powerBall.jackPot(), 100000, "Джек пот равен 100000");
        assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
        
        
        const buyTicket = await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
        
        assert.isTrue(buyTicket, "Билет 1, 2, 3, 4, 5, 6 приобретён");
        assert.isTrue(await powerBall.stopLottery(), "Розыгрыш завершен");
        assert.isTrue(await powerBall.setPrizeCombination(1, 2, 3, 4, 5, 6), "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
        assert.isTrue(await powerBall.setCountTicketWithPrizeCombinations(0,0,0,0,0,1), "Розыгрыш проведен");
        assert.isTrue(await powerBall.payPrize(0), "Розыгрыш проведен");
    
        const tiket = await powerBall.getTicket(1,0);
        assert.equal(tiket[3], 10000, "Победитель получил 100000");
        
        assert.isTrue(await powerBall.finishLottery(), "Лотерея завершена");

        await powerBall.startLottery(100000, 10000);
        assert.equal(await powerBall.jackPot(), 110000, "Джек пот равен 110000");
        assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
        
        //TODO
        const buyTicket2 = await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
        assert.isTrue(buyTicket2, "Билет 1, 2, 3, 4, 5, 6 приобретён");
        assert.isTrue(await powerBall.stopLottery(), "Розыгрыш завершен");
        assert.isTrue(await powerBall.setPrizeCombination(1, 2, 3, 4, 5, 6), "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
    
        assert.isTrue(await powerBall.setCountTicketWithPrizeCombinations(0,0,0,0,0,1), "Розыгрыш проведен");
        assert.isTrue(await powerBall.payPrize(0), "Розыгрыш проведен");

        const tiket2 = await powerBall.getTicket(2,0);
        assert.equal(tiket2[3], 110000, "Победитель получил 110000");
        assert.isTrue(await powerBall.finishLottery(), 'Лотерея завершена');
    });
});

contract('LotteryPowerballReSetPrizeCombination', function(accounts) {
    it("LotteryPowerball success", async () => {
        const powerBall =  await LP.deployed()

    await powerBall.startLottery(100000, 10000);
    assert.equal(await powerBall.jackPot(), 100000, "Джек пот равен 100000");
    assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
    //console.log(await powerBall.isRunningLottery());
    var buyTicket = await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
    var buyTicket = await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
    //console.log(buyTicket);
    assert.ok(buyTicket, true, "Билет 1, 2, 3, 4, 5, 6 приобретён");
    assert.ok(await powerBall.stopLottery(), true, "Розыгрыш завершен");
    assert.ok(await powerBall.setPrizeCombination(1, 2, 3, 4, 5, 6), true, "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
    assert.ok(await powerBall.setPrizeCombination(6, 5, 4, 3, 2, 1), true, "Попытка измение комбинацию 6, 5, 4, 3, 2, 1");
    assert.ok(await powerBall.setCountTicketWithPrizeCombinations(0,0,0,0,0,2), true, "Розыгрыш проведен");
    assert.ok(await powerBall.payPrize(0), true, "Розыгрыш проведен");
    assert.ok(await powerBall.payPrize(1), true, "Розыгрыш проведен");
    var tiket = await powerBall.getTicket(1,0);
    //console.log(tiket);
    assert.equal(tiket[3], 50000, "Победитель получил 50000");
    await powerBall.finishLottery();
});
});

contract('LotteryPowerballManyTicketsTest', function(accounts) {
    it("LotteryPowerball success", async () => {
        const powerBall =  await LP.deployed()

    await powerBall.startLottery(100000, 10000);
    assert.equal(await powerBall.jackPot(), 100000, "Джек пот равен 100000");
    assert.equal(await powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
    //console.log(await powerBall.isRunningLottery());
    var buyTicket = await powerBall.buyTicket(30, 22, 26, 17, 15, 6);
    //console.log(buyTicket);
    assert.ok(buyTicket, true, "Билет 30, 22, 26, 17, 15, 6 приобретён");
    await powerBall.buyTicket(1, 2, 3, 4, 5, 6);
    await powerBall.buyTicket(2, 3, 4, 5, 6, 7);
    await powerBall.buyTicket(3, 4, 5, 6, 7, 8);
    await powerBall.buyTicket(4, 5, 6, 7, 8, 9);
    await powerBall.buyTicket(5, 6, 7, 8, 9, 1);
    await powerBall.buyTicket(6, 7, 8, 9, 1, 2);
    await powerBall.buyTicket(7, 8, 9, 1, 2, 3);
    await powerBall.buyTicket(8, 9, 1, 2, 3, 4);
    await powerBall.buyTicket(30, 22, 26, 17, 15, 7);
    var lotteryData = await powerBall.currentPowerballLottery();
    assert.equal(lotteryData[1], 10, "Куплено 10 билетов ");
    assert.ok(await powerBall.stopLottery(), true, "Розыгрыш завершен");
    assert.ok(await powerBall.setPrizeCombination(30, 22, 26, 17, 15, 6), true, "Задана призовая комбинация 30, 22, 26, 17, 15, 6");
    assert.ok(await powerBall.setCountTicketWithPrizeCombinations(0,0,0,0,1,1), true, "Розыгрыш проведен");
    assert.ok(await powerBall.payPrize(0), true, "Розыгрыш проведен");
    assert.ok(await powerBall.payPrize(9), true, "Розыгрыш проведен");
    var tiket = await powerBall.getTicket(1,0);
    assert.equal(tiket[3], 100000, "Победитель получил 100000");
    var tiket = await powerBall.getTicket(1,9);
    assert.equal(tiket[3], 7500, "Победитель получил 7500");
    await powerBall.finishLottery();
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
*/