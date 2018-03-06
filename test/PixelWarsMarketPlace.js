var PWMP = artifacts.require("PixelWarsMarketPlace");

contract('CreateAccountAndCreateCharacter', function(accounts) {
    it("Тест: Создание учетной записи и персонажа", async () => {
        const PixelWarsMarketPlace =  await PWMP.deployed()
    await PixelWarsMarketPlace.createAccount("mail@mail.ru", "petrovich");
    var newAccount = await PixelWarsMarketPlace.getAccountInfoByIndex(1);
    assert.ok(newAccount[1], true, "Учетная запись создана");
    assert.ok(newAccount[3], true, "Учетная запись активна");

    var accountId = await PixelWarsMarketPlace.getAccountIndexByAddress(accounts[0]);
    assert.equal(accountId, "1", "Id получен верно");

    await PixelWarsMarketPlace.createCharacter("Petrivich")
    var newCharacter = await PixelWarsMarketPlace.getCharacterByIndex(1);
    // console.log(newCharacter);
    assert.equal(newCharacter[1], "Petrivich", "Петрович создан");
    assert.notEqual(newCharacter[1], "0x0", "Петрович создан");
    assert.equal(newCharacter[4], false, "Персонаж не удален");

    var nextUserCharacterIndex = await PixelWarsMarketPlace.getNextUserCharacterIndex(0);
    // console.log(nextUserCharacterIndex);
    assert.equal(nextUserCharacterIndex, 1, "Первый индекс получен");

    nextUserCharacterIndex = await PixelWarsMarketPlace.getNextUserCharacterIndex(1);
    // console.log(nextUserCharacterIndex);
    assert.equal(nextUserCharacterIndex, 0, "Других персонажей нет");
});
});