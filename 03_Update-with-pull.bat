@ECHO OFF
TITLE Checking for update...
SET "root=%~dp0"
CD /D "%root%"

dir /b /a:d "%root%*"

for /f "tokens=*" %%G in ('dir /b /a:d "%root%*"') do (cd %root%\%%G
ECHO.
cd
ECHO --------
ECHO.

git pull)

pause