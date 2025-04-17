@echo off
cls
echo ===============================
echo Welcome to lazy-webp by LazyQuad
echo ===============================
echo.
echo Which version would you like to run?
echo [Y] Advanced Bash (for WSL/Linux users)
echo [N] Basic Windows Batch (recommended for most users)
set /p CHOICE=Your choice (Y/N)? 

where wsl >nul 2>&1
if %errorlevel%==0 (
    if /I "%CHOICE%"=="Y" (
        echo Launching advanced Bash version...
        wsl bash ./advanced-convert.sh
        exit /b
    )
)

echo Running basic Windows version...
call basic-convert.bat
