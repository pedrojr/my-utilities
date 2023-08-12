@echo off
setlocal enabledelayedexpansion

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo This script must be run as Administrator.
    echo Exiting...
    pause
    exit
)

set /p memory=Enter memory value (e.g., 8GB): 
set /p processors=Enter number of processors: 

if "!memory!"=="" (
    echo Memory value cannot be empty.
    pause
    exit
)

if "!processors!"=="" (
    echo Number of processors cannot be empty.
    pause
    exit
)

(
    echo [wsl2]
    echo memory=!memory!
    echo processors=!processors!
) > "%USERPROFILE%\.wslconfig"

powershell.exe -Command "Restart-Service LxssManager"

echo Configuration applied successfully.
pause
