:: Copyright (C) 2019 Marcos Slomp - All Rights Reserved
:: You may use, distribute and modify this code under the
:: terms of the MIT license.

@ECHO OFF

SET UPXBIN=%~dp0upx.exe

"%UPXBIN%" -9 -v --best --ultra-brute *.exe *.dll

for /r /d %%x in (*) do (
PUSHD "%%x"
"%UPXBIN%" -9 -v --best --ultra-brute *.exe *.dll
POPD
)

PAUSE