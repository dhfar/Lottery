pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "../contracts/LotteryPowerball.sol";

contract TestLotteryPowerball {

    function testBuyTickets() public {
        LotteryPowerball powerBall = new LotteryPowerball();
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
}
