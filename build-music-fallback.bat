@echo off

:: map name
set map=pentachoron-garden
:: path of DS documents dir (where Bits are)
set doc_ds=%USERPROFILE%\Documents\Dungeon Siege

set moods_gas=Bits\world\global\moods\pentachoron-garden\pentachoron-garden_moods.gas
set music_map=%doc_ds%\Bits\world\global\moods\pentachoron-garden-music-fallback.txt
set replace=
setlocal enabledelayedexpansion
for /F "usebackq tokens=1* delims==" %%i in ("%music_map%") do (
	set replace=!replace! -replace '%%i','%%j'
)

@echo on
powershell -Command "(Get-Content '%tmp%\%moods_gas%') %replace% | Out-File -encoding ASCII '%tmp%\%moods_gas%'"
