:: map name
set map=pentachoron-garden
:: map name, case sensitive
set map_cs=Pentachoron Garden

:: path of Bits dir
set bits=%~dp0.
:: path of DS installation
set ds=%DungeonSiege%
:: path of TankCreator
set tc=%TankCreator%

set year=2025
set copyright=CC-BY-SA %year%
set author=Johannes Förstner

:: param
set mode=%1
echo %mode%

:: pre-build checks
pushd %gaspy%
setlocal EnableDelayedExpansion
if not "%mode%"=="light" (
  set checks=standard
  if "%mode%"=="release" (
    set checks=all
  )
  venv\Scripts\python -m build.pre_build_checks %map% --check !checks! --bits "%bits%"
  if !errorlevel! neq 0 pause
)
endlocal
popd

:: Compile map file
rmdir /S /Q "%tmp%\Bits"
robocopy "%bits%\world\maps\%map%" "%tmp%\Bits\world\maps\%map%" /E
pushd %gaspy%
venv\Scripts\python -m build.fix_start_positions_required_levels %map% --bits "%tmp%\Bits"
if %errorlevel% neq 0 pause
setlocal EnableDelayedExpansion
if "%mode%"=="release" (
  venv\Scripts\python -m build.add_world_levels %map% --bits "%tmp%\Bits" --template-bits "%bits%"
  if !errorlevel! neq 0 pause
)
endlocal
popd
"%tc%\RTC.exe" -source "%tmp%\Bits" -out "%ds%\Maps\%map_cs%.dsmap" -copyright "%copyright%" -title "%map_cs%" -author "%author%"
if %errorlevel% neq 0 pause

:: Compile main resource file
rmdir /S /Q "%tmp%\Bits"
robocopy "%bits%\art" "%tmp%\Bits\art" /E
robocopy "%bits%\world\ai\jobs\minibits" "%tmp%\Bits\world\ai\jobs\minibits" /E
robocopy "%bits%\world\contentdb\templates\%map%" "%tmp%\Bits\world\contentdb\templates\%map%" /E
robocopy "%bits%\world\contentdb\templates\minibits" "%tmp%\Bits\world\contentdb\templates\minibits" /E
robocopy "%bits%\world\global\moods\%map%" "%tmp%\Bits\world\global\moods\%map%" /E
pushd %gaspy%
venv\Scripts\python -m build.swap_music_tracks --bits "%tmp%\Bits"
if %errorlevel% neq 0 pause
popd
"%tc%\RTC.exe" -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs%.dsres" -copyright "%copyright%" -title "%map_cs%" -author "%author%"
if %errorlevel% neq 0 pause

:: Compile German language resource file
rmdir /S /Q "%tmp%\Bits"
robocopy "%bits%\language" "%tmp%\Bits\language" %map%-*.de.gas /S
robocopy "%bits%\language" "%tmp%\Bits\language" minibits-*.de.gas /S
"%tc%\RTC.exe" -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs%.de.dsres" -copyright "%copyright%" -title "%map_cs%" -author "%author%"
if %errorlevel% neq 0 pause

if not "%mode%"=="light" (
  call "%bits%\build-music.bat"
)

:: Cleanup
rmdir /S /Q "%tmp%\Bits"
