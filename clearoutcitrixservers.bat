@echo off
REM -
REM Readme
REM First For Clears Out Logged on Sessions
REM Second For Clears Out Disconnected Sessions
REM Change %rdporcitrixservername% to your server name
REM Change %rdporcitrixservername1% to your second server name
REM -
echo Clearing out your Logged on Sessions Please Wait
qwinsta /server:%rdporcitrixservername% | findstr %username% > %temp%\rdplogout.txt

for /F "delims= " %%A in (%temp%\rdplogout.txt) do (
      echo %%A
      rwinsta %%A /server:%rdporcitrixservername%
)
for /F "tokens=2" %%A in (%temp%\rdplogout.txt) do (
      echo %%A
      rwinsta %%A /server:%rdporcitrixservername%
)

qwinsta /server:%rdporcitrixservername1% | findstr %username% >> %temp%\rdplogout.txt

for /F "delims= " %%A in (%temp%\rdplogout.txt) do (
      echo %%A
      rwinsta %%A /server:%rdporcitrixservername1%
)
for /F "tokens=2" %%A in (%temp%\rdplogout.txt) do (
      echo %%A
      rwinsta %%A /server:%rdporcitrixservername1%
)

del /f %temp%\rdplogout.txt
