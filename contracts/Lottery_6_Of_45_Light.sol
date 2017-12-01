pragma solidity ^0.4.16;
    
import "./DHFBaseCurrency.sol";
    
/*смарт-контракт лотереи 4 из 20
 *4 коина идет в джек-пот, 4 - на обычные призы, 2 остается и распределяется между держателями контракта
 *Создано Вопиловым А.
 *1.12.2017
 */
contract Lottery_6_Of_45_Light is DHFBaseCurrency 
{
    uint public JackPot = 0; //Размер Джек Пота
    uint public regularPrize = 0; //Размер основного приза лотереи
    uint public ticketPrice = 10; // цена билета
    uint public JackPotAssignment = 40; // процент отчислений в Джек-Пот от каждого билета
    uint public regularPrizeAssignment = 40; //процент отчислений в регулярный призовой фонд
    uint public prizeCombinationSize = 6;//количество чисел в призовой комбинации
    uint public maxNumber = 45; //самое большое число, которое можно загадать в билете
    //структура билета
    struct ticket{
        address owner; //владелец билета
        string time; //время и дата покупки билета
        uint8[13] numbers; //числа в номере - сейчас сделаем ограниченное число - точно 4 числа в билете
        uint8 compliance_level; //число совпавших номеров с выигрышной комбинацией - инициализируется нулем
        uint8 valuable_numbers;//значащих чисел в билете - ненулевых
        uint money;//выграно данным билетом денег
    }
    //структура 1го тиража лотереи
    struct lottery{
        string date; // дата проведения лотереи
        mapping(uint => ticket) tickets; //все билеты одной лотереи.
        uint tickets_count; //количество билетов в этой лотерее
        uint[6] prize_combination; //выигрышная комбинация текущего тиража лотереи
        bool active; //ведется или не ведется прием ставок
        bool played; //проведен ли розыгрыш
    }
    mapping (uint => lottery) public lotteries;
    
    /*Инициализация лотереи
     *задаем первой лотерее дату и количество билетов в ней
     *Создано Вопиловым А.
     *3.11.2017
     */
    function Lottery_6_Of_45_Light() DHFBaseCurrency (10000, "Lottery 6 of 45", "L6x45") public
    { 
        lotteries[0].date = "06.11.2017";
        lotteries[0].tickets_count = 0;
        lotteries[0].prize_combination = [0,0,0,0,0,0];
        lotteries[0].active = true;
        lotteries[0].played = false;
    }
    
    /*проверка на допустимость призовой комбинации - ровно 6 номеров в билете от 1 до 45
     *в нем допустимы нули, но число их не должно быть больше 7
     *Создано Вопиловым А.
     *@prizeNumbers проверяемый билет
     *return bool success - допустим ли такой билет по своему составу чисел
     *22.11.2017
     */
    function isAllowablePrizeCombination(uint[6] prizeNumbers) public constant returns (bool)
    {
        if((prizeNumbers[5] == 0) || (prizeNumbers[5] > maxNumber)) return false;
        for (uint i = 0; i < 5; i++)
        {
            if((prizeNumbers[i] > maxNumber) || (prizeNumbers[i] == 0)) return false;
            for(uint k = i + 1; k < 6; k++)
                if (prizeNumbers[i] == prizeNumbers[k]) return false;
        }
        return true;
    }
    
    /*Расчет факториала числа
     *Создано Вопиловым А.
     *@number uint число для расчета факториала
     *return uint fact - значение факториала числа
     *1.11.2017
     */
    function factorial(uint number) public constant returns(uint fact) 
    {
        fact = 1; 
        if(number == 0) return 1;
        for(uint i = 1;i<=number;i++)
            fact = fact * i;
        return fact;
    }
    
    /*Расчет цены билета от количества номеров в нем
     *Создано Вопиловым А.
     *@numberCount uint8 выбрано чисел в билете
     *return uint256 price - результирующая цена билета - рассчитывается от базовой цены билета, помноженной на число комбинаций в нем
     *1.12.2017
     */
    function getTicketPrice(uint numberCount) public constant returns (uint price)
    {
        if(numberCount < prizeCombinationSize) return 0;
        return (factorial(numberCount) * ticketPrice) / (factorial(numberCount - prizeCombinationSize) * factorial(prizeCombinationSize));
    }
}