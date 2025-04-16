@echo off
echo lazy-webp Basic Windows Batch Script
echo.
echo Converting all PNG and JPG images in this folder to WebP format...

set "CWEBP=.\cwebp\cwebp.exe"
if not exist %CWEBP% (
    echo cwebp.exe not found in /cwebp/
    echo Download it from https://developers.google.com/speed/webp/download
    pause
    exit /b
)

setlocal enabledelayedexpansion
set count=1
for %%f in (*.jpg *.jpeg *.png) do (
    echo Converting: %%f
    %CWEBP% -q 80 "%%f" -o "webp-!count!.webp"
    set /a count+=1
)
echo Done!
pause
