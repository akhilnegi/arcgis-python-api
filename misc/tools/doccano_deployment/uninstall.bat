@echo off
SET DIR_=%~dp0
for /f "delims=" %%i in ('powershell -file  %DIR_%elevated_prompt_check.ps1') do set admin=%%i

if  %admin%==0 (
    echo "Need to run this installation as an administrator"  
    pause
    exit)
set hr=%time:~0,2%
set hr=%hr: =0%
set LOGFILE=C:\doccano\logs\uninstall_log_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%hr%%time:~3,2%%time:~6,2%.txt
call :LOG 2> %LOGFILE%
exit /B

:LOG

net stop doccano /Y
nssm remove doccano confirm
::uninstall doccano
call refresh_path.bat
%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%DIR_%uninstall.ps1' %*" -Verb RunAs
%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%DIR_%uninstall_chocolatey.ps1' %*" -Verb RunAs
cd %DIR_%
del /f /s /q C:/doccano/ 1>nul
call rmdir /Q /S C:/doccano/
del /f /s /q C:/doccano/venv 1>nul
call rmdir /Q /S "C:/doccano/venv"
echo "Uninstalled"
