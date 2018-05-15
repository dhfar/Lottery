pragma solidity ^0.4.21;

import "./Owned.sol";

contract CandyKillerCharacter is Owned {

    string public standard = 'CandyKiller';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    // идентификатор следующего персонажа
    uint public nextCharacterIndexToAssign = 1;
    /* персонажи */
    mapping(uint => address) public characterIndexToAddress;
    mapping(uint => Character) public characters;
    // адреса магазинов
    address characterMarketPlace;
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CKServiceContract ckService;
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
    struct Character {
        uint id; // идентификатор
        string name; // ник
        uint8[32] skils; // способности
        uint8[32] skilsMask; // верхний предел прокачки персонажа
        bool isDeleted; // флаг удаления
        uint experienceCoin; // монеты для прокачки
        uint winCount; // количество побед
        uint gameCount; // количство игр
        address tenant; // арендатор
        uint rentStart;
        uint rentDayLenght;
    }
    // создание персонажа
    event CreateCharacter(address creator, uint index);
    // начисление опыта персонажу
    event IncreaseExperienceCoin(address executor, uint characterIndex, uint experienceCoin);
    // начисление свободного опыта
    event IncreaseFreeExperienceCoin(address executor, uint characterIndex, uint _freeExperienceCoin);
    // прокачка скила
    event IncreaseSkillLevel(address executor, uint characterIndex, uint skillIndex, uint experienceCoins, uint freeExperienceCoins);
    // задать аренду
    event SetCharacterRent(address renter, uint characterIndex, uint rentDays);
    // снять аренду
    event OverCharacterRent(uint characterIndex);
    // передача отряда
    event TransferCharacter(address newOwner, uint characterIndex);

    function CandyKillerCharacter() public {
        owner = msg.sender;
        totalSupply = 10000;
        name = "CandyKillerCharacter";
        symbol = "CKС";
        decimals = 0;
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
        инициализация объекта CKCharacterMarketPlace
    */
    function initCKCharacterMarketPlace(address characterMarketPlaceAddress) public onlyOwner {
        if (characterMarketPlaceAddress == 0x0) return;
        characterMarketPlace = characterMarketPlaceAddress;
    }
    /*
        Создание персонажа
    */
    function createCharacter(string characterName) public onlyActiveAccount returns (uint) {
        // Персонаж ещё никому не принадлежит
        if (characterIndexToAddress[nextCharacterIndexToAssign] != 0x0) return 0;
        // Инициализируем нового персонажа
        Character memory newCharacter;
        newCharacter.name = characterName;
        newCharacter.id = nextCharacterIndexToAssign;
        uint8[32] memory generateSkilsMask;
        bool error;
        (generateSkilsMask, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 32);
        if (error) return 0;
        newCharacter.skilsMask = generateSkilsMask;
        newCharacter.isDeleted = false;
        newCharacter.experienceCoin = 0;
        // Сохраняем персонажа в список персонажей
        characters[nextCharacterIndexToAssign] = newCharacter;
        // Связываем нового персонажа с хозяином
        characterIndexToAddress[nextCharacterIndexToAssign] = msg.sender;
        // Увеличиваем индекс для следующего персонажа
        emit CreateCharacter(msg.sender, nextCharacterIndexToAssign);
        nextCharacterIndexToAssign++;
        return (newCharacter.id);
    }
    /*
    Удаление персонажа.
    Персонаж остается без хозяина и получет статус удален.
    ToDo Проверки, что отрял не в аренде и на него нет предложений аренды/продажи от владельца
    */
    function deleteCharacter(uint characterIndex) public onlyActiveAccount returns (bool) {
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Устанавливаем персонажу флаг удален
        characters[characterIndex].isDeleted = true;
        // Удаляем првязку персонажа к владельцу
        characterIndexToAddress[characterIndex] == 0x0;
        return true;
    }
    /*
        Получение инфо о персонаже по индексу
        владелец, ник, способности, маска способностей, флаг удаления, монеты для прокачки
    */
    function getCharacterByIndex(uint characterIndex) public view returns (address, string, uint8[32], uint8[32], bool, uint, address, uint, uint) {
        Character memory userCharacter = characters[characterIndex];
        return (
        characterIndexToAddress[characterIndex],
        userCharacter.name,
        userCharacter.skils,
        userCharacter.skilsMask,
        userCharacter.isDeleted,
        userCharacter.experienceCoin,
        userCharacter.tenant,
        userCharacter.rentStart,
        userCharacter.rentDayLenght
        );
    }
    /*
        Получение идентификатора следующего персонажа пользователя.
        previousCharacterIndex - предыдущий персонаж пользователя.
        Если previousCharacterIndex не принадлежит вызвавшему функцию вернет 0.
        Если персонажей нет вернет 0.
    */
    function getNextUserCharacterIndex(uint previousCharacterIndex) public view returns (uint) {
        if (characterIndexToAddress[previousCharacterIndex] == msg.sender || previousCharacterIndex == 0) {
            for (uint i = previousCharacterIndex + 1; i < nextCharacterIndexToAssign; i++) {
                if (characterIndexToAddress[i] == msg.sender) {
                    return i;
                }
            }
        }
    }
    /*
        Получение статистики персонажа
        Игры, победы
    */
    function getCharacterStatisticsByIndex(uint characterIndex) public view returns (uint, uint) {
        return (
        characters[characterIndex].winCount,
        characters[characterIndex].gameCount
        );
    }
    /*
        Получение монент для прокачки скилов
    */
    function increaseExperienceCoin(uint characterIndex, uint experienceCoin) public onlyOwner returns (bool) {
        // У персонажа есть хозяин
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] == msg.sender) return false;
        if (characterIndex == 0 || experienceCoin == 0) return false;
        // Увеличиваем колиство монет прокачки персонажа
        if (characters[characterIndex].tenant != 0x0) {
            if (!ckAccount.accrueFreeExperienceCoin(characters[characterIndex].tenant, experienceCoin / 2)) return false;
            characters[characterIndex].experienceCoin += experienceCoin / 2;
            emit IncreaseFreeExperienceCoin(msg.sender, characterIndex, experienceCoin / 2);
        } else {
            characters[characterIndex].experienceCoin += experienceCoin;
            emit IncreaseExperienceCoin(msg.sender, characterIndex, experienceCoin);
        }
        return true;
    }
    /*
        Конвертация опыта персонажа в свободный опыт
    */
    function convertExperienceToFreeExperience(uint characterIndex, uint countCoinForCovert) public onlyActiveAccount returns (bool) {
        // У персонажа есть хозяин
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // у персонажа есть необходимое кол-во монет опыта
        if (characters[characterIndex].experienceCoin < countCoinForCovert) return false;
        characters[characterIndex].experienceCoin -= countCoinForCovert;
        if (!ckAccount.accrueFreeExperienceCoin(msg.sender, countCoinForCovert / 2)) return false;
        return true;
    }
    /*
        Увеличение уровня прокачки скила (на 1)
    */
    function increaseSkillLevel(uint characterIndex, uint skillIndex, uint freeExperienceCoins) public onlyActiveAccount returns (bool) {
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Валидный скил индекс
        if (skillIndex < 0 || skillIndex > 32) return false;
        // Можно ли ещё качать эту способность
        if (characters[characterIndex].skils[skillIndex] >= characters[characterIndex].skilsMask[skillIndex]) return false;
        // у персонажа есть необходимое кол-во монет опыта
        if (ckAccount.getFreeExperienceCoinCount(msg.sender) < freeExperienceCoins) return false;
        // Монеты для поднятия уровня скила
        uint experienceForNextLevel = 2 * (2 ** uint(characters[characterIndex].skils[skillIndex]));
        // Есть ли нужное кол-во монет
        uint hasExperienceCoins = characters[characterIndex].experienceCoin + freeExperienceCoins;
        if (hasExperienceCoins == 0 && hasExperienceCoins < experienceForNextLevel) return false;
        // Если монет для прокачки у персонажа хватает, тратим только их.
        if (characters[characterIndex].experienceCoin >= experienceForNextLevel) {
            characters[characterIndex].experienceCoin -= experienceForNextLevel;
        } else {
            characters[characterIndex].experienceCoin = 0;
            uint usedFreeExperience = freeExperienceCoins - (hasExperienceCoins - experienceForNextLevel);
            if (!ckAccount.writeOffFreeExperienceCoin(msg.sender, usedFreeExperience)) return false;
        }
        characters[characterIndex].skils[skillIndex]++;
        emit IncreaseSkillLevel(msg.sender, characterIndex, skillIndex, experienceForNextLevel, freeExperienceCoins);
        return true;
    }
    /*
        Отряд принадлежит указанному пользователю
    */
    function isCharacterOwner(uint characterIndex, address owner) public view returns (bool) {
        return (characterIndexToAddress[characterIndex] == owner && owner != 0x0);
    }
    /*
        Отряд доступен для аренды
    */
    function isCharacterAvailableForRent(uint characterIndex) public view returns (bool) {
        return (characters[characterIndex].tenant == 0x0 && characters[characterIndex].id > 0);
    }
    /*
        Задать аренду отряда
    */
    function setCharacterRent(uint characterIndex, address characterOwner, address tenant, uint rentDayCount) public returns (bool) {
        // только магазтн
        if (msg.sender != characterMarketPlace) return false;
        // characterOwner владелец отряда
        if (!isCharacterOwner(characterIndex, characterOwner)) return false;
        // данные валидны
        if (tenant == 0x0 || rentDayCount == 0) return false;
        // отряд не в аренде
        if (characters[characterIndex].tenant != 0x0) return false;
        characters[characterIndex].tenant = tenant;
        characters[characterIndex].rentStart = now;
        characters[characterIndex].rentDayLenght = rentDayCount;
        emit SetCharacterRent(tenant, characterIndex, rentDayCount);
        return true;
    }
    /*
        Завершение аренды
    */
    function overCharacterRent(uint characterIndex) public returns (bool) {
        if (characters[characterIndex].tenant == 0x0 && characters[characterIndex].rentStart == 0 && characters[characterIndex].rentDayLenght == 0) return true;
        if (now >= characters[characterIndex].rentStart + (characters[characterIndex].rentDayLenght * 1 days)) {
            characters[characterIndex].tenant = 0x0;
            characters[characterIndex].rentStart = 0;
            characters[characterIndex].rentDayLenght = 0;
            emit OverCharacterRent(characterIndex);
            return true;
        }
        return false;
    }
    /*
        Передать отряд новому хозяину
    */
    function transferCharacter(uint characterIndex, address characterOwner, address newCharacterOwner) public returns (bool) {
        // только магазтн
        if (msg.sender != characterMarketPlace) return false;
        // characterOwner владелец отряда
        if (!isCharacterOwner(characterIndex, characterOwner)) return false;
        // данные валидны
        if (newCharacterOwner == 0x0) return false;
        // отряд не в аренде
        if (characters[characterIndex].tenant != 0x0) return false;
        characterIndexToAddress[characterIndex] = newCharacterOwner;
        emit TransferCharacter(newCharacterOwner, characterIndex);
        return true;
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);

    function accrueFreeExperienceCoin(address accountOwner, uint accrueCoins) public returns (bool);

    function writeOffFreeExperienceCoin(address accountOwner, uint writeOffCoins) public returns (bool);

    function getFreeExperienceCoinCount(address accountOwner) public view returns (uint);
}

contract CKServiceContract {
    function convertBlockHashToUintHexArray(bytes32 bloclHash, uint8 convertCharacterCount) public pure returns (uint8[32] convertValues, bool error);
}