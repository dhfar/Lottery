pragma solidity ^0.4.19;

import "./DhfServiceContract.sol";

contract CandyKiller is DhfServiceContract {
    /*
        Колония
    */
    struct CandyColony {
        uint candyColonyIndex;
        address colonyOwner;
        uint colonyLevel;
        mapping(uint => CandyBuilding) candyBuildingList;
        uint candyBuildingCount;
        uint candySugar;
        uint candyMedarium;
        uint unitCount;
    }
    /*
        Ячейка земли
    */
    struct CandyEarthCell {
        uint candyEarthCellIndex;
        uint8[2] candyEarthCellCoords;
        uint8[9] candyBuildingIdsOnCell;
        address candyEarthCellOwner;
        uint candySugar;
        uint candyMedarium;
        bool cellStatus;
        bool isNotSale;
    }
    /*
        Здания
    */
    struct CandyBuilding {
        // Id земли - на какой ячейке стоит здание
        uint8 candyEarthCellIndex;
        // Локальная координата верхнего левого угла на земле
        uint8 candyBuildingIndexOnCell;
        // Тип здания
        uint8 candyBuildingType;
        // Уровень здания
        uint8 candyBuildingLevel;
        // Статус уничтожения
        bool isDestroyed;
    }

    mapping(uint => CandyEarthCell) candyEarthCellList;
    mapping(uint => CandyColony) candyColonyList;

    uint nextCandyEarthCellIndex = 1;
    uint nextCandyColonyIndex = 1;

    event CreateCandyColony(uint colonyIndex, address indexed ownerColonyAddress);
    event CreateCandyEarthCellForNewColony(uint candyEarthCellIndex, uint candySugar, uint candyMedarium, address indexed ownerCandyEarthCellAddress);
    event GenerateNewCandyEarthCell(uint gameId, uint candyEarthCellIndex, uint candySugar, uint candyMedarium, address indexed ownerCandyEarthCellAddress);

    function CandyKiller() DhfServiceContract() public payable {
        owner = msg.sender;
    }

    function createCandyColony() public {
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = convertBlockHashToUintHexArray(block.number - 1, 10);
        if (error) return;
        // candyColonyListIndexByAddress[msg.sender] = nextCandyColonyIndex;
        CandyColony memory newCandyColony;
        newCandyColony.candyColonyIndex = nextCandyColonyIndex;
        newCandyColony.colonyOwner = msg.sender;
        newCandyColony.colonyLevel = 1;
        candyColonyList[nextCandyColonyIndex] = newCandyColony;
        uint8 convertHashIndex = 0;
        uint8[2] memory cellCoords;
        CandyEarthCell memory newCandyEarthCell;
        uint8 i = 128;
        uint8[9] memory candyBuildingIdsOnCell;

        for (i = 128; i < 130; i++) {
            for (uint8 j = 128; j < 130; j++) {
                cellCoords[0] = i;
                cellCoords[1] = j;
                newCandyEarthCell = CandyEarthCell(nextCandyEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, true, true);
                candyEarthCellList[nextCandyEarthCellIndex] = newCandyEarthCell;
                CreateCandyEarthCellForNewColony(newCandyEarthCell.candyEarthCellIndex, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, newCandyEarthCell.candyEarthCellOwner);
                convertHashIndex += 2;
                nextCandyEarthCellIndex++;
            }
        }

        cellCoords[0] = 0;
        cellCoords[1] = 0;
        for(i = 0; i < 3; i++){
            newCandyEarthCell = CandyEarthCell(nextCandyEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, false, true);
            candyEarthCellList[nextCandyEarthCellIndex] = newCandyEarthCell;
            CreateCandyEarthCellForNewColony(newCandyEarthCell.candyEarthCellIndex, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, newCandyEarthCell.candyEarthCellOwner);
            convertHashIndex += 2;
            nextCandyEarthCellIndex++;
        }

        nextCandyColonyIndex++;
        CreateCandyColony(newCandyColony.candyColonyIndex, newCandyColony.colonyOwner);
    }

    function generateCandyEarthCell(uint colonyId, uint gameId) public onlyOwner {
        if(gameId == 0 || candyColonyList[colonyId].colonyOwner == 0x0 ) return;

        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = convertBlockHashToUintHexArray(block.number - 1, 2);
        if (error) return;

        uint8[2] memory cellCoords;
        CandyEarthCell memory newCandyEarthCell;
        uint8[9] memory candyBuildingIdsOnCell;

        newCandyEarthCell = CandyEarthCell(nextCandyEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[0] * 1000, convertHash[1] * 1000, false, false);
        candyEarthCellList[nextCandyEarthCellIndex] = newCandyEarthCell;
        GenerateNewCandyEarthCell(gameId, newCandyEarthCell.candyEarthCellIndex, convertHash[0] * 1000, convertHash[1] * 1000, newCandyEarthCell.candyEarthCellOwner);
        nextCandyEarthCellIndex++;
    }

    function putCandyEarthCellOnColony(uint colonyId, uint cellId, uint8 x, uint8 y) public {
        if(candyEarthCellList[cellId].candyEarthCellOwner != msg.sender || candyColonyList[colonyId].colonyOwner != msg.sender || candyEarthCellList[cellId].cellStatus = true) return
        // ToDo сделать проверки на возможность поставить ячейку в указанню клетку
        uint8[2] memory cellCoords;
        cellCoords[0] = x;
        cellCoords[1] = y;

        candyEarthCellList[cellId].candyEarthCellCoords = cellCoords;
        candyEarthCellList[cellId].cellStatus = true;
    }
}