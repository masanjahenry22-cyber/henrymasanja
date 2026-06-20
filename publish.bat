@echo off
REM ============================================================
REM  publish.bat  -  one-click website publisher
REM  Double-click this file to push your latest changes live.
REM  Your site updates at https://henrymasanja.com in ~1 minute.
REM ============================================================
cd /d "%~dp0"

echo.
echo  Publishing website to henrymasanja.com ...
echo.

git add -A
git commit -m "update site"
git push

echo.
echo  ============================================================
echo   Done. Changes are live at https://henrymasanja.com shortly.
echo  ============================================================
echo.
pause
