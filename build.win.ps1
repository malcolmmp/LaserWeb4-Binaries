#
# build.win.ps1
#
# Builds Windows PC distribution of LaserWeb
#
# This is a Windows PowerShell script!
# If you can't run this in PowerShell, run the following command (without the #):
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#
# You can verify the setting with this command:
# Get-ExecutionPolicy
#

# Set UnicodeData.txt path to work around https://github.com/dodo/node-unicodetable/issues/16
#set NODE_UNICODETABLE_UNICODEDATA_TXT=%CD%\UnicodeData\UnicodeData.txt

#Setup basic paths
$binariesDir = Get-Location
$parentDir =  Split-Path -Path $binariesDir -Parent
$lwDir = Join-Path -path $parentDir -ChildPath 'LaserWeb4'
$commsDir = Join-Path -path $parentDir -ChildPath "lw.comm-server"


# Set target branch
$targetUIBranch = Get-Content .\BRANCH -Raw
Write-Output "Targetting UI Branch: $targetUIBranch"


# Commence

# Download LaserWeb UI / install modules
#IF EXIST %LW_DIR% (
#    rd /s /q  %LW_DIR%
#)

#git clone https://github.com/LaserWeb/LaserWeb4.git %LW_DIR%
Set-Location $lwDir
Write-Output "Working in $lwDir"

#git checkout %TARGET_UI_BRANCH%
#CALL yarn
#CALL npm run installdev

#$yarninstalldev = "yarn run installdev"
#& $yarninstalldev
yarn run installdev

# Override files
#echo "Applying file overrides.."
#xcopy /s /f /y ..\LaserWeb\overrides\LaserWeb4 .

# Save Git log to Env variable
git log --pretty=format:"[%%h](https://github.com/LaserWeb/LaserWeb4/commit/%%H)%%x09%%an%%x09%%ad%%x09%%s" --date=short -10 > git.log.output
# set /p GIT_LOGS=<git.log.output
$gitLogs = Get-Content .\git.log.output -Raw
git describe --abbrev=0 --tags > ui_version.output
# set /p UI_VERSION=<ui_version.output
$uiVersion = Get-Content .\ui_version.output -Raw
#set /p SERVER_VERSION=<node_modules\lw.comm-server\version.txt
$serverVersion = Join-Path -path $lwDir -ChildPath 'node_modules\lw.comm-server\version.txt'
# Bundle LaserWeb app using webpack
yarn run bundle-dev

# Comm server setup
Set-Location $commsDir
Write-Output "Working in $commsDir"
yarn install

# Copy frontend to comm-server
# set LW_DIST=..\%LW_DIR%\dist
$lwDist = Join-Path -path $lwDir -ChildPath 'dist'

########################
# WORKING THIS FAR

xcopy /i /y "%LW_DIST%" .\app

# Home stretch
Set-Location $binariesDir
Write-Output "Working in $binariesDir"


#git tag -f %UI_VERSION%-%SERVER_VERSION%
$laserwebVersion = "$uiVersion-$serverVersion"
#set LW_VERSION=%UI_VERSION:~1%-%SERVER_VERSION:~-3%
#xcopy /i /y "%LW_DIST%" .\node_modules\lw.comm-server\app

echo %LW_VERSION%>.\node_modules\lw.comm-server\app\VERSION

#echo "LaserWeb4 %LW_VERSION%"
Write-Output "Laserweb4 $laserwebVersion"

#CALL .\node_modules\.bin\electron-rebuild
#CALL .\node_modules\.bin\build --em.version=%LW_VERSION% -p never --ia32
#CALL yarn run make

CALL yarn install
# Copy new comm-server for local dev
CALL yarn newcomms
CALL yarn rebuild
CALL yarn make-win

# List build artifacts
dir dist
# Move release file to distribution directory
#xcopy dist\*.exe ..\LaserWeb4-Binaries\dist\
#cd  ..\LaserWeb4-Binaries\dist\
#dir
#cd ..


