:: WindowsVersionChecker (detect OS) <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@echo off
@rem DEBUG echo on
setlocal enabledelayedexpansion

rem https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832.aspx
rem 10.0 -- Win 10, Win Server 2016 TP2
rem 6.4 -- Win 10 TP, Win Server 2016 TP1
rem 6.3 -- Win 8.1, Win Server 2012 R2
rem 6.2 -- Win 8, Win Server 2012
rem 6.1 -- Win 7, Win Server 2008 R2
rem 6.0 -- Win Vista, Win Server 2008
rem 5.2 -- Win Server 2003, Win Server 2003 R2, Win XP 64-Bit Edition
rem 5.1 -- Win XP
rem 5.0 -- Win 2000

FOR /f "tokens=4,5,6 delims=[]. " %%a IN ('ver') DO (
	SET WVer=%%a.%%b.%%c
	SET WMajor=%%a
	SET WMinor=%%b
	SET WRev=%%c
)
rem check Win8+ capabilities (requires WindowsVersionChecker)
set CHKDSK_NG=0
if 62 LEQ %WMajor%%WMinor% (set CHKDSK_NG=1)

:--------------------------------------
@echo off
echo.
echo Running ScanDisk on %2 drive %1
timeout.exe /T 1 /NOBREAK >nul

echo.
echo ________________________________________
if "%1" == "%systemdrive%" (
	if %CHKDSK_NG% == 1 (
		echo ### Read-Only ScanDisk of System Drive %1
		chkdsk.exe /scan /perf /forceofflinefix %1
		timeout.exe /T 1 /NOBREAK >nul
		start "Running System File Checker on System Drive %1" /ABOVENORMAL sfc.exe /scannow
		timeout.exe /T 10 /NOBREAK >nul
	) else (
		echo Set ### System Drive %1 as dirty to force boot-scandisk scan
		fsutil.exe dirty set %1
	)
) else if "%2" == "NTFS" (
	echo ### Two-steps ScanDisk of %2 drive %1
	if %CHKDSK_NG% == 1 (
		rem http://www.minasi.com/newsletters/nws1305.htm (chkdsk Win 8+ features)
		chkdsk.exe /scan /perf /forceofflinefix %1
		timeout.exe /T 1 /NOBREAK >nul
		chkdsk.exe /X /offlinescanandfix %1
		timeout.exe /T 1 /NOBREAK >nul
	) else (
		rem Old scan (backward compatibility <Win 8)
		chkdsk.exe /F /X %1
		timeout.exe /T 1 /NOBREAK >nul
		chkdsk.exe /F /X /R /B %1
		timeout.exe /T 1 /NOBREAK >nul
	)
) else if "%2" == "FAT32" (
	echo ### Two-steps ScanDisk of %2 drive %1
	chkdsk.exe /F /X %1
	timeout.exe /T 1 /NOBREAK >nul
	chkdsk.exe /F /X /R %1
	timeout.exe /T 1 /NOBREAK >nul
) else if "%2" == "RAW" (
	echo ### Skipping ScanDisk of %2 drive %1
	timeout.exe /T 1 /NOBREAK >nul
)
:--------------------------------------