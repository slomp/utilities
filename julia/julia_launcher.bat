:: Copyright (C) 2019 Marcos Slomp - All Rights Reserved
:: You may use, distribute and modify this code under the
:: terms of the MIT license.

@ECHO OFF

::SET JULIAVERSION=1.0.0
SET JULIAVERSION=current

SET JULIAPATH=%~dp0%JULIAVERSION%
SET JULIA_PKGDIR=%~dp0%packages

:: Depot: new concept introduced by Julia 1.0.0
:: JULIA_PKGDIR is now obsolete...
SET JULIA_DEPOT_PATH=%~dp0%depot

TITLE Julia [bat]
"%JULIAPATH%\bin\julia.exe" %*

:: note the %* above to allow external programs to pass arguments to julia via this batch file as well
