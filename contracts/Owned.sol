pragma solidity ^0.4.21;

contract Owned {
    address public owner;

    //конструктор класса: при СОЗДАНИИ контракта в качестве владелльца контракта прописывается его создатель
    function Owned() public {
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