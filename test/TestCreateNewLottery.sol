pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestCreateNewLottery {

    /*
     *тестирование создание новой лотереи .пока предыдущая активна и неразыграна
     */
    function testCreateNewLotteryFail() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,7,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,7,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buyTicket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    bool createLotteryResult = lottery.newLottery();
    uint32 lastLotteryId = lottery.last_lottery_id();
    Assert.isFalse(createLotteryResult,'Пока не завершена предыдущая лотерея, новую нельзя начинать');
    }
    
    /*
     *тестирование создание новой лотереи .пока предыдущая неактивна, но неразыграна
     */
    function testCreateNewLotteryInactiveFail() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,7,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,7,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buyTicket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    lottery.changeStatus(false);
    bool createLotteryResult = lottery.newLottery();
    Assert.isFalse(createLotteryResult,'Пока не разыграна предыдущая лотерея, новую нельзя начинать');
    }
}