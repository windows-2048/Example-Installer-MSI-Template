@echo off
pushd "%~dp0"
cd /D "%~dp0"

echo CD=%CD%



set PATHMSVC2019={{ MSVC_ROOT }}\{{ MSVC_CL_SUBDIR }};{{ MSVC_ROOT }}\MSBuild\Current\bin\Roslyn;{{ MSVC_ROOT }}\Common7\Tools\devinit;{{ MSVC_ROOT }}\\MSBuild\Current\Bin;{{ MSVC_ROOT }}\Common7\Tools
set PATHMSVCEXTR={{ PYTHON_ROOT }};{{ CMAKE_ROOT }}

set PATH=.;%PATHMSVC2019%;%PATHMSVCEXTR%;C:\Program Files\WinRAR;C:\OpenSSL-Win32\bin;%systemroot%\System32;%systemroot%;%systemroot%\System32\Wbem
echo PATH=%PATH%



mkdir build
cd build\

cmake -G "{{ MSVC }}" ..

MSBuild.exe NewInstallerTemplateMSI.sln ^
    /p:Configuration=Release ^
    /p:Platform=x64 ^
    /t:Installer_{{ CNM }}:Rebuild ^
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
