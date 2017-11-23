pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "../contracts/LotteryPowerball.sol";

contract TestLotteryPowerball {
    function BuyTickets() public {
        LotteryPowerball powerBall = new LotteryPowerball();
        Assert.isTrue(powerBall.buyTicket(1, 2, 3, 4, 5, 6), "Билет 1, 2, 3, 4, 5, 6 приобретён");
    }
}
