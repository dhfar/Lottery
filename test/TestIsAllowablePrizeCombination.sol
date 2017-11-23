pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "../contracts/lottery_6_45.sol";

contract TestIsAllowablePrizeCombination {
    function testIsAllowablePrizeCombination() public{
    lottery_6_45 lottery = new lottery_6_45();
    Assert.isFalse(lottery.isAllowablePrizeCombination([0,0,0,0,0,0]),'пустой билет недопустим');
    Assert.isFalse(lottery.isAllowablePrizeCombination([1,2,3,0,0,0]),'пустой билет недопустим');
    Assert.isFalse(lottery.isAllowablePrizeCombination([1,2,3,0,0,47]),'пустой билет с большими числами недопустим');
    Assert.isTrue(lottery.isAllowablePrizeCombination([1,2,3,4,5,6]),'норм билет');
    Assert.isFalse(lottery.isAllowablePrizeCombination([1,2,113,4,5,6]),'билет с 1 большим числом');
    Assert.isFalse(lottery.isAllowablePrizeCombination([11,23,3,45,25,23]),',билет с нормальными, но повторяющимися числами недопустим');
    }
}
