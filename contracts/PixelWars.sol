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
        bool isActivate; // активин/ неактивен
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
        uint experienceCoin;
    }
    /*
        Описание оружия
    */
    struct Gun {

    }

    // ключ адрес кошеля владельца, значение инфо об аккаунте
    mapping (address => Account) private accounts;
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
        Получить баланс монет аккаунта
    */
    function getAccountBalance() public view returns (uint) {
        return accounts[msg.sender].pixelWarsCoin;
    }
    /*
        Задать цену покупки игровой валюты(в газе)
    */
    function setPixelWarsCoinPrice(uint newPrice) private onlyOwner returns (bool) {
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
        // Инициализируем нового персонажа
        Character memory newCharacter;
        newCharacter.name = characterName;
        newCharacter.skilsMask = generateCharacterSkills();
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
        Получение монент для прокачки скилов
    */
    function increaseExperienceCoin(uint characterIndex, uint experienceCoin) public onlyOwner returns (bool) {
        // У персонажа есть хозяин
        if(characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] == msg.sender) return false;
        // Увеличиваем колиство монет прокачки персонажа
        characters[characterIndex].experienceCoin += experienceCoin;
        return true;
    }
    /*
        Генерация уровня прокачки скилов нового персонажа.
    */
    function generateCharacterSkills() public view onlyOwner returns (uint[32]) {
        bool error = false;
        uint[32] memory skillsLevel;
        bytes32 lastBlockHash = block.blockhash(block.number - 1);
        bytes32 lastBlockHashKeccak256 = keccak256(lastBlockHash);
        string memory s = bytes32ToString(lastBlockHashKeccak256);
        bytes memory b = bytes(s);
        for(uint i = 0; i < 32; i++){
            var (convertValue, resultSuccess) = byteToUint(b[i]);
            if(resultSuccess) {
                skillsLevel[i] = convertValue;
            } else {
                error = true;
            }
        }
        return skillsLevel;
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

    function char(byte b) public pure returns (byte) {
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
            s[i*2] = char(hi);
            s[i*2+1] = char(lo);
        }
        out = string(s);
    }

    function bytes32ToBytes(bytes32 b32) public pure returns (bytes out) {
        bytes memory s = new bytes(64);
        for (uint8 i = 0; i < 32; i++) {
            byte b = byte(b32[i]);
            byte hi = byte(uint8(b) / 16);
            byte lo = byte(uint8(b) - 16 * uint8(hi));
            s[i*2] = char(hi);
            s[i*2+1] = char(lo);
        }
        out = s;
    }
}