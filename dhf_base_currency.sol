pragma solidity ^0.4.16;

contract owned {
    address public owner;

//конструктор класса: при СОЗДАНИИ контракта в качестве владелльца контракта прописывается его создатель
    function owned() public {
        owner = msg.sender;
    }

//Модификатор - в начале функции, наследуемой от можификатора .сначала выполняется код модификатора, а затем - код самой функции
// в этом модификаторе проверяется является ли исполнитель метода создателем контракта
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

//функция для назначения нового владельца контракта - может исполняться только старым владельцем
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

//а вот это надо найти что такое
interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

//сам контракт
contract TokenERC20 {
    // Public variables of the token основные данные о самом токене - нашей криптовалюте
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances балансы участников криптовалюты
    mapping (address => uint256) public balanceOf;
    /* На снятие монет с адреса может быть предоставлено сколько угодно разрешений. По одному для каждого пользователя.
     * При этом каждое разрешение должно хранить сумму которую доверенное лицо может снять.
     * Первый ключ — адрес на снятие с которого предоставляется разрешение. Второй ключ — пользователь, которому предоставляется разрешение.
     */
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    /**
     * Конструктор токена
     * uint256 initialSupply первичный объем выпускаемой криптовалюты
     * string tokenName имя криптовалюты
     * string tokenSymbol символ криптовалюты
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function TokenERC20(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount объем криптоцентов (1 криптоцент это 1/10^18)
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens все криптоценты сразу зачисляются создателю
        name = tokenName;                                   // Set the name for display purposes установка имени токена-валюты
        symbol = tokenSymbol;                               // Set the symbol for display purposes установка символа крипты
    }

    /**
     * Internal transfer, only can be called by this contract
	 * Внутренний перевод, вызывается только этим контрактом
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead проверяется не нулевой ли адрес ,если нулевой, то функция вылетает
        require(_to != 0x0);
        // Check if the sender has enough достаточно ли бенег у отправителя
        require(balanceOf[_from] >= _value);
        // Check for overflows проверяем, увеличивает ли операция баланс получателя
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future сохраняем их общий баланс для подтверждения в будущем
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender снижаем баланс передающего
        balanceOf[_from] -= _value;
        // Add the same to the recipient повышаем баланс принимающего
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     * перевод токенов с ЧУЖОГО адреса
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance Проверить, меньше ли переводимая сумма размера разрешенной к переводу с чужого адреса
        allowance[_from][msg.sender] -= _value; //понизить лимит снятия чужих денег на переводимое значение
        _transfer(_from, _to, _value); // произвести трасфер
        return true;
    }

    /**
     * Set allowance for other address
     * Устанавливаем стороннему пользователю разрешение тратить определенное число токенов со своего счета
	 * В теории можно разрешить тратить больше чем есть на счету - функция _transfer не позволит этого совершить
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
     * Устанавливаем стороннему пользователю разрешение тратить определенное число токенов со своего счета и затем сразу оповещаем его о такой возможности
     * @param _spender The address authorized to spend адрес того, кому разрешаем тратить
     * @param _value the max amount they can spend сколько мы разрешаем тратить
     * @param _extraData some extra information to send to the approved contract сообщение с информацией для того, кому разрешаем тратить
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /**
     * Destroy tokens
     * уничтожаем частб токенов
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough достаточно ли на балансе токенов
        balanceOf[msg.sender] -= _value;            // Subtract from the sender снижаем счет поджигателя
        totalSupply -= _value;                      // Updates totalSupply снижаем общую денежную массу
        Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other ccount
     * мы можем просто взять и сжечь часть токенов другого пользователя .если у нас есть разрешение на полльзование ими просто так
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        Burn(_from, _value);
        return true;
    }
}

/******************************************/
/*       ADVANCED TOKEN STARTS HERE       */
/******************************************/

//наследуем контракт от owned и erc20
contract MyAdvancedToken is owned, TokenERC20 {

    uint256 public sellPrice;
    uint256 public buyPrice;

	//Вводится понятие замороженных аккаунтов
    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract 
	 * 
	 *
	 */
    function MyAdvancedToken(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] > _value);                // Check if the sender has enough
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen нельзя переводить деньги с мороженного аккаунта
        require(!frozenAccount[_to]);                       // Check if recipient is frozen нельзя переводить деньги на мороженный аккаунт
        balanceOf[_from] -= _value;                         // Subtract from the sender изменение балансов
        balanceOf[_to] += _value;                           // Add the same to the recipient изменение балансов
        Transfer(_from, _to, _value);
    }

    /// @notice Create `mintedAmount` tokens and send it to `target` Чеканка токенов для левых владельцев (право на дочеканку есть только у создателя крипты)
    /// @param target Address to receive the tokens получатель токенов
    /// @param mintedAmount the amount of tokens it will receive 
    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, this, mintedAmount);//уведомление о трансфере токенов из ниоткуда в базовый аккаунт крипты??
        Transfer(this, target, mintedAmount); // уведомление о последующем трансфере этой крипты получателю.
    }

    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens заморозка аккаунта - имеет право только создатель крипты
    /// @param target Address to be frozen
    /// @param freeze either to freeze it or not
    function freezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }

    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
    /// @param newSellPrice Price the users can sell to the contract
    /// @param newBuyPrice Price users can buy from the contract
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    /// @notice Buy tokens from contract by sending ether
    function buy() payable public {
        uint amount = msg.value / buyPrice;               // calculates the amount
        _transfer(this, msg.sender, amount);              // makes the transfers
    }

    /// @notice Sell `amount` tokens to contract
    /// @param amount amount of tokens to be sold
    function sell(uint256 amount) public {
        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
        _transfer(msg.sender, this, amount);              // makes the transfers
        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }
}
