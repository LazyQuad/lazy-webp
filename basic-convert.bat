@echo off
setlocal enabledelayedexpansion

rem lazy-webp - Basic Batch Converter v1.4 

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
    echo Creating output directory...
    mkdir "!OUTDIR!"
)

rem Quality prompt
echo Enter quality [0-100, default: 80]
set /p QUALITY=
if "!QUALITY!"=="" set "QUALITY=80"

rem Resize image to largest or longest side.
set "DEFAULT_RESIZE=1920"
echo.
echo Resize images by longest side
echo Enter max pixels for the longest side [!DEFAULT_RESIZE!]
echo Type 0 to skip resizing
set /p RESIZE_INPUT=
if "!RESIZE_INPUT!"=="" set "RESIZE_INPUT=!DEFAULT_RESIZE!"

for /f "delims=0123456789" %%A in ("!RESIZE_INPUT!") do set "RESIZE_INPUT=!DEFAULT_RESIZE!"

if "!RESIZE_INPUT!"=="0" (
    set "RESIZE_LONGEST="
) else (
    set "RESIZE_LONGEST=!RESIZE_INPUT!"
)

rem Strip metadata
echo Strip metadata [Y/N, default: Y]
set /p STRIP=
if "!STRIP!"=="" set "STRIP=Y"

echo Batch convert and name [B] or Manual [M] [default B]
set /p MODE=
if "!MODE!"=="" set "MODE=B"

REM ===== Naming logic =====
if /I "!MODE!"=="B" (
    echo Enter base filename [leave blank to keep original names]
    set /p BASENAME=

    if defined BASENAME (
        REM sanitize
        set "BASENAME=!BASENAME: =-!"
    )
)

REM ===== Locate tools =====
set "CWEBP=.\cwebp\cwebp.exe"
if not exist "%CWEBP%" (
    echo cwebp.exe not found
    pause
    exit /b
)

set "MAGICK_EXE="
set "MAGICK_PATH=.\magick\magick.exe"
if exist "%MAGICK_PATH%" (
    set "MAGICK_EXE=%MAGICK_PATH%"
) else (
    for %%I in (magick.exe) do set "MAGICK_EXE=%%~$PATH:I"
)

set "count=1"

REM ===== MAIN LOOP =====
for %%f in ("!INPUTDIR!\*.jpg" "!INPUTDIR!\*.jpeg" "!INPUTDIR!\*.png") do (
    if exist "%%~f" (

        echo.
        echo Processing %%~nxf

        set "INPUT_FOR_CWEBP=%%f"
        set "TMP_RESIZED="

        REM Resize safely (no upscaling)
        if not "!RESIZE_LONGEST!"=="" (
            if exist "!MAGICK_EXE!" (
                set "TMP_RESIZED=%TEMP%\lazywebp_!RANDOM!.png"
                "%MAGICK_EXE%" "%%f" -resize !RESIZE_LONGEST!x!RESIZE_LONGEST!^> -strip "!TMP_RESIZED!"
                if exist "!TMP_RESIZED!" (
                    set "INPUT_FOR_CWEBP=!TMP_RESIZED!"
                )
            ) else (
                set "CWEBP_EXTRA_ARGS=-resize !RESIZE_LONGEST! 0"
            )
        )

        REM ===== OUTPUT NAME LOGIC =====
        if defined BASENAME (
            set "OUTPUT=!OUTDIR!\!BASENAME!-!count!.webp"
            set /a count+=1
        ) else (
            REM Default = original filename
            set "OUTPUT=!OUTDIR!\%%~nf.webp"

            REM Prevent overwrite
            if exist "!OUTPUT!" (
                set "OUTPUT=!OUTDIR!\%%~nf-!count!.webp"
                set /a count+=1
            )
        )

        echo Saving to !OUTPUT!

        REM Encode
        if /I "!STRIP!"=="Y" (
            call "%CWEBP%" !CWEBP_EXTRA_ARGS! -q !QUALITY! -metadata none "!INPUT_FOR_CWEBP!" -o "!OUTPUT!"
        ) else (
            call "%CWEBP%" !CWEBP_EXTRA_ARGS! -q !QUALITY! "!INPUT_FOR_CWEBP!" -o "!OUTPUT!"
        )

        REM Cleanup
        if defined TMP_RESIZED if exist "!TMP_RESIZED!" del /q "!TMP_RESIZED!"
        set "TMP_RESIZED="
        set "INPUT_FOR_CWEBP="
        set "CWEBP_EXTRA_ARGS="
    )
)

echo.
echo Conversion complete
pause