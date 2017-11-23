pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestCreateAndPlayNewLottery {

    /*
     *тестирование лотереи с верным статусом
     */
    lottery_6_45 lottery = new lottery_6_45();
    
    function testCreateAndPlayOldLottery() public{
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    lottery.changeStatus(false);
    Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея сменила статус на неактивный, и ей можно менять призовую комбинацию");
    Assert.isTrue(lottery.finishLottery(),'Лотерея активна и поэтому проведется');
    }
    
    function testCreateAndPlayNewLottery() public{
    Assert.isTrue(lottery.newLottery(),'Разыграна предыдущая лотерея, новую можно начинать');
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    Assert.equal(lottery.JackPot(),46, "Джек пот должен быть равен 46");
    Assert.equal(lottery.regularPrize(),47, "Основной приз должен быть равен 45");
    lottery.changeStatus(false);
    /*Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея сменила статус на неактивный, и ей можно менять призовую комбинацию");
    Assert.isTrue(lottery.finishLottery(),'Лотерея активна и поэтому проведется');
    var (ticket_numbers, ticket_prize_level,numbers_in_ticket, money) = lottery.getTicket(1,0);
    Assert.equal(money,46,"Первый билет забирает Джек Пот - 46 коинов");
    var (ticket_numbers1, ticket_prize_level1,numbers_in_ticket1, money1) = lottery.getTicket(1,1);
    Assert.equal(money1,4,"Второй билет забирает 4 коина");
    var (ticket_numbers2, ticket_prize_level2,numbers_in_ticket2, money2) = lottery.getTicket(1,2);
    Assert.equal(money2,13,"Третий билет забирает 10 коинов");*/
    }
}