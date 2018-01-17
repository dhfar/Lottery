pragma solidity ^0.4.17;

import "./Owned.sol";

contract PixelWars is Owned {

    string public standard = 'PixelWars';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    uint public nextCharacterIndexToAssign = 0;
    bool public allCharactersAssigned = false;
    uint public characterRemainingToAssign = 0;

    uint public pixelWarsCoinPrice = 10000;

    uint maxCharacterOnAccount = 32;

    mapping (uint => address) public characterIndexToAddress;
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    /* персонажи */
    mapping (uint => Character) public characters;

    event Assign(address indexedTo, uint256 characterIndex);
    event Transfer(address indexedFrom, address indexedTo, uint256 value);
    /*
        Описание аккаунта
    */
    struct Account {
        string email; // почта
        bytes32 password; // хэшпароля
        bool isActivate; // активен/ неактивен
        uint pixelWarsCoin; // игровая валюта
        bool isCreated; //  создан
    }
    /*
        Описание персонажа
    */
    struct Character {
        string name; // ник
        uint[32] skils; // способности
        uint[32] skilsMask; // верхний предел прокачки персонажа
        bool isDeleted; // флаг удаления
        uint experienceCoin; // монеты для прокачки
        uint winCount; // количество побед
        uint gameCount; // количство игр
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
    // ключ адрес кошеля владельца, значение инфо об аккаунте
    mapping (address => Account) private accounts;
    uint lastAccountIndex = 0;
    mapping (uint => address) private indexOfAccounts;
    /*
        Создание контракта
    */
    function PixelWars() public payable  {
        owner = msg.sender;
        totalSupply = 10000;                        // Update total supply
        characterRemainingToAssign = totalSupply;
        name = "PixelWarsCharacter";                                   // Set the name for display purposes
        symbol = "PWС";                               // Set the symbol for display purposes
        decimals = 0; // Amount of decimals for display purposes

    }
    /*
        Создание аккаунта
    */
    function createAccount(string userEmail, string userPassword) public returns (bool) {
        if(accounts[msg.sender].isCreated) return false;
        Account memory newAccount;
        newAccount.email = userEmail;
        newAccount.password = sha256(userPassword);
        newAccount.isActivate = true;
        newAccount.pixelWarsCoin = 0;
        newAccount.isCreated = true;
        accounts[msg.sender] = newAccount;
        indexOfAccounts[lastAccountIndex] = msg.sender;
        lastAccountIndex++;
        return true;
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
        string - email, bool - активен/ неактивен, uint - игровая валюта, bool - создан, address - владелец, Character[] - список персонажей
    */
    function getAccountInfoByIndex(uint indexAccount) public view onlyOwner returns (string, bool, uint, bool, address, uint[32]) {
        return (accounts[indexOfAccounts[indexAccount]].email,
        accounts[indexOfAccounts[indexAccount]].isActivate,
        accounts[indexOfAccounts[indexAccount]].pixelWarsCoin,
        accounts[indexOfAccounts[indexAccount]].isCreated,
        indexOfAccounts[indexAccount],
        getCharactersByIndex(indexAccount)
        );
    }
    /*
        Получить список идентификаторов персонажей по идентификатору учетной записи
    */
    function getCharactersByIndex(uint indexAccount) public view onlyOwner returns (uint[32]){
        uint[32] memory characterByIndexAccount;
        uint characterCount = 0;
        for (uint i = 0; i < nextCharacterIndexToAssign; i++){
            if(characterIndexToAddress[i] == indexOfAccounts[indexAccount]){
                characterByIndexAccount[characterCount] = i;
                characterCount++;
            }
        }
        return characterByIndexAccount;
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
        if(newPrice <= 0) return false;
        pixelWarsCoinPrice = newPrice;
        return true;
    }
    /*
        Покупка игровой валюты
    */
    function buyPixelWarsCoins() public payable returns (bool) {
        if(!accounts[msg.sender].isCreated) return false;
        if(msg.value <= 0) return false;
        uint coins = msg.value / pixelWarsCoinPrice;
        accounts[msg.sender].pixelWarsCoin += coins;
        return true;
    }
    /*
        Создание персонажа
    */
    function createCharacter(string characterName) public returns (bool) {
        // Аккаунта создан и активный
        if(!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонажи ещё не закончились
        if (allCharactersAssigned) return false;
        // Персонаж ещё никому не принадлежит
        if(characterIndexToAddress[nextCharacterIndexToAssign] != 0x0) return false;
        // проверка на лимит персонажей
        if (balanceOf[msg.sender] > maxCharacterOnAccount) return false;
        // Инициализируем нового персонажа
        Character memory newCharacter;
        newCharacter.name = characterName;
        var (skilsMask, error) = generateCharacterSkills();
        if (error) return false;
        newCharacter.skilsMask = skilsMask;
        newCharacter.isDeleted = false;
        newCharacter.experienceCoin = 0;
        // Сохраняем персонажа в список персонажей
        characters[nextCharacterIndexToAssign] = newCharacter;
        // Связываем нового персонажа с хозяином
        characterIndexToAddress[nextCharacterIndexToAssign] = msg.sender;
        // Увеличиваем индекс для следующего персонажа
        nextCharacterIndexToAssign++;
        // Баланс аккаунта увеличиваем
        balanceOf[msg.sender]++;
        return true;
    }
    /*
        Удаление персонажа.
        Персонаж остается без хозяина и получет статус удален.
    */
    function deleteCharacter(uint characterIndex) public returns (bool) {
        // Аккаунта создан и активный
        if(!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if(characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
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
    function getCharacterByIndex(uint characterIndex) public view returns (address, string, uint[32], uint[32], bool, uint) {
        return (
        characterIndexToAddress[characterIndex],
        characters[characterIndex].name,
        characters[characterIndex].skils,
        characters[characterIndex].skilsMask,
        characters[characterIndex].isDeleted,
        characters[characterIndex].experienceCoin
        );
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
        if(characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Увеличиваем колиство монет прокачки персонажа
        characters[characterIndex].experienceCoin += experienceCoin;
        return true;
    }
    /*
        Увеличение уровня прокачки скила (на 1)
    */
    function increaseSkillLevel(uint characterIndex, uint skillIndex) public returns (bool) {
        // Аккаунта создан и активный
        if(!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
        // Персонаж принадлежит вызвавшему функцию
        if(characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
        // Можно ли ещё качать эту способность
        if (characters[characterIndex].skils[skillIndex] >= characters[characterIndex].skilsMask[skillIndex]) return false;
        // Валидный скил индекс
        if(skillIndex < 0 || skillIndex > 32 ) return false;
        // Монеты для поднятия уровня скила
        uint experienceForNextLevel = 2 * (2 ** characters[characterIndex].skils[skillIndex]);
        // Есть ли нужное кол-во монет
        if (characters[characterIndex].experienceCoin == 0 && characters[characterIndex].experienceCoin < experienceForNextLevel) return false;
        characters[characterIndex].experienceCoin -= experienceForNextLevel;
        characters[characterIndex].skils[skillIndex]++;
        return true;
    }
    /*
        Генерация уровня прокачки скилов нового персонажа.
    */
    function generateCharacterSkills() public view onlyOwner returns (uint[32], bool) {
        bool error = false;
        uint[32] memory skillsLevel;
        bytes32 lastBlockHash = block.blockhash(block.number - 1);
        string memory s = bytes32ToString(lastBlockHash);
        bytes memory b = bytes(s);
        for(uint i = 0; i < 32; i++){
            var (convertValue, resultSuccess) = byteToUint(b[i]);
            if(resultSuccess) {
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
        for(uint i = 0; i < characterCount; i++){
            var (convertValue, resultSuccess) = byteToUint(b[i]);
            if(resultSuccess) {
                convertValue += 1;
                resultValue *= convertValue;
            } else {
                error = true;
            }
            characterConvertCount++;
            if(i == 31 && characterConvertCount < characterCount){
                i = 0;
            }
            if(characterConvertCount == characterCount){
                break;
            }
        }
        return (resultValue, error, s);
    }
    /*
        Преобразование байтов в числа
    */
    function byteToUint(byte b) public pure returns (uint, bool) {
        uint retValue = 12345;
        if(b >= 48 && b <= 57) {
            retValue = uint(b) - 48;
        } else if(b == 97) {
            retValue = 10;
        } else if(b == 98) {
            retValue = 11;
        } else if(b == 99) {
            retValue = 12;
        } else if(b == 100) {
            retValue = 13;
        } else if(b == 101) {
            retValue = 14;
        } else if(b == 102) {
            retValue = 15;
        }

        if(retValue >= 0 && retValue <= 15) {
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
            s[i*2] = convertToChar(hi);
            s[i*2+1] = convertToChar(lo);
        }
        out = string(s);
    }

    function bytes32ToBytes(bytes32 b32) public pure returns (bytes out) {
        bytes memory s = new bytes(64);
        for (uint8 i = 0; i < 32; i++) {
            byte b = byte(b32[i]);
            byte hi = byte(uint8(b) / 16);
            byte lo = byte(uint8(b) - 16 * uint8(hi));
            s[i*2] = convertToChar(hi);
            s[i*2+1] = convertToChar(lo);
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
        if(!accounts[indexOfAccounts[accountIndex]].isCreated) return false;
        accounts[msg.sender].pixelWarsCoin += pixelCount;
        return true;
    }
    /*
        Списание игровой валюты с учетной записи
    */
    function withdrawalPixelWarsCoins(uint pixelCount, uint accountIndex) public onlyOwner returns (bool) {
        if(!accounts[indexOfAccounts[accountIndex]].isCreated) return false;
        if (accounts[msg.sender].pixelWarsCoin >= pixelCount){
            accounts[msg.sender].pixelWarsCoin -= pixelCount;
        } else {
            accounts[msg.sender].pixelWarsCoin = 0;
        }
        return true;
    }
}

/*
 function getAccountBalance() - мы можем узнать баланс аккаунта только от имени его владельца? это может затруднить получение данных для других игроков
*/