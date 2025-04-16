@echo off
:: lazy-webp.bat - WSL-aware launcher

where wsl >nul 2>&1
if %errorlevel%==0 (
    echo WSL detected.
    set /p CHOICE=Do you want to run the advanced Bash version? (Y/N): 
    if /I "%CHOICE%"=="Y" (
        wsl bash ./advanced-convert.sh
        exit /b
    )
)

echo Running basic Windows version...
call basic-convert.bat
