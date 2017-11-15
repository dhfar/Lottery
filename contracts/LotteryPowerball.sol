pragma solidity ^0.4.11;
    
import "./dhf_base_currency.sol";

contract LotteryPowerball is MyAdvancedToken {
    
    bool isRunning = false;
    
    uint public jackPot = 0; //Размер Джек Пота
    uint public regularPrize = 0; //Размер основного приза лотереи
    uint public ticketPrice = 40; // цена билета
    uint public jackPotAssignment = 40; // процент отчислений в Джек-Пот от каждого билета
    uint public regularPrizeAssignment = 40; //процент отчислений в регулярный призовой фонд
    uint8 public maxWhiteBallNumberInTicket = 69; //самое большое число, которое можно загадать в билете
    uint8 public maxRedBallNumberInTicket = 26; //самое большое число, которое можно загадать в билете
    uint8 public prizeCombinationSize = 6;//количество чисел в призовой комбинации
    uint8 public maxBallsInTicket = 6;//максимальное количество чисел в билете
    
    uint32 public lastLotteryId = 0; // номер последней лотереи
    // структура билета
    struct PowerballTicket {
        address owner; //владелец билета
        string time; //время и дата покупки билета
        uint8[6] balls; // первые элементов 5 белые шары, 6 элемент красный шар
        uint8[2] complianceLevel; // первый элемент число совпавших белых, второй - число совпавших красных
        uint money;//выграно данным билетом денег
    }
    
    struct PowerballLottery {
        string date; // дата проведения лотереи
        mapping(uint => PowerballTicket) tickets; //все билеты одной лотереи.
        uint ticketsCount; //количество билетов в этой лотерее
        uint[6] prizeCombination; // выигрышная комбинация текущего тиража лотереи
    }
    // история розыгрышей
    mapping (uint => PowerballLottery) public historyPowerballLotteries;
    // текущий розыгрыш 
    PowerballLottery currentPowerballLottery;
    // конструктор контракта
    function LotteryPowerball() MyAdvancedToken (10000, "Lottery Powerball", "LP") public { 
        
    }
    // старт лотереи
    function startLottery() private onlyOwner {
        isRunning = true;
    }
    // завершение лотереи
    function stopLottery() private onlyOwner {
        isRunning = false;
    }
    // Функция проверки текущего состояния лотереи
    function isRunningLottery() public returns (bool res) {
        require(isRunning);
        return true;
    }
    
    function BuyTicket(uint8 firstWhiteBall, uint8 secondWhiteBall, uint8 thirdWhiteBall, uint8 fourWhiteBall, uint8 fiveWhiteBall, uint8 redBall) public returns (bool res) {
        return true;
    }
}