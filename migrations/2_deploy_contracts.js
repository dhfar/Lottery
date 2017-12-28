var lottery_6_45 = artifacts.require('./lottery_6_45.sol');
var powetball = artifacts.require('./LotteryPowerball.sol');
var pixelwars = artifacts.require("./PixelWars.sol");

module.exports = function(deployer) {
  deployer.deploy(lottery_6_45, {gas: 6700000});
  deployer.deploy(powetball, {gas: 6700000});
  deployer.deploy(pixelwars, {gas: 6700000});
};