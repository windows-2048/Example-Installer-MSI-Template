@echo off
pushd "%~dp0"
cd /D "%~dp0"

echo CD=%CD%



set PATHMSVC2019=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.29.30133\bin\HostX64\x64;C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\bin\Roslyn;C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\devinit;C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\\MSBuild\Current\Bin;C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools
set PATHMSVCEXTR=C:\Users\test\AppData\Local\Programs\Python\Python311;C:\Program Files\CMake\bin

set PATH=.;%PATHMSVC2019%;%PATHMSVCEXTR%;C:\Program Files\WinRAR;C:\OpenSSL-Win32\bin;%systemroot%\System32;%systemroot%;%systemroot%\System32\Wbem
echo PATH=%PATH%



mkdir build
cd build\

cmake -G "Visual Studio 16 2019" ..

MSBuild.exe NewInstallerTemplateMSI.sln ^
    /p:Configuration=Release ^
    /p:Platform=x64 ^
    /t:Installer_TFMCfW:Rebuild ^
    /m:4 ^
    /verbosity:normal

if %ERRORLEVEL% NEQ 0 (
    echo Build failed with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
) else (
    echo Build succeeded
)

cd ..



popd

pause
