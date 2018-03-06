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
        uint freeUnitCount;
        string candyColonyName;
    }
    /*
        Ячейка земли
    */
    struct CandyEarthCell {
        uint candyEarthCellIndex;
        int[2] candyEarthCellCoords;
        uint[9] candyBuildingIdsOnCell;
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
        uint candyEarthCellIndex;
        // Локальная координата верхнего левого угла на земле
        uint8 candyBuildingIndexOnCell;
        // Тип здания
        uint8 candyBuildingType;
        // Уровень здания
        uint8 candyBuildingLevel;
        // Статус уничтожения
        bool isDestroyed;
        // Количество юнитов в здании
        uint unitCount;
        // Максимальное количество юнитов в здании
        uint maxUnitCount;
    }

    mapping(uint => CandyEarthCell) candyEarthCellList;
    mapping(uint => CandyColony) candyColonyList;

    uint nextCandyEarthCellIndex = 1;
    uint nextCandyColonyIndex = 1;

    event CreateCandyColony(uint colonyIndex, address indexed ownerColonyAddress);
    event CreateCandyEarthCellForNewColony(uint candyEarthCellIndex, uint candySugar, uint candyMedarium, address indexed ownerCandyEarthCellAddress);
    event GenerateNewCandyEarthCell(uint gameId, uint candyEarthCellIndex, uint candySugar, uint candyMedarium, address indexed ownerCandyEarthCellAddress);

    event BuildCandyBuilding(uint candyBuilding, uint candyEarthCellIndex, uint colonyIndex, address indexed ownerColonyAddress);

    function CandyKiller() DhfServiceContract() public payable {
        owner = msg.sender;
    }

    function createCandyColony(string colonyName) public {
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = convertBlockHashToUintHexArray(block.number - 1, 10);
        if (error) return;
        // candyColonyListIndexByAddress[msg.sender] = nextCandyColonyIndex;
        CandyColony memory newCandyColony;
        newCandyColony.candyColonyIndex = nextCandyColonyIndex;
        newCandyColony.colonyOwner = msg.sender;
        newCandyColony.colonyLevel = 1;
        newCandyColony.candyColonyName = colonyName;
        candyColonyList[nextCandyColonyIndex] = newCandyColony;
        uint8 convertHashIndex = 0;
        int[2] memory cellCoords;
        CandyEarthCell memory newCandyEarthCell;
        int i = 0;
        uint[9] memory candyBuildingIdsOnCell;

        for (i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
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

    function generateCandyEarthCell(uint colonyIndex, uint gameId) public onlyOwner {
        if(gameId == 0 || candyColonyList[colonyIndex].colonyOwner == 0x0 ) return;

        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = convertBlockHashToUintHexArray(block.number - 1, 2);
        if (error) return;

        int[2] memory cellCoords;
        CandyEarthCell memory newCandyEarthCell;
        uint[9] memory candyBuildingIdsOnCell;

        newCandyEarthCell = CandyEarthCell(nextCandyEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[0] * 1000, convertHash[1] * 1000, false, false);
        candyEarthCellList[nextCandyEarthCellIndex] = newCandyEarthCell;
        GenerateNewCandyEarthCell(gameId, newCandyEarthCell.candyEarthCellIndex, convertHash[0] * 1000, convertHash[1] * 1000, newCandyEarthCell.candyEarthCellOwner);
        nextCandyEarthCellIndex++;
    }

    function putCandyEarthCellOnColony(uint colonyIndex, uint cellIndex, int x, int y) public {
        if(candyEarthCellList[cellIndex].candyEarthCellOwner != msg.sender || candyColonyList[colonyIndex].colonyOwner != msg.sender || candyEarthCellList[cellIndex].cellStatus) return;
        if(x > -128 || x < 128 || y > -128 || y < 128) return;
        // ToDo сделать проверки на возможность поставить ячейку в указанню клетку
        int[2] memory cellCoords;
        cellCoords[0] = x;
        cellCoords[1] = y;

        candyEarthCellList[cellIndex].candyEarthCellCoords = cellCoords;
        candyEarthCellList[cellIndex].cellStatus = true;
    }
    /*
        Получение информации о колонии
        Идентификатор, владелец, уровень, кол-во зданий, сахар, медариум, кол-во юнитов, кол-во свободных юнитов, наименование
    */
    function getColonyByIndex(uint colonyIndex) public view returns (uint ,address, uint, uint, uint, uint, uint, uint, string) {
        CandyColony memory candyColony = candyColonyList[colonyIndex];
        return (
        candyColony.candyColonyIndex,
        candyColony.colonyOwner,
        candyColony.colonyLevel,
        candyColony.candyBuildingCount,
        candyColony.candySugar,
        candyColony.candyMedarium,
        candyColony.unitCount,
        candyColony.freeUnitCount,
        candyColony.candyColonyName
        );
    }
    /*
        Получение информации о здании
        Id земли - на какой ячейке стоит здание, Локальная координата верхнего левого угла на земле, Тип здания, Уровень здания, Статус уничтожения,
        Количество юнитов в здании, Максимальное количество юнитов в здании
    */
    function getCandyBuilding(uint colonyIndex, uint buildingIndex) public view returns (uint, uint8, uint8, uint8, bool, uint, uint) {
        CandyBuilding memory candyBuilding = candyColonyList[colonyIndex].candyBuildingList[buildingIndex];
        return (
        candyBuilding.candyEarthCellIndex,
        candyBuilding.candyBuildingIndexOnCell,
        candyBuilding.candyBuildingType,
        candyBuilding.candyBuildingLevel,
        candyBuilding.isDestroyed,
        candyBuilding.unitCount,
        candyBuilding.maxUnitCount
        );
    }

    function buildCandyBuilding(uint colonyIndex, uint candyEarthCellIndex, uint8 candyBuildingIndexOnCell, uint8 candyBuildingType) public {
        if(candyColonyList[colonyIndex].colonyOwner != msg.sender) return;
        if(candyEarthCellList[candyEarthCellIndex].candyEarthCellOwner != msg.sender) return;

        CandyBuilding memory candyBuilding;
        candyBuilding.candyEarthCellIndex = candyColonyList[colonyIndex].candyBuildingCount;
        candyBuilding.candyBuildingIndexOnCell = candyBuildingIndexOnCell;
        candyBuilding.candyBuildingType = candyBuildingType;
        candyBuilding.candyBuildingLevel = 1;
        // ToDo добавить максимальное кол-во юнитов для здания
        candyBuilding.maxUnitCount = 2;

        // ToDo Заполнить ячейки занимающие зданием на землях
        candyEarthCellList[candyEarthCellIndex].candyBuildingIdsOnCell[candyBuildingIndexOnCell] = candyColonyList[colonyIndex].candyBuildingCount;

        candyColonyList[colonyIndex].candyBuildingList[candyColonyList[colonyIndex].candyBuildingCount] = candyBuilding;
        candyColonyList[colonyIndex].candyBuildingCount++;

        BuildCandyBuilding(candyColonyList[colonyIndex].candyBuildingCount - 1, candyEarthCellIndex, colonyIndex, msg.sender);
    }
    /*
        Получение информации о ячейке земли
        Id земли - на какой ячейке стоит здание, Локальная координата верхнего левого угла на земле, Тип здания, Уровень здания, Статус уничтожения
    */
    function getCandyEarthCell(uint candyEarthCellIndex) public view returns (uint, int[2], uint[9], address, uint, uint, bool, bool) {
        CandyEarthCell memory candyEarthCell = candyEarthCellList[candyEarthCellIndex];
        return (
        candyEarthCell.candyEarthCellIndex,
        candyEarthCell.candyEarthCellCoords,
        candyEarthCell.candyBuildingIdsOnCell,
        candyEarthCell.candyEarthCellOwner,
        candyEarthCell.candySugar,
        candyEarthCell.candyMedarium,
        candyEarthCell.cellStatus,
        candyEarthCell.isNotSale
        );
    }
}