pragma solidity ^0.4.17;

import "./DHFBaseCurrency.sol";

contract RgbLottery is DHFBaseCurrency {

    enum RgbLotteryColors { Red, Green, Blue }

    RgbLotteryColors firstDayColor;
    RgbLotteryColors secondDayColor;

    function RgbLottery() DHFBaseCurrency(110000, "Lottery Powerball", "LP") public {

    }
    /*
    Функция возвращает пару цветов текущего дня
    retutn (int, int) - пара цветов дня
    */
    function getDayColors() public constant returns (RgbLotteryColors, RgbLotteryColors) {
        return (firstDayColor, secondDayColor);
    }
    /*
    Функция задает пару цветов текущего дня
    @first - первый цвет, @second - второй цвет
    */
    function setDayColors(RgbLotteryColors firstColor, RgbLotteryColors secondColor) public onlyOwner {
        firstDayColor = firstColor;
        secondDayColor = secondColor;
    }
    /*
    Функция возвращает первые 6 символов хэша предыдущего блока
    retutn string - первые 6 символов хэша предыдущего блока
    */
    function getRgbColorRandom() public view returns (string) {
        bytes32 lastBlockHash = block.blockhash(block.number - 1);
        bytes32 lastBlockHashKeccak256 = keccak256(lastBlockHash);
        return subString(bytes32string(lastBlockHashKeccak256), 0, 6);
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
    function bytes32string(bytes32 b32) public pure returns (string out) {
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
    /*
    Функция обрезает строку
    @str - строка, @startIndex - позиция строки с которой начать обрезание, @endIndex - позиция строки на которой которой завершить обрезание
    retutn string - новая строка
    */
    function subString(string str, uint startIndex, uint endIndex) public pure returns (string) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    /*
    Функция сравнивает 2 строки
    @_a - первая строка, @_b - вторая строка
    retutn int - -1 - строка @_b больше, 0 - строки равны, 1 -  строка @_a больше
    */
    function compareString(string _a, string _b) public pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }

    /*
    Функция сравнивает 2 строки
    @_a - первая строка, @_b - вторая строка
    retutn bool - true - строки равны, false -  строки разные
    */
    function equalString(string a, string b) public pure returns (bool) {
        return compareString(a, b) == 0;
    }
}