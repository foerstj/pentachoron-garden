:: Compile music file
rmdir /S /Q "%tmp%\Bits"
robocopy "%doc_ds%\Bits\world\global\moods\%map%" "%tmp%\Bits\world\global\moods\%map%" /E
robocopy "%doc_ds%\Bits\sound" %tmp%\Bits\sound /E
%tc%\RTC.exe -source "%tmp%\Bits" -out "%ds%\Resources\%map_cs%-music.dsres" -copyright "%copyright%" -title "%map_cs%" -author "%author%"
if %errorlevel% neq 0 pause
