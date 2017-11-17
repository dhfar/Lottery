pragma solidity ^0.4.11;
    
import "./DHFBaseCurrency.sol";

contract LotteryPowerball is DHFBaseCurrency {
    
    bool isRunning = false;
    
    uint public jackPot = 0; //Размер Джек Пота
    uint public regularPrize = 0; //Размер основного приза лотереи
    uint public ticketPrice = 40; // цена билета
    uint public jackPotAssignment = 40; // процент отчислений в Джек-Пот от каждого билета
    uint public regularPrizeAssignment = 40; //процент отчислений в регулярный призовой фонд
    uint public maxWhiteBallNumberInTicket = 69; //самое большое число, которое можно загадать в билете
    uint public maxRedBallNumberInTicket = 26; //самое большое число, которое можно загадать в билете
    uint public prizeCombinationSize = 6;//количество чисел в призовой комбинации
    uint public maxBallsInTicket = 6;//максимальное количество чисел в билете
    
    uint public countWhiteBallsInTicket = 5;
    uint public countRedBallsInTicket = 1;
    
    uint32 public lastLotteryId = 0; // номер последней лотереи
    // структура билета
    struct PowerballTicket {
        address owner; //владелец билета
        string time; //время и дата покупки билета
        uint[6] balls; // первые элементов 5 белые шары, 6 элемент красный шар
        uint[2] complianceLevel; // первый элемент число совпавших белых, второй - число совпавших красных
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
    function LotteryPowerball() DHFBaseCurrency (10000, "Lottery Powerball", "LP") public { 
        startLottery();
    }
    // старт лотереи
    function startLottery() private onlyOwner {
        isRunning = true;
        ++lastLotteryId;
        currentPowerballLottery.date = "16.11.2017";
        currentPowerballLottery.ticketsCount = 0;
        currentPowerballLottery.prizeCombination = [1,22,34,47,58,1];
        
    }
    // завершение лотереи
    function stopLottery() private onlyOwner {
        isRunning = false;
        require(calculatePrizes());
        historyPowerballLotteries[lastLotteryId] = currentPowerballLottery;
    }
    // Функция проверки текущего состояния лотереи
    function isRunningLottery() public view returns (bool res) {
        require(isRunning);
        return true;
    }
    
    // Покупка билета(публичкая функция)
    function buyTicket(uint firstWhiteBall, uint secondWhiteBall, uint thirdWhiteBall, uint fourthWhiteBall, uint fiveWhiteBall, uint redBall) public returns (bool res) {
        uint[6] memory balls;
        balls[0] = firstWhiteBall;
        balls[1] = secondWhiteBall;
        balls[2] = thirdWhiteBall;
        balls[3] = fourthWhiteBall;
        balls[4] = fiveWhiteBall;
        balls[5] = redBall;
        return buyTicket(balls);
    }
    
    // Покупка билета
    function buyTicket(uint[6] ballsInTicket) private returns (bool res) {
        require(isRunningLottery());
        require(validationBallsInTicket(ballsInTicket));
        
        PowerballTicket memory newTicket;
        newTicket.owner = msg.sender;
        newTicket.time = "06.11.2017";
        newTicket.balls = ballsInTicket;
        

        
        if (balanceOf[msg.sender] < ticketPrice) return false;
        balanceOf[msg.sender] -= ticketPrice;
        jackPot += (ticketPrice * jackPotAssignment) / 100;
        regularPrize += (ticketPrice * regularPrizeAssignment) / 100;
        
        currentPowerballLottery.tickets[currentPowerballLottery.ticketsCount] = newTicket;
        currentPowerballLottery.ticketsCount++;
        
        return true;
    }
    
    // Валидация чисел в билете
    function validationBallsInTicket(uint[6] ballsInTicket) public view returns (bool) {
        
        for (uint i = 0; i < countWhiteBallsInTicket; i++){
            if (ballsInTicket[i] > maxWhiteBallNumberInTicket || ballsInTicket[i] == 0) return false;
        }
        if (ballsInTicket[5] > maxRedBallNumberInTicket || ballsInTicket[5] == 0) return false; 
        return true;
    }
    
    // Проверка номеров в билете с выигрышной комбинацией
    function getTicketComplianceLevel(uint[6] ballsInTicket) internal constant returns (uint[2] complianceLevel)
    {
        for(uint i = 0; i < countWhiteBallsInTicket; i++)
        {
            for(uint j = 0; j < countWhiteBallsInTicket; j++)
            {
                if(ballsInTicket[i] == currentPowerballLottery.prizeCombination[j]) complianceLevel[0]++;
            }
        }
        if(ballsInTicket[5] == currentPowerballLottery.prizeCombination[5]) complianceLevel[1]++; 
        return complianceLevel;
    }
    
    // расчет выигрыша
    function calculatePrizes() private view onlyOwner returns (bool)
    {
        require(!isRunningLottery());
        // ТУТ БУДУТ ПРИЗЫ
        return true;
    }
}