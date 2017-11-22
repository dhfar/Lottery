pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestTicketPrice {
    /*
     *тестирование стоимости билета
     */
    function testgetTicketPrice() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.equal(lottery.getTicketPrice(0), 0, "");
    Assert.equal(lottery.getTicketPrice(1), 0, "");
    Assert.equal(lottery.getTicketPrice(2), 0, "");
    Assert.equal(lottery.getTicketPrice(3), 0, "");
    Assert.equal(lottery.getTicketPrice(4), 0, "");
    Assert.equal(lottery.getTicketPrice(5), 0, "");
    Assert.equal(lottery.getTicketPrice(6), 10, "");
    Assert.equal(lottery.getTicketPrice(7), 70, "");
    Assert.equal(lottery.getTicketPrice(8), 280, "");
    Assert.equal(lottery.getTicketPrice(9), 840, "");
    Assert.equal(lottery.getTicketPrice(10), 2100, "");
    Assert.equal(lottery.getTicketPrice(11), 4620, "");
    Assert.equal(lottery.getTicketPrice(12), 9240, "");
    Assert.equal(lottery.getTicketPrice(13), 17160, "");
    }
}