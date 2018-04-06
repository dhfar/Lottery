pragma solidity ^0.4.21;

import "./Owned.sol";

contract CKCharacterMarketPlace is Owned {
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CandyKillerCharacter ckCharacter;
    /*
        Аренда
    */
    /*
        Предложение от владельца персонажа
    */
    struct RentOffer {
        // персонаж
        uint id;
        // владелец персонажа
        address characterOwner;
        // цена за день аренды
        uint costForDay;
        // длина аренды(дней)
        uint rentDays;
        // аренда конкретному пользователю
        address specialTenant;
        // доступен для аренды
        bool isForRent;
    }
    /*
        Предложение от пользователя на аренду
    */
    struct RentBid {
        // персонаж
        uint id;
        // арендатор
        address tenant;
        // цена за день аренды
        uint costForDay;
        // длина аренды(дней)
        uint rentDays;
    }
    /*
        Модификаторы
    */
    modifier onlyActiveAccount {
        // Учетная запись создана и активна
        require(ckAccount.isCreateAndActive(msg.sender));
        _;
    }
    // Массив предложений аренды
    mapping(uint => RentOffer) public characterOfferedForRent;
    // Массив ставок на аренду
    mapping(uint => RentBid) public characterRentBids;
    /*
        События
    */
    event CharacterBidEntered(uint characterIndex, uint costDay, uint rentDays, address rentAddress);
    event CharacterBidAccepted(uint characterIndex, uint costDay, uint rentDays, address tenantAddress);
    event CharacterBidWithdrawn(uint characterIndex, uint value, address tenantAddress);
    event CharacterOffered(uint characterIndex, uint costDay, uint rentDays, address toAddress);
    event WithdrawOfferForCharacter(uint characterIndex);
    event CharacterRent(uint characterIndex, uint costDay, uint rentDays, address fromAddress, address toAddress);
    /*
         Создание контракта
     */
    function CKCharacterMarketPlace() public {
        owner = msg.sender;
    }
    /*
        инициализация объекта CandyKillerAccount
    */
    function initCandyKillerAccount(address accountContract) public onlyOwner {
        if (accountContract == 0x0) return;
        ckAccount = CandyKillerAccount(accountContract);
    }
    /*
        инициализация объекта CandyKillerCharacter
    */
    function initCandyKillerCharacter(address characterContract) public onlyOwner {
        if (characterContract == 0x0) return;
        ckCharacter = CandyKillerCharacter(characterContract);
    }
    /*
        Добавление арендного предложения взять в аренду (от пользователя)
    */
    function enterRentBidForCharacter(uint characterIndex, uint rentDayCount) public onlyActiveAccount payable {
        // пользователь не владелец отряда
        if(ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if(!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        // существующее предложение
        RentBid memory existRentBid = characterRentBids[characterIndex];
        uint newRentBidCost = existRentBid.costForDay * existRentBid.rentDays;
        if (msg.value <= newRentBidCost) return;
        // сумму предыдущего предложения запишем на счет пользователя
        if (newRentBidCost > 0) {
            ckAccount.addPendingWithdrawals.value(newRentBidCost)(existRentBid.tenant);
        }
        // создаем новое предложение
        characterRentBids[characterIndex] = RentBid(characterIndex, msg.sender, newRentBidCost / rentDayCount, rentDayCount);
        emit CharacterBidEntered(characterIndex, newRentBidCost, rentDayCount, msg.sender);
    }
    /*
        Согласится на предложение аренлы отряда
    */
    function acceptRentBidForCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь владелец отряда
        if(!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if(!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        //предложение
        address seller = msg.sender;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.costForDay == 0 || existRentBid.rentDays == 0) return;
        // указывается адрес арендатора
        if (!ckCharacter.setCharacterRent(characterIndex,  msg.sender, existRentBid.tenant,  existRentBid.rentDays)) return;
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        ckAccount.addPendingWithdrawals.value(existRentBid.costForDay * existRentBid.rentDays)(seller);
        emit CharacterBidAccepted(characterIndex, existRentBid.costForDay * existRentBid.rentDays, existRentBid.rentDays, existRentBid.tenant);
    }
    /*
        Снятие арендного предложения пользователем
    */
    function withdrawBidForCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь не владелец отряда
        if(ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.tenant != msg.sender) return;
        uint amount = existRentBid.costForDay * existRentBid.rentDays;
        emit CharacterBidWithdrawn(characterIndex, amount, msg.sender);
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        // вернем деньги за предложение
        msg.sender.transfer(amount);
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);

    function addPendingWithdrawals(address userAddress) public payable returns (bool);
}

contract CandyKillerCharacter {
    function isCharacterOwner(uint characterIndex, address owner) public view returns (bool);

    function isCharacterAvailableForRent(uint characterIndex) public view returns (bool);

    function setCharacterRent(uint characterIndex, address characterOwner, address tenant, uint rentDayCount) public returns (bool);
}