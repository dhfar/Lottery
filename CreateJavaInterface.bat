@ECHO off
SET filePath=%cd%
ECHO Clear old data
DEL /s /q "%filePath%\candykiller\"
ECHO Compilation contracts
CALL solcjs ./contracts/CKServiceContract.sol ./contracts/CandyKillerColony.sol ./contracts/CandyKillerCharacter.sol ./contracts/CandyKillerAccount.sol ./contracts/CKCharacterMarketPlace.sol ./contracts/CKCharacterItem.sol ./contracts/CKCharacterItemMarketPlace.sol ./contracts/Owned.sol --bin --abi --optimize -o ./candykiller/
ECHO Rename binary file
FOR /f %%F IN ('DIR /b %filePath%\candykiller\') do (
	ECHO %%F | findstr __contracts_Owned_sol_Owned.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "Owned.abi"
	)
	ECHO %%F | findstr __contracts_Owned_sol_Owned.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "Owned.bin"
	)	
	ECHO %%F | findstr __contracts_CandyKillerAccount_sol_CandyKillerAccount.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "CandyKillerAccount.abi"
	)	
	ECHO %%F | findstr __contracts_CandyKillerAccount_sol_CandyKillerAccount.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "CandyKillerAccount.bin"
	)
	ECHO %%F | findstr __contracts_CandyKillerCharacter_sol_CandyKillerCharacter.abi > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CandyKillerCharacter.abi"
    )
    ECHO %%F | findstr __contracts_CandyKillerCharacter_sol_CandyKillerCharacter.bin > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CandyKillerCharacter.bin"
    )
    ECHO %%F | findstr __contracts_CandyKillerColony_sol_CandyKillerColony.abi > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CandyKillerColony.abi"
    )
    ECHO %%F | findstr __contracts_CandyKillerColony_sol_CandyKillerColony.bin > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CandyKillerColony.bin"
    )
    ECHO %%F | findstr __contracts_CKServiceContract_sol_CKServiceContract.abi > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CKServiceContract.abi"
    )
    ECHO %%F | findstr __contracts_CKServiceContract_sol_CKServiceContract.bin > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CKServiceContract.bin"
    )
	ECHO %%F | findstr __contracts_CKCharacterMarketPlace_sol_CKCharacterMarketPlace.abi > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CKCharacterMarketPlace.abi"
    )
    ECHO %%F | findstr __contracts_CKCharacterMarketPlace_sol_CKCharacterMarketPlace.bin > NUL
    IF NOT ERRORLEVEL 1 (
    	REN  %filePath%\candykiller\%%F "CKCharacterMarketPlace.bin"
    )

    ECHO %%F | findstr __contracts_CKCharacterItem_sol_CKCharacterItem.abi > NUL
    IF NOT ERRORLEVEL 1 (
        REN  %filePath%\candykiller\%%F "CKCharacterItem.abi"
    )
    ECHO %%F | findstr __contracts_CKCharacterItem_sol_CKCharacterItem.bin > NUL
    IF NOT ERRORLEVEL 1 (
        REN  %filePath%\candykiller\%%F "CKCharacterItem.bin"
    )

    ECHO %%F | findstr __contracts_CKCharacterItemMarketPlace_sol_CKCharacterItemMarketPlace.abi > NUL
    IF NOT ERRORLEVEL 1 (
        REN  %filePath%\candykiller\%%F "CKCharacterItemMarketPlace.abi"
    )
    ECHO %%F | findstr __contracts_CKCharacterItemMarketPlace_sol_CKCharacterItemMarketPlace.bin > NUL
    IF NOT ERRORLEVEL 1 (
         REN  %filePath%\candykiller\%%F "CKCharacterItemMarketPlace.bin"
    )
)
ECHO Create Java files
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CandyKillerAccount.bin %filePath%\candykiller\CandyKillerAccount.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CandyKillerCharacter.bin %filePath%\candykiller\CandyKillerCharacter.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CandyKillerColony.bin %filePath%\candykiller\CandyKillerColony.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CKServiceContract.bin %filePath%\candykiller\CKServiceContract.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CKCharacterMarketPlace.bin %filePath%\candykiller\CKCharacterMarketPlace.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CKCharacterItem.bin %filePath%\candykiller\CKCharacterItem.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CKCharacterItemMarketPlace.bin %filePath%\candykiller\CKCharacterItemMarketPlace.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\Owned.bin %filePath%\candykiller\Owned.abi -o . -p org.dhfar
PAUSE