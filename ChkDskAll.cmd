:: BatchGotAdmin <https://sites.google.com/site/eneerge/scripts/batchgotadmin>
:-------------------------------------
@echo off

REM Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
    @echo on	
:--------------------------------------


:: WindowsVersionChecker (detect OS) <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@ECHO off
REM https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832.aspx
REM 10.0 -- Win 10, Win Server 2016 TP2
REM 6.4 -- Win 10 TP, Win Server 2016 TP1
REM 6.3 -- Win 8.1, Win Server 2012 R2
REM 6.2 -- Win 8, Win Server 2012
REM 6.1 -- Win 7, Win Server 2008 R2
REM 6.0 -- Win Vista, Win Server 2008
REM 5.2 -- Win Server 2003, Win Server 2003 R2, Win XP 64-Bit Edition
REM 5.1 -- Win XP
REM 5.0 -- Win 2000

FOR /f "tokens=4,5,6 delims=[]. " %%a IN ('ver') DO (
	SET WVer=%%a.%%b.%%c
	SET WMajor=%%a
	SET WMinor=%%b
	SET WRev=%%c
)
:--------------------------------------


:: ScanDisk All::PrintInfo <v.arribas.urjc@gmail.com> (c) 2015 BSD-Clause 3
:--------------------------------------
@echo off
echo.
echo == ScanDisk All ==
echo   (C) 2014-2015 "<v.arribas.urjc@gmail.com>" BSD-Clause 3
echo.
echo   This program will run CHKDSK on all drives in an unattended manner.
echo   CHKDSK will be done in a two-steps way for safer execution.
@rem echo   The computer will be shutdown after finishing, but can be aborted by pressing enter.
echo   Supports:
echo     * NTFS
echo     * FAT32
echo     * New generation CKHDSK commands (/scan /perf ...)
echo     * Special treatment of SYSTEM drive (C: as default).
echo       - Includes "sfc.exe /scannow" for check system files integrity.
echo.
timeout 1 > nul
:--------------------------------------


:: ScanDisk All <v.arribas.urjc@gmail.com (c) 2014-2015 BSD-Clause 3>
:--------------------------------------
@echo off

REM check Win8+ capabilities (requires WindowsVersionChecker)
if 62 LEQ %WMajor%%WMinor% (set CHKDSK_NG=1) else (set CHKDSK_NG=0)
if %CHKDSK_NG% == 1 (echo New chkdsk capabilities are enabled.)

REM ^, -- ^ is the escape character for declarations  between '
for /f "skip=1 tokens=1,2 delims= " %%a in ('wmic.exe logicaldisk get caption^,filesystem') do (
	start "Launching ScanDisk for drive %%a" /BELOWNORMAL cmd.exe /C ScanDisk.cmd %%a %%b & timeout.exe /T 2 /NOBREAK >nul
)
:--------------------------------------