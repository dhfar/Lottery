package org.dhfar;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.EventEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.Event;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameter;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.methods.request.EthFilter;
import org.web3j.protocol.core.methods.response.Log;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tuples.generated.Tuple7;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;
import rx.Observable;
import rx.functions.Func1;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 3.4.0.
 */
public class CandyKillerAccount extends Contract {
    private static final String BINARY = "60806040526001805561271060025534801561001a57600080fd5b5060008054600160a060020a033316600160a060020a03199182168117909116179055610ec68061004c6000396000f3006080604052600436106101535763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416630fe1881a811461015857806313f58fd1146101905780631b9e16ad146101b3578063220565de1461020957806331c3f3131461023057806349d64c5f14610248578063531460cc14610263578063544e5b96146102845780635f913e75146102a557806360e505c5146102c65780636896fabf146102de57806368ba75fc146102f35780637ddbb5b714610314578063892d0f6e146103295780638938827c1461034a5780638da5cb5b1461036b5780639dca362f1461039c578063aebc9559146103b1578063b0e8319b146103b9578063b3588d11146103ce578063b9c8c449146103ef578063bfe4b20b14610403578063e040e9a01461041e578063ece9de6214610433578063f2fde38b14610457578063f3f4370314610478575b600080fd5b34801561016457600080fd5b5061017c600160a060020a0360043516602435610499565b604080519115158252519081900360200190f35b34801561019c57600080fd5b506101b1600160a060020a03600435166104fc565b005b3480156101bf57600080fd5b506101c861054b565b604080519788529515156020880152868601949094529115156060860152600160a060020a0316608085015260a084015260c0830152519081900360e00190f35b34801561021557600080fd5b5061021e61058f565b60408051918252519081900360200190f35b34801561023c57600080fd5b5061017c600435610595565b34801561025457600080fd5b5061017c6004356024356105cf565b34801561026f57600080fd5b5061021e600160a060020a03600435166106df565b34801561029057600080fd5b5061021e600160a060020a03600435166106fd565b3480156102b157600080fd5b506101b1600160a060020a0360043516610718565b3480156102d257600080fd5b506101c8600435610768565b3480156102ea57600080fd5b5061021e610855565b3480156102ff57600080fd5b506101b1600160a060020a0360043516610875565b34801561032057600080fd5b5061021e6108c5565b34801561033557600080fd5b5061017c600160a060020a03600435166108cb565b34801561035657600080fd5b506101b1600160a060020a0360043516610913565b34801561037757600080fd5b50610380610963565b60408051600160a060020a039092168252519081900360200190f35b3480156103a857600080fd5b5061021e610972565b61017c610a83565b3480156103c557600080fd5b5061021e610b3f565b3480156103da57600080fd5b506101b1600160a060020a0360043516610b4f565b61017c600160a060020a0360043516610b9f565b34801561040f57600080fd5b5061017c600435602435610c41565b34801561042a57600080fd5b5061017c610d0e565b34801561043f57600080fd5b5061017c600160a060020a0360043516602435610d6c565b34801561046357600080fd5b506101b1600160a060020a0360043516610e17565b34801561048457600080fd5b5061021e600160a060020a0360043516610e54565b60075460009033600160a060020a039081169116146104ba575060006104f6565b6104c3836108cb565b15156104d1575060006104f6565b50600160a060020a038216600090815260036020526040902060040180548201905560015b92915050565b60005433600160a060020a0390811691161461051757600080fd5b600160a060020a038116151561052c57610548565b60068054600160a060020a031916600160a060020a0383161790555b50565b600160a060020a03331660009081526003602052604081205481908190819081908190819061057990610768565b959d949c50929a50909850965094509092509050565b60015481565b6000805433600160a060020a039081169116146105b157600080fd5b600082116105c1575060006105ca565b50600281905560015b919050565b6000805433600160a060020a039081169116146105eb57600080fd5b600082815260046020908152604080832054600160a060020a03168352600391829052909120015460ff161515610624575060006104f6565b600082815260046020908152604080832054600160a060020a031683526003909152902060020154831161068557600082815260046020908152604080832054600160a060020a03168352600390915290206002018054849003905561068d565b5060006104f6565b60408051600160a060020a03331681526020810185905280820184905290517f5ccb25e760b69813d714bbbfa3ef14f68a90e2e90047e39cd05e8107a2b70d229181900360600190a150600192915050565b600160a060020a031660009081526003602052604090206004015490565b600160a060020a031660009081526003602052604090205490565b60005433600160a060020a0390811691161461073357600080fd5b600160a060020a038116151561074857610548565b60098054600160a060020a038316600160a060020a031990911617905550565b60008060008060008060008061077c610e66565b60005433600160a060020a03908116911614806107b3575060008a81526004602052604090205433600160a060020a039081169116145b1561084857505050600087815260046020818152604080842054600160a060020a03168085526003808452828620835160a0810185528154808252600183015460ff9081161515838901819052600285015484890181905295850154909116151560608401819052939098015460808301819052858a5260059097529490972054939c50949a50985092965091945092509083905b5050919395979092949650565b600160a060020a0333166000908152600360205260409020600201545b90565b60005433600160a060020a0390811691161461089057600080fd5b600160a060020a03811615156108a557610548565b60088054600160a060020a038316600160a060020a031990911617905550565b60025481565b600160a060020a03811660009081526003602081905260408220015460ff1680156104f6575050600160a060020a031660009081526003602052604090206001015460ff1690565b60005433600160a060020a0390811691161461092e57600080fd5b600160a060020a038116151561094357610548565b600a8054600160a060020a038316600160a060020a031990911617905550565b600054600160a060020a031681565b600061097c610e66565b600160a060020a0333166000908152600360208190526040909120015460ff16156109aa5760009150610a7f565b60018054825260208083018281526000604080860182815260608701868152600160a060020a03331680855260038088528486208a5181559651878a01805491151560ff1992831617905593516002880155915191860180549215159290931691909117909155608087015160049485015585548352928452908190208054600160a060020a03191683179055925483519182529181019190915281517f85841522199c696c3d4a549fea06732153559ded5db5cf6dfa3bb099827f2c84929181900390910190a16001805480820190915591505b5090565b600160a060020a033316600090815260036020819052604082200154819060ff161515610ab35760009150610a7f565b60003411610ac45760009150610a7f565b60025434811515610ad157fe5b600160a060020a033316600081815260036020908152604091829020600201805495909404948501909355805191825291810183905281519293507f641df157745b52d6599a00a7e22851dbd6e9d1b2defbb2ba611e493a8565c0ab929081900390910190a1600191505090565b6000610b4a336106fd565b905090565b60005433600160a060020a03908116911614610b6a57600080fd5b600160a060020a0381161515610b7f57610548565b60078054600160a060020a038316600160a060020a031990911617905550565b60065460009033600160a060020a03908116911614801590610bd0575060085433600160a060020a03908116911614155b8015610beb5750600a5433600160a060020a03908116911614155b15610bf8575060006105ca565b341515610c07575060006105ca565b610c10826108cb565b1515610c1e575060006105ca565b50600160a060020a03166000908152600560205260409020805434019055600190565b6000805433600160a060020a03908116911614610c5d57600080fd5b600082815260046020908152604080832054600160a060020a03168352600391829052909120015460ff161515610c96575060006104f6565b600082815260046020908152604080832054600160a060020a03908116845260038352928190206002018054870190558051339093168352908201859052818101849052517feca2c485d4cfe01cd0328975f29768cb4f365cd63ceb7daf14cc9e64fa696d2e9181900360600190a150600192915050565b600160a060020a03331660009081526003602081905260408220015460ff161515610d3b57506000610872565b50600160a060020a03331660009081526003602052604090206001908101805460ff19811660ff9091161517905590565b60075460009033600160a060020a03908116911614801590610d9d575060095433600160a060020a03908116911614155b15610daa575060006104f6565b610db3836108cb565b1515610dc1575060006104f6565b600160a060020a038316600090815260036020526040902060040154821115610dec575060006104f6565b50600160a060020a038216600090815260036020526040902060040180548290039055600192915050565b60005433600160a060020a03908116911614610e3257600080fd5b60008054600160a060020a031916600160a060020a0392909216919091179055565b60056020526000908152604090205481565b60a06040519081016040528060008152602001600015158152602001600081526020016000151581526020016000815250905600a165627a7a7230582031407ed23868527274fdfc19f5513d1f193fa554dcbe31092caec8440f79cbbd0029";

