@echo off
rem ====================================================================
rem 🏛️ AVIS CORE V4 - MSVC ENVIRONMENT CONFIGURATION & VERIFICATION MATRIX
rem OPERATING SYSTEM: WINDOWS 11 WIN64 Target
rem HARDWARE BASELINE: 4-Core i5 / 16GB DDR4 RAM
rem DIRECTIVE DIRECT: Strict absolute path execution only — No 'cd' operations allowed
rem ====================================================================

echo ⚙️  [INITIALIZER] Verifying local architectural paths...

rem 1. Locate the default MSVC Community/Professional installation roots
set "MSVC_ENV_64=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
if not exist "%MSVC_ENV_64%" (
    set "MSVC_ENV_64=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
)

rem 2. Enforce safety check if compiler tools are missing
if not exist "%MSVC_ENV_64%" (
    echo 🚨 [CRITICAL_ERROR] MSVC Win64 build environment initialization utility not found.
    exit /b 1
)

echo 🛡️  [ENVIRONMENT] Initializing MSVC Win64 compiler variables inside localized subshell context...
rem Calling environment hooks inside a nesting block prevents changing the host shell context path
cmd /c """%MSVC_ENV_64%"" && cl.exe /?" >nul 2>&1
if %errorlevel% neq 0 (
    echo 🚨 [CRITICAL_ERROR] Failed to map the MSVC runtime compilation environment parameters.
    exit /b 1
)
echo 💎 [SUCCESS] MSVC Environment successfully mapped to active execution frame.

echo 🔬 [AUDIT] Running compilation checks on pure C-header maps...

rem 3. Execute strict syntax and boundary verification using absolute path structures
rem /c = Compile only (no link) | /W4 = Maximum warnings | /std:c11 = Strict standard rules
set "CC_FLAGS=/c /W4 /std:c11 /O2"

echo 💥 [COMPILING] Checking AVIS-DATALAKE schema interface...
cmd /c """%MSVC_ENV_64%"" && cl.exe %CC_FLAGS% /Fo:"%~dp0datalake_check.obj" "%~dp0..\..\..\AVIS-DATALAKE\include\avis_lake_core.h""
if %errorlevel% neq 0 echo 🚨 [FAIL] AVIS-DATALAKE path boundaries mismatched. & exit /b 1

echo 💥 [COMPILING] Checking robo-knight-inventory asset discovery api...
cmd /c """%MSVC_ENV_64%"" && cl.exe %CC_FLAGS% /Fo:"%~dp0inventory_check.obj" "%~dp0..\..\..\robo-knight-inventory\include\avis_inventory_core.h""
if %errorlevel% neq 0 echo 🚨 [FAIL] robo-knight-inventory memory limits mismatched. & exit /b 1

echo 💥 [COMPILING] Checking NEXUS interpretation boundary interfaces...
cmd /c """%MSVC_ENV_64%"" && cl.exe %CC_FLAGS% /Fo:"%~dp0nexus_check.obj" "%~dp0..\..\..\NEXUS\include\nexus_compiler.h""
if %errorlevel% neq 0 echo 🚨 [FAIL] NEXUS compiler graph mismatched. & exit /b 1

echo 💥 [COMPILING] Checking Cyborg unzipping runtime integration layer...
cmd /c """%MSVC_ENV_64%"" && cl.exe %CC_FLAGS% /Fo:"%~dp0cyborg_check.obj" "%~dp0..\..\..\Cyborg\include\cyborg_engine.h""
if %errorlevel% neq 0 echo 🚨 [FAIL] Cyborg decompression boundaries mismatched. & exit /b 1

echo 💥 [COMPILING] Checking Sentinel monitoring gateway trace interfaces...
cmd /c """%MSVC_ENV_64%"" && cl.exe %CC_FLAGS% /Fo:"%~dp0sentinel_check.obj" "%~dp0..\..\..\Sentinel\include\sentinel_trace.h""
if %errorlevel% neq 0 echo 🚨 [FAIL] Sentinel telemetry mappings mismatched. & exit /b 1

echo ✨ [PIPELINE_COMPLETE] All 5 multi-repository C-header maps verified successfully under Windows 11 MSVC.
exit /b 0
