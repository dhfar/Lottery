pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestTickets {
/*
     *тестирование допустимости пустого билета
     */
    function testemptyTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [0,0,0,0,0,0,0,0,0,0,0,0,0];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isFalse(allowability, "Пустой билет должен быть неприемлем");
    }
    
    /*
     *тестирование допустимости билета с 3мя числами
     */
    function test3numbersTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [1,2,0,0,0,3,0,0,0,0,0,0,0];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isFalse(allowability, "билет с 3мя числами неприемлем");
    }
    
    /*
     *тестирование допустимости билета с 4мя числами, одно из них больше предельного
     */
    function testThreeNumbersOneTooBigTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [1,2,0,0,0,0,0,50,0,0,0,0,0];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isFalse(allowability, "билет с 3мя числами неприемлем");
    }
    
    /*
     *тестирование допустимости билета с 6мя числами, нормальными
     */
    function testisGoodTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [4,14,23,26,40,44,0,0,0,0,0,0,0];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isTrue(allowability, ",Билет с 6 нормальными числами приемлем");
    }
    
    /*
     *тестирование допустимости билета с 6ю числами, одно из них больше предельного
     */
    function testisSixAndTooBigTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [4,14,23,26,49,44,0,0,0,0,0,0,0];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isFalse(allowability, ",Билет с 6 числами и одно из них больше 45 неприемлем");
    }
    
    /*
     *тестирование допустимости билета с 13ю числами, одно из них больше предельного
     */
    function testisThertyAndTooBigTicket() public{
    lottery_6_45 lottery = new lottery_6_45();
    uint8[13] memory nmbrs;
    nmbrs = [4,14,23,26,49,44,1,2,3,4,5,6,7];
    var(allowability,qwer) = lottery.isAllowableBigTicket(nmbrs);
    Assert.isFalse(allowability, ",Билет с 13 числами и одно из них больше 45 неприемлем");
    }
}