    public static final String FUNC_ACCRUEFREEEXPERIENCECOIN = "accrueFreeExperienceCoin";

    public static final String FUNC_SETCOLONYMARKETPLACE = "setColonyMarketPlace";

    public static final String FUNC_GETACCOUNTINFO = "getAccountInfo";

    public static final String FUNC_NEXTACCOUNTINDEX = "nextAccountIndex";

    public static final String FUNC_SETPIXELWARSCOINPRICE = "setPixelWarsCoinPrice";

    public static final String FUNC_WITHDRAWALPIXELWARSCOINS = "withdrawalPixelWarsCoins";

    public static final String FUNC_GETFREEEXPERIENCECOINCOUNT = "getFreeExperienceCoinCount";

    public static final String FUNC_GETACCOUNTINDEXBYADDRESS = "getAccountIndexByAddress";

    public static final String FUNC_SETCHARACTERITEM = "setCharacterItem";

    public static final String FUNC_GETACCOUNTINFOBYINDEX = "getAccountInfoByIndex";

    public static final String FUNC_GETACCOUNTBALANCE = "getAccountBalance";

    public static final String FUNC_SETCHARACTERMARKETPLACE = "setCharacterMarketPlace";

    public static final String FUNC_PIXELWARSCOINPRICE = "pixelWarsCoinPrice";

