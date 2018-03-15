pragma solidity ^0.4.20;

import "./Owned.sol";


contract CandyKillerColony is Owned {
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CKServiceContract ckService;
    /*
        Колония
    */
    struct Colony {
        uint index;
        address owner;
        uint level;
        mapping(uint => Building) buildingList;
        uint buildingCount;
        uint sugar;
        uint medarium;
        uint unitCount;
        uint freeUnitCount;
        string name;
        bool isDelete;
    }
    /*
        Ячейка земли
    */
    struct EarthCell {
        uint index;
        int[2] coords;
        uint[9] buildingIdsOnCell;
        address owner;
        uint sugar;
        uint medarium;
        bool cellStatus;
        bool isNotSale;
    }
    /*
        Здания
    */
    struct Building {
        // Id земли - на какой ячейке стоит здание
        uint cellIndex;
        // Локальная координата верхнего левого угла на земле
        uint8 indexOnCell;
        // Тип здания
        uint8 buildingType;
        // Уровень здания
        uint8 level;
        // Статус уничтожения
        bool isDestroyed;
        // Количество юнитов в здании
        uint unitCount;
        // Максимальное количество юнитов в здании
        uint maxUnitCount;
    }

    mapping(uint => EarthCell) earthCellList;
    mapping(uint => Colony) colonyList;

    uint nextEarthCellIndex = 1;
    uint nextColonyIndex = 1;

    event CreateColony(uint colonyIndex, address indexed ownerColonyAddress);
    event CreateEarthCellForNewColony(uint earthCellIndex, uint sugar, uint medarium, address indexed ownerEarthCellAddress);
    event GenerateNewEarthCell(uint gameId, uint earthCellIndex, uint sugar, uint medarium, address indexed ownerEarthCellAddress);

    event BuildCandyBuilding(uint candyBuilding, uint candyEarthCellIndex, uint colonyIndex, address indexed ownerColonyAddress);

    function CandyKillerColony() public {
        owner = msg.sender;
    }
    /*
        инициализация объекта CandyKillerAccount
    */
    function initCandyKillerAccount(address accountContract) public onlyOwner {
        if(accountContract == 0x0) return;
        ckAccount = CandyKillerAccount(accountContract);
    }
    /*
        инициализация объекта CKServiceContract
    */
    function initCKServiceContract(address serviceContract) public onlyOwner {
        if(serviceContract == 0x0) return;
        ckService = CKServiceContract(serviceContract);
    }
    /*
        создание колонии
    */
    function createColony(string colonyName) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 10);
        if (error) return;
        Colony memory newColony;
        newColony.index = nextColonyIndex;
        newColony.owner = msg.sender;
        newColony.level = 1;
        newColony.name = colonyName;
        colonyList[nextColonyIndex] = newColony;
        uint8 convertHashIndex = 0;
        int[2] memory cellCoords;
        EarthCell memory newEarthCell;
        int i = 0;
        uint[9] memory candyBuildingIdsOnCell;
        for (i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                cellCoords[0] = i;
                cellCoords[1] = j;
                newEarthCell = EarthCell(nextEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, true, true);
                earthCellList[nextEarthCellIndex] = newEarthCell;
                CreateEarthCellForNewColony(newEarthCell.index, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, newEarthCell.owner);
                convertHashIndex += 2;
                nextEarthCellIndex++;
            }
        }
        cellCoords[0] = 0;
        cellCoords[1] = 0;
        for(i = 0; i < 3; i++){
            newEarthCell = EarthCell(nextEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, false, true);
            earthCellList[nextEarthCellIndex] = newEarthCell;
            CreateEarthCellForNewColony(newEarthCell.index, convertHash[convertHashIndex] * 1000, convertHash[convertHashIndex + 1] * 1000, newEarthCell.owner);
            convertHashIndex += 2;
            nextEarthCellIndex++;
        }
        nextColonyIndex++;
        CreateColony(newColony.index, newColony.owner);
    }
    /*
        Удаление колонии
    */
    function deleteColony(uint indexColony) public {
        if(indexColony < 1) return;
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        // Колония принадлежит вызвавшему
        if (msg.sender != colonyList[indexColony].owner) return;
        colonyList[indexColony].isDelete = true;
    }
    /*
        Создание ячейки земли
    */
    function generateCandyEarthCell(uint colonyIndex, uint gameId) public onlyOwner {
        if(gameId == 0 || colonyList[colonyIndex].owner == 0x0 ) return;
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 2);
        if (error) return;

        int[2] memory cellCoords;
        EarthCell memory newEarthCell;
        uint[9] memory candyBuildingIdsOnCell;

        newEarthCell = EarthCell(nextEarthCellIndex, cellCoords, candyBuildingIdsOnCell, msg.sender, convertHash[0] * 1000, convertHash[1] * 1000, false, false);
        earthCellList[nextEarthCellIndex] = newEarthCell;
        GenerateNewEarthCell(gameId, newEarthCell.index, convertHash[0] * 1000, convertHash[1] * 1000, newEarthCell.owner);
        nextEarthCellIndex++;
    }
    /*
        Получение идентификатора следующей колонии пользователя.
        previousColonyIndex - предыдущая колония пользователя.
        Если previousColonyIndex не принадлежит вызвавшему функцию вернет 0.
        Если колоний нет вернет 0.
    */
    function getNextUserColonyIndex(uint previousColonyIndex) public view returns (uint) {
        if (colonyList[previousColonyIndex].owner == msg.sender || previousColonyIndex == 0) {
            for (uint i = previousColonyIndex + 1; i < nextColonyIndex; i++) {
                if (colonyList[i].owner == msg.sender) {
                    return i;
                }
            }
        }
    }

    function putCandyEarthCellOnColony(uint colonyIndex, uint cellIndex, int x, int y) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender)) return;
        if(earthCellList[cellIndex].owner != msg.sender || colonyList[colonyIndex].owner != msg.sender || earthCellList[cellIndex].cellStatus) return;
        if(x > -128 || x < 128 || y > -128 || y < 128) return;
        // ToDo сделать проверки на возможность поставить ячейку в указанню клетку
        int[2] memory cellCoords;
        cellCoords[0] = x;
        cellCoords[1] = y;

        earthCellList[cellIndex].coords = cellCoords;
        earthCellList[cellIndex].cellStatus = true;
    }
    /*
        Получение информации о колонии
        Идентификатор, владелец, уровень, кол-во зданий, сахар, медариум, кол-во юнитов, кол-во свободных юнитов, наименование
    */
    function getColonyByIndex(uint colonyIndex) public view returns (uint ,address, uint, uint, uint, uint, uint, uint, string, bool) {
        Colony memory colony = colonyList[colonyIndex];
        return (
        colony.index,
        colony.owner,
        colony.level,
        colony.buildingCount,
        colony.sugar,
        colony.medarium,
        colony.unitCount,
        colony.freeUnitCount,
        colony.name,
        colony.isDelete
        );
    }
    /*
        Получение информации о ячейке земли
        Id земли - на какой ячейке стоит здание, Локальная координата верхнего левого угла на земле, Тип здания, Уровень здания, Статус уничтожения
    */
    function getCandyEarthCell(uint candyEarthCellIndex) public view returns (uint, int[2], uint[9], address, uint, uint, bool, bool) {
        EarthCell memory earthCell = earthCellList[candyEarthCellIndex];
        return (
        earthCell.index,
        earthCell.coords,
        earthCell.buildingIdsOnCell,
        earthCell.owner,
        earthCell.sugar,
        earthCell.medarium,
        earthCell.cellStatus,
        earthCell.isNotSale
        );
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);
}

contract CKServiceContract {
    function convertBlockHashToUintHexArray(bytes32 bloclHash, uint8 convertCharacterCount) public pure returns (uint8[32] convertValues, bool error);
}
