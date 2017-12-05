pragma solidity ^0.4.17;

import "./DHFBaseCurrency.sol";

contract RgbLottery is DHFBaseCurrency {

    enum RgbLotteryColors { Red, Green, Blue }

    RgbLotteryColors firstDayColor;
    RgbLotteryColors secondDayColor;

    function RgbLottery() DHFBaseCurrency(110000, "Lottery Powerball", "LP") public {

    }

    function getDayColors() public constant returns (RgbLotteryColors, RgbLotteryColors) {
        return (firstDayColor, secondDayColor);
    }

    function setDayColors(RgbLotteryColors first, RgbLotteryColors second) public onlyOwner {
        firstDayColor = first;
        secondDayColor = second;
    }

    function getRgbColorRandom() public returns (string) {
        bytes32 lastBlockHash = block.blockhash(block.number - 1);
        bytes32 lastBlockHashKeccak256 = keccak256(lastBlockHash);
        return subString(bytes32string(lastBlockHashKeccak256), 0, 6);
    }

    function char(byte b) private returns (byte) {
        if (b < 10) {
            return byte(uint8(b) + 0x30);
        }
        else {
            return byte(uint8(b) + 0x57);
        }
    }

    function bytes32string(bytes32 b32) private returns (string out) {
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

    function subString(string str, uint startIndex, uint endIndex) public pure returns (string) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }
}