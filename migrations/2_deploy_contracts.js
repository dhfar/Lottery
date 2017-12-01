var lottery_6_45 = artifacts.require('./lottery_6_45.sol');
var powetball = artifacts.require('./LotteryPowerball.sol');
var Lottery_6_Of_45_Light = artifacts.require('./Lottery_6_Of_45_Light.sol');

module.exports = function(deployer) {
  deployer.deploy(lottery_6_45, {gas: 6700000});
  deployer.deploy(powetball, {gas: 6700000});
  deployer.deploy(Lottery_6_Of_45_Light, {gas: 6700000});
};


