@ECHO OFF

:: set Atom package location (if unset, defaults to "\Users\<user>\.atom")
:: http://flight-manual.atom.io/getting-started/sections/installing-atom/#portable-mode
SET ATOM_HOME=%~dp0.atom

PUSHD %~dp0current

START atom.exe %*

POPD
