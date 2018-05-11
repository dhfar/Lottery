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
        uint index;
        // владелец персонажа
        address owner;
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
        uint index;
        // арендатор
        address tenant;
        // цена за день аренды
        uint costForDay;
        // длина аренды(дней)
        uint rentDays;
    }
    /*
        Продажа
    */
    /*
        Предложение продажи отряда
    */
    struct OfferCharacter {
        // отряд
        uint index;
        // владелец отряда
        address owner;
        // цена
        uint price;
        // аренда конкретному пользователю
        address specialCustomer;
        // доступен для продажи
        bool isForSale;
    }
    /*
        Предложение покупки отряда
    */
    struct BidCharacter {
        // отряд
        uint index;
        // покупатель
        address customer;
        // цена
        uint price;
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
    // Массив предложений продажи отрядов
    mapping(uint => OfferCharacter) public characterOffers;
    // Массив предложений покупки отдрядов
    mapping(uint => BidCharacter) public characterBids;
    /*
        События
    */
    event RentCharacterBidEntered(uint characterIndex, uint costDay, uint rentDays, address rentAddress);
    event RentCharacterBidAccepted(uint characterIndex, uint costDay, uint rentDays, address tenantAddress);
    event RentCharacterBidWithdrawn(uint characterIndex, uint value, address tenantAddress);
    event RentCharacterOffered(uint characterIndex, uint costDay, uint rentDays, address toAddress);
    event RentWithdrawOfferForCharacter(uint characterIndex);
    event RentCharacter(uint characterIndex, uint costDay, uint rentDays, address fromAddress, address toAddress);

    event BidCharacterEntered(uint characterIndex, uint price, address customer);
    event BidCharacterAccepted(uint characterIndex, uint price, address customer);
    event BidCharacterWithdrawn(uint characterIndex, uint price, address customer);

    event OfferedCharacter(uint characterIndex, uint price, address toAddress);
    event WithdrawOfferForCharacter(uint characterIndex);
    event BuyCharacter(uint characterIndex, uint price, address fromAddress, address toAddress);
    /*
         Создание контракта
     */
    constructor() public {
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
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
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
        emit RentCharacterBidEntered(characterIndex, newRentBidCost, rentDayCount, msg.sender);
    }
    /*
        Согласится на предложение аренлы отряда
    */
    function acceptRentBidForCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        //предложение
        address seller = msg.sender;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.costForDay == 0 || existRentBid.rentDays == 0) return;
        // указывается адрес арендатора
        if (!ckCharacter.setCharacterRent(characterIndex, msg.sender, existRentBid.tenant, existRentBid.rentDays)) return;
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        ckAccount.addPendingWithdrawals.value(existRentBid.costForDay * existRentBid.rentDays)(seller);
        emit RentCharacterBidAccepted(characterIndex, existRentBid.costForDay * existRentBid.rentDays, existRentBid.rentDays, existRentBid.tenant);
    }
    /*
        Снятие арендного предложения пользователем
    */
    function withdrawBidForCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь не владелец отряда
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        RentBid memory existRentBid = characterRentBids[characterIndex];
        if (existRentBid.tenant != msg.sender) return;
        uint amount = existRentBid.costForDay * existRentBid.rentDays;
        emit RentCharacterBidWithdrawn(characterIndex, amount, msg.sender);
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        // вернем деньги за предложение
        msg.sender.transfer(amount);
    }
    /*
        Добавление арендного предложения отдать в аренду (от владельца)
    */
    function offerCharacterForRent(uint characterIndex, uint offreDayCount, uint offerCostForDay) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        if (offreDayCount == 0 || offerCostForDay == 0) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, offerCostForDay, offreDayCount, 0x0, true);
        emit RentCharacterOffered(characterIndex, offerCostForDay, offreDayCount, 0x0);
    }
    /*
        Добавление арендного предложения отдать в аренду  (от владельца) конкретному пользователю
    */
    function offerCharacterForRentToAddress(uint characterIndex, uint offreDayCount, uint offerCostForDay, address toAddress) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        if (offreDayCount == 0 || offerCostForDay == 0) return;
        if (toAddress == 0x0) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, offerCostForDay, offreDayCount, toAddress, true);
        emit RentCharacterOffered(characterIndex, offerCostForDay, offreDayCount, toAddress);
    }
    /*
        Снятие арендного предложения владельцем
    */
    function withdrawOfferForRentCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        characterOfferedForRent[characterIndex] = RentOffer(characterIndex, msg.sender, 0, 0, 0x0, false);
        emit RentWithdrawOfferForCharacter(characterIndex);
    }
    /*
        Взять персонажа в аренду
    */
    function rentCharacter(uint characterIndex) public payable onlyActiveAccount {
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        RentOffer memory offer = characterOfferedForRent[characterIndex];
        if (!offer.isForRent) return;
        if (offer.specialTenant != 0x0 && offer.specialTenant != msg.sender) return;
        if (msg.value < offer.costForDay * offer.rentDays) return;
        if (!ckCharacter.isCharacterOwner(characterIndex, offer.owner)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        address seller = offer.owner;

        if (!ckCharacter.setCharacterRent(characterIndex, seller, msg.sender, offer.rentDays)) return;
        withdrawOfferForRentCharacter(characterIndex);
        if (!ckAccount.addPendingWithdrawals.value(msg.value)(seller)) return;
        emit RentCharacter(characterIndex, offer.costForDay, offer.rentDays, seller, msg.sender);
        // Если арендатор делал предложение, удалим его и перечислим средства на счёт
        RentBid memory bid = characterRentBids[characterIndex];
        if (bid.tenant == msg.sender) {
            if (!ckAccount.addPendingWithdrawals.value(bid.costForDay * bid.rentDays)(msg.sender)) return;
            characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        }
    }
    /*
        Получить предложение от владельца персонажа
    */
    function getRentOffer(uint characterIndex) public view returns (uint, address, uint, uint, address, bool){
        return (
        characterOfferedForRent[characterIndex].index,
        characterOfferedForRent[characterIndex].owner,
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
        characterRentBids[characterIndex].index,
        characterRentBids[characterIndex].tenant,
        characterRentBids[characterIndex].costForDay,
        characterRentBids[characterIndex].rentDays
        );
    }

    /*
        Получить предложение покупки отряда
    */
    function getOfferCharacter(uint characterIndex) public view returns (uint, address, uint, address, bool){
        return (
        characterOffers[characterIndex].index,
        characterOffers[characterIndex].owner,
        characterOffers[characterIndex].price,
        characterOffers[characterIndex].specialCustomer,
        characterOffers[characterIndex].isForSale
        );
    }
    /*
        Получить предложение продажи отряда
    */
    function getBidCharacter(uint characterIndex) public view returns (uint, address, uint){
        return (
        characterBids[characterIndex].index,
        characterBids[characterIndex].customer,
        characterBids[characterIndex].price
        );
    }
    /*
        Добавление предложения покупки отряда
    */
    function enterBidCharacter(uint characterIndex) public onlyActiveAccount payable {
        // пользователь не владелец отряда
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        // существующее предложение
        BidCharacter memory existBidCharacter = characterBids[characterIndex];
        if (msg.value <= existBidCharacter.price) return;
        // сумму предыдущего предложения запишем на счет пользователя
        if (existBidCharacter.price > 0) {
            ckAccount.addPendingWithdrawals.value(existBidCharacter.price)(existBidCharacter.customer);
        }
        // создаем новое предложение
        characterBids[characterIndex] = BidCharacter(characterIndex, msg.sender, msg.value);
        emit BidCharacterEntered(characterIndex, msg.value, msg.sender);
    }
    /*
        Продать отряд
    */
    function acceptBidCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        //предложение
        address seller = msg.sender;
        BidCharacter memory existBidCharacter = characterBids[characterIndex];
        if (existBidCharacter.price == 0) return;
        // у отряда не должно быть предложения о сдаче в аренду
        if (characterOfferedForRent[characterIndex].owner == msg.sender) return;
        // указывается адрес арендатора
        if (!ckCharacter.transferCharacter(characterIndex, msg.sender, existBidCharacter.customer)) return;
        characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        ckAccount.addPendingWithdrawals.value(existBidCharacter.price)(seller);
        emit BidCharacterAccepted(characterIndex, existBidCharacter.price, existBidCharacter.customer);
    }
    /*
        Снятие предложения покупки отряда
    */
    function withdrawBidCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь не владелец отряда
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        BidCharacter memory existBidCharacter = characterBids[characterIndex];
        if (existBidCharacter.customer != msg.sender) return;
        emit BidCharacterWithdrawn(characterIndex, existBidCharacter.price, msg.sender);
        characterBids[characterIndex] = BidCharacter(characterIndex, 0, 0x0);
        // вернем деньги за предложение
        msg.sender.transfer(existBidCharacter.price);
    }
    /*
        Добавление предложения продажи отряда
    */
    function offerCharacter(uint characterIndex, uint price) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        if (price == 0) return;
        characterOffers[characterIndex] = OfferCharacter(characterIndex, msg.sender, price, 0x0, true);
        emit OfferedCharacter(characterIndex, price, 0x0);
    }
    /*
        Добавление предложения продажи отряда конкретному пользователю
    */
    function offerCharacterToAddress(uint characterIndex, uint price, address toAddress) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        if (price == 0) return;
        if (toAddress == 0x0) return;
        characterOffers[characterIndex] = OfferCharacter(characterIndex, msg.sender, price, toAddress, true);
        emit OfferedCharacter(characterIndex, price, toAddress);
    }
    /*
        Снятие предложения продажи отряда
    */
    function withdrawOfferForCharacter(uint characterIndex) public onlyActiveAccount {
        // пользователь владелец отряда
        if (!ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        characterOffers[characterIndex] = OfferCharacter(characterIndex, msg.sender, 0, 0x0, false);
        emit WithdrawOfferForCharacter(characterIndex);
    }
    /*
        Купить отряд
    */
    function buyCharacter(uint characterIndex) public payable onlyActiveAccount {
        if (ckCharacter.isCharacterOwner(characterIndex, msg.sender)) return;
        OfferCharacter memory offer = characterOffers[characterIndex];
        if (!offer.isForSale) return;
        if (offer.specialCustomer != 0x0 && offer.specialCustomer != msg.sender) return;
        if (msg.value < offer.price) return;
        if (!ckCharacter.isCharacterOwner(characterIndex, offer.owner)) return;
        // отряд не в аренде
        if (!ckCharacter.isCharacterAvailableForRent(characterIndex)) return;
        address seller = offer.owner;
        // если владелец делал предложение об аренде то не продаем
        if (characterOfferedForRent[characterIndex].isForRent)
            if (!ckCharacter.transferCharacter(characterIndex, seller, msg.sender)) return;
        withdrawOfferForCharacter(characterIndex);
        if (!ckAccount.addPendingWithdrawals.value(msg.value)(seller)) return;
        emit BuyCharacter(characterIndex, offer.price, seller, msg.sender);
        // Если арендатор делал предложение, удалим его и перечислим средства на счёт
        RentBid memory bid = characterRentBids[characterIndex];
        if (bid.tenant == msg.sender) {
            if (!ckAccount.addPendingWithdrawals.value(bid.costForDay * bid.rentDays)(msg.sender)) return;
            characterRentBids[characterIndex] = RentBid(characterIndex, 0x0, 0, 0);
        }
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

    function transferCharacter(uint characterIndex, address characterOwner, address newCharacterOwner) public returns (bool);
}