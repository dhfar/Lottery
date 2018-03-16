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
    private static final String BINARY = "606060405260018055612710600255341561001957600080fd5b60008054600160a060020a033316600160a060020a0319909116179055610cfd806100456000396000f3006060604052600436106100f05763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416631928928781146100f55780631b9e16ad1461019a578063220565de1461025d57806331c3f3131461027057806349d64c5f1461029a578063544e5b96146102b357806360e505c5146102d25780636896fabf146102e85780637ddbb5b7146102fb578063892d0f6e1461030e5780638da5cb5b1461032d578063aebc95591461035c578063b0e8319b14610364578063bfe4b20b14610377578063df32754b14610390578063e040e9a0146103a5578063f2fde38b146103b8575b600080fd5b341561010057600080fd5b61018860046024813581810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284378201915050505050509190803590602001908201803590602001908080601f0160208091040260200160405190810160405281815292919060208401838380828437509496506103d795505050505050565b60405190815260200160405180910390f35b34156101a557600080fd5b6101ad6105bd565b6040518781528515156040820152606081018590528315156080820152600160a060020a03831660a082015260c0810182905260e06020820181815290820188818151815260200191508051906020019080838360005b8381101561021c578082015183820152602001610204565b50505050905090810190601f1680156102495780820380516001836020036101000a031916815260200191505b509850505050505050505060405180910390f35b341561026857600080fd5b610188610607565b341561027b57600080fd5b61028660043561060d565b604051901515815260200160405180910390f35b34156102a557600080fd5b610286600435602435610647565b34156102be57600080fd5b610188600160a060020a0360043516610752565b34156102dd57600080fd5b6101ad60043561076d565b34156102f357600080fd5b610188610931565b341561030657600080fd5b610188610951565b341561031957600080fd5b610286600160a060020a0360043516610957565b341561033857600080fd5b6103406109a0565b604051600160a060020a03909116815260200160405180910390f35b6102866109af565b341561036f57600080fd5b610188610a65565b341561038257600080fd5b610286600435602435610a75565b341561039b57600080fd5b6103a3610b42565b005b34156103b057600080fd5b610286610b6c565b34156103c357600080fd5b6103a3600160a060020a0360043516610b9d565b60006103e1610be7565b600160a060020a03331660009081526003602052604090206005015460ff161561040e57600091506105b6565b6001548152602081018490526002836040518082805190602001908083835b6020831061044c5780518252601f19909201916020918201910161042d565b6001836020036101000a0380198251168184511680821785525050505050509050019150506020604051808303816000865af1151561048a57600080fd5b5050604051805160408084019190915260016060840181905260006080850181905260a0850191909152600160a060020a0333168152600360205220829150815181556020820151816001019080516104e7929160200190610c2b565b5060408201516002820155606082015160038201805460ff19169115159190911790556080820151816004015560a082015160058201805460ff191691151591909117905560c08201516006909101555060018054600090815260046020526040908190208054600160a060020a03331673ffffffffffffffffffffffffffffffffffffffff19909116811790915591547f85841522199c696c3d4a549fea06732153559ded5db5cf6dfa3bb099827f2c84915190815260200160405180910390a26001805480820190915591505b5092915050565b60006105c7610ca5565b600160a060020a03331660009081526003602052604081205481908190819081906105f19061076d565b959d949c50929a50909850965094509092509050565b60015481565b6000805433600160a060020a0390811691161461062957600080fd5b6000821161063957506000610642565b50600281905560015b919050565b6000805433600160a060020a0390811691161461066357600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff16151561069c5750600061074c565b600082815260046020818152604080842054600160a060020a03168452600390915290912001548390106106fc57600082815260046020818152604080842054600160a060020a0316845260039091529091200180548490039055610704565b50600061074c565b33600160a060020a03167f5ccb25e760b69813d714bbbfa3ef14f68a90e2e90047e39cd05e8107a2b70d22848460405191825260208201526040908101905180910390a25060015b92915050565b600160a060020a031660009081526003602052604090205490565b6000610777610ca5565b6000806000806000610787610be7565b60005433600160a060020a03908116911614806107be575060008981526004602052604090205433600160a060020a039081169116145b1561092557600089815260046020908152604080832054600160a060020a031683526003909152908190209060e09051908101604052908160008201548152602001600182018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156108985780601f1061086d57610100808354040283529160200191610898565b820191906000526020600020905b81548152906001019060200180831161087b57829003601f168201915b505050918352505060028201546020820152600382015460ff90811615156040830152600483015460608301526005830154161515608082015260069091015460a090910152905080518160200151826060015183608001518460a0015160008e815260046020526040902054600160a060020a031660c087015185955097509750975097509750975097505b50919395979092949650565b600160a060020a0333166000908152600360205260409020600401545b90565b60025481565b600160a060020a03811660009081526003602052604081206005015460ff16801561074c575050600160a060020a03166000908152600360208190526040909120015460ff1690565b600054600160a060020a031681565b600160a060020a033316600090815260036020526040812060050154819060ff1615156109df5760009150610a61565b600034116109f05760009150610a61565b600254348115156109fd57fe5b600160a060020a033316600081815260036020526040908190206004018054949093049384019092559192507f641df157745b52d6599a00a7e22851dbd6e9d1b2defbb2ba611e493a8565c0ab9083905190815260200160405180910390a2600191505b5090565b6000610a7033610752565b905090565b6000805433600160a060020a03908116911614610a9157600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff161515610aca5750600061074c565b600082815260046020818152604080842054600160a060020a0390811685526003909252928390209091018054860190553316907feca2c485d4cfe01cd0328975f29768cb4f365cd63ceb7daf14cc9e64fa696d2e90859085905191825260208201526040908101905180910390a250600192915050565b6000805473ffffffffffffffffffffffffffffffffffffffff191633600160a060020a0316179055565b600160a060020a033316600090815260036020819052604090912001805460ff19811660ff90911615179055600190565b60005433600160a060020a03908116911614610bb857600080fd5b6000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b60e06040519081016040528060008152602001610c02610ca5565b815260006020820181905260408201819052606082018190526080820181905260a09091015290565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10610c6c57805160ff1916838001178555610c99565b82800160010185558215610c99579182015b82811115610c99578251825591602001919060010190610c7e565b50610a61929150610cb7565b60206040519081016040526000815290565b61094e91905b80821115610a615760008155600101610cbd5600a165627a7a72305820198c5412c531fc08330d7e7ff127e31248b6c0594c1bd4a4d1ba5ec326a28deb0029";

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

    public RemoteCall<Boolean> isCreateAndActive(String userAddress) {
        Function function = new Function("isCreateAndActive", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(userAddress)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
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
