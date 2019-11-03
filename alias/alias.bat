@ECHO OFF

:: elevate user privileges, if necessary
:: https://stackoverflow.com/a/24665214
NET FILE 1>NUL 2>NUL
IF ERRORLEVEL 1 (
    powershell "saps -filepath %0 %1 %2 -verb runas" >NUL 2>&1
    GOTO :EOF
)

:: https://superuser.com/a/489242
SET LINK_SOURCE=.\%~nx1
SET LINK_TARGET=%2

:: https://stackoverflow.com/a/830566
IF [%LINK_TARGET%]==[] GOTO :CHOOSE_LINK_TARGET
GOTO :HAS_LINK_TARGET

:CHOOSE_LINK_TARGET
    :: https://stackoverflow.com/a/17359650
    :: https://stackoverflow.com/a/8616822
    CHOICE /t 10 /c yn /d y /m "[!] link target unspecified; default to 'current'"
    IF ERRORLEVEL 1 (
        SET LINK_TARGET=current
    )
    IF [%LINK_TARGET%]==[] (
        :: https://superuser.com/a/1067812
        SET /P LINK_TARGET="[!] enter link target name: > "
    )
    IF [%LINK_TARGET%]==[] (
        ECHO ERROR: unspecified link target.
        GOTO :ERROR
    )

:HAS_LINK_TARGET
PUSHD %1
    :: https://stackoverflow.com/a/6817833
    IF ERRORLEVEL 1 (
        ECHO ERROR: invalid directory: %1
        GOTO :ERROR
    )
    ECHO entering: %CD%
    CD ..
    ECHO entering: %CD%
    ECHO linking: "%LINK_SOURCE%" to "%LINK_TARGET%"...
    RMDIR "%LINK_TARGET%"
    MKLINK /D "%LINK_TARGET%" "%LINK_SOURCE%"
    PAUSE
POPD

GOTO :EOF

:ERROR
PAUSE
