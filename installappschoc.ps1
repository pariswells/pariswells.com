"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco install adobereader-update -y
choco install jre8 -y
choco install googlechrome -y
choco install office365proplus -y
choco install flashplayerplugin -y
choco install flashplayeractivex -y

@echo off

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

IF "%manufacturer%"=="Dell Inc." (
    choco install dellcommandupdate -y
)

IF "%manufacturer%"=="LENOVO" (
    choco install lenovo-thinkvantage-system-update -y
)
