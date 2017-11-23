pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestGetTicketAsStruct {

    /*
     *тестирование лотереи с верным статусом
     */
     
    struct smallticket{
        address owner; //владелец билета
        string time; //время и дата покупки билета
        uint8[13] numbers; //числа в номере - сейчас сделаем ограниченное число - точно 4 числа в билете
        uint8 compliance_level; //число совпавших номеров с выигрышной комбинацией - инициализируется нулем
        uint8 valuable_numbers;//значащих чисел в билете - ненулевых
        uint money;//выграно данным билетом денег
    }
    
    function testGetTicketAsStruct() public{/*
    
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isTrue(lottery.buyTicket(1,2,3,4,5,6,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,6,0,0,0,0,0,0,0 допустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,40,0,0,0,0,0,0,0), "Билет 1,2,3,10,20,40,0,0,0,0,0,0,0 допустим");
    Assert.isFalse(lottery.buyTicket(1,2,3,4,5,67,0,0,0,0,0,0,0), "Билет 1,2,3,4,5,67,0,0,0,0,0,0,0 недопустим");
    Assert.isTrue(lottery.buyTicket(1,2,3,10,20,4,30,0,0,0,0,0,0), "Билет 1,2,3,10,20,4,30,0,0,0,0,0,0 допустим");
    Assert.equal(lottery.JackPot(),36, "Джек пот должен быть равен 36");
    Assert.equal(lottery.regularPrize(),36, "Основной приз должен быть равен 36");
    lottery.changeStatus(false);
    Assert.isTrue(lottery.updatePrizeCombination(1,2,3,4,5,6),"Лотерея еще не сменила статус на неактивный, и ей нельзя менять призовую комбинацию");
    Assert.isTrue(lottery.finishLottery(),'Лотерея активна и поэтому проведется');
    
    lottery_6_45.ticket memory thisTicket = lottery.getTicketAsStruct(0,0);
    Assert.equal(thisTicket.money,36,"Первый билет забирает Джек Пот - 36 коинов");
    thisTicket = lottery.getTicketAsStruct(0,1);
    Assert.equal(thisTicket.money,3,"Второй билет забирает 3 коина");
    thisTicket =  lottery.getTicketAsStruct(0,2);
    Assert.equal(thisTicket.money,10,"Третий билет забирает 10 коинов");*/
    }
}