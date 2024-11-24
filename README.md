# DS_PS
Educational Purposes Only

## Requirements
- [Git for Windows](<https://gitforwindows.org/>)
- [Fiddler Classic](https://www.telerik.com/fiddler)

> [!NOTE]
> Make sure `git` is added to the PATH while installation. 

## Usage

### **(1/3)** 
Make a folder wherever you want and [download the below script](https://github.com/samdivaio/DS_PS/blob/main/01_Clone.bat)[^1] to it and use the downloaded batch script file to clone the repos if you don't wanna type them manually:

```bat
@ECHO OFF
TITLE Cloning...
SET "root=%~dp0"
CD /D "%root%"

ECHO Press any key to start cloning...
pause >nul

git clone https://gitlab.com/Dimbreath/turnbasedgamedata.git

git clone https://github.com/EggLinks/DanhengServer-Resources.git

git clone https://github.com/EggLinks/DanhengServer-Public.git

pause
```

### **(2/3)** 
[Download](https://github.com/samdivaio/DS_PS/blob/main/02_FreshStart.bat)[^1] and use the below script in the same folder as before to get the server assembled: 

```bat
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

IF EXIST "%root%PS\Config\Banners.json" (
TITLE Checking Banners.json
ECHO Renaming old Banners.json...
DEL Banners.json.old >nul 2>&1
REN "%root%PS\Config\Banners.json" Banners.json.old
)

ECHO Downloading New Banners.json...

powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/samdivaio/DS_PS/refs/heads/main/Banners.json -OutFile '%root%PS\Config\Banners.json'"

IF EXIST "%root%PS_Old\Config\Database\danheng.db" (
TITLE Checking the old Database...
ECHO Making Database folder...
MKDIR "%root%PS\Config\Database"
ECHO Copying the old Database...
COPY "%root%PS_Old\Config\Database\danheng.db" "%root%PS\Config\Database\danheng.db"
)

ECHO.
TITLE Done.
ECHO PS is ready. Press any key to exit...
pause >nul
```

### **(3/3)** 
Run Fiddler Classic:
> [!IMPORTANT]
> - Set fiddler to decrypt https traffic. `(Tools -> Options -> HTTPS -> Decrypt HTTPS traffic)`
> - Make sure `ignore server certificate errors` is checked as well.
> - Copy and paste the following code into the `FiddlerScript`[^2] tab of Fiddler Classic:

```py
import System;
import System.Windows.Forms;
import Fiddler;
import System.Text.RegularExpressions;

class Handlers
{
    static function OnBeforeRequest(oS: Session) {
        if (oS.host.EndsWith(".starrails.com") || oS.host.EndsWith(".hoyoverse.com") || oS.host.EndsWith(".mihoyo.com") || oS.host.EndsWith(".bhsr.com")) {
            oS.oRequest.headers.UriScheme = "http";
            oS.host = "127.0.0.1:443"; // This can also be replaced with another IP address.
        }
    }
};
```
> [!WARNING]
> If you can't connect, try resetting the certificates: ![Fiddler-cert-reset](https://github.com/user-attachments/assets/3543880d-2735-419c-b41c-bfc0d240f1ce)


> [!TIP]
> - Run the `DanhengServer.exe` inside the `PS` folder.
> - Once its ready[^3], type `account create <your username>` to create an account.
> - Run the game.
> - Login with `<your username>` and you're done.



[^1]:Download button: ![image](https://github.com/user-attachments/assets/be58bbe8-e80e-49e0-a5ca-b9c93c14320d)
[^2]:Fiddler Script: ![image](https://github.com/user-attachments/assets/a67a72f5-7d0f-4d20-9771-b67769752dfe)
[^3]:Console Ready: ![image](https://github.com/user-attachments/assets/12ffec24-48f5-4250-aa8b-eadd33593c59)

