var PW = artifacts.require("PixelWars");

contract('GenerateCharacterSkills', function() {
    it("Тест: Создание маски способностей", async () => {
        const pixelWars =  await PW.deployed()
    // чтобы было из какого блока тянуть хэш для способностей
    await pixelWars.createAccount("mail@mail.ru", "petrovich");
    var skillsMask = await pixelWars.generateCharacterSkills();
    assert.equal(skillsMask[1], false, "Массив способностей сформирован успешно");
    var levelArray = skillsMask[0];
    assert.equal(levelArray.length, 32, "Кол-во способностей 32");
    var isError = false;
    for(var i = 0; i < levelArray.length; i++){
        if(levelArray[i] < 0 || levelArray[i] > 15){
            isError = true;
        }
    }
    assert.equal(isError, false, "Массив способностей сформирован в диапазоне от 0 до 15");
    });
});

contract('GetWinningPixel', function() {
    it("Тест: Генерация победной ячейки", async () => {
        const pixelWars =  await PW.deployed()
    // чтобы было из какого блока тянуть хэш для способностей
    await pixelWars.createAccount("mail@mail.ru", "petrovich");
    var isError = false;
    for(var i = 0; i < 32; i++){
        var maxValue = Math.pow(16, i);
        var winPixel = await pixelWars.getWinningPixel(i);
        if(winPixel[0] < 1 || winPixel[0] > maxValue){
            isError = true;
            // console.log(winPixel[0]);
        }
    }
    assert.equal(isError, false, "Номера ячеек полученные в результате теста попадают в верный диапазон");
});
});

contract('CreateAccountAndCreateCharacter', function() {
    it("Тест: Создание учетной записи и персонажа", async () => {
        const pixelWars =  await PW.deployed()
        await pixelWars.createAccount("mail@mail.ru", "petrovich");
        var newAccount = await pixelWars.getAccountInfoByIndex(0);
        assert.ok(newAccount[1], true, "Учетная запись создана");
        assert.ok(newAccount[3], true, "Учетная запись активна");
        await pixelWars.createCharacter("Petrivich")
        var newCharacter = await pixelWars.getCharacterByIndex(0);
        // console.log(newCharacter);
        assert.equal(newCharacter[1], "Petrivich", "Петрович создан");
        assert.notEqual(newCharacter[1], "0x0", "Петрович создан");
        assert.equal(newCharacter[4], false, "Персонаж не удален");
    });
});

contract('IncreaseExperienceCoinAndSkillLevelUp', function() {
    it("Тест: Начисление монет опыта и прокачка одной способности на 1 уровень", async () => {
        const pixelWars =  await PW.deployed()
        await pixelWars.createAccount("mail@mail.ru", "petrovich");
        await pixelWars.createCharacter("Petrivich");
        await pixelWars.increaseExperienceCoin(0, 100);
        var newCharacter = await pixelWars.getCharacterByIndex(0);
        // console.log(newCharacter[5]);
        assert.equal(newCharacter[5], 100, "Монеты для прокачки начислены");
        var skillLevel = newCharacter[2];
        var skillMask = newCharacter[3];
        var skillIndex = -1;
        for(var i = 0; i < 32; i++){
            if(skillLevel[i] < skillMask[i]){
                skillIndex = i;
                break;
            }
        }
        var coinsForLevelUp = 2 * Math.pow(2, skillLevel[skillIndex]);
        var lvlAfterIncrease = skillLevel[skillIndex]
        await pixelWars.increaseExperienceCoin(0, coinsForLevelUp);
        await pixelWars.increaseSkillLevel(0, skillIndex);
        newCharacter = await pixelWars.getCharacterByIndex(0);
        assert.equal(parseInt(newCharacter[2][skillIndex]), parseInt(lvlAfterIncrease, 10) + 1, "Способность успешно прокачана");
});
});