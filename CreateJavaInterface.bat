@ECHO off
SET filePath=%cd%
ECHO Clear old data
DEL /s /q "%filePath%\candykiller\"
ECHO Compilation contracts
CALL solcjs ./contracts/CandyKillerAccount.sol ./contracts/Owned.sol --bin --abi --optimize -o ./candykiller/ 
ECHO Rename binary file
FOR /f %%F IN ('DIR /b %filePath%\candykiller\') do (
	ECHO %%F | findstr Owned.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "Owned.abi"
	)
	ECHO %%F | findstr Owned.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "Owned.bin"
	)	
	ECHO %%F | findstr CandyKillerAccount.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "CandyKillerAccount.abi"
	)	
	ECHO %%F | findstr CandyKillerAccount.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\candykiller\%%F "CandyKillerAccount.bin"
	)
)
ECHO Create Java files
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\CandyKillerAccount.bin %filePath%\candykiller\CandyKillerAccount.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\candykiller\Owned.bin %filePath%\candykiller\Owned.abi -o . -p org.dhfar
PAUSE