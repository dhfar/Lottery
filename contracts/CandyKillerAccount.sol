pragma solidity ^0.4.21;

import "./Owned.sol";

contract CandyKillerAccount is Owned {
    // идентификатор следующей учетной записи
    uint public nextAccountIndex = 1;
    // стоимость 1 единицы игровой валюты
    uint public pixelWarsCoinPrice = 10000;
    // список учетных записе
    mapping(address => Account) private accounts;
    mapping(uint => address) private indexOfAccounts;
    /*
        Описание аккаунта
    */
    struct Account {
        uint index; // идентификатор
        string email; // почта
        bytes32 password; // хэшпароля
        bool isActivate; // активен/ неактивен
        uint pixelWarsCoin; // игровая валюта
        bool isCreated; //  создан
        uint freeExperienceCoin; //свободный опыт
    }
    /*
        События
    */
    // создание учетной записи
    event CreateAccount(address indexed _creator, uint _account);
    // создание персонажа
    event CreateCharacter(address indexed _creator, uint _character);
    // покупка игровой валюты
    event BuyPixelWarsCoins(address indexed _buyer, uint _coins);
    // начисление игровой валюты
    event AccrualPixelWarsCoins(address indexed _executor, uint _pixelCount, uint _accountIndex);
    // списание игровой валюты
    event WithdrawalPixelWarsCoins(address indexed _executor, uint _pixelCount, uint _accountIndex);

    function CandyKillerAccount() public {
        owner = msg.sender;
    }
    /*
        Создание аккаунта
    */
    function createAccount(string userEmail, string userPassword) public returns (uint) {
        if (accounts[msg.sender].isCreated) return 0;
        Account memory newAccount;
        newAccount.index = nextAccountIndex;
        newAccount.email = userEmail;
        newAccount.password = sha256(userPassword);
        newAccount.isActivate = true;
        newAccount.pixelWarsCoin = 0;
        newAccount.isCreated = true;
        accounts[msg.sender] = newAccount;
        indexOfAccounts[nextAccountIndex] = msg.sender;
        emit CreateAccount(msg.sender, nextAccountIndex);
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
            userAccount.index,
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
        Получить информацию об учетной записи по адресу вызвавшего функцию
        string - email, bool - активен/ неактивен, uint - игровая валюта, bool - создан, address - владелец, int - свободный опыт
    */
    function getAccountInfo() public view returns (uint, string, bool, uint, bool, address, uint) {
        return getAccountInfoByIndex(accounts[msg.sender].index);
    }
    /*
        Получить идентификатор учетной записи по адресу владельца
        uint - id учетной записи
    */
    function getAccountIndexByAddress(address ownerAccount) public view returns (uint){
        return accounts[ownerAccount].index;
    }
    /*
        Получить идентификатор учетной записи по адресу вызвавшего функцию
        uint - id учетной записи
    */
    function getAccountIndex() public view returns (uint){
        return getAccountIndexByAddress(msg.sender);
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
        emit BuyPixelWarsCoins(msg.sender, coins);
        return true;
    }
    /*
        Начисление игровой валюты на учетную запись
    */
    function accrualPixelWarsCoins(uint pixelCount, uint accountIndex) public onlyOwner returns (bool) {
        if (!accounts[indexOfAccounts[accountIndex]].isCreated) return false;
        accounts[indexOfAccounts[accountIndex]].pixelWarsCoin += pixelCount;
        emit AccrualPixelWarsCoins(msg.sender, pixelCount, accountIndex);
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
        emit WithdrawalPixelWarsCoins(msg.sender, pixelCount, accountIndex);
        return true;
    }
    /*
        Конвертация опыта персонажа в свободный опыт
        ToDo будет после реализации контракта отряда
    */
    // function convertExperienceToFreeExperience(uint characterIndex, uint countCoinForCovert) public returns (bool) {
    // // Аккаунта создан и активный
    // if (!accounts[msg.sender].isCreated || !accounts[msg.sender].isActivate) return false;
    // // Персонаж принадлежит вызвавшему функцию
    // if (characterIndexToAddress[characterIndex] == 0x0 || characterIndexToAddress[characterIndex] != msg.sender) return false;
    // // у персонажа есть необходимое кол-во монет опыта
    // if (characters[characterIndex].experienceCoin < countCoinForCovert) return false;
    // characters[characterIndex].experienceCoin -= countCoinForCovert;
    // accounts[msg.sender].freeExperienceCoin += (countCoinForCovert / 2);
    // return true;
    // }

    // ToDo списание свободного опыта
    // ToDo начисление свободного опыта
}