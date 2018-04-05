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
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);
}

contract CandyKillerCharacter {

}