pragma solidity ^0.4.21;

import "./Owned.sol";

contract CKCharacterItem is Owned {
    /* предметы */
    mapping(uint => address) public itemIndexToAddress;
    mapping(uint => CharacterItem) public items;
    // идентификатор следующего персонажа
    uint public nextItemIndexToAssign = 1;
    // адреса магазинов
    address characterItemMarketPlace;
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CKServiceContract ckService;
    CKCharacterItemMarketPlace ckCharacterItemMarketPlace;
    /*
        Модификаторы
    */
    modifier onlyActiveAccount {
        // Учетная запись создана и активна
        require(ckAccount.isCreateAndActive(msg.sender));
        _;
    }
    /*
        Описание персонажа
    */
    struct CharacterItem {
        uint id; // идентификатор
        uint8[4] skils; // способности
        uint8[4] skilsMask; // верхний предел прокачки персонажа
        bool isDeleted; // флаг удаления
        string itemId; // идентификатор для схожих экземпляров объекта
    }
    // создание предмета
    event CreateCharacterItem(address itemOwner, uint indexCharacterItem);
    // удаление предмета
    event DeleteCharacterItem(address itemOwner, uint indexCharacterItem);
    // прокачка скила
    event IncreaseItemSkillLevel(address itemOwner, uint indexCharacterItem, uint itemSkillIndex, uint experienceCoinsForNextLvl, uint freeExperienceCoins);
    // передача предмета
    event TransferCharacterItem(address newCharacterItemOwner, uint indexCharacterItem);
    /*
        Конструктор контракта
    */
    function CKCharacterItem() public{
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
        инициализация объекта CKServiceContract
    */
    function initCKServiceContract(address serviceContract) public onlyOwner {
        if (serviceContract == 0x0) return;
        ckService = CKServiceContract(serviceContract);
    }
    /*
        инициализация объекта CKCharacterItemMarketPlace
    */
    function initCKCharacterItemMarketPlace(address characterItemMarketPlaceAddress) public onlyOwner {
        if (characterItemMarketPlaceAddress == 0x0) return;
        characterItemMarketPlace = characterItemMarketPlaceAddress;
        ckCharacterItemMarketPlace = CKCharacterItemMarketPlace(characterItemMarketPlaceAddress);
    }
    /*
        Создание предмета
    */
    function createCharacterItem(string itemId, address itemOwner) public onlyOwner {
        if (!ckAccount.isCreateAndActive(itemOwner)) return;
        if(itemOwner == 0x0 || itemOwner == msg.sender) return;
        // Предмет ещё никому не принадлежит
        if (itemIndexToAddress[nextItemIndexToAssign] != 0x0) return;
        // Инициализируем нового персонажа
        CharacterItem memory newItem;
        newItem.id = nextItemIndexToAssign;
        newItem.itemId = itemId;
        uint8[32] memory generateSkilsMask;
        bool error;
        (generateSkilsMask, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 4);
        if (error) return;
        newItem.skilsMask = [generateSkilsMask[0], generateSkilsMask[1], generateSkilsMask[2], generateSkilsMask[3]];
        newItem.isDeleted = false;
        // Сохраняем персонажа в список персонажей
        items[nextItemIndexToAssign] = newItem;
        // Связываем нового персонажа с хозяином
        itemIndexToAddress[nextItemIndexToAssign] = itemOwner;
        // Увеличиваем индекс для следующего персонажа
        emit CreateCharacterItem(itemOwner, nextItemIndexToAssign);
        nextItemIndexToAssign++;
    }
    /*
        Удаление предмета.
        Предмет остается без хозяина и получет статус удален.
    */
    function deleteCharacterItem(uint characterItemIndex) public onlyActiveAccount {
        // Персонаж принадлежит вызвавшему функцию
        if (itemIndexToAddress[characterItemIndex] == 0x0 || itemIndexToAddress[characterItemIndex] != msg.sender) return;
        // Персонаж не продается
        if (ckCharacterItemMarketPlace.isExistOfferCharacterItem(characterItemIndex)) return;
        // Устанавливаем персонажу флаг удален
        items[characterItemIndex].isDeleted = true;
        // Удаляем првязку персонажа к владельцу
        itemIndexToAddress[characterItemIndex] = 0x0;
        emit DeleteCharacterItem(msg.sender, characterItemIndex);
    }
    /*
        Получение инфо о предмете по индексу
        владелец, ник, способности, маска способностей, флаг удаления, монеты для прокачки
    */
    function getCharacterItemByIndex(uint characterItemIndex) public view returns (address, uint8[4], uint8[4], bool, string) {
        CharacterItem memory userCharacterItem = items[characterItemIndex];
        return (
        itemIndexToAddress[characterItemIndex],
        userCharacterItem.skils,
        userCharacterItem.skilsMask,
        userCharacterItem.isDeleted,
        userCharacterItem.itemId
        );
    }
    /*
        Получение идентификатора следующего предмета пользователя.
        previousCharacterItemIndex - предыдущий предмет пользователя.
        Если previousCharacterItemIndex не принадлежит вызвавшему функцию вернет 0.
        Если предметов нет вернет 0.
    */
    function getNextUserCharacterItemIndex(uint previousCharacterItemIndex) public view returns (uint) {
        if (itemIndexToAddress[previousCharacterItemIndex] == msg.sender || previousCharacterItemIndex == 0) {
            for (uint i = previousCharacterItemIndex + 1; i < nextItemIndexToAssign; i++) {
                if (itemIndexToAddress[i] == msg.sender) {
                    return i;
                }
            }
        }
    }
    /*
        Предмет принадлежит указанному пользователю
    */
    function isCharacterItemOwner(uint characterItemIndex, address owner) public view returns (bool) {
        return (itemIndexToAddress[characterItemIndex] == owner && owner != 0x0);
    }
    /*
        Передать предмет новому хозяину
    */
    function transferCharacterItem(uint characterItemIndex, address characterItemOwner, address newCharacterItemOwner) public returns (bool) {
        // только магазтн
        if (msg.sender != characterItemMarketPlace) return false;
        // characterOwner владелец отряда
        if (!isCharacterItemOwner(characterItemIndex, characterItemOwner)) return false;
        // данные валидны
        if (newCharacterItemOwner == 0x0) return false;
        itemIndexToAddress[characterItemIndex] = newCharacterItemOwner;
        emit TransferCharacterItem(newCharacterItemOwner, characterItemIndex);
        return true;
    }
    /*
        Увеличение уровня прокачки скила (на 1)
    */
    function increaseItemSkillLevel(uint characterItemIndex, uint itemSkillIndex, uint freeExperienceCoins) public onlyActiveAccount {
        // Персонаж принадлежит вызвавшему функцию
        if (itemIndexToAddress[characterItemIndex] == 0x0 || itemIndexToAddress[characterItemIndex] != msg.sender) return;
        // Валидный скил индекс
        if (itemSkillIndex < 0 || itemSkillIndex > 4) return;
        // Можно ли ещё качать эту способность
        if (items[characterItemIndex].skils[itemSkillIndex] >= items[characterItemIndex].skilsMask[itemSkillIndex]) return;
        // у персонажа есть необходимое кол-во монет опыта
        if (ckAccount.getFreeExperienceCoinCount(msg.sender) < freeExperienceCoins) return;
        // Монеты для поднятия уровня скила
        uint experienceForNextLevel = 2 * (2 ** uint(items[characterItemIndex].skils[itemSkillIndex]));
        if (freeExperienceCoins == 0 && freeExperienceCoins < experienceForNextLevel) return;
        // Если монет для прокачки у персонажа хватает, тратим только их.
        if (!ckAccount.writeOffFreeExperienceCoin(msg.sender, freeExperienceCoins)) return;
        items[characterItemIndex].skils[itemSkillIndex]++;
        emit IncreaseItemSkillLevel(msg.sender, characterItemIndex, itemSkillIndex, experienceForNextLevel, freeExperienceCoins);
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);

    function writeOffFreeExperienceCoin(address accountOwner, uint writeOffCoins) public returns (bool);

    function getFreeExperienceCoinCount(address accountOwner) public view returns (uint);
}

contract CKServiceContract {
    function convertBlockHashToUintHexArray(bytes32 bloclHash, uint8 convertCharacterCount) public pure returns (uint8[32] convertValues, bool error);
}

contract CKCharacterItemMarketPlace {
    function isExistOfferCharacterItem(uint characterIndex) public view returns (bool);
}
