pragma solidity ^0.4.19;

import "./PixelWars.sol";

contract PixelWarsMarketPlace is PixelWars {
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
    event CharacterBidEntered(uint indexed characterIndex, uint costDay, uint rentDays, address indexed rentAddress);
    event CharacterBidAccepted(uint indexed characterIndex, uint costDay, uint rentDays, address indexed tenantAddress);
    event CharacterBidWithdrawn(uint indexed characterIndex, uint value, address indexed tenantAddress);
    event CharacterOffered(uint indexed characterIndex, uint costDay, uint rentDays, address indexed toAddress);
    event WithdrawOfferForCharacter(uint indexed characterIndex);
    event CharacterRent(uint indexed characterIndex, uint costDay, uint rentDays, address indexed fromAddress, address indexed toAddress);
    /*
        Создание контракта
    */
    function PixelWarsMarketPlace() PixelWars() public payable {
        owner = msg.sender;
    }
    /*
        Добавление арендного предложения от пользователя
    */
    function enterRentBidForCharacter(uint characterIndex, uint rentDayCount) public payable {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] == msg.sender || msg.value == 0) return;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        uint newRentBidCost = existRentBid.costForDay * existRentBid.rentDays;
        if (msg.value <= newRentBidCost) return;
        // сумму предыдущего предложения запишем на счет пользователя
        if (newRentBidCost > 0) {
            pendingWithdrawals[existRentBid.tenant] += newRentBidCost;
        }
        // создаем новое предложение
        characterRentBids[characterIndex] = RentBid(characterIndex, msg.sender, newRentBidCost / rentDayCount, rentDayCount);
        CharacterBidEntered(characterIndex, newRentBidCost, rentDayCount, msg.sender);
    }
    /*
        Принятие арендного предложения от пользователя
    */
    function acceptRentBidForCharacter(uint characterIndex) public {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return;
        address seller = msg.sender;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.costForDay == 0 || existRentBid.rentDays == 0) return;
        // указывается адрес арендатора
        characters[characterIndex].tenant = existRentBid.tenant;
        characters[characterIndex].rentStart = now;
        characters[characterIndex].rentDayLenght = existRentBid.rentDays;
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        pendingWithdrawals[seller] += existRentBid.costForDay * existRentBid.rentDays;
        CharacterBidAccepted(characterIndex, existRentBid.costForDay * existRentBid.rentDays, existRentBid.rentDays, existRentBid.tenant);
    }
    /*
        Снятие арендного предложения пользователем
    */
    function withdrawBidForCharacter(uint characterIndex) public {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] == msg.sender) return;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.tenant != msg.sender) return;
        uint amount = existRentBid.costForDay * existRentBid.rentDays;
        CharacterBidWithdrawn(characterIndex, amount, msg.sender);
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        // вернем деньги за предложение
        msg.sender.transfer(amount);
    }
    /*
        Добавление арендного предложения от владельца
    */
    function offerPunkForSale(uint characterIndex, uint offreDayCount, uint offerCostForDay) public {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return;
        if (offreDayCount == 0 || offerCostForDay == 0) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, offerCostForDay, offreDayCount, 0x0, true);
        CharacterOffered(characterIndex, offerCostForDay, offreDayCount, 0x0);
    }
    /*
        Добавление арендного предложения от владельца конкретному пользователю
    */
    function offerPunkForSaleToAddress(uint characterIndex, uint offreDayCount, uint offerCostForDay, address toAddress) public {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return;
        if (offreDayCount == 0 || offerCostForDay == 0) return;
        if (toAddress == 0x0) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, offerCostForDay, offreDayCount, toAddress, true);
        CharacterOffered(characterIndex, offerCostForDay, offreDayCount, toAddress);
    }
    /*
        Снятие арендного предложения владельцем
    */
    function withdrawOfferForCharacter(uint characterIndex) public {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, 0, 0, 0x0, false);
        WithdrawOfferForCharacter(characterIndex);
    }
    /*
        Взять персонажа в аренду
    */
    function rentCharacter(uint characterIndex) public payable {
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] == msg.sender) return;
        RentOffer memory offer = characterOfferedForRent[characterIndex];
        if (!offer.isForRent) return;
        if (offer.specialTenant != 0x0 && offer.specialTenant != msg.sender) return;
        if (msg.value < offer.costForDay * offer.rentDays) return;
        if (offer.characterOwner != characterIndexToAddress[characterIndex]) return;
        address seller = offer.characterOwner;

        characters[characterIndex].tenant = msg.sender;
        characters[characterIndex].rentStart == now;
        characters[characterIndex].rentDayLenght == offer.rentDays;

        withdrawOfferForCharacter(characterIndex);
        pendingWithdrawals[seller] += msg.value;

        CharacterRent(characterIndex, offer.costForDay, offer.rentDays, seller, msg.sender);
        // Если арендатор делал предложение, удалим его и перечислим средства на счёт
        RentBid memory bid = characterRentBids[characterIndex];
        if (bid.tenant == msg.sender) {
            pendingWithdrawals[msg.sender] += bid.costForDay * bid.rentDays;
            characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        }
    }
    /*
        Получить предложение от владельца персонажа
    */
    function getRentOffer(uint characterIndex) public view returns (uint, address, uint, uint, address, bool){
        return (
        characterOfferedForRent[characterIndex].id,
        characterOfferedForRent[characterIndex].characterOwner,
        characterOfferedForRent[characterIndex].costForDay,
        characterOfferedForRent[characterIndex].rentDays,
        characterOfferedForRent[characterIndex].specialTenant,
        characterOfferedForRent[characterIndex].isForRent
        );
    }
    /*
        Получить предложение от пользователя на аренду
    */
    function getRentBid(uint characterIndex) public view returns (uint, address, uint, uint){
        return (
        characterRentBids[characterIndex].id,
        characterRentBids[characterIndex].tenant,
        characterRentBids[characterIndex].costForDay,
        characterRentBids[characterIndex].rentDays
        );
    }
}