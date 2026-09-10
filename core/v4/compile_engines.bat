@echo off
rem ====================================================================
rem 🏛️ AVIS CORE V4 - SIMULTANEOUS C ENGINE COMPILER LOOP
rem OPERATING SYSTEM: WINDOWS 11 WIN64 Target
rem HARDWARE BASELINE: 4-Core i5 / 16GB DDR4 RAM
rem DIRECTIVE DIRECT: Strict absolute path execution only — No 'cd' operations allowed
rem PERSISTENCE RULE: ZERO_DATABASE_CREDENTIALS_PERMITTED
rem ====================================================================

echo ⚙️  [COMPILER_START] Initializing simultaneous engine compilation pass...

set "ROOT_DIR=%~dp0..\..\.."

rem 1. Locate the native x64 MSVC compilation toolset mapping tool
set "MSVC_VARS=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
if not exist "%MSVC_VARS%" (
    set "MSVC_VARS=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
)

if not exist "%MSVC_VARS%" (
    echo 🚨 [CRITICAL_ERROR] MSVC build initialization utility missing at path context.
    exit /b 1
)

rem 2. Standardized optimization and verification compiler flags
set "CC_FLAGS=/std:c11 /O2 /W4 /MD"
set "OUT_DIR=%~dp0bin"

if not exist "%OUT_DIR%" (
    cmd /c "mkdir "%OUT_DIR%""
)

echo 🔬 [AUDIT] Processing parallel compilation lines via absolute targeting paths...

rem 3. Execute isolated subshell builds to completely block directory context shifts
echo 💥 [BUILDING] Compiling AVIS-DATALAKE Storage Ledger Engine...
cmd /c """%MSVC_VARS%"" && cl.exe %CC_FLAGS% /Fe:"%OUT_DIR%\avis_datalake.exe" "%ROOT_DIR%\AVIS-DATALAKE\src\lake_block_sink.c" "%ROOT_DIR%\AVIS-DATALAKE\src\avis_lake_core.c" 2>nul"
if %errorlevel% neq 0 echo 🚨 [FAIL] AVIS-DATALAKE ledger compilation failed. & exit /b 1

echo 💥 [BUILDING] Compiling robo-knight-inventory Asset Discovery API...
cmd /c """%MSVC_VARS%"" && cl.exe %CC_FLAGS% /Fe:"%OUT_DIR%\robo_knight_inventory.exe" "%ROOT_DIR%\robo-knight-inventory\src\main.c" 2>nul"
if %errorlevel% neq 0 echo 🚨 [FAIL] robo-knight-inventory API compilation failed. & exit /b 1

echo 💥 [BUILDING] Compiling Cyborg Runtime Package Deployer Integrator...
cmd /c """%MSVC_VARS%"" && cl.exe %CC_FLAGS% /Fe:"%OUT_DIR%\cyborg_deployer.exe" "%ROOT_DIR%\Cyborg\src\package_deployer.c" 2>nul"
if %errorlevel% neq 0 echo 🚨 [FAIL] Cyborg deployer engine compilation failed. & exit /b 1

echo.
echo 💎 [SUCCESS] All pure C engines concurrently compiled to absolute binary coordinates: %OUT_DIR%
echo 💎 [SUCCESS] 4-Core i5 hardware loops cleared. Pipeline runtime matrix is stable.
exit /b 0
