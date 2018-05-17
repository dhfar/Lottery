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
 * <p>Generated with web3j version 3.4.0.
 */
public class CandyKillerAccount extends Contract {
    private static final String BINARY = "60806040526001805561271060025534801561001a57600080fd5b5060008054600160a060020a033316600160a060020a0319918216811790911617905561113e8061004c6000396000f30060806040526004361061013d5763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416630fe1881a811461014257806313f58fd11461017a578063192892871461019d5780631b9e16ad14610246578063220565de1461030e57806331c3f3131461032357806349d64c5f1461033b578063531460cc14610356578063544e5b961461037757806360e505c5146103985780636896fabf146103b057806368ba75fc146103c55780637ddbb5b7146103e6578063892d0f6e146103fb5780638da5cb5b1461041c578063aebc95591461044d578063b0e8319b14610455578063b3588d111461046a578063b9c8c4491461048b578063bfe4b20b1461049f578063e040e9a0146104ba578063ece9de62146104cf578063f2fde38b146104f3578063f3f4370314610514575b600080fd5b34801561014e57600080fd5b50610166600160a060020a0360043516602435610535565b604080519115158252519081900360200190f35b34801561018657600080fd5b5061019b600160a060020a0360043516610598565b005b3480156101a957600080fd5b506040805160206004803580820135601f810184900484028501840190955284845261023494369492936024939284019190819084018382808284375050604080516020601f89358b018035918201839004830284018301909452808352979a9998810197919650918201945092508291508401838280828437509497506105f49650505050505050565b60408051918252519081900360200190f35b34801561025257600080fd5b5061025b6107f7565b6040805188815286151591810191909152606081018590528315156080820152600160a060020a03831660a082015260c0810182905260e0602080830182815289519284019290925288516101008401918a019080838360005b838110156102cd5781810151838201526020016102b5565b50505050905090810190601f1680156102fa5780820380516001836020036101000a031916815260200191505b509850505050505050505060405180910390f35b34801561031a57600080fd5b5061023461083c565b34801561032f57600080fd5b50610166600435610842565b34801561034757600080fd5b5061016660043560243561087c565b34801561036257600080fd5b50610234600160a060020a036004351661098a565b34801561038357600080fd5b50610234600160a060020a03600435166109a8565b3480156103a457600080fd5b5061025b6004356109c3565b3480156103bc57600080fd5b50610234610b9f565b3480156103d157600080fd5b5061019b600160a060020a0360043516610bbf565b3480156103f257600080fd5b50610234610c1c565b34801561040757600080fd5b50610166600160a060020a0360043516610c22565b34801561042857600080fd5b50610431610c6b565b60408051600160a060020a039092168252519081900360200190f35b610166610c7a565b34801561046157600080fd5b50610234610d37565b34801561047657600080fd5b5061019b600160a060020a0360043516610d47565b610166600160a060020a0360043516610da4565b3480156104ab57600080fd5b50610166600435602435610e2a565b3480156104c657600080fd5b50610166610ef6565b3480156104db57600080fd5b50610166600160a060020a0360043516602435610f55565b3480156104ff57600080fd5b5061019b600160a060020a0360043516610fe3565b34801561052057600080fd5b50610234600160a060020a036004351661102d565b60075460009033600160a060020a0390811691161461055657506000610592565b61055f83610c22565b151561056d57506000610592565b50600160a060020a038216600090815260036020526040902060060180548201905560015b92915050565b60005433600160a060020a039081169116146105b357600080fd5b600160a060020a03811615156105c8576105f1565b6006805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b50565b60006105fe61103f565b600160a060020a03331660009081526003602052604090206005015460ff161561062b57600091506107f0565b60015481526020808201859052604051845160029286929182918401908083835b6020831061066b5780518252601f19909201916020918201910161064c565b51815160209384036101000a600019018019909216911617905260405191909301945091925050808303816000865af11580156106ac573d6000803e3d6000fd5b5050506040513d60208110156106c157600080fd5b505160408083019190915260016060830181905260006080840181905260a08401829052600160a060020a033316815260036020908152929020835181558383015180518594929361071893908501920190611084565b506040828101516002830155606083015160038301805491151560ff19928316179055608084015160048085019190915560a0850151600585018054911515919093161790915560c09093015160069092019190915560018054600090815260209384528290208054600160a060020a03331673ffffffffffffffffffffffffffffffffffffffff199091168117909155905482519182529281019290925280517f85841522199c696c3d4a549fea06732153559ded5db5cf6dfa3bb099827f2c849281900390910190a16001805480820190915591505b5092915050565b600160a060020a03331660009081526003602052604081205460609082908190819081908190610826906109c3565b959d949c50929a50909850965094509092509050565b60015481565b6000805433600160a060020a0390811691161461085e57600080fd5b6000821161086e57506000610877565b50600281905560015b919050565b6000805433600160a060020a0390811691161461089857600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff1615156108d157506000610592565b600082815260046020818152604080842054600160a060020a0316845260039091529091200154831161093057600082815260046020818152604080842054600160a060020a0316845260039091529091200180548490039055610938565b506000610592565b60408051600160a060020a03331681526020810185905280820184905290517f5ccb25e760b69813d714bbbfa3ef14f68a90e2e90047e39cd05e8107a2b70d229181900360600190a150600192915050565b600160a060020a031660009081526003602052604090206006015490565b600160a060020a031660009081526003602052604090205490565b6000606060008060008060006109d761103f565b60005433600160a060020a0390811691161480610a0e575060008981526004602052604090205433600160a060020a039081169116145b15610b9357600089815260046020908152604080832054600160a060020a031683526003825291829020825160e08101845281548152600180830180548651600261010094831615949094026000190190911692909204601f8101869004860283018601909652858252919492938581019391929190830182828015610ad55780601f10610aaa57610100808354040283529160200191610ad5565b820191906000526020600020905b815481529060010190602001808311610ab857829003601f168201915b505050505081526020016002820154600019166000191681526020016003820160009054906101000a900460ff16151515158152602001600482015481526020016005820160009054906101000a900460ff16151515158152602001600682015481525050905080600001518160200151826060015183608001518460a00151600460008f815260200190815260200160002060009054906101000a9004600160a060020a03168660c0015185955097509750975097509750975097505b50919395979092949650565b600160a060020a0333166000908152600360205260409020600401545b90565b60005433600160a060020a03908116911614610bda57600080fd5b600160a060020a0381161515610bef576105f1565b60088054600160a060020a03831673ffffffffffffffffffffffffffffffffffffffff1990911617905550565b60025481565b600160a060020a03811660009081526003602052604081206005015460ff168015610592575050600160a060020a03166000908152600360208190526040909120015460ff1690565b600054600160a060020a031681565b600160a060020a033316600090815260036020526040812060050154819060ff161515610caa5760009150610d33565b60003411610cbb5760009150610d33565b60025434811515610cc857fe5b600160a060020a033316600081815260036020908152604091829020600401805495909404948501909355805191825291810183905281519293507f641df157745b52d6599a00a7e22851dbd6e9d1b2defbb2ba611e493a8565c0ab929081900390910190a1600191505b5090565b6000610d42336109a8565b905090565b60005433600160a060020a03908116911614610d6257600080fd5b600160a060020a0381161515610d77576105f1565b60078054600160a060020a03831673ffffffffffffffffffffffffffffffffffffffff1990911617905550565b60065460009033600160a060020a039081169116141580610dd4575060085433600160a060020a03908116911614155b15610de157506000610877565b341515610df057506000610877565b610df982610c22565b1515610e0757506000610877565b50600160a060020a03166000908152600560205260409020805434019055600190565b6000805433600160a060020a03908116911614610e4657600080fd5b600082815260046020908152604080832054600160a060020a03168352600390915290206005015460ff161515610e7f57506000610592565b600082815260046020818152604080842054600160a060020a039081168552600383529381902090920180548701905581513390931683528201859052818101849052517feca2c485d4cfe01cd0328975f29768cb4f365cd63ceb7daf14cc9e64fa696d2e9181900360600190a150600192915050565b600160a060020a03331660009081526003602052604081206005015460ff161515610f2357506000610bbc565b50600160a060020a033316600090815260036020819052604090912001805460ff19811660ff90911615179055600190565b60075460009033600160a060020a03908116911614610f7657506000610592565b610f7f83610c22565b1515610f8d57506000610592565b600160a060020a038316600090815260036020526040902060060154821115610fb857506000610592565b50600160a060020a038216600090815260036020526040902060060180548290039055600192915050565b60005433600160a060020a03908116911614610ffe57600080fd5b6000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0392909216919091179055565b60056020526000908152604090205481565b60e06040519081016040528060008152602001606081526020016000801916815260200160001515815260200160008152602001600015158152602001600081525090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106110c557805160ff19168380011785556110f2565b828001600101855582156110f2579182015b828111156110f25782518255916020019190600101906110d7565b50610d3392610bbc9250905b80821115610d3357600081556001016110fe5600a165627a7a72305820057e83804d1c5fb9dd1a36a5b2cb5b365ae17b3b276f1b2c798411fd3aa419fb0029";

    public static final String FUNC_ACCRUEFREEEXPERIENCECOIN = "accrueFreeExperienceCoin";

    public static final String FUNC_SETCOLONYMARKETPLACE = "setColonyMarketPlace";

    public static final String FUNC_CREATEACCOUNT = "createAccount";

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

    public RemoteCall<TransactionReceipt> createAccount(String userEmail, String userPassword) {
        final Function function = new Function(
                FUNC_CREATEACCOUNT, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Utf8String(userEmail), 
                new org.web3j.abi.datatypes.Utf8String(userPassword)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>> getAccountInfo() {
        final Function function = new Function(FUNC_GETACCOUNTINFO, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>(
                new Callable<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
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

    public RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>> getAccountInfoByIndex(BigInteger indexAccount) {
        final Function function = new Function(FUNC_GETACCOUNTINFOBYINDEX, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(indexAccount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}, new TypeReference<Bool>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Address>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>(
                new Callable<Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger>>() {
                    @Override
                    public Tuple7<BigInteger, String, Boolean, BigInteger, Boolean, String, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
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
