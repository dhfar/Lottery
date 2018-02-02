@ECHO off
SET filePath=%cd%
ECHO Clear old data
DEL /s /q "%filePath%\pixelwars\"
ECHO Compilation contracts
CALL solcjs ./contracts/PixelWars.sol ./contracts/Owned.sol --bin --abi --optimize -o ./pixelwars/ 
ECHO Rename binary file
FOR /f %%F IN ('DIR /b %filePath%\pixelwars\') do (
	ECHO %%F | findstr Owned.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\pixelwars\%%F "Owned.abi"
	)
	ECHO %%F | findstr Owned.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\pixelwars\%%F "Owned.bin"
	)	
	ECHO %%F | findstr PixelWars.abi > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\pixelwars\%%F "PixelWars.abi"
	)	
	ECHO %%F | findstr PixelWars.bin > NUL
	IF NOT ERRORLEVEL 1 (
		REN  %filePath%\pixelwars\%%F "PixelWars.bin"
	)
)
ECHO Create Java files
CALL %filePath%\java\bin\web3j solidity generate %filePath%\pixelwars\PixelWars.bin %filePath%\pixelwars\PixelWars.abi -o . -p org.dhfar
CALL %filePath%\java\bin\web3j solidity generate %filePath%\pixelwars\Owned.bin %filePath%\pixelwars\Owned.abi -o . -p org.dhfar
PAUSE