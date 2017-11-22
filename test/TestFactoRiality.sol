pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestFactoRiality {
    /*
     *тестирование функции факториала
     */
    function testfactoRiality() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.equal(lottery.factorial(0), 1, "factorial 0! = 1");
    Assert.equal(lottery.factorial(1), 1, "factorial 1! = 1");
    Assert.equal(lottery.factorial(2), 2, "factorial 2! = 2");
    Assert.equal(lottery.factorial(3), 6, "factorial 3! = 6");
    Assert.equal(lottery.factorial(10), 3628800, "factorial 10! = 3628800");
    }
}