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

    event Assign(address indexedTo, uint256 characterIndex);
    event Transfer(address indexedFrom, address indexedTo, uint256 value);
    /*

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
        Skill[5] skils; // способности
        Skill[5] skilsMask; // верхний предел прокачки персонажа
    }
    /*
        Описание способностей
    */
    struct Skill {
        uint slillType; // тип способности
        uint[6] skillCharacteristic; // характеристики способности
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
}