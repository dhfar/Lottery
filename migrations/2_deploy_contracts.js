// var pixelwars = artifacts.require("./PixelWars.sol");
// var pixelwarsMarketPlace = artifacts.require("./PixelWarsMarketPlace.sol");
var candyKiller = artifacts.require("./CandyKiller.sol");
// module.exports = function(deployer) {
//   deployer.deploy(pixelwars, {gas: 6700000});
// };

// module.exports = function(deployer) {
//     deployer.deploy(pixelwarsMarketPlace, {gas: 6700000});
// };

module.exports = function(deployer) {
    deployer.deploy(candyKiller, {gas: 6700000});
};