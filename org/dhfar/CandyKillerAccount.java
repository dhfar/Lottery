package org.dhfar;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.EventEncoder;
import org.web3j.abi.EventValues;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.Event;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
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
 * <p>Generated with web3j version 3.2.0.
 */
public class CandyKillerAccount extends Contract {
    private static final String BINARY = "606060405260018055612710600255341561001957600080fd5b60008054600160a060020a033316600160a060020a0319909116179055610c97806100456000396000f3006060604052600436106100e55763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416631928928781146100ea5780631b9e16ad1461018f578063220565de1461025257806331c3f3131461026557806349d64c5f1461028f578063544e5b96146102a857806360e505c5146102c75780636896fabf146102dd5780637ddbb5b7146102f05780638da5cb5b14610303578063aebc955914610332578063b0e8319b1461033a578063bfe4b20b1461034d578063df32754b14610366578063e040e9a01461037b578063f2fde38b1461038e575b600080fd5b34156100f557600080fd5b61017d60046024813581810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284378201915050505050509190803590602001908201803590602001908080601f0160208091040260200160405190810160405281815292919060208401838380828437509496506103ad95505050505050565b60405190815260200160405180910390f35b341561019a57600080fd5b6101a26105a0565b6040518781528515156040820152606081018590528315156080820152600160a060020a03831660a082015260c0810182905260e06020820181815290820188818151815260200191508051906020019080838360005b838110156102115780820151838201526020016101f9565b50505050905090810190601f16801561023e5780820380516001836020036101000a031916815260200191505b509850505050505050505060405180910390f35b341561025d57600080fd5b61017d6105ea565b341561027057600080fd5b61027b6004356105f0565b604051901515815260200160405180910390f35b341561029a57600080fd5b61027b60043560243561062a565b34156102b357600080fd5b61017d600160a060020a0360043516610735565b34156102d257600080fd5b6101a2600435610750565b34156102e857600080fd5b61017d610914565b34156102fb57600080fd5b61017d610934565b341561030e57600080fd5b61031661093a565b604051600160a060020a03909116815260200160405180910390f35b61027b610949565b341561034557600080fd5b61017d6109ff565b341561035857600080fd5b61027b600435602435610a0f565b341561037157600080fd5b610379610adc565b005b341561038657600080fd5b61027b610b06565b341561039957600080fd5b610379600160a060020a0360043516610b37565b60006103b7610b81565b600160a060020a03331660009081526003602052604090206005015460ff16156103e45760009150610599565b6001548152602081018490526002836000604051602001526040518082805190602001908083835b6020831061042b5780518252601f19909201916020918201910161040c565b6001836020036101000a03801982511681845116808217855250505050505090500191505060206040518083038160008661646e5a03f1151561046d57600080fd5b5050604051805160408084019190915260016060840181905260006080850181905260a0850191909152600160a060020a0333168152600360205220829150815181556020820151816001019080516104ca929160200190610bc5565b5060408201516002820155606082015160038201805460ff19169115159190911790556080820151816004015560a082015160058201805460ff191691151591909117905560c08201516006909101555060018054600090815260046020526040908190208054600160a060020a03331673ffffffffffffffffffffffffffffffffffffffff19909116811790915591547f85841522199c696c3d4a549fea06732153559ded5db5cf6dfa3bb099827f2c84915190815260200160405180910390a26001805480820190915591505b5092915050565b60006105aa610c3f565b600160a060020a03331660009081526003602052604081205481908190819081906105d490610750565b959d949c50929a50909850965094509092509050565b60015481565b6000805433600160a060020a0390811691161461060c57600080fd5b6000821161061c57506000610625565b50600281905560015b919050565b6000805433600160a060020a0390811691161461064657600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff16151561067f5750600061072f565b600082815260046020818152604080842054600160a060020a03168452600390915290912001548390106106df57600082815260046020818152604080842054600160a060020a03168452600390915290912001805484900390556106e7565b50600061072f565b33600160a060020a03167f5ccb25e760b69813d714bbbfa3ef14f68a90e2e90047e39cd05e8107a2b70d22848460405191825260208201526040908101905180910390a25060015b92915050565b600160a060020a031660009081526003602052604090205490565b600061075a610c3f565b600080600080600061076a610b81565b60005433600160a060020a03908116911614806107a1575060008981526004602052604090205433600160a060020a039081169116145b1561090857600089815260046020908152604080832054600160a060020a031683526003909152908190209060e09051908101604052908160008201548152602001600182018054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561087b5780601f106108505761010080835404028352916020019161087b565b820191906000526020600020905b81548152906001019060200180831161085e57829003601f168201915b505050918352505060028201546020820152600382015460ff90811615156040830152600483015460608301526005830154161515608082015260069091015460a090910152905080518160200151826060015183608001518460a0015160008e815260046020526040902054600160a060020a031660c087015185955097509750975097509750975097505b50919395979092949650565b600160a060020a0333166000908152600360205260409020600401545b90565b60025481565b600054600160a060020a031681565b600160a060020a033316600090815260036020526040812060050154819060ff16151561097957600091506109fb565b6000341161098a57600091506109fb565b6002543481151561099757fe5b600160a060020a033316600081815260036020526040908190206004018054949093049384019092559192507f641df157745b52d6599a00a7e22851dbd6e9d1b2defbb2ba611e493a8565c0ab9083905190815260200160405180910390a2600191505b5090565b6000610a0a33610735565b905090565b6000805433600160a060020a03908116911614610a2b57600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff161515610a645750600061072f565b600082815260046020818152604080842054600160a060020a0390811685526003909252928390209091018054860190553316907feca2c485d4cfe01cd0328975f29768cb4f365cd63ceb7daf14cc9e64fa696d2e90859085905191825260208201526040908101905180910390a250600192915050565b6000805473ffffffffffffffffffffffffffffffffffffffff191633600160a060020a0316179055565b600160a060020a033316600090815260036020819052604090912001805460ff19811660ff90911615179055600190565b60005433600160a060020a03908116911614610b5257600080fd5b6000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b60e06040519081016040528060008152602001610b9c610c3f565b815260006020820181905260408201819052606082018190526080820181905260a09091015290565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10610c0657805160ff1916838001178555610c33565b82800160010185558215610c33579182015b82811115610c33578251825591602001919060010190610c18565b506109fb929150610c51565b60206040519081016040526000815290565b61093191905b808211156109fb5760008155600101610c575600a165627a7a72305820577210853e6fe7261a79373bce971385e11b358cea4cb60f6b1c917522e6c3890029";

