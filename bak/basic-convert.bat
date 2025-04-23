@echo off
setlocal enabledelayedexpansion

rem lazy-webp - Basic Batch Converter v1.2

cls
echo =============================================
echo       lazy-webp - Basic Batch Converter
echo =============================================
echo.

rem Handle optional command-line args
set "INPUTDIR=%~1"
set "OUTDIR=%~2"
set "QUALITY=%~3"
set "MODE=%~4"
set "BASENAME=%~5"

if "%INPUTDIR%"=="" (
    echo Enter input folder (default is current folder)
    set /p INPUTDIR=
    if "%INPUTDIR%"=="" set "INPUTDIR=."
)

if "%OUTDIR%"=="" (
    echo Enter output folder (default is same as input folder)
    set /p OUTDIR=
    if "%OUTDIR%"=="" set "OUTDIR=%INPUTDIR%"
)

if not exist "%OUTDIR%" (
    echo Output directory does not exist. Creating it...
    mkdir "%OUTDIR%"
)

if "%QUALITY%"=="" (
    echo Enter quality ^(0-100, default is 80^)
    set /p QUALITY=
    if "%QUALITY%"=="" set "QUALITY=80"
)

echo Strip metadata? ^(Y/N, default is N^)
set /p STRIP=
if /I "%STRIP%"=="" set "STRIP=N"

if "%MODE%"=="" (
    echo Batch rename ^[B^] or Manual prompt ^[M^]?
    set /p MODE=
)

if /I "%MODE%"=="B" if "%BASENAME%"=="" (
    echo Enter base filename ^(e.g. photo-name, default is lazy-webp^)
    set /p BASENAME=
    if "%BASENAME%"=="" set "BASENAME=lazy-webp"
)

set "CWEBP=.\cwebp\cwebp.exe"
if not exist "%CWEBP%" (
    echo [!] cwebp.exe not found in cwebp\cwebp.exe
    echo.
    echo Download WebP utilities for Windows from 
    echo https://developers.google.com/speed/webp/download
    echo.
    echo After downloading:
    echo   - Unzip the archive
    echo   - Locate cwebp.exe inside the "bin" folder
    echo   - Place it here: cwebp\cwebp.exe
    echo.
    pause
    exit /b
)

set count=1

for %%f in ("%INPUTDIR%\*.jpg" "%INPUTDIR%\*.jpeg" "%INPUTDIR%\*.png") do (
    set "INPUT=%%f"
    cls
    echo Converting %%~nxf

    if /I "!MODE!"=="B" (
        set "OUTPUT=%OUTDIR%\%BASENAME%-!count!.webp"
        echo Saving to !OUTPUT!
        if /I "%STRIP%"=="Y" (
            call "%CWEBP%" -q %QUALITY% -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call "%CWEBP%" -q %QUALITY% "%%f" -o "!OUTPUT!"
        )
        set /a count+=1
    ) else (
        echo Enter new name for this file ^(or type QUIT to exit^)
        set /p NEWNAME=
        if /I "!NEWNAME!"=="QUIT" goto :eof
        if "!NEWNAME!"=="" (
            echo No name entered. Skipping...
        ) else (
            set "OUTPUT=%OUTDIR%\!NEWNAME!.webp"
            echo Saving to !OUTPUT!
            if /I "%STRIP%"=="Y" (
                call "%CWEBP%" -q %QUALITY% -metadata none "%%f" -o "!OUTPUT!"
            ) else (
                call "%CWEBP%" -q %QUALITY% "%%f" -o "!OUTPUT!"
            )
        )
    )
)

endlocal
echo.
echo Conversion complete.
pause
