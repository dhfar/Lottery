pragma solidity ^0.4.11;
    
import "./dhf_base_currency.sol";
    
/*смарт-контракт лотереи 4 из 20
 *4 коина идет в джек-пот, 4 - на обычные призы, 2 остается и распределяется между держателями контракта
 *Создано Вопиловым А.
 *3.11.2017
 */
contract lottery_4_20 is MyAdvancedToken 
{
    uint public JackPot = 0; //Размер Джек Пота
    uint public ticketPrice = 10; // цена билета
    uint public JackPot_assignment = 4; // размер отчислений в Джек-Пот
    uint public regularPrize_assignment = 4; //размер отчислений в регулярный призовой фонд
    uint8 public max_Number = 20; //самое большое число, которое можно загадать в билете
    uint32 public last_lottery_id = 0; // номер последней лотереи
    //структура билета
    struct ticket{
        address owner; //владелец билета
        string time; //время и дата покупки билета
        uint8[4] numbers; //числа в номере - сейчас сделаем ограниченное число - точно 4 числа в билете
    }
    //структура 1го тиража лотереи
    struct lottery{
        string date; // дата проведения лотереи
        mapping(uint => ticket) tickets; //все билеты одной лотереи.
        uint tickets_count; //количество билетов в этой лотерее
        uint[4] prize_combination; //выигрышная комбинация текущего тиража лотереи
    }
    mapping (uint => lottery) public lotteries;

    /*Инициализация лотереи
     *задаем первой лотерее дату и количество билетов в ней
     *Создано Вопиловым А.
     *3.11.2017
     */
    function lottery_4_20() MyAdvancedToken (10000, "Lottery 4 of 20", "L4x20") public
    { 
        lotteries[0].date = "06.11.2017";
        lotteries[0].tickets_count = 0;
        lotteries[0].prize_combination = [1,2,5,10];
    }
    
    /*функция приобретения билета
     *Создано Вопиловым А.
     *3.11.2017
     *@number_1 - первое число в билете
     *@number_2 - второе число в билете
     *@number_3 - третье число в билете
     *@number_4 - четвертое число в билете
     */
    function buyTicket(uint8 number_1,uint8 number_2,uint8 number_3,uint8 number_4) public returns (bool success)
    {
        ticket memory new_ticket;
        if (balanceOf[msg.sender] < ticketPrice) return false;
        new_ticket.numbers = [number_1, number_2, number_3, number_4];
        require(allowable_ticket(new_ticket.numbers));
        new_ticket.owner = msg.sender;
        new_ticket.time = "06.11.2017";
        lotteries[last_lottery_id].tickets[lotteries[last_lottery_id].tickets_count] = new_ticket;
        lotteries[last_lottery_id].tickets_count++;
        balanceOf[msg.sender] -= ticketPrice;
        JackPot += JackPot_assignment;
        return true;
    }
        
    /*функция чтения билетов
     *Создано Вопиловым А.
     *@lottery_id идентификатор лотереи
     *@ticket_Id ноомер билета игрока
     *6.11.2017
     */
    function getTicket(uint lottery_id,uint ticket_Id) public returns (uint8[4])
    {
        return lotteries[lottery_id].tickets[ticket_Id].numbers;
    }
        
    /*Проверка на допустимость билета
     *проверяет, повторяются ли числа в билете и вписываются ли они в диапазон от 1 до максимально допустимого номера в лотерее
     *Создано Вопиловым А.
     *@array_to_search массив, в котором ищем
     *return bool success - допустим ли такой билет
     *6.11.2017
     */
    function allowable_ticket(uint8[4] array_to_search) internal returns (bool success)
    {
        for (uint i = 0; i < 3; i++)
        {
            if((array_to_search[i] == 0) || (array_to_search[i] > max_Number)) return false;
            for(uint k = i + 1; k < 4; k++)
                if ((array_to_search[i] == array_to_search[k]) || (array_to_search[k] == 0) || (array_to_search[k] > max_Number)) return false;
        }
        return true;
    }
}