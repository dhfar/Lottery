pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestUnfinishLottery {
    
    /*
     *тестирование лотереи с обломом из-за неверного статуса лотереи
     */
    function testLotteryBadActive() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buyTicket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    Assert.equal(lottery.JackPot(),36, "Джек пот должен быть равен 36");
    Assert.equal(lottery.regularPrize(),36, "Джек пот должен быть равен 36");
    Assert.isFalse(lottery.finishLottery(),'Лотерея неактивна и поэтому не проведется');
    }
}