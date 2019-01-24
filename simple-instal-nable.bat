@echo off

title Installing N-able Remote Monitoring Software

SET        "programFiles=c:\program files (x86)"

IF NOT EXIST "%programFiles%\N-Able Technologies\Windows Agent\bin\agent.exe" ( GOTO INSTALL ) else ( GOTO AlreadyInstalled )

GOTO: END

:INSTALL

echo %notInstalled%

"\\location\of\file\324WindowsAgentSetup.exe" /quiet

GOTO END 

:AlreadyInstalled

echo %AlreadyInstalled%

GOTO END

:END

pause
