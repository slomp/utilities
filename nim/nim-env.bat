:: Copyright (C) 2019 Marcos Slomp - All Rights Reserved
:: You may use, distribute and modify this code under the
:: terms of the MIT license.

@IF DEFINED NIM_VERSION GOTO :EOF
:: ^^^ alternatively, one could use "where nim" instead...

@SET NIM_VERSION=current
@SET PATH=%~dp0%NIM_VERSION%\bin;%PATH%
