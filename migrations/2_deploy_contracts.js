var lottery_6_45 = artifacts.require('./lottery_6_45.sol');

module.exports = function(deployer) {
  deployer.deploy(lottery_6_45, {gas: 6700000});
};