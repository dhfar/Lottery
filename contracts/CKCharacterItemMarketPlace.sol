pragma solidity ^0.4.21;

import "./Owned.sol";

contract CKCharacterItemMarketPlace is Owned {
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CKCharacterItem ckCharacterItem;
    /*
        Продажа
    */
    /*
        Предложение продажи отряда
    */
    struct OfferCharacterItem {
        // предмет
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
    struct BidCharacterItem {
        // предмет
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
    // Массив предложений продажи отрядов
    mapping(uint => OfferCharacterItem) public characterItemOffers;
    // Массив предложений покупки отдрядов
    mapping(uint => BidCharacterItem) public characterItemBids;
    /*
        События
    */
    event BidCharacterItemEntered(uint characterIndex, uint price, address customer);
    event BidCharacterItemAccepted(uint characterIndex, uint price, address customer);
    event BidCharacterItemWithdrawn(uint characterIndex, uint price, address customer);

    event OfferedCharacterItem(uint characterItemIndex, uint price, address toAddress);
    event WithdrawOfferCharacterItem(uint characterItemIndex);
    event BuyCharacterItem(uint characterItemIndex, uint price, address fromAddress, address toAddress);

    function CKCharacterItemMarketPlace() public {
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
        инициализация объекта CKCharacterItem
    */
    function initCandyKillerCharacterItem(address characterItemContract) public onlyOwner {
        if (characterItemContract == 0x0) return;
        ckCharacterItem = CKCharacterItem(characterItemContract);
    }
    /*
        Получить предложение покупки предмета
    */
    function getOfferCharacterItem(uint characterItemIndex) public view returns (uint, address, uint, address, bool){
        return (
        characterItemOffers[characterItemIndex].index,
        characterItemOffers[characterItemIndex].owner,
        characterItemOffers[characterItemIndex].price,
        characterItemOffers[characterItemIndex].specialCustomer,
        characterItemOffers[characterItemIndex].isForSale
        );
    }
    /*
        Получить предложение продажи предмета
    */
    function getBidCharacterItem(uint characterItemIndex) public view returns (uint, address, uint){
        return (
        characterItemBids[characterItemIndex].index,
        characterItemBids[characterItemIndex].customer,
        characterItemBids[characterItemIndex].price
        );
    }
    /*
        Предмет выставлен на продажу
    */
    function isExistOfferCharacterItem(uint characterItemIndex) public view returns (bool) {
        return characterItemOffers[characterItemIndex].isForSale;
    }
    /*
         Добавление предложения покупки предмета
     */
    function enterBidCharacterItem(uint characterItemIndex) public onlyActiveAccount payable {
        // пользователь не владелец предмета
        if (ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        // существующее предложение
        BidCharacterItem memory existBidCharacterItem = characterItemBids[characterItemIndex];
        if (msg.value <= existBidCharacterItem.price) return;
        // сумму предыдущего предложения запишем на счет пользователя
        if (existBidCharacterItem.price > 0) {
            ckAccount.addPendingWithdrawals.value(existBidCharacterItem.price)(existBidCharacterItem.customer);
        }
        // создаем новое предложение
        characterItemBids[characterItemIndex] = BidCharacterItem(characterItemIndex, msg.sender, msg.value);
        emit BidCharacterItemEntered(characterItemIndex, msg.value, msg.sender);
    }
    /*
        Продать предмет
    */
    function acceptBidCharacterItem(uint characterItemIndex) public onlyActiveAccount {
        // пользователь владелец предмета
        if (!ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        //предложение
        address seller = msg.sender;
        BidCharacterItem memory existBidCharacterItem = characterItemBids[characterItemIndex];
        if (existBidCharacterItem.price == 0) return;
        // указывается адрес нового владельца
        if (ckCharacterItem.transferCharacterItem(characterItemIndex, msg.sender, existBidCharacterItem.customer)) {
            characterItemBids[characterItemIndex] = BidCharacterItem(0, 0x0, 0);
            ckAccount.addPendingWithdrawals.value(existBidCharacterItem.price)(seller);
            emit BidCharacterItemAccepted(characterItemIndex, existBidCharacterItem.price, existBidCharacterItem.customer);
        }
    }
    /*
        Снятие предложения покупки предмета
    */
    function withdrawBidCharacterItem(uint characterItemIndex) public onlyActiveAccount {
        // пользователь не владелец отряда
        if (ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        BidCharacterItem memory existBidCharacterItem = characterItemBids[characterItemIndex];
        if (existBidCharacterItem.customer != msg.sender) return;
        emit BidCharacterItemWithdrawn(characterItemIndex, existBidCharacterItem.price, msg.sender);
        characterItemBids[characterItemIndex] = BidCharacterItem(0, 0, 0x0);
        // вернем деньги за предложение
        msg.sender.transfer(existBidCharacterItem.price);
    }

    /*
    Добавление предложения продажи предмета
    */
    function offerCharacterItem(uint characterItemIndex, uint price) public onlyActiveAccount {
        // пользователь владелец предмета
        if (!ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        if (price == 0) return;
        characterItemOffers[characterItemIndex] = OfferCharacterItem(characterItemIndex, msg.sender, price, 0x0, true);
        emit OfferedCharacterItem(characterItemIndex, price, 0x0);
    }
    /*
        Добавление предложения продажи отряда конкретному пользователю
    */
    function offerCharacterItemToAddress(uint characterItemIndex, uint price, address toAddress) public onlyActiveAccount {
        // пользователь владелец предмета
        if (!ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        if (price == 0) return;
        if (toAddress == 0x0) return;
        characterItemOffers[characterItemIndex] = OfferCharacterItem(characterItemIndex, msg.sender, price, toAddress, true);
        emit OfferedCharacterItem(characterItemIndex, price, toAddress);
    }
    /*
        Снятие предложения продажи предмета
    */
    function withdrawOfferCharacterItem(uint characterItemIndex) public onlyActiveAccount {
        // пользователь владелец предмета
        if (!ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        characterItemOffers[characterItemIndex] = OfferCharacterItem(0, 0x0, 0, 0x0, false);
        emit WithdrawOfferCharacterItem(characterItemIndex);
    }
    /*
        Купить предмет
    */
    function buyCharacterItem(uint characterItemIndex) public payable onlyActiveAccount {
        if (ckCharacterItem.isCharacterItemOwner(characterItemIndex, msg.sender)) return;
        OfferCharacterItem memory offer = characterItemOffers[characterItemIndex];
        if (!offer.isForSale) return;
        if (offer.specialCustomer != 0x0 && offer.specialCustomer != msg.sender) return;
        if (msg.value < offer.price) return;
        address seller = offer.owner;
        if (!ckCharacterItem.transferCharacterItem(characterItemIndex, seller, msg.sender)) return;
        // удалим предложение на покупку
        characterItemOffers[characterItemIndex] = OfferCharacterItem(0, 0x0, 0, 0x0, false);
        if (!ckAccount.addPendingWithdrawals.value(msg.value)(seller)) return;
        emit BuyCharacterItem(characterItemIndex, offer.price, seller, msg.sender);
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);

    function addPendingWithdrawals(address userAddress) public payable returns (bool);
}

contract CKCharacterItem {
    function isCharacterItemOwner(uint characterIndex, address owner) public view returns (bool);

    function transferCharacterItem(uint characterItemIndex, address characterItemOwner, address newCharacterItemOwner) public returns (bool);
}