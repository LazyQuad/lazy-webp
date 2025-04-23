@echo off
setlocal

rem lazy-webp launcher - v1.3.2 by LazyQuad

echo ===============================
echo     lazy-webp by LazyQuad
echo ===============================
echo.

rem Check for override flags
if /I "%~1"=="--bash" goto run_bash
if /I "%~1"=="--basic" goto run_basic

rem Auto-detect WSL
where bash.exe >nul 2>nul
if %errorlevel%==0 (
    echo [✓] Detected WSL
    goto run_bash
) else (
    echo [!] WSL not detected
    goto run_basic
)

:run_bash
echo Launching advanced Bash version...
timeout /t 1 >nul
bash ./advanced-convert.sh
goto end

:run_basic
echo Launching basic Windows batch converter...
timeout /t 1 >nul
call basic-convert.bat
goto end

:end
endlocal
