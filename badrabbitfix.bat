IF NOT EXIST "%SYSTEMROOT%\CSCC.dat" ( echo “” > %SYSTEMROOT%\CSCC.dat ) 
IF NOT EXIST "%SYSTEMROOT%\INFPUB.dat" ( echo “” > %SYSTEMROOT%\INFPUB.dat ) 
icacls "%SYSTEMROOT%\CSCC.dat" /inheritance:r /grant:r Administrators:(OI)(CI)F 
icacls "%SYSTEMROOT%\CSCC.dat" /inheritance:r /remove:g USERS 
icacls "%SYSTEMROOT%\CSCC.dat" /inheritance:r /remove:g SYSTEM 
icacls "%SYSTEMROOT%\INFPUB.dat" /inheritance:r /grant:r Administrators:(OI)(CI)F 
icacls "%SYSTEMROOT%\INFPUB.dat" /inheritance:r /remove:g USERS 
icacls "%SYSTEMROOT%\INFPUB.dat" /inheritance:r /remove:g SYSTEM
