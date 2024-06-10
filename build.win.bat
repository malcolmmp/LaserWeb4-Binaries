::
:: build.win.bat
::
:: Builds Windows PC distribution of LaserWeb
::
:: Run from classic Windows Command Prompt (cmd.exe)!
::

:: Set UnicodeData.txt path to work around https://github.com/dodo/node-unicodetable/issues/16
set NODE_UNICODETABLE_UNICODEDATA_TXT=%CD%\UnicodeData\UnicodeData.txt
set LW_DIR=Laserweb4
set CURRENT_DIR=%CD%

:: Set target branch
set /p TARGET_UI_BRANCH=<BRANCH
echo "Targetting UI Branch: %TARGET_UI_BRANCH%"

:: Commence

::CALL yarn

cd ..
dir

:: Download LaserWeb UI / install modules
::IF EXIST %LW_DIR% (
::    rd /s /q  %LW_DIR%
::)

::git clone https://github.com/LaserWeb/LaserWeb4.git %LW_DIR%
cd %LW_DIR%
::git checkout %TARGET_UI_BRANCH%
::CALL yarn
::CALL npm run installdev
CALL yarn run installdev

:: Override files
::echo "Applying file overrides.."
::xcopy /s /f /y ..\LaserWeb\overrides\LaserWeb4 .

:: Save Git log to Env variable
git log --pretty=format:"[%%h](https://github.com/LaserWeb/LaserWeb4/commit/%%H)%%x09%%an%%x09%%ad%%x09%%s" --date=short -10 > git.log.output
set /p GIT_LOGS=<git.log.output

git describe --abbrev=0 --tags > ui_version.output
set /p UI_VERSION=<ui_version.output
set /p SERVER_VERSION=<node_modules\lw.comm-server\version.txt

:: Bundle LaserWeb app using webpack
CALL yarn run bundle-dev
:: Copy web front-end

:: Comm server setup
cd ..\lw.comm-server
CALL yarn install
:: Copy frontend to comm-server
set LW_DIST=..\%LW_DIR%\dist
xcopy /i /y "%LW_DIST%" .\app

:: Home stretch
::cd ..\LaserWeb4-Binaries
cd ..\%CURRENT_DIR%


::git tag -f %UI_VERSION%-%SERVER_VERSION%

set LW_VERSION=%UI_VERSION:~1%-%SERVER_VERSION:~-3%
::xcopy /i /y "%LW_DIST%" .\node_modules\lw.comm-server\app

echo %LW_VERSION%>.\node_modules\lw.comm-server\app\VERSION

echo "LaserWeb4 %LW_VERSION%"

::CALL .\node_modules\.bin\electron-rebuild
::CALL .\node_modules\.bin\build --em.version=%LW_VERSION% -p never --ia32
::CALL yarn run make

CALL yarn install
:: Copy new comm-server for local dev
CALL yarn newcomms
CALL yarn rebuild
CALL yarn make-win

:: List build artifacts
dir dist
:: Move release file to distribution directory
::xcopy dist\*.exe ..\LaserWeb4-Binaries\dist\
::cd  ..\LaserWeb4-Binaries\dist\
::dir
::cd ..


