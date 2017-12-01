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
    uint public lastLotteryId = 0; // номер последней лотереи
    //структура билета
    struct ticket{
        address owner; //владелец билета
        string buyTime; //время и дата покупки билета
        //mapping (uint => uint) numbers; //числа в номере - сейчас сделаем ограниченное число - точно 4 числа в билете
        uint[] numbers; //числа в номере - сейчас сделаем ограниченное число - точно 4 числа в билете
        uint complianceLevel; //число совпавших номеров с выигрышной комбинацией - инициализируется нулем
        uint valuableNumbers;//значащих чисел в билете - ненулевых
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
    
    /*приобретение билета длиной от 6 до 13 номеров в билете
     *Создано Вопиловым А.
     *@number_1-number_13 uint числа для билета - всего 13
     *return bool success - допустима ли покупка билета
     *1.12.2017
     */
    function buyTicket(
            uint number_1,
            uint number_2,
            uint number_3,
            uint number_4,
            uint number_5,
            uint number_6,
            uint number_7,
            uint number_8,
            uint number_9,
            uint number_10,
            uint number_11,
            uint number_12,
            uint number_13)
        public returns (bool success){
        uint[] memory currentTicket;// = [number_1, number_2, number_3, number_4, number_5, number_6, number_7, number_8, number_9, number_10, number_11, number_12, number_13];
        /*currentTicket.push(number_1);
        currentTicket.push(number_2);
        currentTicket.push(number_3);
        currentTicket.push(number_4);
        currentTicket.push(number_5);
        currentTicket.push(number_6);
        currentTicket.push(number_7);
        currentTicket.push(number_8);
        currentTicket.push(number_9);
        currentTicket.push(number_10);
        currentTicket.push(number_11);
        currentTicket.push(number_12);
        currentTicket.push(number_13);*/
        uint[13] memory ticketNumbers;
        ticketNumbers[0] = number_1;
        ticketNumbers[1] = number_2;
        ticketNumbers[2] = number_3;
        ticketNumbers[3] = number_4;
        ticketNumbers[4] = number_5;
        ticketNumbers[5] = number_6;
        ticketNumbers[6] = number_7;
        ticketNumbers[7] = number_8;
        ticketNumbers[8] = number_9;
        ticketNumbers[9] = number_10;
        ticketNumbers[10] = number_11;
        ticketNumbers[11] = number_12;
        ticketNumbers[12] = number_13;
        //normalizeTicket(number_1, number_2, number_3, number_4, number_5, number_6, number_7, number_8, number_9, number_10, number_11, number_12, number_13);
        normalizeTicket(ticketNumbers);
        /*new_ticket.numbers[0] = number_1;
        new_ticket.numbers[1] = number_2;
        new_ticket.numbers[2] = number_3;
        new_ticket.numbers[3] = number_4;
        new_ticket.numbers[4] = number_5;
        new_ticket.numbers[5] = number_6;
        new_ticket.numbers[6] = number_7;
        new_ticket.numbers[7] = number_8;
        new_ticket.numbers[8] = number_9;
        new_ticket.numbers[9] = number_10;
        new_ticket.numbers[10] = number_11;
        new_ticket.numbers[11] = number_12;
        new_ticket.numbers[12] = number_13;*/
        //return checkTicketBuying(new_ticket);
        return true;
    }
    
    /*проверка процедуры покупки билета
     *пришлось вынести ее из-за лимитирования на использование переменных в функции - порядка 16!
     *Создано Вопиловым А.
     *@ticked_for_checking проверяемый билет
     *return bool success - допустима ли покупка билета
     *1.12.2017
     */
    function checkTicketBuying(ticket ticked_for_checking) internal returns (bool success)
    {
        if(!lotteries[lastLotteryId].active) return false;
        var(allowability, valuable_numbers) = isAllowableBigTicket(ticked_for_checking.numbers);
        if(!allowability) return false;
        uint current_ticket_price = getTicketPrice(valuable_numbers);// расчет текущей цены билета из количества выбранных чисел в нем
        if (balanceOf[msg.sender] < current_ticket_price) return false;
        ticked_for_checking.owner = msg.sender;
        ticked_for_checking.buyTime = "06.11.2017";
        ticked_for_checking.valuableNumbers = valuable_numbers;
        lotteries[lastLotteryId].tickets[lotteries[lastLotteryId].tickets_count] = ticked_for_checking;
        lotteries[lastLotteryId].tickets_count++;
        balanceOf[msg.sender] -= current_ticket_price;
        JackPot += (current_ticket_price * JackPotAssignment) / 100;//в джекпот отправляется только часть средств с билета, другая часть отправляется в регулярный фонд
        regularPrize += (current_ticket_price * regularPrizeAssignment) / 100;//в регулярный приз лотереи отправляется только часть средств с билета, другая часть отправляется в джек пот
        /*
        uint8[] memory temp;
        for (uint8 i = 0; i < 13; i++ ){
            temp[i] = ticked_for_checking.numbers[i];
        }*/
        //BuyTicket(current_ticket_number, current_ticket_price, msg.sender, now, lastLotteryId , "Lottery 6 45", temp);
        return true;
    }
    
    function normalizeTicket(
            /*uint number_1,
            uint number_2,
            uint number_3,
            uint number_4,
            uint number_5,
            uint number_6,
            uint number_7,
            uint number_8,
            uint number_9,
            uint number_10,
            uint number_11,
            uint number_12,
            uint number_13*/
            uint[13] ticketNumbers)
    returns (bool result,uint numbersInTicket,uint[] normalTicket)
    {
        //uint[13] memory ticketNumbers;
        return normalizeTicketInner(ticketNumbers);
    }
    
    function normalizeTicketInner(uint[13] ticketNumbers) returns (bool result,uint numbersInTicket,uint[] normalTicket)
    {
        numbersInTicket = 13;
        if(ticketNumbers[12] == 0) numbersInTicket--;
        for (uint i = 0; i < 12; i++)
        {
            if((ticketNumbers[i] > maxNumber) || (ticketNumbers[12] > maxNumber) || (numbersInTicket < 6)) return (false, numbersInTicket,normalTicket);
            if(ticketNumbers[i] == 0) numbersInTicket--;
            for(uint k = i + 1; k < 13; k++)
            {
                if ((ticketNumbers[i] == ticketNumbers[k]) && (ticketNumbers[i] != 0)) return (false, numbersInTicket,normalTicket);
            }
        }
        return (true,numbersInTicket,normalTicket);
    }
    
    /*проверка на допустимость большого билета от 6 до 13 номеров в билете
     *в нем допустимы нули, но число их не должно быть больше 7
     *Создано Вопиловым А.
     **@ticketNumbers проверяемый билет
     *return bool success - допустим ли такой билет по своему составу чисел
     **return uint8 numbers_in_ticket количество значащих чисел в билете - необходимо для определения его цены
     *9.11.2017
     */
    function isAllowableBigTicket(uint[] ticketNumbers) public constant returns (bool, uint8 numbersInTicket)
    {
        numbersInTicket = 13;
        if(ticketNumbers[12] == 0) numbersInTicket--;
        for (uint i = 0; i < 12; i++)
        {
            if((ticketNumbers[i] > maxNumber) || (ticketNumbers[12] > maxNumber) || (numbersInTicket < 6)) return (false, numbersInTicket);
            if(ticketNumbers[i] == 0) numbersInTicket--;
            for(uint k = i + 1; k < 13; k++)
            {
                if ((ticketNumbers[i] == ticketNumbers[k]) && (ticketNumbers[i] != 0)) return (false, numbersInTicket);
            }
        }
        return (true,numbersInTicket);
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