    public static final String FUNC_ISCREATEANDACTIVE = "isCreateAndActive";

    public static final String FUNC_SETCHARACTERITEMMARKETPLACE = "setCharacterItemMarketPlace";

    public static final String FUNC_OWNER = "owner";

    public static final String FUNC_CREATEACCOUNT = "createAccount";

    public static final String FUNC_BUYPIXELWARSCOINS = "buyPixelWarsCoins";

    public static final String FUNC_GETACCOUNTINDEX = "getAccountIndex";

    public static final String FUNC_SETCANDYKILLERCHARACTER = "setCandyKillerCharacter";

    public static final String FUNC_ADDPENDINGWITHDRAWALS = "addPendingWithdrawals";

    public static final String FUNC_ACCRUALPIXELWARSCOINS = "accrualPixelWarsCoins";

    public static final String FUNC_DEACTIVATEACCOUNT = "deactivateAccount";

    public static final String FUNC_WRITEOFFFREEEXPERIENCECOIN = "writeOffFreeExperienceCoin";

    public static final String FUNC_TRANSFEROWNERSHIP = "transferOwnership";

    public static final String FUNC_PENDINGWITHDRAWALS = "pendingWithdrawals";

    public static final Event CREATEACCOUNT_EVENT = new Event("CreateAccount", 
            Arrays.<TypeReference<?>>asList(),
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
    ;

    public static final Event BUYPIXELWARSCOINS_EVENT = new Event("BuyPixelWarsCoins", 
            Arrays.<TypeReference<?>>asList(),
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
    ;

    public static final Event ACCRUALPIXELWARSCOINS_EVENT = new Event("AccrualPixelWarsCoins", 
            Arrays.<TypeReference<?>>asList(),
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
    ;

    public static final Event WITHDRAWALPIXELWARSCOINS_EVENT = new Event("WithdrawalPixelWarsCoins", 
            Arrays.<TypeReference<?>>asList(),
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
    ;

    protected CandyKillerAccount(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected CandyKillerAccount(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public RemoteCall<TransactionReceipt> accrueFreeExperienceCoin(String accountOwner, BigInteger accrueCoins) {
        final Function function = new Function(
                FUNC_ACCRUEFREEEXPERIENCECOIN, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(accountOwner), 
                new org.web3j.abi.datatypes.generated.Uint256(accrueCoins)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> setColonyMarketPlace(String colonyMarketPlaceAddress) {
        final Function function = new Function(
                FUNC_SETCOLONYMARKETPLACE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(colonyMarketPlaceAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>> getAccountInfo() {
        final Function function = new Function(FUNC_GETACCOUNTINFO, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>>(
                new Callable<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (Boolean) results.get(1).getValue(), 
                                (BigInteger) results.get(2).getValue(), 
                                (Boolean) results.get(3).getValue(), 
                                (String) results.get(4).getValue(), 
                                (BigInteger) results.get(5).getValue(), 
                                (BigInteger) results.get(6).getValue());
                    }
                });
    }

    public RemoteCall<BigInteger> nextAccountIndex() {
        final Function function = new Function(FUNC_NEXTACCOUNTINDEX, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> setPixelWarsCoinPrice(BigInteger newPrice) {
        final Function function = new Function(
                FUNC_SETPIXELWARSCOINPRICE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(newPrice)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> withdrawalPixelWarsCoins(BigInteger pixelCount, BigInteger accountIndex) {
        final Function function = new Function(
                FUNC_WITHDRAWALPIXELWARSCOINS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(pixelCount), 
                new org.web3j.abi.datatypes.generated.Uint256(accountIndex)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<BigInteger> getFreeExperienceCoinCount(String accountOwner) {
        final Function function = new Function(FUNC_GETFREEEXPERIENCECOINCOUNT, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(accountOwner)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> getAccountIndexByAddress(String ownerAccount) {
        final Function function = new Function(FUNC_GETACCOUNTINDEXBYADDRESS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(ownerAccount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> setCharacterItem(String characterItemAddress) {
        final Function function = new Function(
                FUNC_SETCHARACTERITEM, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(characterItemAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>> getAccountInfoByIndex(BigInteger indexAccount) {
        final Function function = new Function(FUNC_GETACCOUNTINFOBYINDEX, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(indexAccount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>>(
                new Callable<Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple7<BigInteger, Boolean, BigInteger, Boolean, String, BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (Boolean) results.get(1).getValue(), 
                                (BigInteger) results.get(2).getValue(), 
                                (Boolean) results.get(3).getValue(), 
                                (String) results.get(4).getValue(), 
                                (BigInteger) results.get(5).getValue(), 
                                (BigInteger) results.get(6).getValue());
                    }
                });
    }

    public RemoteCall<BigInteger> getAccountBalance() {
        final Function function = new Function(FUNC_GETACCOUNTBALANCE, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> setCharacterMarketPlace(String characterMarketPlaceAddress) {
        final Function function = new Function(
                FUNC_SETCHARACTERMARKETPLACE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(characterMarketPlaceAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<BigInteger> pixelWarsCoinPrice() {
        final Function function = new Function(FUNC_PIXELWARSCOINPRICE, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<Boolean> isCreateAndActive(String userAddress) {
        final Function function = new Function(FUNC_ISCREATEANDACTIVE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(userAddress)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteCall<TransactionReceipt> setCharacterItemMarketPlace(String characterItemMarketPlaceAddress) {
        final Function function = new Function(
                FUNC_SETCHARACTERITEMMARKETPLACE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(characterItemMarketPlaceAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<String> owner() {
        final Function function = new Function(FUNC_OWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<TransactionReceipt> createAccount() {
        final Function function = new Function(
                FUNC_CREATEACCOUNT, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> buyPixelWarsCoins(BigInteger weiValue) {
        final Function function = new Function(
                FUNC_BUYPIXELWARSCOINS, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<BigInteger> getAccountIndex() {
        final Function function = new Function(FUNC_GETACCOUNTINDEX, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> setCandyKillerCharacter(String candyKillerCharacterAddress) {
        final Function function = new Function(
                FUNC_SETCANDYKILLERCHARACTER, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(candyKillerCharacterAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> addPendingWithdrawals(String userAddress, BigInteger weiValue) {
        final Function function = new Function(
                FUNC_ADDPENDINGWITHDRAWALS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(userAddress)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<TransactionReceipt> accrualPixelWarsCoins(BigInteger pixelCount, BigInteger accountIndex) {
        final Function function = new Function(
                FUNC_ACCRUALPIXELWARSCOINS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(pixelCount), 
                new org.web3j.abi.datatypes.generated.Uint256(accountIndex)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> deactivateAccount() {
        final Function function = new Function(
                FUNC_DEACTIVATEACCOUNT, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> writeOffFreeExperienceCoin(String accountOwner, BigInteger writeOffCoins) {
        final Function function = new Function(
                FUNC_WRITEOFFFREEEXPERIENCECOIN, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(accountOwner), 
                new org.web3j.abi.datatypes.generated.Uint256(writeOffCoins)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> transferOwnership(String newOwner) {
        final Function function = new Function(
                FUNC_TRANSFEROWNERSHIP, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(newOwner)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<BigInteger> pendingWithdrawals(String param0) {
        final Function function = new Function(FUNC_PENDINGWITHDRAWALS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(param0)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public static RemoteCall<CandyKillerAccount> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(CandyKillerAccount.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<CandyKillerAccount> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(CandyKillerAccount.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public List<CreateAccountEventResponse> getCreateAccountEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(CREATEACCOUNT_EVENT, transactionReceipt);
        ArrayList<CreateAccountEventResponse> responses = new ArrayList<CreateAccountEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            CreateAccountEventResponse typedResponse = new CreateAccountEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.creator = (String) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.account = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<CreateAccountEventResponse> createAccountEventObservable(EthFilter filter) {
        return web3j.ethLogObservable(filter).map(new Func1<Log, CreateAccountEventResponse>() {
            @Override
            public CreateAccountEventResponse call(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(CREATEACCOUNT_EVENT, log);
                CreateAccountEventResponse typedResponse = new CreateAccountEventResponse();
                typedResponse.log = log;
                typedResponse.creator = (String) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.account = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public Observable<CreateAccountEventResponse> createAccountEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(CREATEACCOUNT_EVENT));
        return createAccountEventObservable(filter);
    }

    public List<BuyPixelWarsCoinsEventResponse> getBuyPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(BUYPIXELWARSCOINS_EVENT, transactionReceipt);
        ArrayList<BuyPixelWarsCoinsEventResponse> responses = new ArrayList<BuyPixelWarsCoinsEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            BuyPixelWarsCoinsEventResponse typedResponse = new BuyPixelWarsCoinsEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.buyer = (String) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.coins = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<BuyPixelWarsCoinsEventResponse> buyPixelWarsCoinsEventObservable(EthFilter filter) {
        return web3j.ethLogObservable(filter).map(new Func1<Log, BuyPixelWarsCoinsEventResponse>() {
            @Override
            public BuyPixelWarsCoinsEventResponse call(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(BUYPIXELWARSCOINS_EVENT, log);
                BuyPixelWarsCoinsEventResponse typedResponse = new BuyPixelWarsCoinsEventResponse();
                typedResponse.log = log;
                typedResponse.buyer = (String) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.coins = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public Observable<BuyPixelWarsCoinsEventResponse> buyPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(BUYPIXELWARSCOINS_EVENT));
        return buyPixelWarsCoinsEventObservable(filter);
    }

    public List<AccrualPixelWarsCoinsEventResponse> getAccrualPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(ACCRUALPIXELWARSCOINS_EVENT, transactionReceipt);
        ArrayList<AccrualPixelWarsCoinsEventResponse> responses = new ArrayList<AccrualPixelWarsCoinsEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            AccrualPixelWarsCoinsEventResponse typedResponse = new AccrualPixelWarsCoinsEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.executor = (String) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            typedResponse.accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<AccrualPixelWarsCoinsEventResponse> accrualPixelWarsCoinsEventObservable(EthFilter filter) {
        return web3j.ethLogObservable(filter).map(new Func1<Log, AccrualPixelWarsCoinsEventResponse>() {
            @Override
            public AccrualPixelWarsCoinsEventResponse call(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(ACCRUALPIXELWARSCOINS_EVENT, log);
                AccrualPixelWarsCoinsEventResponse typedResponse = new AccrualPixelWarsCoinsEventResponse();
                typedResponse.log = log;
                typedResponse.executor = (String) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                typedResponse.accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
                return typedResponse;
            }
        });
    }

    public Observable<AccrualPixelWarsCoinsEventResponse> accrualPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(ACCRUALPIXELWARSCOINS_EVENT));
        return accrualPixelWarsCoinsEventObservable(filter);
    }

    public List<WithdrawalPixelWarsCoinsEventResponse> getWithdrawalPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(WITHDRAWALPIXELWARSCOINS_EVENT, transactionReceipt);
        ArrayList<WithdrawalPixelWarsCoinsEventResponse> responses = new ArrayList<WithdrawalPixelWarsCoinsEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            WithdrawalPixelWarsCoinsEventResponse typedResponse = new WithdrawalPixelWarsCoinsEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.executor = (String) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            typedResponse.accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<WithdrawalPixelWarsCoinsEventResponse> withdrawalPixelWarsCoinsEventObservable(EthFilter filter) {
        return web3j.ethLogObservable(filter).map(new Func1<Log, WithdrawalPixelWarsCoinsEventResponse>() {
            @Override
            public WithdrawalPixelWarsCoinsEventResponse call(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(WITHDRAWALPIXELWARSCOINS_EVENT, log);
                WithdrawalPixelWarsCoinsEventResponse typedResponse = new WithdrawalPixelWarsCoinsEventResponse();
                typedResponse.log = log;
                typedResponse.executor = (String) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                typedResponse.accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
                return typedResponse;
            }
        });
    }

    public Observable<WithdrawalPixelWarsCoinsEventResponse> withdrawalPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(WITHDRAWALPIXELWARSCOINS_EVENT));
        return withdrawalPixelWarsCoinsEventObservable(filter);
    }

    public static CandyKillerAccount load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new CandyKillerAccount(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    public static CandyKillerAccount load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new CandyKillerAccount(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static class CreateAccountEventResponse {
        public Log log;

        public String creator;

        public BigInteger account;
    }

    public static class BuyPixelWarsCoinsEventResponse {
        public Log log;

        public String buyer;

        public BigInteger coins;
    }

    public static class AccrualPixelWarsCoinsEventResponse {
        public Log log;

        public String executor;

        public BigInteger pixelCount;

        public BigInteger accountIndex;
    }

    public static class WithdrawalPixelWarsCoinsEventResponse {
        public Log log;

        public String executor;

        public BigInteger pixelCount;

        public BigInteger accountIndex;
    }
}
