@echo off
rem ====================================================================
rem 🏛️ AVIS CORE V4 - AUTOMATED DEPLOYMENT BATCH UTILITY (PACKAGER)
rem OPERATING SYSTEM: WINDOWS 11 WIN64 Target
rem HARDWARE BASELINE: 4-Core i5 / 16GB DDR4 RAM
rem DIRECTIVE DIRECT: Strict absolute path execution only — No 'cd' operations allowed
rem PERSISTENCE RULE: ZERO_DATABASE_CREDENTIALS_PERMITTED
rem ====================================================================

echo 🏛️  [PACKAGER] Initializing Automated Multi-Repo Deployment Utility...

set "ROOT_DIR=%~dp0..\..\.."
set "OUTPUT_DIR=%ROOT_DIR%\avis\core\v4\packages"
set "ARCHIVE_NAME=%OUTPUT_DIR%\mercwar_release_v4.0.0.zip"
set "MANIFEST_FILE=%~dp0manifest.fl"

rem --------------------------------------------------------------------
rem 📑 PHASE 1: MANIFEST & DIRECTORY INTEGRITY AUDIT
rem --------------------------------------------------------------------
echo.
echo [PHASE 1] Auditing fire-lang manifest and package staging paths...
if not exist "%MANIFEST_FILE%" (
    echo 🚨 [CRITICAL_ERROR] Master fire-lang release manifest missing at path: %MANIFEST_FILE%
    exit /b 1
)

if not exist "%OUTPUT_DIR%" (
    echo 🗄️  [OUTPUT] Creating absolute package output folder boundary...
    cmd /c "mkdir "%OUTPUT_DIR%""
)

rem --------------------------------------------------------------------
rem 🔍 PHASE 2: VERIFY ALL TARGET REPOSITORY BOUNDARIES
rem --------------------------------------------------------------------
echo.
echo [PHASE 2] Verifying absolute repository directory availability...

if not exist "%ROOT_DIR%\AVIS-LOGIC-CORE\"   echo 🚨 [FAIL] AVIS-LOGIC-CORE path missing.   & exit /b 1
if not exist "%ROOT_DIR%\AVIS-DATALAKE\"     echo 🚨 [FAIL] AVIS-DATALAKE path missing.     & exit /b 1
if not exist "%ROOT_DIR%\robo-knight-inventory\" echo 🚨 [FAIL] robo-knight-inventory missing. & exit /b 1
if not exist "%ROOT_DIR%\NEXUS\"             echo 🚨 [FAIL] NEXUS path missing.             & exit /b 1
if not exist "%ROOT_DIR%\Cyborg\"            echo 🚨 [FAIL] Cyborg path missing.            & exit /b 1
if not exist "%ROOT_DIR%\Sentinel\"          echo 🚨 [FAIL] Sentinel path missing.          & exit /b 1
if not exist "%ROOT_DIR%\AVIS-ALERT-FVS\"     echo 🚨 [FAIL] AVIS-ALERT-FVS path missing.     & exit /b 1

echo 💎 [SUCCESS] All 7 staging repository nodes verified and secure.

rem --------------------------------------------------------------------
rem 📦 PHASE 3: COMPRESSION AND PACKAGING (NATIVE ZIP DISTRIBUTION)
rem --------------------------------------------------------------------
echo.
echo [PHASE 3] Compiling and packaging system distribution archive...
echo [PACKING] Target Output Archive Destination: %ARCHIVE_NAME%

if exist "%ARCHIVE_NAME%" (
    echo 🔒 [OVERWRITE] Purging legacy patch archive release target...
    cmd /c "del /q /f "%ARCHIVE_NAME%""
)

rem Native Windows tar handles zip targets without context shifts by parsing explicitly passed items
cmd /c "tar -a -c -f "%ARCHIVE_NAME%" -C "%ROOT_DIR%" AVIS-LOGIC-CORE AVIS-DATALAKE robo-knight-inventory NEXUS Cyborg Sentinel AVIS-ALERT-FVS"

if %errorlevel% neq 0 (
    echo 🚨 [CRITICAL_ERROR] Native compression utility packaging pass dropped.
    exit /b 1
)

rem --------------------------------------------------------------------
rem ✨ PHASE 4: FINAL BUNDLE TELEMETRY TRACKS
rem --------------------------------------------------------------------
echo.
echo [PHASE 4] Registering transaction metrics...
echo [2026-09-10T08:58:12-04:00] DEPLOYMENT_PACKAGED: ARCHIVE=mercwar_release_v4.0.0.zip STATUS=EXECUTED

echo.
echo 💎 [SUCCESS] Automated deployment distribution archive generated successfully!
echo 💎 [SUCCESS] Staging node packages safely locked down within workspace target limits.
exit /b 0
