\ ******************************************************************************
\
\ COMMODORE 64 ELITE MAIN GAME SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code in this file is identical to the source disks released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains the main game code for Commodore 64 Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary files:
\
\   * ELTA.bin
\   * ELTB.bin
\   * ELTC.bin
\   * ELTD.bin
\   * ELTE.bin
\   * ELTF.bin
\   * ELTG.bin
\   * ELTH.bin
\   * ELTI.bin
\   * ELTJ.bin
\   * ELTK.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85_NTSC            = (_VARIANT = 1)
 _GMA86_PAL             = (_VARIANT = 2)
 _GMA_RELEASE           = (_VARIANT = 1) OR (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)
 _SOURCE_DISK           = (_VARIANT = 3) OR (_VARIANT = 4)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &1D00          \ The address where the first block of game code will
                        \ be run (ELITE A to C)

 LOAD% = &1D00          \ The address where the first block of game code will
                        \ be loaded (ELITE A to C)

IF _GMA_RELEASE

 C% = &6A00             \ The address where the second block of game code will
                        \ be loaded and run (ELITE D onwards)

ELIF _SOURCE_DISK

 C% = &7300             \ The address where the second block of game code will
                        \ be loaded and run (ELITE D onwards)

ENDIF

 Q% = _MAX_COMMANDER    \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander

 USA% = TRUE            \ Set USA% to FALSE to introduce a timing loop to bring
                        \ PAL machines in line with NTSC machines (interestingly
                        \ both the GMA85 NTSC and GMA86 PAL versions have this
                        \ set to TRUE, so the timing loop is not included in
                        \ either version)

 NOST = 12              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 10              \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 33               \ The number of different ship types

 MSL = 1                \ Ship type for a missile

 SST = 2                \ Ship type for a Coriolis space station

 ESC = 3                \ Ship type for an escape pod

 PLT = 4                \ Ship type for an alloy plate

 OIL = 5                \ Ship type for a cargo canister

 AST = 7                \ Ship type for an asteroid

 SPL = 8                \ Ship type for a splinter

 SHU = 9                \ Ship type for a Shuttle

 CYL = 11               \ Ship type for a Cobra Mk III

 ANA = 14               \ Ship type for an Anaconda

 HER = 15               \ Ship type for a rock hermit (asteroid)

 COPS = 16              \ Ship type for a Viper

 SH3 = 17               \ Ship type for a Sidewinder

 KRA = 19               \ Ship type for a Krait

 ADA = 20               \ Ship type for an Adder

 WRM = 23               \ Ship type for a Worm

 CYL2 = 24              \ Ship type for a Cobra Mk III (pirate)

 ASP = 25               \ Ship type for an Asp Mk II

 THG = 29               \ Ship type for a Thargoid

 TGL = 30               \ Ship type for a Thargon

 CON = 31               \ Ship type for a Constrictor

 COU = 32               \ Ship type for a Cougar

 DOD = 33               \ Ship type for a Dodecahedron ("Dodo") space station

 JL = ESC               \ Junk is defined as starting from the escape pod

 JH = SHU+2             \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ Shuttle or Transporter

 PACK = SH3             \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

 POW = 15               \ Pulse laser power

 Mlas = 50              \ Mining laser power

 Armlas = INT(128.5 + 1.5*POW)  \ Military laser power

 NI% = 37               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 X = 128                \ The centre x-coordinate of the 256 x 144 space view

 Y = 72                 \ The centre y-coordinate of the 256 x 144 space view

 conhieght = 80         \ The size of the gap left for the rotating Constrictor
                        \ at the top of the briefing for mission 1

 f0 = &3C               \ Internal key number for key F1 (Launch, Front)

 f1 = &08               \ Internal key number for key "1" (Buy Cargo)

 f2 = &05               \ Internal key number for key "2" (Sell Cargo)

 f3 = &38               \ Internal key number for key "3" (Equip Ship)

 f4 = &35               \ Internal key number for key "4" (Long-range Chart)

 f5 = &30               \ Internal key number for key "5" (Short-range Chart)

 f6 = &2D               \ Internal key number for key "6" (Data on System)

 f7 = &28               \ Internal key number for key "7" (Market Price)

 f8 = &25               \ Internal key number for key "8" (Status Mode)

 f9 = &20               \ Internal key number for key "9" (Inventory)

 f12 = &3B              \ Internal key number for key F3 (Rear)

 f22 = &3A              \ Internal key number for key F5 (Left)

 f32 = &3D              \ Internal key number for key F7 (Right)

 DINT = &2E             \ Internal key number for key "D" (Distance to system)

 FINT = &2B             \ Internal key number for key "F" (System search)

 HINT = &23             \ Internal key number for key "H" (Hyperspace)

 OINT = &1A             \ Internal key number for key "O" (Crosshairs home)

 YINT = &27             \ Internal key number for key "Y" (Y/N)

 RED = %01010101        \ Four multicolour bitmap mode pixels of colour %01,
                        \ which is mapped to the danger colour for the dashboard
                        \ dials, or red on the scanner, via the colour mapping
                        \ in sdump (high nibble)

 YELLOW = %10101010     \ Four multicolour bitmap mode pixels of colour %10,
                        \ which is mapped to the normal indicator colour for
                        \ the dashboard dials, or yellow on the scanner, via the
                        \ colour mapping in sdump (low nibble)

 GREEN = %11111111      \ Four multicolour bitmap mode pixels of colour %11,
                        \ which is mostly mapped to green for the notched lines
                        \ on the dashboard, or light green on the scanner, via
                        \ the colour mapping in cdump (low nibble)

 WHITE = %01011010      \ Four multicolour bitmap mode pixels of colours %01,
                        \ %01, %10 and %10, for showing Thargoids on the scanner
                        \ with a striped design of red and yellow

 BLUE = YELLOW          \ Ships that are set to a scanner colour of BLUE in the
                        \ scacol table will actually be shown in yellow

 CYAN = YELLOW          \ Ships that are set to a scanner colour of CYAN in the
                        \ scacol table will actually be shown in yellow

 MAG = YELLOW           \ Ships that are set to a scanner colour of MAG in the
                        \ scacol table will actually be shown in yellow

 RED2 = $27             \ A multicolour bitmap mode palette byte for screen RAM
                        \ that sets red (2) for %01 in the bitmap and yellow (7)
                        \ for %10 in the bitmap, for displaying a red missile
                        \ indicator

 GREEN2 = $57           \ A multicolour bitmap mode palette byte for screen RAM
                        \ that sets green (5) for %01 in the bitmap and yellow
                        \ (7) for %10 in the bitmap, for displaying a green
                        \ missile indicator

 YELLOW2 = $87          \ A multicolour bitmap mode palette byte for screen RAM
                        \ that sets orange (8) for %01 in the bitmap and yellow
                        \ (7) for %10 in the bitmap, for displaying an orange
                        \ missile indicator

 BLACK2 = $B7           \ A multicolour bitmap mode palette byte for screen RAM
                        \ that sets dark grey (&B) for %01 in the bitmap and
                        \ yellow (7) for %10 in the bitmap, for displaying an
                        \ empty missile indicator

 MAG2 = $40             \ A multicolour text mode palette byte for screen RAM
                        \ that displays purple (4) foreground text on a black
                        \ (0) background for showing player input in the text
                        \ view

 BULBCOL = $E0          \ A multicolour bitmap mode palette byte that is EOR'd
                        \ into screen RAM to toggle the E.C.M. and space station
                        \ indicator bulbs in light blue (&E), as the "E" and "S"
                        \ are in colour %01, and this is initially set to black
                        \ in the colour mapping in sdump

 sfxplas = 0            \ Sound 0  = Pulse lasers fired by us

 sfxelas = 1            \ Sound 1  = Being hit by lasers 1

 sfxhit = 2             \ Sound 2  = Other ship exploding

 sfxexpl = 3            \ Sound 3  = We died / Collision

 sfxwhosh = 4           \ Sound 4  = Missile launched / Ship launch

 sfxbeep = 5            \ Sound 5  = Short, high beep

 sfxboop = 6            \ Sound 6  = Long, low beep

 sfxhyp1 = 7            \ Sound 7  = Hyperspace drive engaged 1

 sfxeng = 8             \ Sound 8  = This sound is not used

 sfxecm = 9             \ Sound 9  = E.C.M. on

 sfxblas = 10           \ Sound 10 = Beam lasers fired by us

 sfxalas = 11           \ Sound 11 = Military lasers fired by us

 sfxmlas = 12           \ Sound 12 = Mining lasers fired by us

 sfxbomb = 13           \ Sound 13 = Energy bomb

 sfxtrib = 14           \ Sound 14 = Trumbles dying

 sfxelas2 = 15          \ Sound 15 = Being hit by lasers 2

 NRU% = 0               \ The number of planetary systems with extended system
                        \ description overrides in the RUTOK table
                        \
                        \ NRU% is set to 0 in the original source, but this is a
                        \ bug, as it should match the number of entries in the
                        \ RUGAL table
                        \
                        \ This bug causes the Data on System screen to crash the
                        \ game for a small number of systems - for example, the
                        \ game will freeze if you bring up the Data on System
                        \ screen after docking at Biarge in the first galaxy
                        \ during the Constrictor mission

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

 KEY1 = &36             \ The seed for encrypting LOCODE from G% to R%, where
                        \ LOCODE = ELTA-C

 KEY2 = &49             \ The seed for encrypting HICODE from R% to F%, where
                        \ HICODE = ELTD-K

 LL = 30                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

 PALCK = LO(311)        \ When USA% is set to FALSE, a timing loop is included
                        \ in the build that waits until the raster line in PALCK
                        \ is reached; the LO() extracts the lower byte of the
                        \ raster line to make it easier to compare with VIC-II
                        \ register &12, which contains the bottom byte of the
                        \ 9-bit raster line count

 l1 = &0001             \ The 6510 input/output port register, which we can use
                        \ to configure the Commodore 64 memory layout (see page
                        \ 260 of the Programmer's Reference Guide)

 BRKV = &0316           \ The CBINV break vector that we intercept to enable us
                        \ to handle and display system errors

 NMIV = &0318           \ The NMINV vector that we intercept with our custom NMI
                        \ handler, which just acknowledges NMI interrupts and
                        \ ignores them

 CHRV = &0326           \ The IBSOUT vector that we intercept with our custom
                        \ text printing routine

 QQ18 = &0700           \ The address of the text token table, as set in
                        \ elite-data.asm

 SNE = &0AC0            \ The address of the sine lookup table, as set in
                        \ elite-data.asm

 ACT = &0AE0            \ The address of the arctan lookup table, as set in
                        \ elite-data.asm

 FONT = &0B00           \ The address of the game's text font

 TKN1 = &0E00           \ The address of the extended token table, as set in
                        \ elite-data.asm

 RUPLA = TKN1 + &C28    \ The address of the extended system description system
                        \ number table, as set in elite-data.asm

 RUGAL = TKN1 + &C42    \ The address of the extended system description galaxy
                        \ number table, as set in elite-data.asm

 RUTOK = TKN1 + &C5C    \ The address of the extended system description token
                        \ table, as set in elite-data.asm

 SCBASE = &4000         \ The address of the screen bitmap

 DLOC% = SCBASE+18*8*40 \ The address in the screen bitmap of the start of the
                        \ dashboard (which starts character row 18)

 ECELL = SCBASE+$2400+23*40+11  \ The address in screen RAM of the colour byte
                                \ for the E.C.M. indicator bulb ("E")

 SCELL = SCBASE+$2400+23*40+28  \ The address in screen RAM of the colour byte
                                \ for the space station indicator bulb ("S")

 MCELL = SCBASE+$2400+24*40+6   \ The address in screen RAM of the colour byte
                                \ for the first missile indicator

 TAP% = &CF00           \ The staging area where we copy files after loading and
                        \ before saving

 XX21 = &D000           \ The address of the ship blueprints lookup table, as
                        \ set in elite-data.asm

 E% = &D042             \ The address of the default NEWB ship bytes, as set in
                        \ elite-data.asm

 KWL% = &D063           \ The address of the kill tally fraction table, as set
                        \ in elite-data.asm

 KWH% = &D084           \ The address of the kill tally integer table, as set in
                        \ elite-data.asm

 VIC = &D000            \ Registers for the VIC-II video controller chip, which
                        \ are memory-mapped to the 46 bytes from &D000 to &D02E
                        \ (see page 454 of the Programmer's Reference Guide)

 SID = &D400            \ Registers for the SID sound synthesis chip, which are
                        \ memory-mapped to the 29 bytes from &D400 to &D41C (see
                        \ page 461 of the Programmer's Reference Guide)

 CIA = &DC00            \ Registers for the CIA1 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DC00 to &DC0F
                        \ (see page 428 of the Programmer's Reference Guide)

 CIA2 = &DD00           \ Registers for the CIA2 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DD00 to &DD0F
                        \ (see page 428 of the Programmer's Reference Guide)

IF _GMA_RELEASE

 DSTORE% = SCBASE + &AF90       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &2800    \ The address where the sprite definitions get
                                \ copied to during the loading process (the
                                \ screen bitmap at SCBASE is &2000 bytes long,
                                \ and it's followed by &400 bytes of screen RAM
                                \ for the space view and another &400 for the
                                \ text view, and we put the sprite definitions
                                \ after this)

ELIF _SOURCE_DISK

 DSTORE% = SCBASE + &2800       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &3100    \ The address where the sprite definitions get
                                \ copied to during the loading process (the
                                \ screen bitmap at SCBASE is &2000 bytes long,
                                \ and it's followed by &400 bytes of screen RAM
                                \ for the space view and another &400 for the
                                \ text view, then &900 bytes for the copy of the
                                \ dashboard bitmap at DSTORE%, and we put the
                                \ sprite definitions after this)

ENDIF

 SPOFF% = (SPRITELOC% - SCBASE) / 64    \ Sprite pointers are defined as the
                                        \ offset from the start of the VIC-II
                                        \ screen bank to start of the sprite
                                        \ definitions, divided by 64, so SPOFF%
                                        \ is the offset for the first sprite
                                        \ definition at SPRITELOC%

 LS% = &FFC0            \ The start of the descending ship line heap

 KERNALSVE = &FFD8      \ The Kernal function to save a file to a device

 KERNALSETLFS = &FFBA   \ The Kernal function to set the logical, first, and
                        \ second addresses for file access

 KERNALSETNAM = &FFBD   \ The Kernal function to set a filename

 KERNALSETMSG = &FF90   \ The Kernal function to control Kernal messages

 KERNALLOAD = &FFD5     \ The Kernal function to load a file from a device

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/enhanced/main/workspace/up.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ Produces the binary file ELTA.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

 LOAD_A% = LOAD%

INCLUDE "library/advanced/main/workspace/option_variables.asm"
INCLUDE "library/master/main/variable/tgint.asm"
INCLUDE "library/c64/main/subroutine/s_per_cent.asm"
INCLUDE "library/master/main/subroutine/deeor.asm"
INCLUDE "library/master/main/subroutine/deeors.asm"

 EQUB &B7, &AA          \ These bytes appear to be unused, though there is a
 EQUB &45, &23          \ comment in the original source that says "red
                        \ herring", so this would appear to be a red herring
                        \ aimed at confusing any crackers

INCLUDE "library/c64/main/variable/g_per_cent.asm"
INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk-cold.asm"
INCLUDE "library/c64/main/variable/tribdir.asm"
INCLUDE "library/c64/main/variable/tribdirh.asm"
INCLUDE "library/c64/main/variable/spmask.asm"
INCLUDE "library/c64/main/subroutine/mvtribs.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_3_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_4_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_5_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_6_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_7_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_8_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_9_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_10_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_11_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_12_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_13_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_14_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_15_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_16_of_16.asm"
INCLUDE "library/enhanced/main/subroutine/spin.asm"
INCLUDE "library/c64/main/subroutine/bomboff.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/6502sp/main/subroutine/whitetext.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/master/main/variable/na_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/advanced/main/variable/chk3.asm"
INCLUDE "library/common/main/variable/chk.asm"
INCLUDE "library/enhanced/main/variable/s1_per_cent.asm"
INCLUDE "library/common/main/variable/na_per_cent-na2_per_cent.asm"
INCLUDE "library/advanced/main/variable/scacol.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"

\ ******************************************************************************
\
\ Save ELTA.bin
\
\ ******************************************************************************

 PRINT "ELITE A"
 PRINT "Assembled at ", ~CODE%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_A%

 PRINT "S.ELTA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
 SAVE "versions/c64/3-assembled-output/ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ Produces the binary file ELTB.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_B% = P%

 LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/univ.asm"

 EQUD &10204080         \ These bytes appear to be unused; they contain a copy
 EQUD &01020408         \ of the TWOS variable, and the original source has a
 EQUW &4080             \ commented out label .TWOS

 EQUD &030C30C0         \ These bytes appear to be unused; they contain a copy
                        \ of the DTWOS variable, and the original source has a
                        \ commented out label .DTWOS

INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/subroutine/flip.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/mas1.asm"
INCLUDE "library/common/main/subroutine/mas2.asm"
INCLUDE "library/common/main/subroutine/mas3.asm"
INCLUDE "library/common/main/subroutine/status.asm"
INCLUDE "library/common/main/subroutine/plf2.asm"
INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/enhanced/main/subroutine/feed.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/enhanced/main/subroutine/hme2.asm"

\ ******************************************************************************
\
\ Save ELTB.bin
\
\ ******************************************************************************

 PRINT "ELITE B"
 PRINT "Assembled at ", ~CODE_B%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_B%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_B%

 PRINT "S.ELTB ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_B%
 SAVE "versions/c64/3-assembled-output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ Produces the binary file ELTC.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_C% = P%

 LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/common/main/subroutine/tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_7_of_7.asm"
INCLUDE "library/enhanced/main/subroutine/dockit.asm"
INCLUDE "library/enhanced/main/subroutine/vcsu1.asm"
INCLUDE "library/enhanced/main/subroutine/vcsub.asm"
INCLUDE "library/common/main/subroutine/tas1.asm"
INCLUDE "library/enhanced/main/subroutine/tas4.asm"
INCLUDE "library/enhanced/main/subroutine/tas6.asm"
INCLUDE "library/enhanced/main/subroutine/dcs1.asm"
INCLUDE "library/common/main/subroutine/hitch.asm"
INCLUDE "library/common/main/subroutine/frs1.asm"
INCLUDE "library/common/main/subroutine/frmis.asm"
INCLUDE "library/common/main/subroutine/angry.asm"
INCLUDE "library/common/main/subroutine/fr1.asm"
INCLUDE "library/common/main/subroutine/sescp.asm"
INCLUDE "library/common/main/subroutine/sfs1.asm"
INCLUDE "library/common/main/subroutine/sfs2.asm"
INCLUDE "library/common/main/subroutine/ll164.asm"
INCLUDE "library/common/main/subroutine/laun.asm"
INCLUDE "library/common/main/subroutine/hfs2.asm"
INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut3.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/tas3.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/advanced/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/enhanced/main/subroutine/brief2.asm"
INCLUDE "library/enhanced/main/subroutine/brp.asm"
INCLUDE "library/enhanced/main/subroutine/brief3.asm"
INCLUDE "library/enhanced/main/subroutine/debrief2.asm"
INCLUDE "library/enhanced/main/subroutine/debrief.asm"
INCLUDE "library/c64/main/subroutine/tbrief.asm"
INCLUDE "library/enhanced/main/subroutine/brief.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/pas1.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/master/main/variable/sightcol.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/advanced/main/variable/r_per_cent.asm"

\ ******************************************************************************
\
\ Save ELTC.bin
\
\ ******************************************************************************

 PRINT "ELITE C"
 PRINT "Assembled at ", ~CODE_C%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_C%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_C%

 PRINT "S.ELTC ", ~CODE_C%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_C%
 SAVE "versions/c64/3-assembled-output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 ORG C%                 \ Set the assembly address for the second block of game
                        \ code (ELITE D onwards), which is defined in C%

 CODE_D% = P%

 LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/enhanced/main/subroutine/tnpr1.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/advanced/main/subroutine/setxc-doxc.asm"
INCLUDE "library/advanced/main/subroutine/setyc-doyc.asm"
INCLUDE "library/advanced/main/subroutine/incyc.asm"
INCLUDE "library/advanced/main/subroutine/setvdu19-dovdu19.asm"
INCLUDE "library/advanced/main/subroutine/trademode.asm"
INCLUDE "library/common/main/subroutine/tt20.asm"
INCLUDE "library/common/main/subroutine/tt54.asm"
INCLUDE "library/common/main/subroutine/tt146.asm"
INCLUDE "library/common/main/subroutine/tt60.asm"
INCLUDE "library/common/main/subroutine/ttx69.asm"
INCLUDE "library/common/main/subroutine/tt69.asm"
INCLUDE "library/common/main/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt70.asm"
INCLUDE "library/common/main/subroutine/spc.asm"
INCLUDE "library/common/main/subroutine/tt25.asm"
INCLUDE "library/common/main/subroutine/tt24.asm"
INCLUDE "library/common/main/subroutine/tt22.asm"
INCLUDE "library/common/main/subroutine/tt15.asm"
INCLUDE "library/common/main/subroutine/tt14.asm"
INCLUDE "library/common/main/subroutine/tt128.asm"
INCLUDE "library/common/main/subroutine/tt219.asm"
INCLUDE "library/common/main/subroutine/gnum.asm"
INCLUDE "library/enhanced/main/subroutine/nwdav4.asm"
INCLUDE "library/common/main/subroutine/tt208.asm"
INCLUDE "library/common/main/subroutine/tt210.asm"
INCLUDE "library/common/main/subroutine/tt213.asm"
INCLUDE "library/common/main/subroutine/tt214.asm"
INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"
INCLUDE "library/common/main/subroutine/tt23.asm"
INCLUDE "library/common/main/subroutine/tt81.asm"
INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/hy6-docked.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/enhanced/main/subroutine/ttx110.asm"
INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/jmp.asm"
INCLUDE "library/common/main/subroutine/ee3.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"
INCLUDE "library/common/main/subroutine/prq.asm"
INCLUDE "library/common/main/subroutine/tt151.asm"
INCLUDE "library/common/main/subroutine/tt152.asm"
INCLUDE "library/common/main/subroutine/tt162.asm"
INCLUDE "library/common/main/subroutine/tt160.asm"
INCLUDE "library/common/main/subroutine/tt161.asm"
INCLUDE "library/common/main/subroutine/tt16a.asm"
INCLUDE "library/common/main/subroutine/tt163.asm"
INCLUDE "library/common/main/subroutine/tt167.asm"
INCLUDE "library/common/main/subroutine/var.asm"
INCLUDE "library/common/main/subroutine/hyp1.asm"
INCLUDE "library/common/main/subroutine/gvl.asm"
INCLUDE "library/common/main/subroutine/gthg.asm"
INCLUDE "library/common/main/subroutine/mjp.asm"
INCLUDE "library/common/main/subroutine/tt18.asm"
INCLUDE "library/common/main/subroutine/tt110.asm"
INCLUDE "library/common/main/subroutine/tt114.asm"
INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"
INCLUDE "library/enhanced/main/variable/rdli.asm"
INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
INCLUDE "library/common/main/subroutine/hm.asm"
INCLUDE "library/enhanced/main/subroutine/refund.asm"
INCLUDE "library/common/main/variable/prxs.asm"

\ ******************************************************************************
\
\ Save ELTD.bin
\
\ ******************************************************************************

 PRINT "ELITE D"
 PRINT "Assembled at ", ~CODE_D%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_D%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_D%

 PRINT "S.ELTD ", ~CODE_D%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_D%
 SAVE "versions/c64/3-assembled-output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ Produces the binary file ELTE.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_E% = P%

 LOAD_E% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/cpl.asm"
INCLUDE "library/common/main/subroutine/cmn.asm"
INCLUDE "library/common/main/subroutine/ypl.asm"
INCLUDE "library/common/main/subroutine/tal.asm"
INCLUDE "library/common/main/subroutine/fwl.asm"
INCLUDE "library/common/main/subroutine/csh.asm"
INCLUDE "library/common/main/subroutine/plf.asm"
INCLUDE "library/common/main/subroutine/tt68.asm"
INCLUDE "library/common/main/subroutine/tt73.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/crlf.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt46.asm"
INCLUDE "library/common/main/subroutine/tt74.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"
INCLUDE "library/c64/main/subroutine/swappzero.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/master/main/variable/exlook.asm"
INCLUDE "library/c64/main/subroutine/ptcls2.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/advanced/main/subroutine/det1.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/sps4.asm"
INCLUDE "library/common/main/subroutine/sp1.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/common/main/subroutine/proj.asm"
INCLUDE "library/common/main/subroutine/pl2.asm"
INCLUDE "library/common/main/subroutine/planet.asm"
INCLUDE "library/common/main/subroutine/pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine/pls1.asm"
INCLUDE "library/common/main/subroutine/pls2.asm"
INCLUDE "library/common/main/subroutine/pls22.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/wpls2.asm"
INCLUDE "library/common/main/subroutine/wp1.asm"
INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"
INCLUDE "library/master/main/subroutine/yesno.asm"
INCLUDE "library/c64/main/subroutine/tt17.asm"

\ ******************************************************************************
\
\ Save ELTE.bin
\
\ ******************************************************************************

 PRINT "ELITE E"
 PRINT "Assembled at ", ~CODE_E%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_E%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_E%

 PRINT "S.ELTE ", ~CODE_E%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_E%
 SAVE "versions/c64/3-assembled-output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ Produces the binary file ELTF.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_F% = P%

 LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/c64/main/subroutine/swappzero2.asm"
INCLUDE "library/c64/main/subroutine/nosprites.asm"
INCLUDE "library/c64/main/subroutine/setl1.asm"
INCLUDE "library/c64/main/variable/l1m.asm"
INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"
INCLUDE "library/common/main/subroutine/killshp.asm"
INCLUDE "library/enhanced/main/subroutine/there.asm"
INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/ze.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_1_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_3_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_4_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/common/main/subroutine/bad.asm"
INCLUDE "library/common/main/subroutine/farof.asm"
INCLUDE "library/common/main/subroutine/farof2.asm"
INCLUDE "library/common/main/subroutine/mas4.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"
INCLUDE "library/enhanced/main/subroutine/brbr-newbrk.asm"
INCLUDE "library/common/main/subroutine/death.asm"
INCLUDE "library/advanced/main/variable/spasto.asm"
INCLUDE "library/enhanced/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/common/main/subroutine/br1_part_1_of_2.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/common/main/subroutine/dfault-qu5.asm"
INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/check.asm"
INCLUDE "library/c64/main/subroutine/check2.asm"
INCLUDE "library/master/main/subroutine/jameson.asm"
INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/common/main/subroutine/gtnme-gtnmew.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/common/main/variable/rline.asm"
INCLUDE "library/master/main/subroutine/filepr.asm"
INCLUDE "library/master/main/subroutine/otherfilepr.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/enhanced/main/subroutine/zebc.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/master/main/variable/thislong.asm"
INCLUDE "library/master/main/variable/oldlong.asm"
INCLUDE "library/c64/main/subroutine/kernalsetup.asm"
INCLUDE "library/enhanced/main/subroutine/gtdrv.asm"
INCLUDE "library/c64/main/variable/filesys.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/6502sp/main/subroutine/backtonormal.asm"
INCLUDE "library/c64/main/subroutine/tapeerror.asm"
INCLUDE "library/6502sp/main/subroutine/cldelay.asm"
INCLUDE "library/6502sp/main/subroutine/zektran.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/c64/main/workspace/keylook.asm"
INCLUDE "library/c64/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/variable/kytb-ikns.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/common/main/subroutine/dks4-dks5.asm"
INCLUDE "library/c64/main/subroutine/dksanykey.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dkj1.asm"
INCLUDE "library/common/main/subroutine/u_per_cent.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"
INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/subroutine/ouch.asm"
INCLUDE "library/common/main/subroutine/ou2.asm"
INCLUDE "library/common/main/subroutine/ou3.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"
INCLUDE "library/c64/main/subroutine/startat.asm"
INCLUDE "library/c64/main/subroutine/startbd.asm"
INCLUDE "library/c64/main/subroutine/mutokch.asm"
INCLUDE "library/c64/main/subroutine/stopbd.asm"
INCLUDE "library/advanced/main/variable/ktran.asm"
INCLUDE "library/advanced/main/variable/trantable-trtb_per_cent.asm"

\ ******************************************************************************
\
\ Save ELTF.bin
\
\ ******************************************************************************

 PRINT "ELITE F"
 PRINT "Assembled at ", ~CODE_F%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_F%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_F%

 PRINT "S.ELTF ", ~CODE_F%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_F%
 SAVE "versions/c64/3-assembled-output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_G% = P%

 LOAD_G% = LOAD% + P% - CODE%

IF _GMA_RELEASE

 EQUB &A9, &05, &20, &7F, &82, &A9, &00, &8D    \ These bytes appear to be
 EQUB &15, &D0, &A9, &04, &78, &8D, &8E, &82    \ unused and just contain random
 EQUB &A5, &01, &29, &F8, &0D, &8E, &82, &85    \ workspace noise left over from
 EQUB &01, &58, &60, &04, &A5, &2E, &8D, &F2    \ the BBC Micro assembly process
 EQUB &04, &A5, &2F, &8D, &F3, &04, &60, &A6
 EQUB &9D, &20, &F3, &82, &A6, &9D, &4C, &2F
 EQUB &20, &20, &47, &84, &20, &4F, &7B, &8D
 EQUB &53, &04, &8D, &5F, &04, &20, &0E, &B1
 EQUB &A9

ELIF _SOURCE_DISK

 EQUB &A2, &36, &B5, &00, &BC, &00, &CE, &9D    \ These bytes appear to be
 EQUB &00, &CE, &94, &00, &E8, &D0, &F3, &60    \ unused and just contain random
 EQUB &A9, &05, &20, &7F, &8B, &A9, &00, &8D    \ workspace noise left over from
 EQUB &15, &D0, &A9, &04, &78, &8D, &8E, &8B    \ the BBC Micro assembly process
 EQUB &A5, &01, &29, &F8, &0D, &8E, &8B, &85    \
 EQUB &01, &58, &60, &04, &A5, &2E, &8D, &F2    \ They contain parts of the
 EQUB &04, &A5, &2F, &8D, &F3, &04, &60, &A6    \ SWAPPZERO, NOSPRITES and KS3
 EQUB &9D, &20, &F3, &8B, &A6, &9D, &4C, &2C    \ routines from when they were
 EQUB &20, &20, &47, &8D, &20, &3F, &84, &8D    \ assembled in memory
 EQUB &53, &04, &8D, &5F, &04, &20, &0E, &BA
 EQUB &A9, &06, &85, &0E, &A9, &81, &4C, &5B
 EQUB &85, &A2, &FF, &E8, &BD, &52, &04, &F0
 EQUB &CB, &C9, &01, &D0, &F6, &8A, &0A, &A8
 EQUB &B9, &A1, &28, &85, &07, &B9, &A2

ENDIF

INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog-alogh.asm"
INCLUDE "library/6502sp/main/variable/antilogodd.asm"
INCLUDE "library/c64/main/variable/ylookupl.asm"
INCLUDE "library/c64/main/variable/ylookuph.asm"
INCLUDE "library/c64/main/variable/celllookl.asm"
INCLUDE "library/c64/main/variable/celllookh.asm"
INCLUDE "library/common/main/subroutine/shppt.asm"
INCLUDE "library/common/main/subroutine/ll5.asm"
INCLUDE "library/common/main/subroutine/ll28.asm"
INCLUDE "library/common/main/subroutine/ll38.asm"
INCLUDE "library/common/main/subroutine/ll51.asm"
INCLUDE "library/common/main/subroutine/ll9_part_1_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_2_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_3_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_4_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_5_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_6_of_12.asm"
INCLUDE "library/common/main/subroutine/ll61.asm"
INCLUDE "library/common/main/subroutine/ll62.asm"
INCLUDE "library/common/main/subroutine/ll9_part_7_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_8_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_9_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_10_of_12.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"

\ ******************************************************************************
\
\ Save ELTG.bin
\
\ ******************************************************************************

 PRINT "ELITE G"
 PRINT "Assembled at ", ~CODE_G%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_G%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_G%

 PRINT "S.ELTG ", ~CODE_G%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_G%
 SAVE "versions/c64/3-assembled-output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ Produces the binary file ELTH.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_H% = P%

 LOAD_H% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/mveit_part_1_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_2_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_3_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_4_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_5_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_6_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine/mvt1.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvt6.asm"
INCLUDE "library/common/main/subroutine/mv40.asm"
INCLUDE "library/6502sp/main/subroutine/checksum.asm"
INCLUDE "library/common/main/subroutine/plut-pu1.asm"
INCLUDE "library/common/main/subroutine/look1.asm"
INCLUDE "library/common/main/subroutine/sight.asm"
INCLUDE "library/c64/main/variable/tribta.asm"
INCLUDE "library/c64/main/variable/tribma.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66-ttx66k.asm"

\ ******************************************************************************
\
\ Save ELTH.bin
\
\ ******************************************************************************

 PRINT "ELITE H"
 PRINT "Assembled at ", ~CODE_H%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_H%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_H%

 PRINT "S.ELTH ", ~CODE_H%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
 SAVE "versions/c64/3-assembled-output/ELTH.bin", CODE_H%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE I FILE
\
\ Produces the binary file ELTI.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_I% = P%

 LOAD_I% = LOAD% + P% - CODE%

INCLUDE "library/master/main/subroutine/yetanotherrts.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/master/main/subroutine/soflush.asm"
INCLUDE "library/c64/main/subroutine/noiseoff.asm"
INCLUDE "library/c64/main/subroutine/hypnoise.asm"
INCLUDE "library/c64/main/subroutine/noise2.asm"
INCLUDE "library/c64/main/subroutine/noise.asm"
INCLUDE "library/c64/main/variable/rasct.asm"
INCLUDE "library/c64/main/variable/zebop.asm"
INCLUDE "library/c64/main/variable/abraxas.asm"
INCLUDE "library/c64/main/variable/innersec.asm"
INCLUDE "library/c64/main/variable/shango.asm"
INCLUDE "library/c64/main/variable/moonflower.asm"
INCLUDE "library/c64/main/variable/caravanserai.asm"
INCLUDE "library/c64/main/variable/santana.asm"
INCLUDE "library/c64/main/variable/lotus.asm"
INCLUDE "library/c64/main/variable/welcome.asm"
INCLUDE "library/c64/main/subroutine/soul3b.asm"
INCLUDE "library/c64/main/subroutine/comirq1.asm"
INCLUDE "library/c64/main/subroutine/soint.asm"
INCLUDE "library/c64/main/subroutine/coffee.asm"
INCLUDE "library/c64/main/workspace/sound_variables.asm"
INCLUDE "library/c64/main/variable/sevens.asm"
INCLUDE "library/c64/main/variable/sfxpr.asm"
INCLUDE "library/c64/main/variable/sfxcnt.asm"
INCLUDE "library/c64/main/variable/sfxfq.asm"
INCLUDE "library/c64/main/variable/sfxcr.asm"
INCLUDE "library/c64/main/variable/sfxatk.asm"
INCLUDE "library/c64/main/variable/sfxsus.asm"
INCLUDE "library/c64/main/variable/sfxfrch.asm"
INCLUDE "library/c64/main/variable/sfxvch.asm"
INCLUDE "library/c64/main/subroutine/cold.asm"
INCLUDE "library/c64/main/subroutine/nmipissoff.asm"

\ ******************************************************************************
\
\ Save ELTI.bin
\
\ ******************************************************************************

 PRINT "ELITE I"
 PRINT "Assembled at ", ~CODE_I%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_I%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_I%

 PRINT "S.ELTI ", ~CODE_I%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
 SAVE "versions/c64/3-assembled-output/ELTI.bin", CODE_I%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE J FILE
\
\ Produces the binary file ELTJ.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_J% = P%

 LOAD_J% = LOAD% + P% - CODE%

INCLUDE "library/c64/main/subroutine/startup.asm"
INCLUDE "library/c64/main/subroutine/putback.asm"
INCLUDE "library/c64/main/subroutine/dohfx.asm"
INCLUDE "library/c64/main/subroutine/docol.asm"
INCLUDE "library/c64/main/subroutine/dosvn.asm"
INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/c64/main/variable/dtwos.asm"

 EQUD &3060C0C0         \ These bytes appear to be unused; they contain a copy
 EQUD &03060C18         \ of the TWOS2 variable, and the original source has a
                        \ commented out label .TWOS2

INCLUDE "library/c64/main/variable/ctwos2.asm"
INCLUDE "library/c64/main/variable/lijt1.asm"
INCLUDE "library/c64/main/variable/lijt2.asm"
INCLUDE "library/c64/main/variable/lijt3.asm"
INCLUDE "library/c64/main/variable/lijt4.asm"
INCLUDE "library/c64/main/variable/lijt5.asm"
INCLUDE "library/c64/main/variable/lijt6.asm"
INCLUDE "library/c64/main/variable/lijt7.asm"
INCLUDE "library/c64/main/variable/lijt8.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7-loinq_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7-loinq_part_2_of_7.asm"
INCLUDE "library/c64/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/c64/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7-loinq_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7-loinq_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7-loinq_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"

 EQUD &F0E0C080         \ These bytes appear to be unused; they contain a copy
 EQUW &FCF8             \ of the TWFL variable, and the original source has a
 EQUB &FE               \ commented out label .TWFL

 EQUD &1F3F7FFF         \ These bytes appear to be unused; they contain a copy
 EQUD &0103070F         \ of the TWFR variable, and the original source has a
                        \ commented out label .TWFR

INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2-cpixk.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/c64/main/subroutine/msbar.asm"
INCLUDE "library/6502sp/io/subroutine/newosrdch.asm"
INCLUDE "library/c64/main/subroutine/wscan.asm"
INCLUDE "library/c64/main/subroutine/chpr2.asm"
INCLUDE "library/c64/main/subroutine/r5.asm"
INCLUDE "library/c64/main/subroutine/clss.asm"
INCLUDE "library/c64/main/subroutine/rr4s.asm"
INCLUDE "library/advanced/main/subroutine/tt67-tt67k.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/c64/main/subroutine/ttx66k.asm"
INCLUDE "library/c64/main/subroutine/box2.asm"
INCLUDE "library/c64/main/subroutine/boxs.asm"
INCLUDE "library/c64/main/subroutine/boxs2.asm"
INCLUDE "library/c64/main/subroutine/wantdials.asm"
INCLUDE "library/c64/main/subroutine/zonkscanners.asm"
INCLUDE "library/c64/main/subroutine/blueband.asm"
INCLUDE "library/c64/main/subroutine/bluebands.asm"
INCLUDE "library/c64/main/subroutine/tt66simp.asm"
INCLUDE "library/advanced/main/subroutine/zes1k.asm"
INCLUDE "library/advanced/main/subroutine/zes2k.asm"
INCLUDE "library/advanced/main/subroutine/zesnew.asm"
INCLUDE "library/c64/main/subroutine/setxc.asm"
INCLUDE "library/c64/main/subroutine/setyc.asm"
INCLUDE "library/advanced/main/subroutine/mvblockk.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/common/main/subroutine/scan.asm"

\ ******************************************************************************
\
\ Save ELTJ.bin
\
\ ******************************************************************************

 PRINT "ELITE J"
 PRINT "Assembled at ", ~CODE_J%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_J%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_J%

 PRINT "S.ELTJ ", ~CODE_J%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_J%
 SAVE "versions/c64/3-assembled-output/ELTJ.bin", CODE_J%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE K FILE
\
\ Produces the binary file ELTK.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_K% = P%

 LOAD_K% = LOAD% + P% - CODE%

INCLUDE "library/c64/main/workspace/music_variables.asm"
INCLUDE "library/c64/main/subroutine/bdirqhere.asm"
INCLUDE "library/c64/main/subroutine/bdro1.asm"
INCLUDE "library/c64/main/subroutine/bdro2.asm"
INCLUDE "library/c64/main/subroutine/bdro3.asm"
INCLUDE "library/c64/main/subroutine/bdro4.asm"
INCLUDE "library/c64/main/subroutine/bdro5.asm"
INCLUDE "library/c64/main/subroutine/bdro6.asm"
INCLUDE "library/c64/main/subroutine/bdro15.asm"
INCLUDE "library/c64/main/subroutine/bdro8.asm"
INCLUDE "library/c64/main/subroutine/bdro7.asm"
INCLUDE "library/c64/main/subroutine/bdro9.asm"
INCLUDE "library/c64/main/subroutine/bdro10.asm"
INCLUDE "library/c64/main/subroutine/bdro11.asm"
INCLUDE "library/c64/main/subroutine/bdro12.asm"
INCLUDE "library/c64/main/subroutine/bdro13.asm"
INCLUDE "library/c64/main/subroutine/bdro14.asm"
INCLUDE "library/c64/main/subroutine/bdlab4.asm"
INCLUDE "library/c64/main/subroutine/bdlab6.asm"
INCLUDE "library/c64/main/subroutine/bdlab8.asm"
INCLUDE "library/c64/main/subroutine/bdlab19.asm"
INCLUDE "library/c64/main/subroutine/bdlab3.asm"
INCLUDE "library/c64/main/subroutine/bdlab5.asm"
INCLUDE "library/c64/main/subroutine/bdlab7.asm"
INCLUDE "library/c64/main/subroutine/bdentry.asm"
INCLUDE "library/c64/main/subroutine/bdlab24.asm"
INCLUDE "library/c64/main/subroutine/bdlab23.asm"
INCLUDE "library/c64/main/subroutine/bdlab1.asm"
INCLUDE "library/c64/main/subroutine/bdlab21.asm"
INCLUDE "library/c64/main/variable/bdjmptbl.asm"
INCLUDE "library/c64/main/variable/bdjmptbh.asm"
INCLUDE "library/c64/main/variable/comudat.asm"
INCLUDE "library/advanced/main/variable/f_per_cent.asm"

\ ******************************************************************************
\
\ Save ELTK.bin
\
\ ******************************************************************************

 PRINT "ELITE K"
 PRINT "Assembled at ", ~CODE_K%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_K%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_K%

 PRINT "S.ELTK ", ~CODE_K%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_J%
 SAVE "versions/c64/3-assembled-output/ELTK.bin", CODE_K%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "B% = ", ~CODE%
 PRINT "G% = ", ~G%
 PRINT "NA2% = ", ~NA2%
