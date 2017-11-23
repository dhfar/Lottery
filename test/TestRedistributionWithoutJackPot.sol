pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestRedistributionWithoutJackPot {

    /*
     *тестирование результатов перерасчета остатков для игры без выиграного джек пота
     */
    function testRedistributionWithoutJackPot() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,7,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,7,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buyTicket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    lottery.changeStatus(false);
    Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея сменила статус на неактивный, и ей можно менять призовую комбинацию");
    Assert.isTrue(lottery.finishLottery(),'Лотерея активна и поэтому проведется');
    var (ticket_numbers, ticket_prize_level,numbers_in_ticket, money, addr) = lottery.getTicket(0,0);
    Assert.equal(money,21,"Первый билет забирает 21 коин");
    (ticket_numbers, ticket_prize_level,numbers_in_ticket, money, addr) = lottery.getTicket(0,1);
    Assert.equal(money,3,"Второй билет забирает 3 коина");
    (ticket_numbers, ticket_prize_level,numbers_in_ticket, money, addr) = lottery.getTicket(0,2);
    Assert.equal(money,10,"Третий билет забирает 10 коинов");
    Assert.equal(lottery.JackPot(),36, "Джек пот должен быть равен 36");
    Assert.equal(lottery.regularPrize(),2, "Основной приз должен быть равен 2");
    }
}