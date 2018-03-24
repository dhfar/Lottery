var CKA = artifacts.require("CandyKillerAccount");
var CKC = artifacts.require("CandyKillerColony");
var CKSC = artifacts.require("CKServiceContract");

contract('CreateColony', function(accounts) {
    it("Тест: Создание колонии", async () => {
        const candyKillerAccount =  await CKA.deployed()
    var transactioncreateAccount = await candyKillerAccount.createAccount("mail@mail.ru", "petrovich");
    var accountIndex = transactioncreateAccount["logs"][0]["args"]["_account"];
    // console.log(Number(accountIndex));
    var newAccount = await candyKillerAccount.getAccountInfoByIndex(accountIndex);
    assert.ok(newAccount[1], true, "Учетная запись создана");
    assert.ok(newAccount[3], true, "Учетная запись активна");
    var accountId = await candyKillerAccount.getAccountIndexByAddress(accounts[0]);
    assert.equal(Number(accountId), Number(accountIndex), "Id получен верно");
    accountId = await candyKillerAccount.getAccountIndex();
    assert.equal(Number(accountId), Number(accountIndex), "Id получен верно");
    const ckServiceContract =  await CKSC.deployed()
    console.log("CKServiceContract address :" + ckServiceContract["address"]);
    const candyKillerColony =  await CKC.deployed()
    console.log("CandyKillerColony address :" + candyKillerColony["address"]);
    await candyKillerColony.initCKServiceContract(ckServiceContract["address"]);
    await candyKillerColony.initCandyKillerAccount(candyKillerAccount["address"]);
    var myFirstColony = await candyKillerColony.createColony("myFirstColony");
    // console.log(myFirstColony);
    var colonyIndex = 0;
    var cellsIndex = new Array();
    var cellsCount = 0;
    var colonyIndex = 0;
    for(var i = 0; i < myFirstColony["logs"].length; i++){
        // console.log(myFirstColony["logs"][i]["event"]);
        if(myFirstColony["logs"][i]["event"] == "CreateEarthCellForNewColony"){
            cellsIndex[cellsCount] = Number(myFirstColony["logs"][i]["args"]["earthCellIndex"]);
            cellsCount++;
        } else if (myFirstColony["logs"][i]["event"] == "CreateColony"){
            colonyIndex = Number(myFirstColony["logs"][i]["args"]["colonyIndex"]);
        }
    }
    // console.log(cellsIndex);
    // console.log(colonyIndex);
    assert.equal(cellsIndex.length, 7, "Количетво ячеек выдано верно");
    assert.equal(colonyIndex, 1, "Id получен верно");
});
});

contract('BuildBuilding', function(accounts) {
    it("Тест: строительство здания", async () => {
        const candyKillerAccount =  await CKA.deployed();
    const ckServiceContract =  await CKSC.deployed();
    const candyKillerColony =  await CKC.deployed();
    var transactioncreateAccount = await candyKillerAccount.createAccount("mail@mail.ru", "petrovich");
    var accountIndex = transactioncreateAccount["logs"][0]["args"]["_account"];
    var newAccount = await candyKillerAccount.getAccountInfoByIndex(accountIndex);
    await candyKillerColony.initCKServiceContract(ckServiceContract["address"]);
    await candyKillerColony.initCandyKillerAccount(candyKillerAccount["address"]);
    var myFirstColony = await candyKillerColony.createColony("myFirstColony");
    var colonyIndex = 0;
    var cellsIndex = new Array();
    var cellsCount = 0;
    for(var i = 0; i < myFirstColony["logs"].length; i++){
        if(myFirstColony["logs"][i]["event"] == "CreateEarthCellForNewColony"){
            cellsIndex[cellsCount] = Number(myFirstColony["logs"][i]["args"]["earthCellIndex"]);
            cellsCount++;
        } else if (myFirstColony["logs"][i]["event"] == "CreateColony"){
            colonyIndex = Number(myFirstColony["logs"][i]["args"]["colonyIndex"]);
        }
    }
    var buildingTransaction = await candyKillerColony.buildBuilding(colonyIndex, cellsIndex[0], 1, 1 );
    // console.log(buildingTransaction["logs"][0]["args"]);
    assert.equal(Number(buildingTransaction["logs"][0]["args"]["building"]), 1, "Здание построено");

    var buildingData = await candyKillerColony.getBuildingByIndex(colonyIndex, Number(buildingTransaction["logs"][0]["args"]["building"]));
    assert.equal(Number(buildingData[0]), 1, "Здание построено");
    // console.log(buildingData);
    });
});