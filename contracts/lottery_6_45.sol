pragma solidity ^0.4.11;
    
import "./dhf_base_currency.sol";
    
/*смарт-контракт лотереи 4 из 20
 *4 коина идет в джек-пот, 4 - на обычные призы, 2 остается и распределяется между держателями контракта
 *Создано Вопиловым А.
 *3.11.2017
 */
contract lottery_6_45 is dhf_base_currency 
{
    uint public JackPot = 0; //Размер Джек Пота
    uint public regularPrize = 0; //Размер основного приза лотереи
    uint public ticketPrice = 10; // цена билета
    uint public JackPot_assignment = 40; // процент отчислений в Джек-Пот от каждого билета
    uint public regularPrize_assignment = 40; //процент отчислений в регулярный призовой фонд
    uint8 public max_Number = 45; //самое большое число, которое можно загадать в билете
    uint32 public last_lottery_id = 0; // номер последней лотереи
    uint8 public prize_combination_size = 6;//количество чисел в призовой комбинации
    uint8 public max_numbers_in_ticket = 13;//максимальное количество чисел в билете
    uint8[3] public won_percent = [10, 30, 60];//доля регулярного выигрыша для билетов с 3, 4 и 5 совпавшими номерами в билете соответственно
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
        bool active;
    }
    mapping (uint => lottery) public lotteries;

    /*Инициализация лотереи
     *задаем первой лотерее дату и количество билетов в ней
     *Создано Вопиловым А.
     *3.11.2017
     */
    function lottery_6_45() dhf_base_currency (10000, "Lottery 6 of 45", "L6x45") public
    { 
        lotteries[0].date = "06.11.2017";
        lotteries[0].tickets_count = 0;
        lotteries[0].prize_combination = [1,2,3,4,5,6];
        lotteries[0].active = true;
    }
    // Событие покупки билета
    event BuyTicket(uint ticket_number, uint ticket_price, address ticket_owner, uint buy_time, uint lottery_number, string lottery_type, uint8[] ticket_numbers );
    
    /*функция чтения билетов
     *Создано Вопиловым А.
     *@lottery_id идентификатор лотереи
     *@ticket_Id номер билета игрока
     *6.11.2017
     */
    function getTicket(uint lottery_id,uint ticket_Id) public view returns (uint8[13] ticket_numbers, uint8 ticket_prize_level,uint8 numbers_in_ticket,uint money)
    {
        return (lotteries[lottery_id].tickets[ticket_Id].numbers, lotteries[lottery_id].tickets[ticket_Id].compliance_level, lotteries[lottery_id].tickets[ticket_Id].valuable_numbers, lotteries[lottery_id].tickets[ticket_Id].money);
    }
    
    /*Функция проведения тиража лотереи
     *пока что только записывает в каждый билет - сколько совпадений с призовой комбинацией
     *проверяет все билеты на количество угаданных номеров
     *сохраняет число взявших джекпот и делит сумму джекпота
     *Создано Вопиловым А.
     *@array_to_search массив, в котором ищем
     *return bool success - успешность проведения
     *8.11.2017
     */ 
    function finish_lottery() onlyOwner public returns (bool success)
    {
        require(!lotteries[last_lottery_id].active);
        calculate_prizes();
        return true;
    }
    
    /*Функция смены статуса текущего тиража лотереи
     *Создано Вопиловым А.
     *@lottery_activity bool новый статус лотереи 
     *return bool success - успешность проведения
     *14.11.2017
     */ 
    function change_status(bool lottery_activity) onlyOwner public returns (bool success)
    {
        lotteries[last_lottery_id].active = lottery_activity;
        return true;
    }
    
    /*Функция проверки уровня выигрышности билета
     *проверяет билет на количество совпавших номеров
     *Создано Вопиловым А.
     *@array_to_search массив, в котором ищем
     *return uint compliance_level - количество совпавших номеров в билете
     *8.11.2017
     */ 
    function ticket_compliance_level(uint8[13] ticket_numbers) internal constant returns (uint8 compliance_level)
    {
        compliance_level = 0;
        for(uint i = 0; i < 13; i++)
        {
            for(uint k = 0; k < 6; k++)
            {
                if(ticket_numbers[i] == lotteries[last_lottery_id].prize_combination[k])
                    compliance_level++;
            }
        }
        return compliance_level;
    }
    
    /*Расчет размеров призов участников
     *расчитывает призы для участников и записывает размер отчислений для них в отдельный массив
     *Создано Вопиловым А.
     *return bool success - допустим ли такой билет
     *9.11.2017
     */
    function calculate_prizes() internal returns (bool)
    {
        uint jack_pot_numbers;//сколько в тираже оказалось билетов с джекпотом
        uint numbers_5_of_6;//сколько в тираже оказалось билетов с 5 верными номерами
        uint numbers_4_of_6;//сколько в тираже оказалось билетов с 4 верными номерами
        uint numbers_3_of_6;//сколько в тираже оказалось билетов с 3 верными номерами
        uint regularLotteryCountedPrize;//размер распределяемого приза основной лотереи
        uint JackPotCountedPrize;//размер распределяемого приза джек-пота
        uint8 ticketComplianceLevel; 
        //обходим все билеты в лотерее чтобы узнать, сколько каких билетов выиграло и установить им уровень выигрыша
        for (uint i = 0; i < lotteries[last_lottery_id].tickets_count; i++)
        {
            ticketComplianceLevel = ticket_compliance_level(lotteries[last_lottery_id].tickets[i].numbers);
            lotteries[last_lottery_id].tickets[i].compliance_level = ticketComplianceLevel;
            if(ticketComplianceLevel == 3) numbers_3_of_6++;
            if(ticketComplianceLevel == 4) numbers_4_of_6++;
            if(ticketComplianceLevel == 5) numbers_5_of_6++;
            if(ticketComplianceLevel == 6) jack_pot_numbers++;
        }
        //обходим все билеты в лотерее чтобы разделить между ними выигрыш, записываем размер выигрыша в каждый билет
        for (i = 0; i < lotteries[last_lottery_id].tickets_count; i++)
        {
            ticketComplianceLevel = lotteries[last_lottery_id].tickets[i].compliance_level;
            if(ticketComplianceLevel == 3)
                lotteries[last_lottery_id].tickets[i].money = regularPrize * (won_percent[0]) / (numbers_3_of_6 * 100);
            if(ticketComplianceLevel == 4)
                lotteries[last_lottery_id].tickets[i].money = regularPrize * (won_percent[1]) / (numbers_4_of_6 * 100);
            if(ticketComplianceLevel == 5)
                lotteries[last_lottery_id].tickets[i].money = regularPrize * (won_percent[2]) / (numbers_5_of_6 * 100);
            if(ticketComplianceLevel == 6)
                lotteries[last_lottery_id].tickets[i].money = JackPot / jack_pot_numbers;
            if(ticketComplianceLevel < 6) regularLotteryCountedPrize += lotteries[last_lottery_id].tickets[i].money; //шаг за шагом вычисляем, сколько денег мы распределим из основной лотереи
            if(ticketComplianceLevel == 6) JackPotCountedPrize += lotteries[last_lottery_id].tickets[i].money; //шаг за шагом вычисляем, сколько денег мы распределим из джек пота
            balanceOf[lotteries[last_lottery_id].tickets[i].owner] += lotteries[last_lottery_id].tickets[i].money;//перечисление средств за выигрыш на счет победителя
        }
        regularPrize -= regularLotteryCountedPrize;//рассчитываем остаток от основного приза
        JackPot -= JackPotCountedPrize;//рассчитываем остаток от джек пота
        return true;
    }
    
    /*
     *перенос остатков от лотереи на новую лотерею
     *выполняются расчеты отчислений от остатка регулярного призового фонда и переносятся на основу следующего тиража
     *Также выплачиваются дивиденды владельцам
     *Создано Вопиловым А.
     *return bool success - результат переноса фонда
     *9.11.2017
     */
    function donate_next_lottery() internal returns (bool)
    {
        
    }
    
    /*приобретение билета длиной от 6 до 13 номеров в билете
     *Создано Вопиловым А.
     *@number_1-number_13 uint8 числа для билета - всего 13
     *return bool success - допустима ли покупка билета
     *9.11.2017
     */
    function buy_big_ticket(uint8 number_1,uint8 number_2,uint8 number_3,uint8 number_4, uint8 number_5,uint8 number_6,uint8 number_7,uint8 number_8,uint8 number_9,uint8 number_10, uint8 number_11,uint8 number_12,uint8 number_13) public returns (bool success)
    {
        ticket memory new_ticket;
        new_ticket.numbers[0] = number_1;
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
        new_ticket.numbers[12] = number_13;
        return check_ticket_buying(new_ticket);
    }
    
    /*проверка процедуры покупки билета
     *пришлось вынести ее из-за лимитирования на использование переменных в функции - порядка 16!
     *Создано Вопиловым А.
     *@ticked_for_checking проверяемый билет
     *return bool success - допустима ли покупка билета
     *9.11.2017
     */
    function check_ticket_buying(ticket ticked_for_checking) internal returns (bool success)
    {
        require(lotteries[last_lottery_id].active);
        var(allowability, valuable_numbers) = allowable_big_ticket(ticked_for_checking.numbers);
        require(allowability);
        uint current_ticket_price = get_ticket_price(valuable_numbers);// расчет текущей цены билета из количества выбранных чисел в нем
        if (balanceOf[msg.sender] < current_ticket_price) return false;
        ticked_for_checking.owner = msg.sender;
        ticked_for_checking.time = "06.11.2017";
        ticked_for_checking.valuable_numbers = valuable_numbers;
        lotteries[last_lottery_id].tickets[lotteries[last_lottery_id].tickets_count] = ticked_for_checking;
        lotteries[last_lottery_id].tickets_count++;
        balanceOf[msg.sender] -= current_ticket_price;
        JackPot += (current_ticket_price * JackPot_assignment) / 100;//в джекпот отправляется только часть средств с билета, другая часть отправляется в регулярный фонд
        regularPrize += (current_ticket_price * regularPrize_assignment) / 100;//в регулярный приз лотереи отправляется только часть средств с билета, другая часть отправляется в джек пот
        /*
        uint8[] memory temp;
        for (uint8 i = 0; i < 13; i++ ){
            temp[i] = ticked_for_checking.numbers[i];
        }*/
        //BuyTicket(current_ticket_number, current_ticket_price, msg.sender, now, last_lottery_id , "Lottery 6 45", temp);
        return true;
    }
    
    
    /*проверка на допустимость большого билета от 6 до 13 номеров в билете
     *в нем допустимы нули, но число их не должно быть больше 7
     *Создано Вопиловым А.
     **@ticket_numbers проверяемый билет
     *return bool success - допустим ли такой билет по своему составу чисел
     **return uint8 numbers_in_ticket количество значащих чисел в билете - необходимо для определения его цены
     *9.11.2017
     */
    function allowable_big_ticket(uint8[13] ticket_numbers) internal constant returns (bool, uint8 numbers_in_ticket)
    {
        numbers_in_ticket = 13;
        if(ticket_numbers[12] == 0) numbers_in_ticket--;
        for (uint i = 0; i < 12; i++)
        {
            if((ticket_numbers[i] > max_Number) || (ticket_numbers[12] > max_Number) || (numbers_in_ticket < 6)) return (false, numbers_in_ticket);
            if(ticket_numbers[i] == 0) numbers_in_ticket--;
            for(uint k = i + 1; k < 13; k++)
            {
                if ((ticket_numbers[i] == ticket_numbers[k]) && (ticket_numbers[i] != 0)) return (false, numbers_in_ticket);
            }
        }
        return (true,numbers_in_ticket);
    }
    
    
    /*Расчет цены билета от количества номеров в нем
     *Создано Вопиловым А.
     *@number_count uint8 выбрано чисел в билете
     *return uint256 price - результирующая цена билета - рассчитывается от базовой цены билета, помноженной на число комбинаций в нем
     *9.11.2017
     */
    function get_ticket_price(uint8 number_count) public constant returns (uint256 price)
    {
        return (factorial(number_count) * ticketPrice) / (factorial(number_count - prize_combination_size) * factorial(prize_combination_size));
    }
    
    /*Расчет факториала числа
     *Создано Вопиловым А.
     *@number uint256 число для расчета факториала
     *return uint256 fact - значение факториала числа
     *10.11.2017
     */
    function factorial(uint256 number) internal constant returns(uint256 fact) 
    {
        fact = 1;
        if(number == 0) return 1;
        for(uint256 i = 1;i<=number;i++)
            fact = fact * i;
        return fact;
    }
    
    
}