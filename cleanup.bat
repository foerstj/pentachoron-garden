:: map name, case sensitive
set map_cs=Pentachoron Garden
:: path of DS installation
set ds=%DungeonSiege%

:: Cleanup resources so as not to confuse Siege Editor
del "%ds%\Resources\%map_cs%.dsres"
del "%ds%\Resources\%map_cs%.de.dsres"
del "%ds%\Resources\%map_cs% music.dsres"
