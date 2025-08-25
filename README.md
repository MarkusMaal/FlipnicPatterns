# Flipnic hex patterns

This repository contains hex patterns that can be used with ImHex and are specific to various file formats used by the Flipnic PlayStation 2 game.

This is a part of the Flipnic extraction project, where we try to understand as much of the game's file formats as possible.


* [binfile.hexpat](binfile.hexpat) - Virtual filesystem for .BIN blob files [VFS support]
* [folder.hexpat](folder.hexpat) - Subfolders in .BIN blob files [VFS support]
* [fpc.hexpat](fpc.hexpat) - Camera sequences
* [ipu.hexpat](ipu.hexpat) - While Flipnic uses .IPU files, which are found in many PS2 games, it has made a few modifications to header and footer, which can be seen with this pattern file
* [msg.hexpat](msg.hexpat) - JA.MSG file (strings used by the game)
* [pss.hexpat](pss.hexpat) - Custom .PSS container, which contains audio/video streams
* [savefile.hexpat](savefile.hexpat) - Save file format
* [sst.hexpat](sst.hexpat) - Stage definition files (.SST)
* [tim2.hexpat](tim2.hexpat) - Texture files
* [saveicon.hexpat](saveicon.hexpat) - Save file icon (FICON.ICO)
* [vsd.hexpat](vsd.hexpat) - Vibration strength data (.VSD)

Incomplete patterns:

* [mlb.hexpat](mlb.hexpat) - Layout for various in-game menus
* [hd.hexpat](hd.hexpat) - Soundbank (VAB) header file (pattern is displayed correctly for music soundbanks, but sound effect .hd visualization is incomplete)
* [lp4.hexpat](lp4.hexpat) - Game resource file (usually 3D models and 2D text animations)


## Importing these files

1. Open a desired file in ImHex hex editor.
2. Make sure you see "Pattern editor" on the right side. If not, check View > Pattern editor.
3. Right click on text area of pattern editor
4. Choose "Import Pattern File..."
5. Choose "Browse.."
6. Find matching .hexpat file
7. Click "Open"
8. Press the play button to evaluate the pattern
9. If done correctly, certain areas of the file should get highlighted
10. If a pattern file has VFS support, you can also see stuff on the "Virtual Filesystem" tab. You can right click on a file and select "Open Selection View" or double click to analyze hex data of the virtual file separately.


## Progress

| Extension  | Description                | Decode | Generate | Notes                                                                         |
|------------|----------------------------|--------|----------|-------------------------------------------------------------------------------|
| BIN        | Blob files                 |✅     |✅       | Can generate, but making a RES.BIN from scratch causes the game to crash      |
| COL        | Collision maps             |❌     |❌       | Appears to have similar structure to LP4 files                                |
| CSV        | Comma seperated values     |✅     |✅       | Development left-overs, unused by the game                                    |
| FPC        | Camera sequences           |✅     |❌       | Can also contain camera animations                                            |
| FPD        | AI path data?              |❌     |❌       | Looks similar to FPC, maybe next one to figure out?                           |
| HD/BD      | VAB soundbank files        | Part.  |❌       | Can understand the contents, but SF2 conversion requires further research     |
| ICO        | Save file icon             |✅     | ?        | Apparently a standard format                                                  |
| LAY        | "Layout" files             |❌     |❌       | Defines what models can be gimmicks, I guess?                                 |
| LIT        | Light tables               |❌     |❌       | Controls how the stage is lit                                                 |
| LP4        | Flipnic resources          |❌     |❌       | Can be 2D or 3D and sometimes animated, a bizarre format                      |
| MID        | MIDI sequences             |✅     |✅       | Just general MIDI played on specific channels specified by .HD/.BD files      |
| MLB        | Menu layout (binary?)      |✅     |❌       | Used to stitch various textures together to create a menu interface           |
| MSG        | Message tables             |✅     |✅       | Strings used by the game                                                      |
| PSS        | Interleaved audio/video    |✅     | Part.    | Generation is only possible with a donor file and audio stutters              |
| PSS.INT    | Audio stream               |✅     |✅       | Stereo Sony ADPCM compressed audio stream (interleave 0x400)                  |
| PSS.IPU    | IPU video                  |✅     |✅       | Modified version of M2V for PlayStation 2                                     |
| SCC        | ???                        |❌     |❌       | Maybe memory offsets? Also why do they all have the same name?                |
| SST        | Stage (special?) table     | Part.  |❌       | Contains stuff like gimmicks, list of files and event system                  |
| SVAG       | Mono audio stream          |✅     |✅       | Sony ADPCM compressed again, but single audio channel this time               |
| TM2        | Texture image map 2 (TIM2) |✅     |✅       | Standard texture file for PlayStation 2 games                                 |
| VSD        | Vibration data             |✅     |❌       | Controls when the controller should vibrate, maybe has relations to gimmicks  |
| XML        | eXtensible Markup Language |✅     |✅       | Developer left-overs, unused by the game                                      |
| GAME_ID    | Save file format           |✅     |✅       | Checksums are just CRC-32/JAMCRC, primary at 0xC, secondary at 0x8            |
| GAME_ID    | Game executable (footer)   |❌     |❌       | Some strings and memory addresses can be modified to change menu actions    |