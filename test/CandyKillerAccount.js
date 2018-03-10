var CKA = artifacts.require("CandyKillerAccount");

contract('CreateAccountAndCreateCharacter', function(accounts) {
    it("Тест: Создание учетной записи и персонажа", async () => {
        const candyKillerAccount =  await CKA.deployed()
    await candyKillerAccount.createAccount("mail@mail.ru", "petrovich");
    var newAccount = await candyKillerAccount.getAccountInfoByIndex(1);
    assert.ok(newAccount[1], true, "Учетная запись создана");
    assert.ok(newAccount[3], true, "Учетная запись активна");

    var accountId = await candyKillerAccount.getAccountIndexByAddress(accounts[0]);
    assert.equal(accountId, "1", "Id получен верно");

    accountId = await candyKillerAccount.getAccountIndex();
    assert.equal(accountId, "1", "Id получен верно");
    });
});

contract('BuyPixelWarsCoins', function(accounts) {
    it("Тест: покупки игровой валюты", async () => {
        const candyKillerAccount =  await CKA.deployed()
    await candyKillerAccount.createAccount("mail@mail.ru", "petrovich");
    var price = await candyKillerAccount.pixelWarsCoinPrice();
    //console.log(price);
    // измнение курса
    assert.equal(price, 10000, "Курс по умолчанию верен");
    await candyKillerAccount.buyPixelWarsCoins({from : accounts[0], value: 10000000});
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 1000, "Куплено верное кол-во монет");

    await candyKillerAccount.setPixelWarsCoinPrice(100000);
    price = await candyKillerAccount.pixelWarsCoinPrice();
    assert.equal(price, 100000, "Курс изменен на 100000");
    await candyKillerAccount.buyPixelWarsCoins({from : accounts[0], value: 10000000});
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 1100, "Куплено верное кол-во монет");

    await candyKillerAccount.setPixelWarsCoinPrice(1000000);
    price = await candyKillerAccount.pixelWarsCoinPrice();
    assert.equal(price, 1000000, "Курс изменен на 1000000");
    await candyKillerAccount.buyPixelWarsCoins({from : accounts[0], value: 10000000});
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 1110, "Куплено верное кол-во монет");

    await candyKillerAccount.setPixelWarsCoinPrice(10000000);
    price = await candyKillerAccount.pixelWarsCoinPrice();
    assert.equal(price, 10000000, "Курс изменен на 10000000");
    // покупка монет
    await candyKillerAccount.buyPixelWarsCoins({from : accounts[0], value: 10000000});
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 1111, "Куплено верное кол-во монет");
});
});

contract('Accrual/WithdrawalPixelWarsCoins', function(accounts) {
    it("Тест: начисление/списание игровой валюты", async () => {
        const candyKillerAccount =  await CKA.deployed()
    await candyKillerAccount.createAccount("mail@mail.ru", "petrovich");

    await candyKillerAccount.accrualPixelWarsCoins(1000, 1);
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 1000, "Начислено 1000 монет");

    await candyKillerAccount.accrualPixelWarsCoins(10000, 1);
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 11000, "Начислено 11000 монет");

    await candyKillerAccount.withdrawalPixelWarsCoins(1000, 1);
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 10000, "Начислено 1000 монет");

    await candyKillerAccount.withdrawalPixelWarsCoins(10000, 1);
    var balance = await candyKillerAccount.getAccountBalance();
    assert.equal(balance, 0, "Начислено 10000 монет");
});
});