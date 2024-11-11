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