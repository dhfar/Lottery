pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "../contracts/LotteryPowerball.sol";

contract TestLotteryPowerball {

    function testBuyTickets() public {
        LotteryPowerball powerBall = new LotteryPowerball();
        powerBall.startLottery(100000, 10000);
        Assert.equal(powerBall.jackPot(), 100000, "Джек пот равен 100000");
        Assert.equal(powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
        Assert.isTrue(powerBall.buyTicket(1, 2, 3, 4, 5, 6), "Билет 1, 2, 3, 4, 5, 6 приобретён");
        Assert.isTrue(powerBall.buyTicket(1, 2, 3, 4, 69, 26), "Билет 1, 2, 3, 4, 69, 26 приобретён");
        Assert.isFalse(powerBall.buyTicket(1, 2, 3, 4, 5, 45), "Билет 1, 2, 3, 4, 5, 45 не приобретён");
        Assert.isFalse(powerBall.buyTicket(1, 2, 3, 4, 69, 27), "Билет 1, 2, 3, 4, 69, 27 не приобретён");
        Assert.isFalse(powerBall.buyTicket(1, 2, 3, 4, 70, 26), "Билет 1, 2, 3, 4, 70, 26 не приобретён");
        Assert.isFalse(powerBall.buyTicket(1, 2, 3, 4, 70, 27), "Билет 1, 2, 3, 4, 70, 27 не приобретён");
        Assert.isFalse(powerBall.buyTicket(0, 2, 3, 4, 5, 6), "Билет 0, 2, 3, 4, 5, 45 не приобретён");
        Assert.isFalse(powerBall.buyTicket(0, 2, 3, 4, 5, 0), "Билет 0, 2, 3, 4, 5, 0 не приобретён");
        Assert.isFalse(powerBall.buyTicket(1, 2, 3, 4, 5, 0), "Билет 1, 2, 3, 4, 5, 0 не приобретён");
    }

    function testSimpleLottery() public {
        LotteryPowerball powerBall = new LotteryPowerball();
        powerBall.startLottery(100000, 10000);
        Assert.equal(powerBall.jackPot(), 100000, "Джек пот равен 100000");
        Assert.equal(powerBall.regularPrize(), 10000, "Призовой фонд равен 10000");
        Assert.isTrue(powerBall.buyTicket(1, 2, 3, 4, 5, 6), "Билет 1, 2, 3, 4, 5, 6 приобретён");
        Assert.isTrue(powerBall.stopLottery(), "Приобретение билетов завершено");
        Assert.isTrue(powerBall.setPrizeCombination(1, 2, 3, 4, 5, 6), "Задана призовая комбинация 1, 2, 3, 4, 5, 6");
        Assert.isTrue(powerBall.finishLottery(), "Розыгрыш проведен");
        var (owner, time, balls, money) = powerBall.getTicket(1,1);
        Assert.equal(money, 100000, "Победитель получил 100000");
    }
}
