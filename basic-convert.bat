@echo off
setlocal enabledelayedexpansion

cls
echo =============================================
echo       lazy-webp - Basic Batch Converter
echo =============================================
echo.

echo Checking for 'cwebp' folder...
if not exist ".\cwebp" (
    echo Creating cwebp folder...
    mkdir ".\cwebp"
) else (
    echo cwebp folder exists.
)

rem Check if cwebp\bin\cwebp.exe exists
if exist ".\cwebp\bin\cwebp.exe" (
    echo Detected  cwebp\bin\cwebp.exe
    echo.
    echo Moving cwebp.exe to the correct location - cwebp\cwebp.exe
    move /Y ".\cwebp\bin\cwebp.exe" ".\cwebp\cwebp.exe" >nul
    echo Move complete.
    echo.

    if exist ".\cwebp\cwebp.exe" (
        set /p DELETEBIN=Delete the cwebp\bin\ folder and its contents (Y/N)  
        if /I "!DELETEBIN!"=="Y" (
            echo Deleting cwebp\bin\ folder...
            rmdir /S /Q ".\cwebp\bin"
            echo Folder deleted.
        ) else (
            echo Bin folder was not deleted. You can remove it manually later if you prefer.
        )
    ) 

set "CWEBP=.\cwebp\cwebp.exe"

if not exist "!CWEBP!" (
    echo [!] cwebp.exe not found in cwebp\cwebp.exe
    echo.
    echo Download WebP utilities for Windows from
    echo https://developers.google.com/speed/webp/download
    echo.
    echo After downloading
    echo   - Unzip the archive
    echo   - Locate cwebp.exe inside the "bin" folder
    echo   - Place it here  cwebp\cwebp.exe
    echo.
    pause
    exit /b
) else (
    echo cwebp.exe found. Good to go
)
echo.
echo ---------------------------------------------
echo.
echo Enter input folder (leave blank for current directory)
set /p INPUTDIR=
if "!INPUTDIR!"=="" set "INPUTDIR=."

echo Enter output folder (leave blank for same directory)
set /p OUTDIR=
if "!OUTDIR!"=="" set "OUTDIR=!INPUTDIR!"

if not exist "!OUTDIR!" (
    echo Output directory does not exist. Creating it...
    mkdir "!OUTDIR!"
)

echo Enter quality (0-100, default 80)
set /p QUALITY=
if "!QUALITY!"=="" set "QUALITY=80"

echo Strip metadata? ^(Y/N^)
set /p STRIP=

echo Batch rename ^[B^] or Manual prompt ^[M^]?
set /p MODE=

if /I "!MODE!"=="B" (
    echo Enter base filename ^(e.g. photo-name^)
    set /p BASENAME=
)

set count=1

for %%f in ("!INPUTDIR!\*.jpg" "!INPUTDIR!\*.jpeg" "!INPUTDIR!\*.png") do (
    set "INPUT=%%f"
    cls
    echo Converting %%~nxf

    if /I "!MODE!"=="B" (
        set "OUTPUT=!OUTDIR!\!BASENAME!-!count!.webp"
        echo Saving to  !OUTPUT!
        if /I "!STRIP!"=="Y" (
            call "!CWEBP!" -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call "!CWEBP!" -q !QUALITY! "%%f" -o "!OUTPUT!"
        )
        set /a count+=1
    ) else (
        echo Enter new name for this file ^(or type QUIT to exit^)
        set /p NEWNAME=
        if /I "!NEWNAME!"=="QUIT" goto :eof
        set "OUTPUT=!OUTDIR!\!NEWNAME!.webp"
        echo Saving to  !OUTPUT!
        if /I "!STRIP!"=="Y" (
            call "!CWEBP!" -q !QUALITY! -metadata none "%%f" -o "!OUTPUT!"
        ) else (
            call "!CWEBP!" -q !QUALITY! "%%f" -o "!OUTPUT!"
        )
    )
)

endlocal
echo Conversion complete.
pause
