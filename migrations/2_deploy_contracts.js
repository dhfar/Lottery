var candyKillerAccount = artifacts.require("./CandyKillerAccount.sol");
var serviceContract = artifacts.require("./CKServiceContract.sol");
var candyKillerColony = artifacts.require("./CandyKillerColony.sol");

module.exports = function(deployer) {
    deployer.deploy(candyKillerAccount, {gas: 6700000});
    deployer.deploy(serviceContract, {gas: 6700000});
    deployer.deploy(candyKillerColony, {gas: 6700000});
};