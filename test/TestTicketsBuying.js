const lottery_6_45 = artifacts.require('lottery_6_45.sol');
const Web3 = require('web3');

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

contract('lottery_6_45', function(accounts) {
  it("При покупке билета тратится валюта", async () =>  {
    const lottery = await lottery_6_45.deployed();

    const account_one = accounts[0];
    const account_two = accounts[1];

    const account_one_starting_balance = await web3.eth.getBalance(account_one); // 96928406200000000000 ??
    const account_two_starting_balance = await web3.eth.getBalance(account_two); // 100000000000000000000
    
    const amount = 10;
    assert.equal(await lottery.owner.call(), account_one, 'Account one is lottery owner');
    await lottery.buyTicket(12,23,3,4,5,6,0,0,0,0,0,0,0)
    
    const account_one_ending_balance = await web3.eth.getBalance(account_one);
    const account_two_ending_balance = await web3.eth.getBalance(account_two);

    const spent = account_one_starting_balance - account_one_ending_balance; // 38480399999991810
    
    assert.isTrue(spent > 0, "Account should spent money");
    assert.equal(account_two_starting_balance.toNumber(), account_two_ending_balance.toNumber(), 'Account 2 doesnt changes');

  });
});