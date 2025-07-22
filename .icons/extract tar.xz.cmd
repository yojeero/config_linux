
@echo off
REM Extract .tar from .tar.xz
"C:\Program Files\7-Zip\7z.exe" e "*.tar.xz" -ooutput

REM Extract contents of .tar into folder
for %%f in (output\*.tar) do (
    "C:\Program Files\7-Zip\7z.exe" x "%%f" -ooutput\extracted
)