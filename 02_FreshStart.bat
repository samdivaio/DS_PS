@ECHO OFF
TITLE Starting...
SET "root=%~dp0"
CD /D "%root%"

ECHO Press any key to assemble the private server...
ECHO.
pause >nul

IF EXIST "%root%PS\" (
TITLE Deleting Private Server...
ECHO Removing Old PS Folder...
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

ROBOCOPY "%root%DanhengServer-Resources" "%root%PS\resources" /E /COPY:DAT
timeout /t 2 >nul

REM ROBOCOPY "%root%turnbasedgamedata" "%root%PS\resources" /E /COPY:DAT
REM timeout /t 2 >nul

REM ROBOCOPY "%root%DanhengServer-Resources\Config" "%root%PS\resources\Config" /E /COPY:DAT
REM timeout /t 2 >nul

REM ROBOCOPY "%root%DanhengServer-Resources\ExcelOutput" "%root%PS\resources\ExcelOutput" /E /COPY:DAT
REM timeout /t 2 >nul

ROBOCOPY "%root%DanhengServer-Public\Config" "%root%PS\Config" /E /COPY:DAT
timeout /t 2 >nul

COPY "%root%DanhengServer-Public\WebServer\certificate.p12" "%root%PS\certificate.p12"
timeout /t 2 >nul

IF EXIST "%root%PS\Config\Banners.json" (
TITLE Checking Banners.json
ECHO Renaming old Banners.json...
DEL Banners.json.old >nul 2>&1
REN "%root%PS\Config\Banners.json" Banners.json.old
)

ECHO Downloading New Banners.json (Thanks to @wfowicwjcwc)...

powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/samdivaio/DS_PS/refs/heads/main/Banners.json -OutFile '%root%PS\Config\Banners.json'"

IF EXIST "%root%PS_Old\Config\Database\danheng.db" (
TITLE Checking the old Database...
ECHO Making Database folder...
MKDIR "%root%PS\Config\Database"
ECHO Copying the old Database...
COPY "%root%PS_Old\Config\Database\danheng.db" "%root%PS\Config\Database\danheng.db"
)

IF EXIST "%root%PS_Old\config.json" (
REN "%root%PS\config.json" config.json.old
ECHO Copying the old config.json...
COPY "%root%PS_Old\config.json" "%root%PS\config.json"
)

ECHO.
TITLE Done.
ECHO PS is ready. Press any key to exit...
pause >nul
