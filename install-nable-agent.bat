@echo off

cls

REM WindowsAgentSetup.exe can be downloaded from N-able by Manual Add Device

xcopy /y /e \\%pathtonableinstaller%\137WindowsAgentSetup.exe c:\Temp\137WindowsAgentSetup.exe*

title Installing N-able Remote Monitoring Software



SET	"server=%nableserverAddress%"

REM Can be found by going to the root of your N-able , Administration Tab on the Left then Customer

SET	"customerID=%CUSTOMERID%"

SET	"installerLocation=c:\Temp"

SET	"alreadyInstalled=The N-able Agent is already installed"

SET	"notInstalled=The N-able Agent is not yet installed, installing it now..."

SET	"programFiles=c:\program files"



REM       Check to see if its x86 or x64

IF %PROCESSOR_ARCHITECTURE% EQU  AMD64 ( SET "programFiles=%programFiles% (x86)" )



REM Debug Information

echo %server%

echo %customerID%

echo %installerLocation%

echo %programFiles%



IF NOT EXIST "%programFiles%\N-Able Technologies\Windows Agent\bin\agent.exe" ( GOTO INSTALL ) else ( GOTO AlreadyInstalled )

GOTO: END



:INSTALL

echo %notInstalled%

%installerLocation%\137WindowsAgentSetup.exe /s /v" /qn CUSTOMERID=%customerID% CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=%server% SERVERPORT=443"

GOTO END



:AlreadyInstalled

echo %AlreadyInstalled%

GOTO END



:END

