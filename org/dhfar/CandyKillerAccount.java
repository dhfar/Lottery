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
    private static final String BINARY = "60806040526001805561271060025534801561001a57600080fd5b5060008054600160a060020a033316600160a060020a03199182168117909116179055610dd68061004c6000396000f30060806040526004361061013d5763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416630fe1881a811461014257806313f58fd11461017a5780631b9e16ad1461019d578063220565de146101f357806331c3f3131461021a57806349d64c5f14610232578063531460cc1461024d578063544e5b961461026e57806360e505c51461028f5780636896fabf146102a757806368ba75fc146102bc5780637ddbb5b7146102dd578063892d0f6e146102f25780638da5cb5b146103135780639dca362f14610344578063aebc955914610359578063b0e8319b14610361578063b3588d1114610376578063b9c8c44914610397578063bfe4b20b146103ab578063e040e9a0146103c6578063ece9de62146103db578063f2fde38b146103ff578063f3f4370314610420575b600080fd5b34801561014e57600080fd5b50610166600160a060020a0360043516602435610441565b604080519115158252519081900360200190f35b34801561018657600080fd5b5061019b600160a060020a03600435166104a4565b005b3480156101a957600080fd5b506101b2610500565b604080519788529515156020880152868601949094529115156060860152600160a060020a0316608085015260a084015260c0830152519081900360e00190f35b3480156101ff57600080fd5b50610208610544565b60408051918252519081900360200190f35b34801561022657600080fd5b5061016660043561054a565b34801561023e57600080fd5b50610166600435602435610584565b34801561025957600080fd5b50610208600160a060020a0360043516610694565b34801561027a57600080fd5b50610208600160a060020a03600435166106b2565b34801561029b57600080fd5b506101b26004356106cd565b3480156102b357600080fd5b506102086107ba565b3480156102c857600080fd5b5061019b600160a060020a03600435166107da565b3480156102e957600080fd5b50610208610837565b3480156102fe57600080fd5b50610166600160a060020a036004351661083d565b34801561031f57600080fd5b50610328610885565b60408051600160a060020a039092168252519081900360200190f35b34801561035057600080fd5b50610208610894565b6101666109b2565b34801561036d57600080fd5b50610208610a6e565b34801561038257600080fd5b5061019b600160a060020a0360043516610a7e565b610166600160a060020a0360043516610adb565b3480156103b757600080fd5b50610166600435602435610b61565b3480156103d257600080fd5b50610166610c2e565b3480156103e757600080fd5b50610166600160a060020a0360043516602435610c8c565b34801561040b57600080fd5b5061019b600160a060020a0360043516610d1a565b34801561042c57600080fd5b50610208600160a060020a0360043516610d64565b60075460009033600160a060020a039081169116146104625750600061049e565b61046b8361083d565b15156104795750600061049e565b50600160a060020a038216600090815260036020526040902060040180548201905560015b92915050565b60005433600160a060020a039081169116146104bf57600080fd5b600160a060020a03811615156104d4576104fd565b6006805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b50565b600160a060020a03331660009081526003602052604081205481908190819081908190819061052e906106cd565b959d949c50929a50909850965094509092509050565b60015481565b6000805433600160a060020a0390811691161461056657600080fd5b600082116105765750600061057f565b50600281905560015b919050565b6000805433600160a060020a039081169116146105a057600080fd5b600082815260046020908152604080832054600160a060020a03168352600391829052909120015460ff1615156105d95750600061049e565b600082815260046020908152604080832054600160a060020a031683526003909152902060020154831161063a57600082815260046020908152604080832054600160a060020a031683526003909152902060020180548490039055610642565b50600061049e565b60408051600160a060020a03331681526020810185905280820184905290517f5ccb25e760b69813d714bbbfa3ef14f68a90e2e90047e39cd05e8107a2b70d229181900360600190a150600192915050565b600160a060020a031660009081526003602052604090206004015490565b600160a060020a031660009081526003602052604090205490565b6000806000806000806000806106e1610d76565b60005433600160a060020a0390811691161480610718575060008a81526004602052604090205433600160a060020a039081169116145b156107ad57505050600087815260046020818152604080842054600160a060020a03168085526003808452828620835160a0810185528154808252600183015460ff9081161515838901819052600285015484890181905295850154909116151560608401819052939098015460808301819052858a5260059097529490972054939c50949a50985092965091945092509083905b5050919395979092949650565b600160a060020a0333166000908152600360205260409020600201545b90565b60005433600160a060020a039081169116146107f557600080fd5b600160a060020a038116151561080a576104fd565b60088054600160a060020a03831673ffffffffffffffffffffffffffffffffffffffff1990911617905550565b60025481565b600160a060020a03811660009081526003602081905260408220015460ff16801561049e575050600160a060020a031660009081526003602052604090206001015460ff1690565b600054600160a060020a031681565b600061089e610d76565b600160a060020a0333166000908152600360208190526040909120015460ff16156108cc57600091506109ae565b60018054825260208083018281526000604080860182815260608701868152600160a060020a03331680855260038088528486208a5181559651878a01805491151560ff199283161790559351600288015591519186018054921515929093169190911790915560808701516004948501558554835292845290819020805473ffffffffffffffffffffffffffffffffffffffff191683179055925483519182529181019190915281517f85841522199c696c3d4a549fea06732153559ded5db5cf6dfa3bb099827f2c84929181900390910190a16001805480820190915591505b5090565b600160a060020a033316600090815260036020819052604082200154819060ff1615156109e257600091506109ae565b600034116109f357600091506109ae565b60025434811515610a0057fe5b600160a060020a033316600081815260036020908152604091829020600201805495909404948501909355805191825291810183905281519293507f641df157745b52d6599a00a7e22851dbd6e9d1b2defbb2ba611e493a8565c0ab929081900390910190a1600191505090565b6000610a79336106b2565b905090565b60005433600160a060020a03908116911614610a9957600080fd5b600160a060020a0381161515610aae576104fd565b60078054600160a060020a03831673ffffffffffffffffffffffffffffffffffffffff1990911617905550565b60065460009033600160a060020a039081169116141580610b0b575060085433600160a060020a03908116911614155b15610b185750600061057f565b341515610b275750600061057f565b610b308261083d565b1515610b3e5750600061057f565b50600160a060020a03166000908152600560205260409020805434019055600190565b6000805433600160a060020a03908116911614610b7d57600080fd5b600082815260046020908152604080832054600160a060020a03168352600391829052909120015460ff161515610bb65750600061049e565b600082815260046020908152604080832054600160a060020a03908116845260038352928190206002018054870190558051339093168352908201859052818101849052517feca2c485d4cfe01cd0328975f29768cb4f365cd63ceb7daf14cc9e64fa696d2e9181900360600190a150600192915050565b600160a060020a03331660009081526003602081905260408220015460ff161515610c5b575060006107d7565b50600160a060020a03331660009081526003602052604090206001908101805460ff19811660ff9091161517905590565b60075460009033600160a060020a03908116911614610cad5750600061049e565b610cb68361083d565b1515610cc45750600061049e565b600160a060020a038316600090815260036020526040902060040154821115610cef5750600061049e565b50600160a060020a038216600090815260036020526040902060040180548290039055600192915050565b60005433600160a060020a03908116911614610d3557600080fd5b6000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b60056020526000908152604090205481565b60a06040519081016040528060008152602001600015158152602001600081526020016000151581526020016000815250905600a165627a7a72305820330817dfefd04ec1f85581192e7974429fa25d45b3fefb44725760a5798e805d0029";

    public static final String FUNC_ACCRUEFREEEXPERIENCECOIN = "accrueFreeExperienceCoin";

    public static final String FUNC_SETCOLONYMARKETPLACE = "setColonyMarketPlace";

    public static final String FUNC_GETACCOUNTINFO = "getAccountInfo";

    public static final String FUNC_NEXTACCOUNTINDEX = "nextAccountIndex";

    public static final String FUNC_SETPIXELWARSCOINPRICE = "setPixelWarsCoinPrice";

    public static final String FUNC_WITHDRAWALPIXELWARSCOINS = "withdrawalPixelWarsCoins";

    public static final String FUNC_GETFREEEXPERIENCECOINCOUNT = "getFreeExperienceCoinCount";

    public static final String FUNC_GETACCOUNTINDEXBYADDRESS = "getAccountIndexByAddress";

    public static final String FUNC_GETACCOUNTINFOBYINDEX = "getAccountInfoByIndex";

    public static final String FUNC_GETACCOUNTBALANCE = "getAccountBalance";

    public static final String FUNC_SETCHARACTERMARKETPLACE = "setCharacterMarketPlace";

    public static final String FUNC_PIXELWARSCOINPRICE = "pixelWarsCoinPrice";

    public static final String FUNC_ISCREATEANDACTIVE = "isCreateAndActive";

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
