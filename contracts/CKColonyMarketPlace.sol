pragma solidity ^0.4.20;

import "./Owned.sol";

contract CKColonyMarketPlace is Owned {
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CandyKillerColony ckColony;
    /*
        Продажа земли
    */
    /*
        Предложение на продажу
    */
    struct OfferEarthCell {
        // ячейка
        uint index;
        // владелец ячейки
        address owner;
        // цена
        uint price;
        // продажа конкретному покупателю
        address specialCustomer;
        // доступен для продажи
        bool isForSale;
    }
    /*
        Предложение на покупку
    */
    struct BidEarthCell {
        // ячейка
        uint index;
        // покупатель
        address customer;
        // цена
        uint price;
    }

    // Массив предложений протажи ячейки
    mapping(uint => OfferEarthCell) public earthCellOffer;
    // Массив ставок на продажу ячейки
    mapping(uint => BidEarthCell) public earthCellBids;
    /*
        События
    */
    event EarthCellBidEntered(uint cellIndex, uint price, address indexed customerAddress);
    event EarthCellBidWithdrawn(uint cellIndex, uint price, address indexed customerAddress);
    event EarthCellBidAccepted(uint charactecellIndexrIndex, uint price, address indexed tenantAddress);
    event EarthCellOffered(uint indexed cellIndex, uint price, address indexed toAddress);
    event WithdrawOfferForEarthCell(uint indexed cellIndex);

    function CKColonyMarketPlace() public {
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
        инициализация объекта CandyKillerColony
    */
    function initCandyKillerColony(address colonyContract) public onlyOwner {
        if (colonyContract == 0x0) return;
        ckColony = CandyKillerColony(colonyContract);
    }
    /*
        Добавление предложения на покупку ячейки земли
    */
    function enterBidEarthCell(uint cellIndex) public payable {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // ячейка свободна для продажи и принадлежит
        if (!ckColony.isExistAndForSaleCell(msg.sender, cellIndex)) return;
        BidEarthCell memory existBidEarthCell = earthCellBids[cellIndex];
        if (msg.value <= 0) return;
        // сумму предыдущего предложения запишем на счет пользователя
        if (msg.value > existBidEarthCell.price) {
            // вернем деньги
            ckAccount.addPendingWithdrawals.value(msg.value)(msg.sender);
            // создаем новое предложение
            earthCellBids[cellIndex] = BidEarthCell(cellIndex, msg.sender, msg.value);
            EarthCellBidEntered(cellIndex, msg.value, msg.sender);
        }
    }
    /*
        Продажа ячейки земли
    */
    function acceptBidEarthCell(uint cellIndex) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // ячейка свободна для продажи и принадлежит
        if (ckColony.isOwnerEarthCell(msg.sender, cellIndex)) return;
        BidEarthCell memory existBid = earthCellBids[cellIndex];
        if (existBid.price == 0) return;
        // передаем ячейку новому владельцу
        if (!ckColony.transferEarthCell(msg.sender, existBid.customer, cellIndex)) return;
        earthCellBids[cellIndex] = BidEarthCell(cellIndex, 0x0, 0);
        // переведём бабки пользователю
        ckAccount.addPendingWithdrawals.value(existBid.price)(msg.sender);
        EarthCellBidAccepted(cellIndex, existBid.price, existBid.customer);
    }
    /*
        Снятие предложения на покупку ячейки земли
    */
    function withdrawBidForCharacter(uint cellIndex) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        BidEarthCell memory existBidEarthCell = earthCellBids[cellIndex];
        // существует предложение
        if (existBidEarthCell.customer != msg.sender) return;
        // Обнуляем предложения по ячейке
        EarthCellBidWithdrawn(cellIndex, existBidEarthCell.price, msg.sender);
        earthCellBids[cellIndex] = BidEarthCell(cellIndex, 0x0, 0);
        // вернем деньги за предложение
        msg.sender.transfer(existBidEarthCell.price);
    }
    /*
        Добавление предложения на продажу ячейки земли
    */
    function offerEarthCellForSale(uint cellIndex, uint price) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // ячейка свободна для продажи и принадлежит
        if (!ckColony.isExistAndForSaleCell(0x0, cellIndex)) return;
        // хозяин ячейки
        if (!ckColony.isOwnerEarthCell(msg.sender, cellIndex)) return;
        if (price == 0) return;
        earthCellOffer[cellIndex] = OfferEarthCell(cellIndex, msg.sender, price, 0x0, true);
        EarthCellOffered(cellIndex, price, 0x0);
    }
    /*
        Добавление предложения на продажу ячейки земли, конкретному пользователю
    */
    function offerEarthCell(uint cellIndex, uint price, address toAddress) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // ячейка свободна для продажи и принадлежит
        if (!ckColony.isExistAndForSaleCell(0x0, cellIndex)) return;
        // хозяин ячейки
        if (!ckColony.isOwnerEarthCell(msg.sender, cellIndex)) return;
        if (price == 0) return;
        if (toAddress == 0x0) return;
        earthCellOffer[cellIndex] = OfferEarthCell(cellIndex, msg.sender, price, toAddress, true);
        EarthCellOffered(cellIndex, price, toAddress);
    }
    /*
        Снятие предложения на продажу ячейки земли
    */
    function withdrawOfferEarthCell(uint cellIndex) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // ячейка свободна для продажи и принадлежит
        if (!ckColony.isOwnerEarthCell(msg.sender, cellIndex)) return;
        earthCellOffer[cellIndex] = OfferEarthCell(cellIndex, msg.sender, 0, 0x0, false);
        WithdrawOfferForEarthCell(cellIndex);
    }
    /*
        Получить информацию о предложение на продажу ячейки
    */
    function getOfferEarthCell(uint cellIndex) public view returns (uint, address, uint, address, bool) {
        return (
        earthCellOffer[cellIndex].index,
        earthCellOffer[cellIndex].owner,
        earthCellOffer[cellIndex].price,
        earthCellOffer[cellIndex].specialCustomer,
        earthCellOffer[cellIndex].isForSale
        );
    }
    /*
        Получить информацию о предложение на покупку ячейки
    */
    function getBidEarthCell(uint cellIndex) public view returns (uint, address, uint) {
        return (
        earthCellBids[cellIndex].index,
        earthCellBids[cellIndex].customer,
        earthCellBids[cellIndex].price
        );
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);

    function addPendingWithdrawals(address userAddress) public payable returns (bool);
}

contract CandyKillerColony {
    function isExistAndForSaleCell(address customer, uint cellIndex) public view returns (bool);

    function isOwnerEarthCell(address possibleOwner, uint cellIndex) public view returns (bool);

    function transferEarthCell(address from, address to, uint cellIndex) public returns (bool);
}