pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestCreateAndPlayNewLotteryFullyC {

    /*
     *тестирование лотереи с верным статусом
     */
    lottery_6_45 lottery = new lottery_6_45();
    
    function testCreateAndPlayLottery() public{
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    lottery.changeStatus(false);
    Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея сменила статус на неактивный, и ей можно менять призовую комбинацию");
    Assert.isTrue(lottery.finishLottery(),'Лотерея активна и поэтому проведется');
    Assert.isTrue(lottery.newLottery(),'Разыграна предыдущая лотерея, новую можно начинать');
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    lottery.changeStatus(false);
    Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея сменила статус на неактивный, и ей можно менять призовую комбинацию");
    lottery.finishLottery();
    var (ticket_numbers2, ticket_prize_level2,numbers_in_ticket2, money2) = lottery.getTicket(1,2);
    Assert.equal(money2,14,"Третий билет забирает 14 коинов");
    }
}