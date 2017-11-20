pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestBuyTicket {
    /*
     *тестирование покупки нормального билета
     */
    function testNormalTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buy_big_ticket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.equal(lottery.JackPot(),4, "Джек пот должен быть равен 4");
    }
    
    /*
     *тестирование покупки билета с числом больше 45
     */
    function testTicketWithBigNumber() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isFalse(lottery.buy_big_ticket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.equal(lottery.JackPot(),0, "Джек пот должен быть равен 0");
    }
    
    /*
     *тестирование покупки нескольки билетов
     */
    function testManyTickets() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buy_big_ticket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buy_big_ticket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buy_big_ticket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buy_big_ticket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    Assert.equal(lottery.JackPot(),36, "Джек пот должен быть равен 36");
    Assert.equal(lottery.regularPrize(),36, "Джек пот должен быть равен 36");
    }
}