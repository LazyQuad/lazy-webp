@echo off
cls
echo =============================================
echo       lazy-webp - Basic Batch Converter
echo =============================================

set "CWEBP=.\cwebp\cwebp.exe"

if not exist %CWEBP% (
    echo ❌ cwebp.exe not found in /cwebp/
    echo Please download it from:
    echo https://developers.google.com/speed/webp/download
    pause
    exit /b
)

echo Enter input folder (leave blank for current directory)
set /p INPUTDIR=
if "%INPUTDIR%"=="" set "INPUTDIR=."

echo Enter output folder (leave blank for same directory)
set /p OUTDIR=
if "%OUTDIR%"=="" set "OUTDIR=%INPUTDIR%"

if not exist "%OUTDIR%" (
    echo Output directory does not exist. Creating it...
    mkdir "%OUTDIR%"
)

echo Enter quality (0-100, default 80)
set /p QUALITY=
if "%QUALITY%"=="" set "QUALITY=80"

echo Strip metadata? ^(Y/N^)
set /p STRIP=

echo Batch rename ^[B^] or Manual prompt ^[M^]?
set /p MODE=

if /I "%MODE%"=="B" (
    echo Enter base filename ^(e.g. photo-name^)
    set /p BASENAME=
)

setlocal enabledelayedexpansion
set count=1

for %%f in ("%INPUTDIR%\*.jpg" "%INPUTDIR%\*.jpeg" "%INPUTDIR%\*.png") do (
    set "INPUT=%%f"
    cls
    echo Converting: %%~nxf

    if /I "!MODE!"=="B" (
        set "OUTPUT=!OUTDIR!\!BASENAME!-!count!.webp"
        echo Saving to: !OUTPUT!
        if /I "!STRIP!"=="Y" (
            call !CWEBP! -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call !CWEBP! -q !QUALITY! "%%f" -o "!OUTPUT!"
        )
        set /a count+=1
    ) else (
        echo Enter new name for this file ^(or type QUIT to exit^)
        set /p NEWNAME=
        if /I "!NEWNAME!"=="QUIT" goto :eof
        set "OUTPUT=!OUTDIR!\!NEWNAME!.webp"
        echo Saving to: !OUTPUT!
        if /I "!STRIP!"=="Y" (
            call !CWEBP! -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call !CWEBP! -q !QUALITY! "%%f" -o "!OUTPUT!"
        )
    )
)

endlocal
echo ✅ Conversion complete.
pause
