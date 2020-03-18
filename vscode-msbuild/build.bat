@ECHO OFF

:: retrieve and cache the Visual Studio environment
IF NOT EXIST "%~dp0env-after.txt" (
    SET > %~dp0env-before.txt
    CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvars64.bat"
    SET > %~dp0env-after.txt
)

:: apply cached Visual Studio environment
FOR /F "usebackq tokens=*" %%A IN ("%~dp0env-after.txt") DO SET %%A

msbuild "<Solution.sln>" /property:Configuration=Release /property:Platform=x64 /maxcpucount:4