    protected CandyKillerAccount(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected CandyKillerAccount(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public List<CreateAccountEventResponse> getCreateAccountEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("CreateAccount", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<CreateAccountEventResponse> responses = new ArrayList<CreateAccountEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            CreateAccountEventResponse typedResponse = new CreateAccountEventResponse();
            typedResponse._creator = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse._account = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<CreateAccountEventResponse> createAccountEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("CreateAccount", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, CreateAccountEventResponse>() {
            @Override
            public CreateAccountEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                CreateAccountEventResponse typedResponse = new CreateAccountEventResponse();
                typedResponse._creator = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse._account = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                return typedResponse;
            }
        });
    }

    public List<CreateCharacterEventResponse> getCreateCharacterEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("CreateCharacter", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<CreateCharacterEventResponse> responses = new ArrayList<CreateCharacterEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            CreateCharacterEventResponse typedResponse = new CreateCharacterEventResponse();
            typedResponse._creator = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse._character = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<CreateCharacterEventResponse> createCharacterEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("CreateCharacter", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, CreateCharacterEventResponse>() {
            @Override
            public CreateCharacterEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                CreateCharacterEventResponse typedResponse = new CreateCharacterEventResponse();
                typedResponse._creator = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse._character = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                return typedResponse;
            }
        });
    }

