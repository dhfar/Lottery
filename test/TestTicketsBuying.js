var lottery_6_45 = artifacts.require('lottery_6_45.sol');

/*contract('lottery', function(accounts) {
  it("should put 10000 MetaCoin in the first account", function() {
    return lottery.deployed().then(function(instance) {
      return instance.JackPot;
    });
  });
});*/

contract('lottery_6_45', function(accounts) {
  it("Пока нерабочий яваскриптовый тест", function() {
    var lottery;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return lottery_6_45.deployed().then(function(instance) {
        lottery = instance;
        //console.log(lottery.owner())
        //console.log(JSON.stringify(lottery.buy_big_ticket(12,23,3,4,5,6,0,0,0,0,0,0,0)));
        return lottery.buy_big_ticket(12,23,3,4,5,6,0,0,0,0,0,0,0);
    }).then(function(buy_ticket_result) {
        var bbres = buy_ticket_result;
        //console.log(JSON.stringify(bbres));
        
        //assert.equal(bbres,1, "билет в порядке");
      //account_two_ending_balance = balance.toNumber();
      //assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      //assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});