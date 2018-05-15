pragma solidity ^0.4.21;

import "./Owned.sol";

contract CKServiceContract is Owned {

    function CKServiceContract() public {
        owner = msg.sender;
    }

    function convertBlockHashToUintHexArray(uint blockNumber, uint8 convertCharacterCount) public view returns (uint8[32] convertValues, bool error) {
        return convertBlockHashToUintHexArray(block.blockhash(blockNumber), convertCharacterCount);
    }

    function convertBlockHashToUintHexArray(bytes32 bloclHash, uint8 convertCharacterCount) public pure returns (uint8[32] convertValues, bool error) {
        if (convertCharacterCount == 0 || convertCharacterCount > 32) return (convertValues, error);
        string memory s = bytes32ToString(bloclHash);
        bytes memory b = bytes(s);
        uint8 convertValue;
        bool resultSuccess;
        for (uint i = 0; i < convertCharacterCount; i++) {
            (convertValue, resultSuccess) = byteToUint(b[i]);
            if (resultSuccess) {
                convertValues[i] = convertValue;
            } else {
                error = true;
            }
        }
        return (convertValues, error);
    }
    /*
        Получение выигрышного пикселя
        characterCount - кол-во символов необходимых для получения выигрышного пикселя
    */
    function geMultiplicationBlochHashCharacters(uint characterCount) public view onlyOwner returns (uint, bool, string) {
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
}