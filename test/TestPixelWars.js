var PW = artifacts.require("PixelWars");

contract('PixelWarsTest', function() {
    it("Create account, create charater sucsess", async () => {
        const pixelWars =  await PW.deployed()

    await pixelWars.createAccount("mail@mail.ru", "petrovich");
    var newAccount = await pixelWars.getAccountInfoByIndex(0);
    console.log(newAccount);

    });
});