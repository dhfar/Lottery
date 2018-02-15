pragma solidity ^0.4.17;

import "./Owned.sol";

contract PixelWars is Owned {

    string public standard = 'PixelWars';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    uint public nextCharacterIndexToAssign = 1;
    bool public allCharactersAssigned = false;
    uint public characterRemainingToAssign = 0;

    uint public pixelWarsCoinPrice = 10000;

    mapping(uint => address) public characterIndexToAddress;
    /* This creates an array with all balances */
    mapping(address => uint256) public balanceOf;
    /* персонажи */
    mapping(uint => Character) public characters;

    event Assign(address indexedTo, uint256 characterIndex);
    event Transfer(address indexedFrom, address indexedTo, uint256 value);
    /*
        События
    */
    // создание учетной записи
    event CreateAccount(address indexed _creator, uint _account);
    // создание персонажа
    event CreateCharacter(address indexed _creator, uint _character);
    // покупка игровой валюты
    event BuyPixelWarsCoins(address indexed _buyer, uint _coins);
    // начисление опыта персонажу
    event IncreaseExperienceCoin(address indexed _executor, uint _characterIndex, uint _experienceCoin);
    // начисление свободного опыта
    event IncreaseFreeExperienceCoin(address indexed _executor, uint _characterIndex, uint _freeExperienceCoin);
    // прокачка скила
    event IncreaseSkillLevel(address indexed _executor, uint _characterIndex, uint _skillIndex, uint _experienceCoins, uint _freeExperienceCoins);
    // начисление игровой валюты
    event AccrualPixelWarsCoins(address indexed _executor, uint _pixelCount, uint _accountIndex);
    // списание игровой валюты
    event WithdrawalPixelWarsCoins(address indexed _executor, uint _pixelCount, uint _accountIndex);
    // задать возможного арендатора персонажу
    event SetPossibleTenant(address indexed _executor, uint _characterIndex, address _tenant);


    /*
        Описание аккаунта
    */
    struct Account {
        uint id; // идентификатор
        string email; // почта
        bytes32 password; // хэшпароля
        bool isActivate; // активен/ неактивен
        uint pixelWarsCoin; // игровая валюта
        bool isCreated; //  создан
        uint freeExperienceCoin; //свободный опыт
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
        bool isTenanted; // персонаж арендован
        address possibleTenant; // возможный арендатор
    }
    /*
        Описание трофея
    */
    struct Trophy {
        // идентификатор трофея
        uint trophyId;
        // владелец трофея
        uint characterOwner;
        // дата получения
        string dateReceive;
    }
    /*
        Аренда
    */

    struct RentOffer {
        // персонаж
        uint id;
        // владелец персонажа
        address characterOwner;
        // цена за день аренды
        uint costForDay;
        // длина аренды(дней)
        uint lenght;
        // аренда конкретному пользователю
        address specialTenant;
    }

    struct RentBid {
        // персонаж
        uint id;
        // арендатор
        address tenant;
        // цена за день аренды
        uint costForDay;
        // длина аренды(дней)
        uint lenght;
    }

    // Массив предложений аренды
    //mapping(uint => RentOffer) public characterOfferedForRent
    // Массив ставок на аренду
    //mapping(uint => RentBid) public characterRentBids;
    // Валюта пользователей
    //mapping(address => uint) public pendingWithdrawals;


    // ключ адрес кошеля владельца, значение инфо об аккаунте
    mapping(address => Account) private accounts;
    uint public nextAccountIndex = 1;
    mapping(uint => address) private indexOfAccounts;
    /*
        Создание контракта
    */
    function PixelWars() public payable {
        owner = msg.sender;
        totalSupply = 10000;
        // Update total supply
        characterRemainingToAssign = totalSupply;
        name = "PixelWarsCharacter";
        // Set the name for display purposes
        symbol = "PWС";
        // Set the symbol for display purposes
        decimals = 0;
        // Amount of decimals for display purposes

    }
    /*
        Создание аккаунта
    */
    function createAccount(string userEmail, string userPassword) public returns (uint) {
        if (accounts[msg.sender].isCreated) return 0;
        Account memory newAccount;
        newAccount.id = nextAccountIndex;
        newAccount.email = userEmail;
        newAccount.password = sha256(userPassword);
        newAccount.isActivate = true;
        newAccount.pixelWarsCoin = 0;
        newAccount.isCreated = true;
        accounts[msg.sender] = newAccount;
        indexOfAccounts[nextAccountIndex] = msg.sender;
        CreateAccount(msg.sender, nextAccountIndex);
        nextAccountIndex++;
        return nextAccountIndex - 1;
    }
    /*
         Активация/деактивация аккаунта
    */
    function deactivateAccount() public returns (bool) {
        accounts[msg.sender].isActivate = !accounts[msg.sender].isActivate;
        return true;
    }
    /*
        Получить информацию об учетной записи по идентификатору
        indexAccount - идентификатор учетной записи
        string - email, bool - активен/ неактивен, uint - игровая валюта, bool - создан, address - владелец, int - свободный опыт
    */
    function getAccountInfoByIndex(uint indexAccount) public view returns (uint, string, bool, uint, bool, address, uint) {
        if (msg.sender == owner || msg.sender == indexOfAccounts[indexAccount]) {
            Account memory userAccount = accounts[indexOfAccounts[indexAccount]];
            return (
            userAccount.id,
            userAccount.email,
            userAccount.isActivate,
            userAccount.pixelWarsCoin,
            userAccount.isCreated,
            indexOfAccounts[indexAccount],
            userAccount.freeExperienceCoin
            );
        }
    }
    /*
        Получить информацию об учетной записи по идентификатору
        string - email, bool - активен/ неактивен, uint - игровая валюта, bool - создан, address - владелец, int - свободный опыт
    */
    function getAccountInfo() public view returns (uint, string, bool, uint, bool, address, uint) {
        return getAccountInfoByIndex(accounts[msg.sender].id);
    }
    /*
        Получить идентификатор учетной записи по адресу владельца
        uint - id учетной записи
    */
    function getAccountIndexByAddress(address ownerAccount) public view returns (uint){
        return accounts[ownerAccount].id;
    }
    /*
        Получить баланс монет аккаунта
    */
    function getAccountBalance() public view returns (uint) {
        return accounts[msg.sender].pixelWarsCoin;
    }
    /*
        Задать цену покупки игровой валюты(в газе)
    */
    function setPixelWarsCoinPrice(uint newPrice) public onlyOwner returns (bool) {
        if (newPrice <= 0) return false;
        pixelWarsCoinPrice = newPrice;
        return true;
    }
    /*
        Покупка игровой валюты
    */
    function buyPixelWarsCoins() public payable returns (bool) {
        if (!accounts[msg.sender].isCreated) return false;
        if (msg.value <= 0) return false;
        uint coins = msg.value / pixelWarsCoinPrice;
        accounts[msg.sender].pixelWarsCoin += coins;
        BuyPixelWarsCoins(msg.sender, coins);
        return true;
    }
    /*
        Создание персонажа
    */
    function createCharacter(string characterName) public returns (uint) {
        // Аккаунта создан и активный
        if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return 0;
        // Персонажи ещё не закончились
        if (allCharactersAssigned) return 0;
        // Персонаж ещё никому не принадлежит
        if (characterIndexToAddress[nextCharacterIndexToAssign] != 0x0) return 0;
        // Инициализируем нового персонажа
        Character memory newCharacter;
        newCharacter.name = characterName;
        newCharacter.id = nextCharacterIndexToAssign;
        uint8[32] memory generateSkilsMask;
        bool error;
        (generateSkilsMask, error) = generateCharacterSkillMask();
        if(error) return 0;
        newCharacter.skilsMask = generateSkilsMask;
        newCharacter.isDeleted = false;
        newCharacter.experienceCoin = 0;
        // Сохраняем персонажа в список персонажей
        characters[nextCharacterIndexToAssign] = newCharacter;
        // Связываем нового персонажа с хозяином
        characterIndexToAddress[nextCharacterIndexToAssign] = msg.sender;
        // Увеличиваем индекс для следующего персонажа
        CreateCharacter(msg.sender, nextCharacterIndexToAssign);
        nextCharacterIndexToAssign++;
        // Баланс аккаунта увеличиваем
        balanceOf[msg.sender]++;
        return (nextCharacterIndexToAssign - 1);
    }
    /*
        Удаление персонажа.
        Персонаж остается без хозяина и получет статус удален.
    */
    function deleteCharacter(uint characterIndex) public returns (bool) {
        // Аккаунта создан и активный
        if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Устанавливаем персонажу флаг удален
        characters[characterIndex].isDeleted = true;
        // Удаляем првязку персонажа к владельцу
        characterIndexToAddress[characterIndex] == 0x0;
        // Уменьшаем баланс владельца
        balanceOf[msg.sender]--;
        return true;
    }
    /*
        Получение инфо о персонаже по индексу
        владелец, ник, способности, маска способностей, флаг удаления, монеты для прокачки
    */
    function getCharacterByIndex(uint characterIndex) public view returns (address, string, uint8[32], uint8[32], bool, uint, bool, address, address) {
        Character memory userCharacter = characters[characterIndex];
        return (
        characterIndexToAddress[characterIndex],
        userCharacter.name,
        userCharacter.skils,
        userCharacter.skilsMask,
        userCharacter.isDeleted,
        userCharacter.experienceCoin,
        userCharacter.isTenanted,
        userCharacter.tenant,
        userCharacter.possibleTenant
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
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        if(characterIndex == 0 || experienceCoin == 0) return false;
        // Увеличиваем колиство монет прокачки персонажа
        if(characters[characterIndex].isTenanted && characters[characterIndex].tenant != 0x0) {
            accounts[msg.sender].freeExperienceCoin += experienceCoin/2;
            IncreaseFreeExperienceCoin(msg.sender, characterIndex, experienceCoin/2);
        } else {
            characters[characterIndex].experienceCoin += experienceCoin;
            IncreaseExperienceCoin(msg.sender, characterIndex, experienceCoin);
        }
        return true;
    }
    /*
        Увеличение уровня прокачки скила (на 1)
    */
    function increaseSkillLevel(uint characterIndex, uint skillIndex, uint freeExperienceCoins) public returns (bool) {
        // Аккаунта создан и активный
        if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Валидный скил индекс
        if (skillIndex < 0 || skillIndex > 32) return false;
        // Можно ли ещё качать эту способность
        if (characters[characterIndex].skils[skillIndex] >= characters[characterIndex].skilsMask[skillIndex]) return false;
        // у персонажа есть необходимое кол-во монет опыта
        if (accounts[msg.sender].freeExperienceCoin < freeExperienceCoins) return false;
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
            accounts[msg.sender].freeExperienceCoin -= usedFreeExperience;
        }
        characters[characterIndex].skils[skillIndex]++;
        IncreaseSkillLevel(msg.sender, characterIndex, skillIndex, experienceForNextLevel, freeExperienceCoins);
        return true;
    }
    /*
        Генерация уровня прокачки скилов нового персонажа.
    */
    function generateCharacterSkillMask() public view returns (uint8[32], bool) {
        return convertBlockHashToUintHexArray(block.number - 1);
    }

    function convertBlockHashToUintHexArray(uint blockNumber) public view returns (uint8[32] skillsLevel, bool error) {
        bytes32 lastBlockHash = block.blockhash(blockNumber);
        string memory s = bytes32ToString(lastBlockHash);
        bytes memory b = bytes(s);
        uint8 convertValue;
        bool resultSuccess;
        for (uint i = 0; i < 32; i++) {
            (convertValue, resultSuccess) = byteToUint(b[i]);
            if (resultSuccess) {
                skillsLevel[i] = convertValue;
            } else {
                error = true;
            }
        }
        return (skillsLevel, error);
    }
    /*
        Получение выигрышного пикселя
        characterCount - кол-во символов необходимых для получения выигрышного пикселя
    */
    function getWinningPixel(uint characterCount) public view onlyOwner returns (uint, bool, string) {
        bool error = false;
        bytes32 lastBlockHash = block.blockhash(block.number - 1);
        string memory s = bytes32ToString(lastBlockHash);
        bytes memory b = bytes(s);
        uint characterConvertCount = 0;
        uint resultValue = 1;
        uint8 convertValue;
        bool resultSuccess;
        for (uint i = 0; i < characterCount; i++) {
            (convertValue, resultSuccess) = byteToUint(b[i]);
            if (resultSuccess) {
                convertValue += 1;
                resultValue *= uint(convertValue);
            } else {
                error = true;
            }
            characterConvertCount++;
            if (i == 31 && characterConvertCount < characterCount) {
                i = 0;
            }
            if (characterConvertCount == characterCount) {
                break;
            }
        }
        return (resultValue, error, s);
    }
    /*
        Преобразование байтов в числа
    */
    function byteToUint(byte b) public pure returns (uint8, bool) {
        uint8 retValue = 127;
        if (b >= 48 && b <= 57) {
            retValue = uint8(b) - 48;
        } else if (b == 97) {
            retValue = 10;
        } else if (b == 98) {
            retValue = 11;
        } else if (b == 99) {
            retValue = 12;
        } else if (b == 100) {
            retValue = 13;
        } else if (b == 101) {
            retValue = 14;
        } else if (b == 102) {
            retValue = 15;
        }

        if (retValue >= 0 && retValue <= 15) {
            return (retValue, true);
        }
        return (retValue, false);
    }

    function convertToChar(byte b) public pure returns (byte) {
        if (b < 10) {
            return byte(uint8(b) + 0x30);
        }
        else {
            return byte(uint8(b) + 0x57);
        }
    }
    /*
    Функция преобразовывает байты в строку UTF-8
    @b32 - массив байт для преобразования
    retutn string - полученная строка
    */
    function bytes32ToString(bytes32 b32) public pure returns (string out) {
        bytes memory s = new bytes(64);
        for (uint8 i = 0; i < 32; i++) {
            byte b = byte(b32[i]);
            byte hi = byte(uint8(b) / 16);
            byte lo = byte(uint8(b) - 16 * uint8(hi));
            s[i * 2] = convertToChar(hi);
            s[i * 2 + 1] = convertToChar(lo);
        }
        out = string(s);
    }

    function bytes32ToBytes(bytes32 b32) public pure returns (bytes out) {
        bytes memory s = new bytes(64);
        for (uint8 i = 0; i < 32; i++) {
            byte b = byte(b32[i]);
            byte hi = byte(uint8(b) / 16);
            byte lo = byte(uint8(b) - 16 * uint8(hi));
            s[i * 2] = convertToChar(hi);
            s[i * 2 + 1] = convertToChar(lo);
        }
        out = s;
    }
    /*
        Блок раздачи призов
    */
    /*
        Начисление игровой валюты на учетную запись
    */
    function accrualPixelWarsCoins(uint pixelCount, uint accountIndex) public onlyOwner returns (bool) {
        if (!accounts[indexOfAccounts[accountIndex]].isCreated) return false;
        accounts[indexOfAccounts[accountIndex]].pixelWarsCoin += pixelCount;
        AccrualPixelWarsCoins(msg.sender, pixelCount, accountIndex);
        return true;
    }
    /*
        Списание игровой валюты с учетной записи
    */
    function withdrawalPixelWarsCoins(uint pixelCount, uint accountIndex) public onlyOwner returns (bool) {
        if (!accounts[indexOfAccounts[accountIndex]].isCreated) return false;
        if (accounts[indexOfAccounts[accountIndex]].pixelWarsCoin >= pixelCount) {
            accounts[indexOfAccounts[accountIndex]].pixelWarsCoin -= pixelCount;
        } else {
            return false;
        }
        WithdrawalPixelWarsCoins(msg.sender, pixelCount, accountIndex);
        return true;
    }
    /*
        Конвертация опыта персонажа в свободный опыт
    */
    function convertExperienceToFreeExperience(uint characterIndex, uint countCoinForCovert) public returns (bool) {
        // Аккаунта создан и активный
        if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // у персонажа есть необходимое кол-во монет опыта
        if (characters[characterIndex].experienceCoin < countCoinForCovert) return false;
        characters[characterIndex].experienceCoin -= countCoinForCovert;
        accounts[msg.sender].freeExperienceCoin += (countCoinForCovert / 2);
        return true;
    }
    /*
        Задать предполагаемого арендатора персонажа
    */
    function setPossibleTenant(uint characterIndex, address tenant) public returns (bool) {
        // Аккаунта создан и активный
        if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Персонаж не в аренде
        if (characters[characterIndex].isTenanted) return false;
        characters[characterIndex].possibleTenant = tenant;
        SetPossibleTenant(msg.sender, characterIndex, tenant);
        return true;
    }
}

/*
 function getAccountBalance() - мы можем узнать баланс аккаунта только от имени его владельца? это может затруднить получение данных для других игроков
*/