    public List<BuyPixelWarsCoinsEventResponse> getBuyPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("BuyPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<BuyPixelWarsCoinsEventResponse> responses = new ArrayList<BuyPixelWarsCoinsEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            BuyPixelWarsCoinsEventResponse typedResponse = new BuyPixelWarsCoinsEventResponse();
            typedResponse._buyer = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse._coins = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<BuyPixelWarsCoinsEventResponse> buyPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("BuyPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, BuyPixelWarsCoinsEventResponse>() {
            @Override
            public BuyPixelWarsCoinsEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                BuyPixelWarsCoinsEventResponse typedResponse = new BuyPixelWarsCoinsEventResponse();
                typedResponse._buyer = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse._coins = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                return typedResponse;
            }
        });
    }

    public List<AccrualPixelWarsCoinsEventResponse> getAccrualPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("AccrualPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<AccrualPixelWarsCoinsEventResponse> responses = new ArrayList<AccrualPixelWarsCoinsEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            AccrualPixelWarsCoinsEventResponse typedResponse = new AccrualPixelWarsCoinsEventResponse();
            typedResponse._executor = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse._pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse._accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<AccrualPixelWarsCoinsEventResponse> accrualPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("AccrualPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, AccrualPixelWarsCoinsEventResponse>() {
            @Override
            public AccrualPixelWarsCoinsEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                AccrualPixelWarsCoinsEventResponse typedResponse = new AccrualPixelWarsCoinsEventResponse();
                typedResponse._executor = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse._pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse._accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public List<WithdrawalPixelWarsCoinsEventResponse> getWithdrawalPixelWarsCoinsEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("WithdrawalPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<WithdrawalPixelWarsCoinsEventResponse> responses = new ArrayList<WithdrawalPixelWarsCoinsEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            WithdrawalPixelWarsCoinsEventResponse typedResponse = new WithdrawalPixelWarsCoinsEventResponse();
            typedResponse._executor = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse._pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse._accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<WithdrawalPixelWarsCoinsEventResponse> withdrawalPixelWarsCoinsEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("WithdrawalPixelWarsCoins", 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, WithdrawalPixelWarsCoinsEventResponse>() {
            @Override
            public WithdrawalPixelWarsCoinsEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                WithdrawalPixelWarsCoinsEventResponse typedResponse = new WithdrawalPixelWarsCoinsEventResponse();
                typedResponse._executor = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse._pixelCount = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse._accountIndex = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public RemoteCall<TransactionReceipt> createAccount(String userEmail, String userPassword) {
        Function function = new Function(
                "createAccount", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Utf8String(userEmail), 
                new org.web3j.abi.datatypes.Utf8String(userPassword)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>> getAccountInfo() {
        final Function function = new Function("getAccountInfo", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>(
                new Callable<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);;
                        return new Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (String) results.get(1).getValue(), 
                                (Boolean) results.get(2).getValue(), 
                                (BigInteger) results.get(3).getValue(), 
                                (Boolean) results.get(4).getValue(), 
                                (String) results.get(5).getValue(), 
                                (BigInteger) results.get(6).getValue());
                    }
                });
    }

    public RemoteCall<BigInteger> nextAccountIndex() {
        Function function = new Function("nextAccountIndex", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> setPixelWarsCoinPrice(BigInteger newPrice) {
        Function function = new Function(
                "setPixelWarsCoinPrice", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(newPrice)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> withdrawalPixelWarsCoins(BigInteger pixelCount, BigInteger accountIndex) {
        Function function = new Function(
                "withdrawalPixelWarsCoins", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(pixelCount), 
                new org.web3j.abi.datatypes.generated.Uint256(accountIndex)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<BigInteger> getAccountIndexByAddress(String ownerAccount) {
        Function function = new Function("getAccountIndexByAddress", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(ownerAccount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>> getAccountInfoByIndex(BigInteger indexAccount) {
        final Function function = new Function("getAccountInfoByIndex", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(indexAccount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>(
                new Callable<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);;
                        return new Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (String) results.get(1).getValue(), 
                                (Boolean) results.get(2).getValue(), 
                                (BigInteger) results.get(3).getValue(), 
                                (Boolean) results.get(4).getValue(), 
                                (String) results.get(5).getValue(), 
                                (BigInteger) results.get(6).getValue());
                    }
                });
    }

    public RemoteCall<BigInteger> getAccountBalance() {
        Function function = new Function("getAccountBalance", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> pixelWarsCoinPrice() {
        Function function = new Function("pixelWarsCoinPrice", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<String> owner() {
        Function function = new Function("owner", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<TransactionReceipt> buyPixelWarsCoins(BigInteger weiValue) {
        Function function = new Function(
                "buyPixelWarsCoins", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<BigInteger> getAccountIndex() {
        Function function = new Function("getAccountIndex", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> accrualPixelWarsCoins(BigInteger pixelCount, BigInteger accountIndex) {
        Function function = new Function(
                "accrualPixelWarsCoins", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(pixelCount), 
                new org.web3j.abi.datatypes.generated.Uint256(accountIndex)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> owned() {
        Function function = new Function(
                "owned", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> deactivateAccount() {
        Function function = new Function(
                "deactivateAccount", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<TransactionReceipt> transferOwnership(String newOwner) {
        Function function = new Function(
                "transferOwnership", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(newOwner)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public static RemoteCall<CandyKillerAccount> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(CandyKillerAccount.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<CandyKillerAccount> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(CandyKillerAccount.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public static CandyKillerAccount load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new CandyKillerAccount(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    public static CandyKillerAccount load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new CandyKillerAccount(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static class CreateAccountEventResponse {
        public String _creator;

        public BigInteger _account;
    }

    public static class CreateCharacterEventResponse {
        public String _creator;

        public BigInteger _character;
    }

    public static class BuyPixelWarsCoinsEventResponse {
        public String _buyer;

        public BigInteger _coins;
    }

    public static class AccrualPixelWarsCoinsEventResponse {
        public String _executor;

        public BigInteger _pixelCount;

        public BigInteger _accountIndex;
    }

    public static class WithdrawalPixelWarsCoinsEventResponse {
        public String _executor;

        public BigInteger _pixelCount;

        public BigInteger _accountIndex;
    }
}
