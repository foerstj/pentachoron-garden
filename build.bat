:: This script is supposed to be executed from your DS installation folder.
:: TankCreator and gaspy are expected to be in sibling dirs.

:: map name
set map=pentachoron-garden
:: map name, case sensitive
set map_cs=Pentachoron Garden
:: path of DS documents dir (where Bits are)
set doc_ds=%USERPROFILE%\Documents\Dungeon Siege
:: path of DS installation
set ds=.
:: path of TankCreator
set tc=..\TankCreator
:: path of GasPy
set gaspy=..\gaspy

:: param
set mode=%1
echo %mode%

:: Compile map file
rmdir /S /Q "%tmp%\Bits"
robocopy "%doc_ds%\Bits\world\maps\%map%" "%tmp%\Bits\world\maps\%map%" /E
pushd %gaspy%
venv\Scripts\python -m build.fix_start_positions_required_levels %map% "%tmp%\Bits"
if %errorlevel% neq 0 pause
popd
%tc%\RTC.exe -source "%tmp%\Bits" -out "%ds%\Maps\%map_cs%.dsmap" -copyright "CC-BY-SA 2023" -title "%map_cs%" -author "Johannes Förstner"
if %errorlevel% neq 0 pause

:: Compile main resource file
rmdir /S /Q "%tmp%\Bits"
robocopy "%doc_ds%\Bits\art" "%tmp%\Bits\art" /E
robocopy "%doc_ds%\Bits\world\ai\jobs\%map%" "%tmp%\Bits\world\ai\jobs\%map%" /E
robocopy "%doc_ds%\Bits\world\contentdb\templates\%map%" "%tmp%\Bits\world\contentdb\templates\%map%" /E
robocopy "%doc_ds%\Bits\world\global\moods\%map%" "%tmp%\Bits\world\global\moods\%map%" /E
call "%doc_ds%\Bits\build-music-fallback.bat"
%tc%\RTC.exe -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs%.dsres" -copyright "CC-BY-SA 2023" -title "%map_cs%" -author "Johannes Förstner"
if %errorlevel% neq 0 pause

:: Compile German language resource file
rmdir /S /Q "%tmp%\Bits"
robocopy "%doc_ds%\Bits\language" "%tmp%\Bits\language" %map%-* /S
%tc%\RTC.exe -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs%-de.dsres" -copyright "CC-BY-SA 2023" -title "%map_cs%" -author "Johannes Förstner"
if %errorlevel% neq 0 pause

if not "%mode%"=="light" (
  call "%doc_ds%\Bits\build-music.bat"
)

:: Cleanup
rmdir /S /Q "%tmp%\Bits"
