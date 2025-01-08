:: Compile music file
rmdir /S /Q "%tmp%\Bits"
robocopy "%bits%\world\global\moods\%map%" "%tmp%\Bits\world\global\moods\%map%" /E
robocopy "%bits%\sound" %tmp%\Bits\sound /E
"%tc%\RTC.exe" -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs% music.dsres" -copyright "%copyright%" -title "%map_cs%" -author "%author%"
if %errorlevel% neq 0 pause
