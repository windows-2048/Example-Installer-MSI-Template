@echo off
pushd "%~dp0"
cd /D "%~dp0"

echo CD=%CD%



set PATHMSVCEXTR=C:\Users\test\AppData\Local\Programs\Python\Python311

set PATH=.;%PATHMSVCEXTR%;%systemroot%\System32;%systemroot%;%systemroot%\System32\Wbem
echo PATH=%PATH%



python _template_generation.py ..\NewInstallerTemplateMSI _configMSI.yml



popd

pause
