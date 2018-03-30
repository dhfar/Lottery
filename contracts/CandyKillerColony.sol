pragma solidity ^0.4.21;

import "./Owned.sol";


contract CandyKillerColony is Owned {
    /*
        Контракты
    */
    CandyKillerAccount ckAccount;
    CKServiceContract ckService;
    CKColonyMarketPlace ckColonyMarketPlace;
    // адреса магазинов
    address colonyMarketPlace;
    /*
        Колония
    */
    struct Colony {
        uint index;
        address owner;
        mapping(uint => Building) buildingList;
        uint nextBuildingIndex;
        uint sugar;
        uint heavySugar;
        uint medarium;
        uint unitCount;
        uint freeUnitCount;
        string name;
        bool isDelete;
        // массив ячеек земли в колонии
        mapping(uint => uint) earthCellInColonyList;
        uint nextEarthCellInColonyIndex;
    }
    /*
        Ячейка земли
    */
    struct EarthCell {
        uint index;
        uint colonyIndex;
        int[2] coords;
        mapping(uint => EarthCellPart) earthCellParts;
        address owner;
        bool cellStatus;
        bool isNotSale;
    }
    /*
        Здания
    */
    struct Building {
        // идентификатор здания
        uint index;
        // Id земли - на какой ячейке стоит здание
        uint cellIndex;
        // Локальная координата верхнего левого угла на земле
        uint8 indexOnCell;
        // Тип здания
        uint8 buildingType;
        // Уровень здания
        uint8 level;
        // Статус уничтожения
        // bool isDestroyed;
        // Количество юнитов в здании
        uint unitCount;
        // Максимальное количество юнитов в здании
        uint maxUnitCount;
        // здание уничтожено
        bool isDelete;
    }
    /*
        Клетка в ячейке
    */
    struct EarthCellPart {
        // идентификатор здания
        uint indexBuilding;
        // сахар
        uint sugar;
        // медариум
        uint medarium;
    }
    /*
        Модификаторы
    */
    modifier onlyActiveAccount {
        // Учетная запись создана и активна
        require(ckAccount.isCreateAndActive(msg.sender));
        _;
    }

    mapping(uint => EarthCell) earthCellList;
    mapping(uint => Colony) colonyList;

    uint nextEarthCellIndex = 1;
    uint nextColonyIndex = 1;

    event CreateColony(uint colonyIndex, address ownerColonyAddress);
    event CreateEarthCellForNewColony(uint earthCellIndex, uint sugar, uint medarium, address ownerEarthCellAddress);
    event DeleteColony(uint colonyIndex, address ownerColonyAddress);
    event GenerateNewEarthCell(uint gameId, uint earthCellIndex, uint sugar, uint medarium, address ownerEarthCellAddress);

    event BuildBuilding(uint building, uint earthCellIndex, uint colonyIndex, address ownerColonyAddress);
    event DeleteBuilding(uint building, uint colonyIndex, address ownerColonyAddress);

    function CandyKillerColony() public {
        owner = msg.sender;
    }
    /*
        инициализация объекта CandyKillerAccount
    */
    function initCandyKillerAccount(address accountContract) public onlyOwner {
        if (accountContract == 0x0) return;
        ckAccount = CandyKillerAccount(accountContract);
    }
    /*
        инициализация объекта CKServiceContract
    */
    function initCKServiceContract(address serviceContract) public onlyOwner {
        if (serviceContract == 0x0) return;
        ckService = CKServiceContract(serviceContract);
    }
    /*
        инициализация объекта CKColonyMarketPlace
    */
    function initCKColonyMarketPlace(address colonyMarketPlaceContract) public onlyOwner {
        if (colonyMarketPlaceContract == 0x0) return;
        ckColonyMarketPlace = CKColonyMarketPlace(colonyMarketPlaceContract);
        setColonyMarketPlace(colonyMarketPlaceContract);
    }
    /*
        Задать адрес контракта магазина колонии
    */
    function setColonyMarketPlace(address colonyMarketPlaceAddress) public onlyOwner {
        if (colonyMarketPlaceAddress == 0x0) return;
        colonyMarketPlace = colonyMarketPlaceAddress;
    }
    /*
        создание колонии
    */
    function createColony(string colonyName) public onlyActiveAccount {
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 14);
        if (error) return;
        Colony memory newColony;
        newColony.index = nextColonyIndex;
        newColony.owner = msg.sender;
        newColony.name = colonyName;
        // на развитие новой колонии 1000 сахара
        newColony.sugar = 1000;
        newColony.nextBuildingIndex = 1;
        colonyList[nextColonyIndex] = newColony;
        // содание ячеек земли
        uint8 convertHashIndex = 0;
        int[2] memory cellCoords;
        EarthCell memory newEarthCell;
        EarthCellPart memory newEarthCellPart;
        uint createSugar;
        uint createMedarium;
        uint z = 0;
        int i = 0;

        newEarthCell.colonyIndex = newColony.index;
        newEarthCell.cellStatus = true;
        newEarthCell.isNotSale = true;
        newEarthCell.owner = msg.sender;

        for (i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                cellCoords[0] = i;
                cellCoords[1] = j;
                newEarthCell.index = nextEarthCellIndex;
                newEarthCell.coords = cellCoords;
                earthCellList[nextEarthCellIndex] = newEarthCell;
                createSugar = convertHash[convertHashIndex] * 1000;
                createMedarium = convertHash[convertHashIndex + 1] * 1000;
                for (z = 0; z < 9; z++) {
                    newEarthCellPart.sugar = 0;
                    newEarthCellPart.medarium = 0;
                    if (createSugar > 0) {
                        newEarthCellPart.sugar = createSugar / 9;
                    }
                    if (createMedarium > 0) {
                        newEarthCellPart.medarium = createMedarium / 9;
                    }
                    earthCellList[nextEarthCellIndex].earthCellParts[z] = newEarthCellPart;
                }
                emit CreateEarthCellForNewColony(newEarthCell.index, createSugar, createMedarium, newEarthCell.owner);
                convertHashIndex += 2;
                nextEarthCellIndex++;
                colonyList[nextColonyIndex].earthCellInColonyList[colonyList[nextColonyIndex].nextEarthCellInColonyIndex] = newEarthCell.index;
                colonyList[nextColonyIndex].nextEarthCellInColonyIndex++;
            }
        }

        cellCoords[0] = 0;
        cellCoords[1] = 0;
        newEarthCell.coords = cellCoords;
        newEarthCell.cellStatus = false;

        for (i = 0; i < 3; i++) {
            newEarthCell.index = nextEarthCellIndex;
            earthCellList[nextEarthCellIndex] = newEarthCell;
            createSugar = convertHash[convertHashIndex] * 1000;
            createMedarium = convertHash[convertHashIndex + 1] * 1000;
            for (z = 0; z < 9; z++) {
                newEarthCellPart.sugar = 0;
                newEarthCellPart.medarium = 0;
                if (createSugar > 0) {
                    newEarthCellPart.sugar = createSugar / 9;
                }
                if (createMedarium > 0) {
                    newEarthCellPart.medarium = createMedarium / 9;
                }
                earthCellList[nextEarthCellIndex].earthCellParts[z] = newEarthCellPart;
            }

            emit CreateEarthCellForNewColony(newEarthCell.index, createSugar, createMedarium, newEarthCell.owner);
            convertHashIndex += 2;
            nextEarthCellIndex++;
        }
        nextColonyIndex++;
        emit CreateColony(newColony.index, newColony.owner);
    }
    /*
        Удаление колонии
    */
    function deleteColony(uint indexColony) public onlyActiveAccount {
        // Колония принадлежит вызвавшему
        if (msg.sender != colonyList[indexColony].owner) return;
        colonyList[indexColony].isDelete = true;
        colonyList[indexColony].owner = 0x0;

        for (uint i = 0; i < nextEarthCellIndex; i++) {
            if (earthCellList[i].owner == msg.sender && earthCellList[i].colonyIndex == indexColony) {
                earthCellList[i].owner = 0x0;
                earthCellList[i].isNotSale = true;
            }
        }
        emit DeleteColony(indexColony, msg.sender);
    }
    /*
        Начисление сахара
    */
    function addSugar(uint indexColony, uint newSugar) public onlyOwner {
        if (msg.sender == colonyList[indexColony].owner || colonyList[indexColony].owner == 0x0) return;
        colonyList[indexColony].sugar += newSugar;
    }
    /*
        Начисление тяжелого сахара
    */
    function addHeavySugar(uint indexColony, uint newHeavySugar) public onlyOwner {
        if (msg.sender == colonyList[indexColony].owner || colonyList[indexColony].owner == 0x0) return;
        colonyList[indexColony].heavySugar += newHeavySugar;
    }
    /*
        Начисление медариума
    */
    function addMedarium(uint indexColony, uint newMedarium) public onlyOwner {
        if (msg.sender == colonyList[indexColony].owner || colonyList[indexColony].owner == 0x0) return;
        colonyList[indexColony].medarium += newMedarium;
    }
    /*
        Создание ячейки земли
    */
    function generateCandyEarthCell(address userAddress, uint gameId) public onlyOwner {
        if (gameId == 0) return;
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(userAddress)) return;
        uint8[32] memory convertHash;
        bool error;
        (convertHash, error) = ckService.convertBlockHashToUintHexArray(block.blockhash(block.number - 1), 2);
        if (error) return;

        EarthCell memory newEarthCell;
        uint createSugar;
        uint createMedarium;
        uint z = 0;
        newEarthCell.index = nextEarthCellIndex;
        newEarthCell.owner = userAddress;
        earthCellList[nextEarthCellIndex] = newEarthCell;
        createSugar = convertHash[0] * 1000;
        createMedarium = convertHash[1] * 1000;
        EarthCellPart memory newEarthCellPart;
        for (z = 0; z < 9; z++) {
            newEarthCellPart.sugar = 0;
            newEarthCellPart.medarium = 0;
            if (createSugar > 0) {
                newEarthCellPart.sugar = createSugar / 9;
            }
            if (createMedarium > 0) {
                newEarthCellPart.medarium = createMedarium / 9;
            }
            earthCellList[nextEarthCellIndex].earthCellParts[z] = newEarthCellPart;
        }
        emit GenerateNewEarthCell(gameId, newEarthCell.index, createSugar, createMedarium, newEarthCell.owner);
        nextEarthCellIndex++;
    }
    /*
       Ячейка существует и свободна для продажи
    */
    function isExistAndForSaleCell(address customer, uint cellIndex) public view returns (bool) {
        return (earthCellList[cellIndex].owner != 0x0 && earthCellList[cellIndex].owner != customer && !earthCellList[cellIndex].isNotSale);
    }
    /*
       Является владельцем ячейки
    */
    function isOwnerEarthCell(address possibleOwner, uint cellIndex) public view returns (bool) {
        return (earthCellList[cellIndex].owner == possibleOwner && possibleOwner != 0x0);
    }
    /*
      Колония существует и покупатель не её владелец
    */
    function isExistColony(address customer, uint colonyIndex) public view returns (bool) {
        return (colonyList[colonyIndex].owner != 0x0 && colonyList[colonyIndex].owner != customer);
    }
    /*
       Является владельцем колонии
    */
    function isOwnerColony(address possibleOwner, uint colonyIndex) public view returns (bool) {
        return (colonyList[colonyIndex].owner == possibleOwner && possibleOwner != 0x0);
    }
    /*
        Продажа ячейки
    */
    function transferEarthCell(address from, address to, uint cellIndex) public returns (bool) {
        // функцию вызывает только контракт магазин
        if (msg.sender != colonyMarketPlace) return false;
        if (earthCellList[cellIndex].owner != from || earthCellList[cellIndex].colonyIndex != 0 || earthCellList[cellIndex].isNotSale) return false;
        earthCellList[cellIndex].owner = to;
        return true;
    }
    /*
        Продажа колонии
    */
    function transferColony(address from, address to, uint colonyIndex) public returns (bool) {
        // функцию вызывает только контракт магазин
        if (msg.sender != colonyMarketPlace) return false;
        if (colonyList[colonyIndex].owner != from || colonyList[colonyIndex].isDelete || to == 0x0) return false;
        colonyList[colonyIndex].owner = to;
        for (uint i = 0; i < colonyList[colonyIndex].nextEarthCellInColonyIndex; i++) {
            earthCellList[colonyList[colonyIndex].earthCellInColonyList[i]].owner = to;
        }
        return true;
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

    function putCandyEarthCellOnColony(uint colonyIndex, uint cellIndex, int x, int y) public onlyActiveAccount {
        if (earthCellList[cellIndex].owner != msg.sender || colonyList[colonyIndex].owner != msg.sender || earthCellList[cellIndex].cellStatus) return;
        if (ckColonyMarketPlace.isExistOfferEarthCell(colonyIndex)) return;
        if (x < - 128 || x > 128 || y < - 128 || y > 128) return;
        // ToDo сделать проверки на возможность поставить ячейку в указанню клетку
        int[2] memory cellCoords;
        cellCoords[0] = x;
        cellCoords[1] = y;

        earthCellList[cellIndex].coords = cellCoords;
        earthCellList[cellIndex].cellStatus = true;
        earthCellList[cellIndex].colonyIndex = colonyIndex;
        earthCellList[cellIndex].isNotSale = true;

        colonyList[colonyIndex].earthCellInColonyList[colonyList[colonyIndex].nextEarthCellInColonyIndex] = earthCellList[cellIndex].index;
        colonyList[colonyIndex].nextEarthCellInColonyIndex++;
    }
    /*
        Получение информации о колонии
        Идентификатор, владелец, уровень, кол-во зданий, сахар, тяжелый сахар, медариум, кол-во юнитов, кол-во свободных юнитов, наименование
    */
    function getColonyByIndex(uint colonyIndex) public view returns (uint, address, uint, uint, uint, uint, uint, uint, string, bool) {
        Colony memory colony = colonyList[colonyIndex];
        return (
        colony.index,
        colony.owner,
        colony.nextBuildingIndex,
        colony.sugar,
        colony.heavySugar,
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
    function getEarthCellByIndex(uint candyEarthCellIndex) public view returns (uint, uint, int[2], address, bool, bool) {
        EarthCell memory earthCell = earthCellList[candyEarthCellIndex];
        return (
        earthCell.index,
        earthCell.colonyIndex,
        earthCell.coords,
        earthCell.owner,
        earthCell.cellStatus,
        earthCell.isNotSale
        );
    }

    /*
        Получение идентификатора следующей ячейки земли пользователя.
        previousEarthCellIndex - предыдущая ячейка земли  пользователя.
        Если previousEarthCellIndex не принадлежит вызвавшему функцию вернет 0.
        Если ячеек земли нет вернет 0.
        Если нужны ячейки конкретной колонии указать colonyIndex, иначе указать 0
    */
    function getNextUserEarthCellIndex(uint previousEarthCellIndex, uint colonyIndex) public view returns (uint) {
        if (earthCellList[previousEarthCellIndex].owner == msg.sender || previousEarthCellIndex == 0) {
            for (uint i = previousEarthCellIndex + 1; i < nextEarthCellIndex; i++) {
                if (earthCellList[i].owner == msg.sender) {
                    if (colonyIndex == 0 || earthCellList[i].colonyIndex == colonyIndex) {
                        return i;
                    }
                }
            }
        }
    }
    /*
        Списание ресурсов с ячейки
    */
    function collectResources(uint colonyIndex, uint cellIndex, uint cellPartIndex, uint collectSugar, uint collectMedarium) public onlyOwner {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(colonyList[colonyIndex].owner)) return;
        // Ячейка принадлежит владельцу колонии и находится в колоние
        if (earthCellList[cellIndex].owner != colonyList[colonyIndex].owner || !earthCellList[cellIndex].cellStatus) return;
        if (collectSugar > 0 && earthCellList[cellIndex].earthCellParts[cellPartIndex].sugar >= collectSugar) {
            earthCellList[cellIndex].earthCellParts[cellPartIndex].sugar -= collectSugar;
            colonyList[colonyIndex].sugar += collectSugar;
        }
        if (collectMedarium > 0 && earthCellList[cellIndex].earthCellParts[cellPartIndex].medarium >= collectMedarium) {
            earthCellList[cellIndex].earthCellParts[cellPartIndex].medarium -= collectMedarium;
            colonyList[colonyIndex].medarium += collectMedarium;
        }
    }
    /*
        Получение информации о здании
        Id земли - на какой ячейке стоит здание, Локальная координата верхнего левого угла на земле, Тип здания, Уровень здания, Статус уничтожения,
        Количество юнитов в здании, Максимальное количество юнитов в здании
    */
    function getBuildingByIndex(uint colonyIndex, uint buildingIndex) public view returns (uint, uint, uint8, uint8, uint8, uint, uint, bool) {
        Building memory building = colonyList[colonyIndex].buildingList[buildingIndex];
        return (
        building.index,
        building.cellIndex,
        building.indexOnCell,
        building.buildingType,
        building.level,
        building.unitCount,
        building.maxUnitCount,
        building.isDelete
        );
    }
    /*
        Строительство здания
    */
    function buildBuilding(uint colonyIndexForBuild, uint earthCellIndexForBuild, uint8 buildingIndexOnCellForBuild, uint8 buildingType) public onlyActiveAccount {
        // Колония принадлежит нужному человеку
        if (colonyList[colonyIndexForBuild].owner != msg.sender) return;
        // Ячейка принадлежит нужному человеку
        if (earthCellList[earthCellIndexForBuild].owner != msg.sender) return;

        Building memory building;
        building.index = colonyList[colonyIndexForBuild].nextBuildingIndex;
        building.cellIndex = earthCellIndexForBuild;
        building.indexOnCell = buildingIndexOnCellForBuild;
        building.buildingType = buildingType;
        building.level = 1;
        // ToDo добавить максимальное кол-во юнитов для здания
        building.maxUnitCount = 2;

        // ToDo Заполнить ячейки занимающие зданием на землях
        // Если, что то стоит прогоняем
        if (earthCellList[earthCellIndexForBuild].earthCellParts[buildingIndexOnCellForBuild].indexBuilding != 0) return;
        earthCellList[earthCellIndexForBuild].earthCellParts[buildingIndexOnCellForBuild].indexBuilding = colonyList[colonyIndexForBuild].nextBuildingIndex;

        colonyList[colonyIndexForBuild].buildingList[colonyList[colonyIndexForBuild].nextBuildingIndex] = building;
        colonyList[colonyIndexForBuild].nextBuildingIndex++;

        emit BuildBuilding(colonyList[colonyIndexForBuild].nextBuildingIndex - 1, earthCellIndexForBuild, colonyIndexForBuild, msg.sender);
    }
    /*
        Удаление здания
    */
    function deleteBuilding(uint colonyIndex, uint buildingIndex) public {
        // Аккаунта создан и активный
        if (!ckAccount.isCreateAndActive(msg.sender) || msg.sender != owner) return;
        // Колония принадлежит нужному человеку
        if (colonyList[colonyIndex].owner != msg.sender || msg.sender != owner) return;
        // здания не существует или удалено
        if (colonyList[colonyIndex].buildingList[buildingIndex].cellIndex == 0) return;
        earthCellList[colonyList[colonyIndex].buildingList[buildingIndex].cellIndex].earthCellParts[colonyList[colonyIndex].buildingList[buildingIndex].indexOnCell].indexBuilding = 0;
        colonyList[colonyIndex].buildingList[buildingIndex].isDelete = true;
        colonyList[colonyIndex].buildingList[buildingIndex].cellIndex = 0;
        removeUnitFromBuilding(colonyIndex, buildingIndex, colonyList[colonyIndex].buildingList[buildingIndex].unitCount);

        emit DeleteBuilding(buildingIndex, colonyIndex, msg.sender);
    }
    /*
        Получение идентификатора следующго здания в колонии.
        previousBuildingIndex - предыдущее здание колонии.
        Если colonyIndex не принадлежит вызвавшему функцию вернет 0.
        Если ячеек земли нет вернет 0.
    */
    function getNextUserBuildingIndex(uint previousBuildingIndex, uint colonyIndex) public view returns (uint) {
        if (colonyList[colonyIndex].owner != msg.sender) return 0;
        for (uint i = previousBuildingIndex + 1; i < colonyList[colonyIndex].nextBuildingIndex; i++) {
            if (!colonyList[colonyIndex].buildingList[i].isDelete) {
                return i;
            }
        }
        return 0;
    }
    /*
        Добавить юнитов в здание
    */
    function addUnitInBuilding(uint colonyIndex, uint buildingIndex, uint addUnitCount) public onlyActiveAccount {
        // Колония принадлежит нужному человеку
        if (colonyList[colonyIndex].owner != msg.sender) return;
        // Если здание не заполнено
        if (colonyList[colonyIndex].buildingList[buildingIndex].unitCount >= colonyList[colonyIndex].buildingList[buildingIndex].maxUnitCount) return;
        // В колонии есть свободные юниты
        if (colonyList[colonyIndex].freeUnitCount < addUnitCount) return;
        // Если добавляем больше, чем можно
        if (colonyList[colonyIndex].buildingList[buildingIndex].unitCount + addUnitCount > colonyList[colonyIndex].buildingList[buildingIndex].maxUnitCount) return;
        colonyList[colonyIndex].buildingList[buildingIndex].unitCount += addUnitCount;
        colonyList[colonyIndex].freeUnitCount -= addUnitCount;
    }
    /*
        Вывести юнитов из здания
    */
    function removeUnitFromBuilding(uint colonyIndex, uint buildingIndex, uint removeUnitCount) public onlyActiveAccount {
        // Колония принадлежит нужному человеку
        if (colonyList[colonyIndex].owner != msg.sender) return;
        // Если выводим больше, чем есть
        if (colonyList[colonyIndex].buildingList[buildingIndex].unitCount < removeUnitCount) return;
        colonyList[colonyIndex].buildingList[buildingIndex].unitCount -= removeUnitCount;
        colonyList[colonyIndex].freeUnitCount += removeUnitCount;
    }
    /*
        Создание свободного юнита
    */
    function createNewUnitInColony(uint colonyIndex) public onlyActiveAccount {
        // Колония принадлежит нужному человеку
        if (colonyList[colonyIndex].owner != msg.sender) return;

        colonyList[colonyIndex].unitCount++;
        colonyList[colonyIndex].freeUnitCount++;
    }
    /*
        Получение информации о клетке в ячейке
    */
    function getEarthCellPart(uint earthCellIndex, uint earthCellPartIndex) public view returns (uint, uint, uint) {
        EarthCellPart memory earthCellPart = earthCellList[earthCellIndex].earthCellParts[earthCellPartIndex];
        return (earthCellPart.indexBuilding, earthCellPart.sugar, earthCellPart.medarium);
    }
}

contract CandyKillerAccount {
    function isCreateAndActive(address userAddress) public view returns (bool);
}

contract CKServiceContract {
    function convertBlockHashToUintHexArray(bytes32 bloclHash, uint8 convertCharacterCount) public pure returns (uint8[32] convertValues, bool error);
}

contract CKColonyMarketPlace {
    function isExistOfferEarthCell(uint cellIndex) public view returns (bool);
}
