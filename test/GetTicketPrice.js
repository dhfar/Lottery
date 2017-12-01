var Lottery = artifacts.require("Lottery_6_Of_45_Light");

contract('lottery', function(accounts) {
    it("Проверка цены билета", async () => {
    const lottery =  await Lottery.deployed();
    assert.equal(await lottery.getTicketPrice(0), 0, "Цена билета из 1 номера");
    assert.equal(await lottery.getTicketPrice(1), 0, "Цена билета из 2 номеров");
    assert.equal(await lottery.getTicketPrice(2), 0, "Цена билета из 3 номеров");
    assert.equal(await lottery.getTicketPrice(4), 0, "Цена билета из 4 номеров");
    assert.equal(await lottery.getTicketPrice(5), 0, "Цена билета из 5 номеров");
    assert.equal(await lottery.getTicketPrice(6), 10, "Цена билета из 6 номеров");
    assert.equal(await lottery.getTicketPrice(7), 70, "Цена билета из 7 номеров");
    assert.equal(await lottery.getTicketPrice(8), 280, "Цена билета из 8 номеров");
    assert.equal(await lottery.getTicketPrice(9), 840, "Цена билета из 9 номеров");
    assert.equal(await lottery.getTicketPrice(10), 2100, "Цена билета из 10 номеров");
    assert.equal(await lottery.getTicketPrice(11), 4620, "Цена билета из 11 номеров");
    assert.equal(await lottery.getTicketPrice(12), 9240, "Цена билета из 12 номеров");
    assert.equal(await lottery.getTicketPrice(13), 17160, "Цена билета из 13 номеров");
    });
});
