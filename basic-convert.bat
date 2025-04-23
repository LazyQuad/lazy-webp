@echo off
setlocal enabledelayedexpansion

rem lazy-webp - Basic Batch Converter v1.3.2 (patched input/output capture)

cls
echo =============================================
echo       lazy-webp - Basic Batch Converter
echo =============================================
echo.

rem Capture current working directory
set "CWD=%CD%"

rem Prompt for input folder
echo Enter input folder [default: !CWD!]
set /p USER_INPUTDIR=
if "!USER_INPUTDIR!"=="" (
    set "INPUTDIR=!CWD!"
) else (
    set "INPUTDIR=!USER_INPUTDIR!"
)

rem Prompt for output folder
echo Enter output folder [default: same as input folder]
set /p USER_OUTDIR=
if "!USER_OUTDIR!"=="" (
    set "OUTDIR=!INPUTDIR!"
) else (
    set "OUTDIR=!USER_OUTDIR!"
)

echo.
echo Input folder set to: !INPUTDIR!
echo Output folder set to: !OUTDIR!
echo.

if not exist "!OUTDIR!" (
    echo Output directory does not exist. Creating it...
    mkdir "!OUTDIR!"
)

rem Quality prompt
echo Enter quality [0-100, default: 80]
set /p QUALITY=
if "!QUALITY!"=="" set "QUALITY=80"

rem Strip metadata
echo Strip metadata? [Y/N, default: Y]
set /p STRIP=
if /I "!STRIP!"=="" set "STRIP=Y"

rem Choose mode
echo Batch convert and name [B] or Manual prompt [M] [default: B]
set /p MODE=
if "!MODE!"=="" set "MODE=B"

rem Base name if in batch mode
if /I "!MODE!"=="B" (
    echo Enter base filename [e.g. photo-name, default: lazy-webp]
    set /p BASENAME=
    if "!BASENAME!"=="" set "BASENAME=lazy-webp"
)

rem Check for cwebp
set "CWEBP=.\cwebp\cwebp.exe"
if not exist "%CWEBP%" (
    echo [!] cwebp.exe not found in cwebp\cwebp.exe
    echo Download from https://developers.google.com/speed/webp/download
    pause
    exit /b
)

set count=1

for %%f in ("!INPUTDIR!\*.jpg" "!INPUTDIR!\*.jpeg" "!INPUTDIR!\*.png") do (
    set "INPUT=%%f"
    cls
    echo Converting %%~nxf

    if /I "!MODE!"=="B" (
        set "OUTPUT=!OUTDIR!\!BASENAME!-!count!.webp"
        echo Saving to !OUTPUT!
        if /I "!STRIP!"=="Y" (
            call "%CWEBP%" -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call "%CWEBP%" -q !QUALITY! "%%f" -o "!OUTPUT!"
        )
        set /a count+=1
    ) else (
        echo Enter new name for this file [or type QUIT to exit]
        set /p NEWNAME=
        if /I "!NEWNAME!"=="QUIT" goto :eof
        if "!NEWNAME!"=="" (
            echo No name entered. Skipping...
        ) else (
            set "OUTPUT=!OUTDIR!\!NEWNAME!.webp"
            echo Saving to !OUTPUT!
            if /I "!STRIP!"=="Y" (
                call "%CWEBP%" -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
            ) else (
                call "%CWEBP%" -q !QUALITY! "%%f" -o "!OUTPUT!"
            )
        )
    )
)

endlocal
echo.
echo Conversion complete.
pause
