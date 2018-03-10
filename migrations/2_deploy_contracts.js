var candyKillerAccount = artifacts.require("./CandyKillerAccount.sol");

module.exports = function(deployer) {
    deployer.deploy(candyKillerAccount, {gas: 6700000});
};