:: Copyright (C) 2019 Marcos Slomp - All Rights Reserved
:: You may use, distribute and modify this code under the
:: terms of the MIT license.

@ECHO OFF

IF not exist "%~dp0codeblocks.exe" ( CALL :ERROR "%~dp0codeblocks.exe" && GOTO :EOF )

SET MINGW32=%~dp0..\MSYS2\mingw32
IF not exist "%MINGW32%" ( CALL :ERROR "%MINGW32%" && GOTO :EOF )

SET MINGW64=%~dp0..\MSYS2\mingw64
IF not exist "%MINGW64%" ( CALL :ERROR "%MINGW64%" && GOTO :EOF )

::SET PATH=%PATH%;%MINGWBINPATH%
START "<no-title>" "%~dp0codeblocks.exe" --user-data-dir="%~dp0_portable" %*
GOTO :EOF



:ERROR
ECHO ERROR: file or location not found: %~1
PAUSE
GOTO :EOF
