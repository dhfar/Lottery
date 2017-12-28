var pixelwars = artifacts.require("./PixelWars.sol");

module.exports = function(deployer) {
  deployer.deploy(pixelwars, {gas: 6700000});
};