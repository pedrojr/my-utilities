@echo off
title Uninstall Android Studio

:: Check running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as administrator...
) else (
    echo Please run this file as an administrator.
    pause
    exit /b
)

:: Run Android Studio uninstall
set key=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Android Studio
set value=UninstallString
for /f "tokens=2*" %%a in ('reg query "%key%" /v %value% ^| find "%value%"') do (
    set UninstallPath=%%b
)
if exist "%UninstallPath%" (
    echo Uninstalling Android Studio...
    start "Uninstall Android Studio" "%UninstallPath%"
    :: Wait while the uninstaller completes
    :WAIT
    tasklist | find /i "Au_.exe" >nul
    if %errorlevel% equ 0 goto WAIT
) else (
    echo The uninstall.exe file was not found.
    pause
    exit /b
)

echo The uninstaller has closed.
pause

:: Delete additional folders and files
setlocal enabledelayedexpansion
set "USER_NAME=%USERNAME%"
set "AndroidPath=C:\Program Files\Android"
set "AndroidMenu=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio"
set "UserAppData=C:\Users\!USER_NAME!\AppData"

echo Deleting additional folders and files...

:: Delete folders
if exist "!AndroidPath!" (
    rmdir /s /q "!AndroidPath!"
)
if exist "!AndroidMenu!" (
    rmdir /s /q "!AndroidMenu!"
)

:: Delete folders starting with "Android" in the AppData folders
for /d %%A in ("!UserAppData!\Local\Google\Android*") do (
    rmdir /s /q "%%A"
)
for /d %%B in ("!UserAppData!\Roaming\Google\Android*") do (
    rmdir /s /q "%%B"
)

:: Delete files in the Temp folder
echo Deleting files in the Temp folder...
del /q /s "!UserAppData!\Local\Temp\*.*"

echo Completed.
pause
