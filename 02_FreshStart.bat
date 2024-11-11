@ECHO OFF
TITLE Starting...
SET "root=%~dp0"
CD /D "%root%"

ECHO Press any key to delete the private server...
pause >nul

TITLE Deleting Private Server...
IF EXIST "%root%PS\" (
ECHO Removing Old Folder...
RMDIR "%root%PS_Old\" /S /Q >nul 2>&1
ECHO Renaming existing PS folder to PS_Old...
REN "%root%PS" PS_Old
)

TITLE Checking release.zip
IF EXIST "%root%release.zip" (DEL "%root%release_old.zip"
REN "%root%release.zip" release_old.zip
ECHO release file already exists.
ECHO renamed release file to release_old.
) ELSE (ECHO release_old.zip doesn't exist...)

ECHO.
ECHO Press any key to download the latest release...
pause >nul
TITLE Downloading release.zip
powershell -Command "Invoke-WebRequest https://github.com/EggLinks/DanhengServer-Public/releases/latest/download/win-x64-self-contained.zip -OutFile '%root%release.zip'"
ECHO.
ECHO Downloaded the latest release.
TITLE Downloaded release.zip
ECHO Press any key to continue extraction...
pause >nul 2>&1
ECHO.
ECHO Extracting files...
TITLE Extracting release.zip

IF EXIST "%root%release.zip" (powershell -Command "Expand-Archive -Path '.\release.zip' -DestinationPath '.' -Force") ELSE (ECHO release.zip not found.)
ECHO.
REN "%root%win-x64-self-contained" PS
ECHO release file extracted to new PS folder.
pause

TITLE Checking resources folder...
timeout /t 2 >nul

IF EXIST "%root%PS\resources" (
ECHO resources folder exists.
) ELSE (
ECHO resources folder doesn't exists.
MKDIR "%root%PS\resources"
)
ECHO.
timeout /t 2 >nul
TITLE Copying Files...

ROBOCOPY %root%turnbasedgamedata %root%PS\resources\ /E /COPY:DAT
timeout /t 2 >nul

ROBOCOPY %root%DanhengServer-Resources\Config %root%PS\resources\Config\ /E /COPY:DAT
timeout /t 2 >nul

ROBOCOPY %root%DanhengServer-Resources\ExcelOutput %root%PS\resources\ExcelOutput\ /E /COPY:DAT
timeout /t 2 >nul

ROBOCOPY %root%DanhengServer-Public\Config %root%PS\Config\ /E /COPY:DAT
timeout /t 2 >nul

COPY "%root%DanhengServer-Public\WebServer\certificate.p12" "%root%PS\certificate.p12"
timeout /t 2 >nul

ECHO.
TITLE Done.
pause
