\ ******************************************************************************
\
\ COMMODORE 64 ELITE GAME SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source disks released on Ian Bell's
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
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISC_FILES     = (_VARIANT = 4)
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

 CODE% = &1D00          \ The address where the code will be run

 LOAD% = &1D00          \ The address where the code will be loaded

IF _GMA85_NTSC OR _GMA86_PAL

 C% = &6A00             \ The address where the second block of game code will
                        \ be run (ELITE C onwards)

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 C% = &7300             \ The address where the second block of game code will
                        \ be run (ELITE C onwards)

ENDIF

 D% = &D000             \ The address where the ship data will be loaded
                        \ (i.e. XX21)

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

 BLUE = YELLOW          \ Ship that are set to a scanner colour of BLUE in the
                        \ scacol table will actually be shown in yellow

 CYAN = YELLOW          \ Ship that are set to a scanner colour of CYAN in the
                        \ scacol table will actually be shown in yellow

 MAG = YELLOW           \ Ship that are set to a scanner colour of MAG in the
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

 sfxeng = 8             \ Sound 8  = This sound is not defined or used

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
                        \ ignores tham

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

IF _GMA85_NTSC OR _GMA86_PAL

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

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

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

 ORG CODE%

 LOAD_A% = LOAD%

INCLUDE "library/advanced/main/workspace/option_variables.asm"
INCLUDE "library/master/main/variable/tgint.asm"
INCLUDE "library/c64/main/subroutine/s_per_cent.asm"
INCLUDE "library/master/main/subroutine/deeor.asm"
INCLUDE "library/master/main/subroutine/deeors.asm"
INCLUDE "library/advanced/main/variable/g_per_cent.asm"
INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk-cold.asm"
INCLUDE "library/advanced/main/variable/tribdir.asm"
INCLUDE "library/advanced/main/variable/tribdirh.asm"
INCLUDE "library/advanced/main/variable/spmask.asm"
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
INCLUDE "library/advanced/main/subroutine/tbrief.asm"
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
                        \ code (ELITE C onwards), which is defined in C%

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
INCLUDE "library/advanced/main/subroutine/check2.asm"
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

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &A9, &05, &20, &7F, &82, &A9, &00, &8D    \ These bytes appear to be
 EQUB &15, &D0, &A9, &04, &78, &8D, &8E, &82    \ unused and just contain random
 EQUB &A5, &01, &29, &F8, &0D, &8E, &82, &85    \ workspace noise left over from
 EQUB &01, &58, &60, &04, &A5, &2E, &8D, &F2    \ the BBC Micro assembly process
 EQUB &04, &A5, &2F, &8D, &F3, &04, &60, &A6
 EQUB &9D, &20, &F3, &82, &A6, &9D, &4C, &2F
 EQUB &20, &20, &47, &84, &20, &4F, &7B, &8D
 EQUB &53, &04, &8D, &5F, &04, &20, &0E, &B1
 EQUB &A9

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

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
INCLUDE "library/advanced/main/variable/tribta.asm"
INCLUDE "library/advanced/main/variable/tribma.asm"
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

\ ******************************************************************************
\
\       Name: RASTCT
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.RASTCT

 EQUB 0

\ ******************************************************************************
\
\       Name: zebop
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.zebop

 EQUB &81

\ ******************************************************************************
\
\       Name: abraxas
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.abraxas

 EQUB &81

\ ******************************************************************************
\
\       Name: innersec
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.innersec

 EQUB 1
 EQUB 0

\ ******************************************************************************
\
\       Name: shango
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.shango

 EQUB 51+143
 EQUB 51

\ ******************************************************************************
\
\       Name: moonflower
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Controls the energy bomb effect by switching between multicolour
\             and standard mode
\
\ ******************************************************************************

.moonflower

 EQUB %11000000   

\ ******************************************************************************
\
\       Name: caravanserai
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.caravanserai

 EQUB %11000000

\ ******************************************************************************
\
\       Name: santana
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.santana

 EQUB &FE
 EQUB &FC

\ ******************************************************************************
\
\       Name: lotus
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.lotus

 EQUB 2
 EQUB 0

\ ******************************************************************************
\
\       Name: welcome
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.welcome

 EQUB 0
 EQUB 0

\ ******************************************************************************
\
\       Name: COMIRQ1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.SOUL3b

 DEY
 BPL SOUL8
 PLA
 TAY

.COMIRQ3

 PLA
 TAX
 LDA l1
 AND #&F8
 ORA L1M
 STA l1
 PLA
 RTI

.COMIRQ1

 PHA
 LDA l1
 AND #&F8
 ORA #5
 STA l1
 \Page in I/O

.iansint

 LDA VIC+&19
 ORA #128
 STA VIC+&19
 TXA
 PHA
 LDX RASTCT
 LDA zebop,X
 STA VIC+&18
 LDA moonflower,X
 STA VIC+&16 \Mode Change
 LDA shango,X
 STA VIC+&12 \Raster
 LDA santana,X
 STA VIC+&1C \Multicol
 LDA lotus,X
 STA VIC+&28 \Sp1Col

 BIT BOMB               \ If bit 7 of BOMB is zero then the energy bomb is not
 BPL nobombef           \ currently going off, so jump to nobombef to skip the
                        \ following instruction

 INC welcome            \ The energy bomb is going off, so increment welcome so
                        \ we work our way through a range of background colours

.nobombef

 LDA welcome,X          \ Set VIC register &21 to the X-th entry in welcome, so
 STA VIC+&21            \ we flash and change the background colour while the
                        \ energy bomb is going off

 LDA innersec,X         \ ???
 STA RASTCT
 BNE COMIRQ3
 TYA
 PHA

 BIT MUPLA              \ If bit 7 of MUPLA is clear then there is no music
 BPL SOINT              \ currently playing, so jump to SOINT to make the sound
                        \ effect

 JSR BDirqhere          \ ???

 BIT MUSILLY            \ If bit 7 of MUSILLY is set then sounds are configured
 BMI SOINT              \ to be played during music, and we know that music is
                        \ already playing, so jump to SOINT to make the sound
                        \ effect

 JMP coffee             \ Otherwise sounds are configured not to play during
                        \ music, and we know that music is playins, so jmp to
                        \ coffee to return from the interrupt handler without
                        \ making the sound effect

\ ******************************************************************************
\
\       Name: SOINT
\       Type: Subroutine
\   Category: Sound
\    Summary: Process the contents of the sound buffer and send it to the sound
\             chip
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   coffee            Return from the interrupt handler
\
\ ******************************************************************************

.SOINT

 LDY #2                 \ ???

.SOUL8

 LDA SOFLG,Y
 BEQ SOUL3b
 BMI SOUL4
 LDX SEVENS,Y
 LDA SOFRCH,Y
 BEQ SOUL5
 BNE SOUX2
\EQUB &2C

.SOUL4

 LDA SEVENS,Y
 STA SOUX3+1 \ %%
 LDA #0
 LDX #6

.SOUX3

 STA SID,X
 DEX
 BPL SOUX3
 LDX SEVENS,Y
 LDA SOCR,Y
 STA SID+4,X
 LDA SOATK,Y
 STA SID+5,X
 LDA SOSUS,Y
 STA SID+6,X
 LDA #0

.SOUX2

 CLC
 CLD
 ADC SOFRQ,Y
 STA SOFRQ,Y
 PHA
 LSR A
 LSR A
 STA SID+1,X
 PLA
 ASL A
 ASL A
 ASL A
 ASL A
 ASL A
 ASL A
 STA SID,X
 LDA PULSEW
 STA SID+3,X

.SOUL5

 LDA SOFLG,Y
 BMI SOUL6
 TYA
 TAX
 DEC SOPR,X
 BNE P%+5
 INC SOPR,X
 DEC SOCNT,X
 BEQ SOKILL
 LDA SOCNT,X
 AND SOVCH,Y
 BNE SOUL3
 LDA SOSUS,Y
 SEC
 SBC #16
 STA SOSUS,Y
 LDX SEVENS,Y
 STA SID+6,X
 JMP SOUL3

.SOKILL

 LDX SEVENS,Y
 LDA SOCR,Y
 AND #&FE
 STA SID+4,X
 LDA #0
 STA SOFLG,Y
 STA SOPR,Y
 BEQ SOUL3

.SOUL6

 AND #127
 STA SOFLG,Y

.SOUL3

 DEY
 BMI P%+5
 JMP SOUL8 \**
 LDA PULSEW
 EOR #4
 STA PULSEW
\LDA #1
\STA intcnt

.coffee

 PLA
 TAY
 PLA
 TAX
 LDA l1
 AND #&F8
 ORA L1M
 STA l1
 PLA
 RTI

\ ******************************************************************************
\
\       Name: Sound variables
\       Type: Workspace
\   Category: Sound
\    Summary: The sound buffer where the data to be sent to the sound chip is
\             processed
\
\ ******************************************************************************

INCLUDE "library/advanced/main/variable/soflg.asm"
INCLUDE "library/advanced/main/variable/socnt.asm"
INCLUDE "library/advanced/main/variable/sopr.asm"

.PULSEW

 EQUB 2                 \ ???

INCLUDE "library/advanced/main/variable/sofrch.asm"
INCLUDE "library/advanced/main/variable/sofrq.asm"

.SOCR

 EQUB 0                 \ ???
 EQUB 0
 EQUB 0

.SOATK

 EQUB 0                 \ ???
 EQUB 0
 EQUB 0

.SOSUS

 EQUB 0                 \ ???
 EQUB 0
 EQUB 0

INCLUDE "library/advanced/main/variable/sovch.asm"

\ ******************************************************************************
\
\       Name: SEVENS
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SEVENS

 EQUB 0                 \ ???
 EQUB 7
 EQUB 14

\ ******************************************************************************
\
\       Name: SFXPR
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

 \        0-Plas  1-Elas  2-Hit   3-Expl  4-Whosh 5-Beep  6-Boop  7-Hyp1  8-Eng   9-ECM  10-Blas 11-Alas 12-Mlas          14-Trib

.SFXPR

 EQUB &72               \ ???
 EQUB &70
 EQUB &74
 EQUB &77
 EQUB &73
 EQUB &68
 EQUB &60
 EQUB &F0
 EQUB &30
 EQUB &FE
 EQUB &72
 EQUB &72
 EQUB &92
 EQUB &E1
 EQUB &51
 EQUB &02

\ ******************************************************************************
\
\       Name: SFXCNT
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXCNT

 EQUB &14               \ ???
 EQUB &0E
 EQUB &0C
 EQUB &50
 EQUB &3F
 EQUB &05
 EQUB &18
 EQUB &80
 EQUB &30
 EQUB &FF
 EQUB &10
 EQUB &10
 EQUB &70
 EQUB &40
 EQUB &0F
 EQUB &0E

\ ******************************************************************************
\
\       Name: SFXFQ
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXFQ

 EQUB &45               \ ???
 EQUB &48
 EQUB &D0
 EQUB &51
 EQUB &40
 EQUB &F0
 EQUB &40
 EQUB &80
 EQUB &10
 EQUB &50
 EQUB &34
 EQUB &33
 EQUB &60
 EQUB &55
 EQUB &80
 EQUB &40

\ ******************************************************************************
\
\       Name: SFXCR
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXCR

 EQUB &41               \ ???
 EQUB &11
 EQUB &81
 EQUB &81
 EQUB &81
 EQUB &11
 EQUB &11
 EQUB &41
 EQUB &21
 EQUB &41
 EQUB &21
 EQUB &21
 EQUB &11
 EQUB &81
 EQUB &11
 EQUB &21

\ ******************************************************************************
\
\       Name: SFXATK
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXATK

 EQUB &01               \ ???
 EQUB &09
 EQUB &20
 EQUB &08
 EQUB &0C
 EQUB &00
 EQUB &63
 EQUB &18
 EQUB &44
 EQUB &11
 EQUB &00
 EQUB &00
 EQUB &44
 EQUB &11
 EQUB &18
 EQUB &09

\ ******************************************************************************
\
\       Name: SFXSUS
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXSUS

 EQUB &D1               \ ???
 EQUB &F1
 EQUB &E5
 EQUB &FB
 EQUB &DC
 EQUB &F0
 EQUB &F3
 EQUB &D8
 EQUB &00
 EQUB &E1
 EQUB &E1
 EQUB &F1
 EQUB &F4
 EQUB &E3
 EQUB &B0
 EQUB &A1

\ ******************************************************************************
\
\       Name: SFXFRCH
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXFRCH

 EQUB &FE               \ ???
 EQUB &FE
 EQUB &F3
 EQUB &FF
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &44
 EQUB &00
 EQUB &55
 EQUB &FE
 EQUB &FF
 EQUB &EF
 EQUB &77
 EQUB &7B
 EQUB &FE

\ ******************************************************************************
\
\       Name: SFXVCH
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFXVCH

 EQUB &03               \ ???
 EQUB &03
 EQUB &03
 EQUB &0F
 EQUB &0F
 EQUB &FF
 EQUB &FF
 EQUB &1F
 EQUB &FF
 EQUB &FF
 EQUB &03
 EQUB &03
 EQUB &0F
 EQUB &FF
 EQUB &FF
 EQUB &03

INCLUDE "library/c64/main/subroutine/cold.asm"
INCLUDE "library/advanced/main/subroutine/nmipissoff.asm"

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

\ ******************************************************************************
\
\       Name: STARTUP
\       Type: Subroutine
\   Category: Loader
\    Summary: Set the various vectors, interrupts and timers
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.STARTUP

 LDA #&FF               \ Set COL to &FF, which would set the colour to green
 STA COL                \ for a dashboard indicator (though this code is never
                        \ run)

                        \ Fall through into PUTBACK to return from the
                        \ subroutine

\ ******************************************************************************
\
\       Name: PUTBACK
\       Type: Subroutine
\   Category: Tube
\    Summary: Reset the OSWRCH vector in WRCHV to point to USOSWRCH
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.PUTBACK

\LDA #128               \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DOHFX
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Implement the #DOHFX <flag> command (update the hyperspace effect
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.DOHFX

\STA HFX                \ These instructions are commented out in the original
\JMP PUTBACK            \ source

\ ******************************************************************************
\
\       Name: DOCOL
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #SETCOL <colour> command (set the current colour)
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.DOCOL

 STA COL                \ Store the new colour in COL

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DOSVN
\       Type: Subroutine
\   Category: Save and load
\    Summary: Implement the #DOSVN <flag> command (update the "save in progress"
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.DOSVN

\STA svn                \ These instructions are commented out in the original
\JMP PUTBACK            \ source

INCLUDE "library/common/main/variable/twos.asm"

\ ******************************************************************************
\
\       Name: DTWOS
\       Type: Variable
\   Category: Drawing pixels
\    Summary: ???
\
\ ******************************************************************************

.DTWOS

 EQUD &030C30C0

 EQUD &3060C0C0         \ These bytes appear to be unused; they contain a copy
 EQUD &03060C18         \ of the TWOS2 variable, and the original source has a
                        \ commented out label .TWOS2

\ ******************************************************************************
\
\       Name: CTWOS2
\       Type: Variable
\   Category: Drawing pixels
\    Summary: ???
\
\ ******************************************************************************

.CTWOS2

 EQUD &3030C0C0
 EQUD &03030C0C
 EQUW &C0C0

\ ******************************************************************************
\
\       Name: LIJT1
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT1

 EQUB LO(LI81)
 EQUB LO(LI82)
 EQUB LO(LI83)
 EQUB LO(LI84)
 EQUB LO(LI85)
 EQUB LO(LI86)
 EQUB LO(LI87)
 EQUB LO(LI88)

\ ******************************************************************************
\
\       Name: LIJT2
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT2

 EQUB HI(LI81)
 EQUB HI(LI82)
 EQUB HI(LI83)
 EQUB HI(LI84)
 EQUB HI(LI85)
 EQUB HI(LI86)
 EQUB HI(LI87)
 EQUB HI(LI88)

\ ******************************************************************************
\
\       Name: LIJT3
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT3

 EQUB LO(LI81+6)
 EQUB LO(LI82+6)
 EQUB LO(LI83+6)
 EQUB LO(LI84+6)
 EQUB LO(LI85+6)
 EQUB LO(LI86+6)
 EQUB LO(LI87+6)
 EQUB LO(LI88+6)

\ ******************************************************************************
\
\       Name: LIJT4
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT4

 EQUB HI(LI81+6)
 EQUB HI(LI82+6)
 EQUB HI(LI83+6)
 EQUB HI(LI84+6)
 EQUB HI(LI85+6)
 EQUB HI(LI86+6)
 EQUB HI(LI87+6)
 EQUB HI(LI88+6)

\ ******************************************************************************
\
\       Name: LIJT5
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT5

 EQUB LO(LI21)
 EQUB LO(LI22)
 EQUB LO(LI23)
 EQUB LO(LI24)
 EQUB LO(LI25)
 EQUB LO(LI26)
 EQUB LO(LI27)
 EQUB LO(LI28)

\ ******************************************************************************
\
\       Name: LIJT6
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT6

 EQUB HI(LI21)
 EQUB HI(LI22)
 EQUB HI(LI23)
 EQUB HI(LI24)
 EQUB HI(LI25)
 EQUB HI(LI26)
 EQUB HI(LI27)
 EQUB HI(LI28)

\ ******************************************************************************
\
\       Name: LIJT7
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT7

 EQUB LO(LI21+6)
 EQUB LO(LI22+6)
 EQUB LO(LI23+6)
 EQUB LO(LI24+6)
 EQUB LO(LI25+6)
 EQUB LO(LI26+6)
 EQUB LO(LI27+6)
 EQUB LO(LI28+6)

\ ******************************************************************************
\
\       Name: LIJT8
\       Type: Variable
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.LIJT8

 EQUB HI(LI21+6)
 EQUB HI(LI22+6)
 EQUB HI(LI23+6)
 EQUB HI(LI24+6)
 EQUB HI(LI25+6)
 EQUB HI(LI26+6)
 EQUB HI(LI27+6)
 EQUB HI(LI28+6)

INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"

\ ******************************************************************************
\
\       Name: LOIN (Part 3 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a shallow line going right and up or left and down
\  Deep dive: Bresenham's line algorithm
\
\ ******************************************************************************

 LDA X1
 AND #&F8
 CLC
 ADC ylookupl,Y
 STA SC
 LDA ylookuph,Y
 ADC #0
 STA SC+1
 TYA
 AND #7
 TAY
 LDA X1
 AND #7
 TAX
 BIT SWAP
 BMI LI70
 LDA LIJT1,X
 STA LI71+1
 LDA LIJT2,X
 STA LI71+2
 LDX P2

.LI71

 JMP &8888 \~~!!

.LI70

 LDA LIJT3,X
 STA LI72+1
 LDA LIJT4,X
 STA LI72+2
 LDX P2
 INX
 BEQ LIE1 \ **

.LI72

 JMP &8888 \~~!!

.LIE1

 LDY YSAV
 RTS

.LI81

 LDA #&80
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE1
 LDA S2
 ADC Q2
 STA S2
 BCC LI82
 DEY
 BPL LI82-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI82

 LDA #&40
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE1
 LDA S2
 ADC Q2
 STA S2
 BCC LI83
 DEY
 BPL LI83-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI83

 LDA #&20
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE1
 LDA S2
 ADC Q2
 STA S2
 BCC LI84
 DEY
 BPL LI84-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI84

 LDA #&10
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE1
 LDA S2
 ADC Q2
 STA S2
 BCC LI85
 DEY
 BPL LI85-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI85

 LDA #&08
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE0S
 LDA S2
 ADC Q2
 STA S2
 BCC LI86
 DEY
 BPL LI86-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI86

 LDA #&04
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE0
 LDA S2
 ADC Q2
 STA S2
 BCC LI87
 DEY
 BPL LI87-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI87

 LDA #&02
 EOR (SC),Y
 STA (SC),Y
 DEX

.LIE0S

 BEQ LIE0
 LDA S2
 ADC Q2
 STA S2
 BCC LI88
 DEY
 BPL LI88-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI88

 LDA #&01
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE0
 LDA S2
 ADC Q2
 STA S2
 BCC LI89
 DEY
 BPL LI89-1
 LDA SC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1
 LDY #7
 CLC

.LI89

 LDA SC
 ADC #8
 STA SC
 BCS P%+5
 JMP LI81
 INC SC+1
 JMP LI81

.LIE0

 LDY YSAV
 RTS

\ ******************************************************************************
\
\       Name: LOIN (Part 4 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a shallow line going right and down or left and up
\  Deep dive: Bresenham's line algorithm
\
\ ******************************************************************************

.DOWN

 LDA ylookuph,Y
 STA SC+1
 LDA X1
 AND #&F8
 ADC ylookupl,Y
 STA SC
 BCC P%+5
 INC SC+1
 CLC
 SBC #&F7
 STA SC
 BCS P%+4
 DEC SC+1
 TYA
 AND #7
 EOR #&F8
 TAY
 LDA X1
 AND #7
 TAX
 BIT SWAP
 BMI LI90
 LDA LIJT5,X
 STA LI91+1
 LDA LIJT6,X
 STA LI91+2
 LDX P2
 BEQ LIE0

.LI91

 JMP &8888 \~~!!

.LI90

 LDA LIJT7,X
 STA LI92+1
 LDA LIJT8,X
 STA LI92+2
 LDX P2
 INX
 BEQ LIE0 \ **

.LI92

 JMP &8888 \~~!!

.LIE3

 LDY YSAV
 RTS

.LI21

 LDA #&80
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE3
 LDA S2
 ADC Q2
 STA S2
 BCC LI22
 INY
 BNE LI22-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI22

 LDA #&40
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE3
 LDA S2
 ADC Q2
 STA S2
 BCC LI23
 INY
 BNE LI23-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI23

 LDA #&20
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE3
 LDA S2
 ADC Q2
 STA S2
 BCC LI24
 INY
 BNE LI24-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI24

 LDA #&10
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE2S
 LDA S2
 ADC Q2
 STA S2
 BCC LI25
 INY
 BNE LI25-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI25

 LDA #&08
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE2S
 LDA S2
 ADC Q2
 STA S2
 BCC LI26
 INY
 BNE LI26-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI26

 LDA #&04
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE2
 LDA S2
 ADC Q2
 STA S2
 BCC LI27
 INY
 BNE LI27-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI27

 LDA #&02
 EOR (SC),Y
 STA (SC),Y
 DEX

.LIE2S

 BEQ LIE2
 LDA S2
 ADC Q2
 STA S2
 BCC LI28
 INY
 BNE LI28-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI28

 LDA #&01
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIE2
 LDA S2
 ADC Q2
 STA S2
 BCC LI29
 INY
 BNE LI29-1
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 LDY #&F8
 CLC

.LI29

 LDA SC
 ADC #8
 STA SC
 BCC P%+4
 INC SC+1
 JMP LI21

.LIE2

 LDY YSAV
 RTS

\ ******************************************************************************
\
\       Name: LOIN (Part 5 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Line has a steep gradient, step up along y-axis
\  Deep dive: Bresenham's line algorithm
\
\ ******************************************************************************

.STPY

 LDY Y1
 TYA
 LDX X1
 CPY Y2
 BCS LI15
 DEC SWAP
 LDA X2
 STA X1
 STX X2
 TAX
 LDA Y2
 STA Y1
 STY Y2
 TAY

.LI15

 TXA
 AND #&F8
 CLC
 ADC ylookupl,Y
 STA SC
 LDA ylookuph,Y
 ADC #0
 STA SC+1
 TYA
 AND #7
 TAY
 TXA
 AND #7
 TAX
 LDA TWOS,X
 STA R2
 LDX P2
 BEQ LIfudge
 LDA logL,X
 LDX Q2
 SEC
 SBC logL,X
 BMI LIloG
 LDX P2
 LDA log,X
 LDX Q2
 SBC log,X
 BCS LIlog3
 TAX
 LDA antilog,X
 JMP LIlog2

.LIlog3

 LDA #&FF
 BNE LIlog2

.LIloG

 LDX P2
 LDA log,X
 LDX Q2
 SBC log,X
 BCS LIlog3
 TAX
 LDA antilogODD,X

.LIlog2

 STA P2

.LIfudge

 SEC
 LDX Q2
 INX
 LDA X2
 SBC X1
 BCC LFT

\ ******************************************************************************
\
\       Name: LOIN (Part 6 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and left or down and right
\  Deep dive: Bresenham's line algorithm
\
\ ******************************************************************************

 CLC
 LDA SWAP
 BEQ LI17
 DEX

.LIL5

 LDA R2
 EOR (SC),Y
 STA (SC),Y

.LI17

 DEY
 BPL LI16
 LDA SC
 SBC #&3F
 STA SC
 LDA SCH
 SBC #1
 STA SCH
 LDY #7

.LI16

 LDA S2
 ADC P2
 STA S2
 BCC LIC5
 LSR R2
 BCC LIC5
 ROR R2
 LDA SC
 ADC #8
 STA SC
 BCC P%+5
 INC SCH
 CLC

.LIC5

 DEX
 BNE LIL5
 LDY YSAV
 RTS

\ ******************************************************************************
\
\       Name: LOIN (Part 7 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and right or down and left
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   HL6                 Contains an RTS
\
\ ******************************************************************************

.LFT

 LDA SWAP
 BEQ LI18
 DEX

.LIL6

 LDA R2
 EOR (SC),Y
 STA (SC),Y

.LI18

 DEY
 BPL LI19
 LDA SC
 SBC #&3F
 STA SC
 LDA SCH
 SBC #1
 STA SCH
 LDY #7

.LI19

 LDA S2
 ADC P2
 STA S2
 BCC LIC6
 ASL R2
 BCC LIC6
 ROL R2
 LDA SC
 SBC #7
 STA SC
 BCS P%+4
 DEC SCH
 CLC

.LIC6

 DEX
 BNE LIL6
 LDY YSAV

.HL6

 RTS

\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
\
\ ******************************************************************************

.HLOIN

 STY YSAV
 LDX X1
 CPX X2
 BEQ HL6
 BCC HL5
 LDA X2
 STA X1
 STX X2
 TAX

.HL5

 DEC X2
 LDA Y1
 TAY
 AND #7
 STA SC
 LDA ylookuph,Y
 STA SC+1
 TXA
 AND #&F8
 CLC
 ADC ylookupl,Y
 TAY
 BCC P%+4
 INC SC+1

.HL1

 TXA
 AND #&F8
 STA T2
 LDA X2
 AND #&F8
 SEC
 SBC T2

 BEQ HL2
 LSR A
 LSR A
 LSR A

 STA R2
 LDA X1
 AND #7
 TAX
 LDA TWFR,X
 EOR (SC),Y
 STA (SC),Y
 TYA
 ADC #8
 TAY
 BCC P%+4
 INC SC+1
 LDX R2

 DEX
 BEQ HL3
 CLC

.HLL1

 LDA #&FF
 EOR (SC),Y
 STA (SC),Y
 TYA
 ADC #8
 TAY
 BCC P%+5
 INC SC+1
 CLC
 DEX
 BNE HLL1

.HL3

 LDA X2
 AND #7
 TAX
 LDA TWFL,X
 EOR (SC),Y
 STA (SC),Y
 LDY YSAV
 RTS

.HL2

 LDA X1
 AND #7
 TAX

 LDA TWFR,X
 STA T2
 LDA X2
 AND #7
 TAX
 LDA TWFL,X
 AND T2
 EOR (SC),Y
 STA (SC),Y

 LDY YSAV
 RTS

 EQUD &F0E0C080         \ These bytes appear to be unused; they contain a copy
 EQUW &FCF8             \ of the TWFL variable, and the original source has a
 EQUB &FE               \ commented out label .TWFL

 EQUD &1F3F7FFF         \ These bytes appear to be unused; they contain a copy
 EQUD &0103070F         \ of the TWFR variable, and the original source has a
                        \ commented out label .TWFR

INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"

\ ******************************************************************************
\
\       Name: CPIX2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single-height dash on the dashboard
\
\ ******************************************************************************

.CPIX2

 LDY Y1
 LDA X1
 AND #&F8
 CLC
 ADC ylookupl,Y
 STA SC
 LDA ylookuph,Y
 ADC #0
 STA SC+1
 TYA
 AND #7
 TAY
 LDA X1
 AND #7
 TAX
 LDA CTWOS2,X
 AND COL
 EOR (SC),Y
 STA (SC),Y
\JSR P%+3
\INX
 LDA CTWOS2+2,X
 BPL CP1
 LDA SC
 CLC
 ADC #8
 STA SC
 BCC P%+4
 INC SC+1
 LDA CTWOS2+2,X

.CP1

 AND COL
 EOR (SC),Y
 STA (SC),Y
 RTS

INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/c64/main/subroutine/msbar.asm"
INCLUDE "library/6502sp/io/subroutine/newosrdch.asm"

\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Wait for the vertical sync
\
\ ******************************************************************************

.WSCAN

 PHA                    \ ???

.WSC1

 LDA RASTCT
 BEQ WSC1

.WSC2

 LDA RASTCT
 BNE WSC2
 PLA
 RTS

\ ******************************************************************************
\
\       Name: CHPR2
\       Type: Subroutine
\   Category: Text
\    Summary: Character print vector handler
\
\ ******************************************************************************

.CHPR2

 CMP #123               \ ???
 BCS whosentthisshit
 CMP #13
 BCC whosentthisshit
 BNE CHPR
 LDA #12
 JSR CHPR
 LDA #13

.whosentthisshit

 CLC
 RTS  \ tape CHPR

\ ******************************************************************************
\
\       Name: R5
\       Type: Subroutine
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.R5

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

\ ******************************************************************************
\
\       Name: clss
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the top part of the screen and ???
\
\ ******************************************************************************

.clss

 JSR TT66simp
 LDA K3
 JMP RRafter

\ ******************************************************************************
\
\       Name: RR4S
\       Type: Subroutine
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.RR4S

 JMP RR4

INCLUDE "library/advanced/main/subroutine/tt67-tt67x.asm"

\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RR4                 Restore the registers and return from the subroutine
\
\ ******************************************************************************

.CHPR

 \PRINT   Rewrite for Mode 4 Map

 STA K3                 \ ???
 STY YSAV2
 STX XSAV2
 LDY QQ17
 CPY #&FF
 BEQ RR4S

.RRafter

 CMP #7
 BEQ R5
 CMP #32
 BCS RR1
 CMP #10
 BEQ RRX1

.RRX2

 LDX #1
 STX XC

.RRX1

 CMP #13
 BEQ RR4S
 INC YC
 BNE RR4S

.RR1

 TAY
 LDX #HI(FONT)-1
 ASL A
 ASL A
 BCC P%+4
 LDX #HI(FONT)+1
 ASL A
 BCC P%+3
 INX
 STA P+1
 STX P+2
 LDA XC
 CMP #31
 BCS RRX2
 LDA #128
 STA SC
 LDA YC
 CMP #24
 BCC RR3
 JMP clss

.RR3

 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC YC
 ADC #HI(SCBASE)
 STA SC+1
 LDA XC
 ASL A
 ASL A
 ASL A
 ADC SC
 STA SC
 BCC P%+4
 INC SC+1
 CPY #&7F
 BNE RR2
 DEC XC
 DEC SC+1
 LDY #&F8
 JSR ZESNEW
 BEQ RR4

.RR2

 INC XC
 EQUB &2C
 STA SC+1
 LDY #7

.RRL1

 LDA (P+1),Y
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL RRL1

 LDY YC                 \ Set SC(1 0) to the address of the start of the current
 LDA celllookl,Y        \ text row in screen RAM, by looking up the address from
 STA SC                 \ the celllookl and celllookh tables for the row given
 LDA celllookh,Y        \ in YC
 STA SC+1               \
                        \ In the text view, screen RAM is used to determine the
                        \ colour of each on-screen character, so SC(1 0) is now
                        \ set to the address of the colour information for the
                        \ start of the current text row

 LDY XC                 \ Set the contents of SC(1 0) + XC to COL2
 LDA COL2               \
 STA (SC),Y             \ This sets the XC-th byte in SC(1 0) to COL2, which
                        \ sets the colour information for the XC-th character in
                        \ the current text row to COL2 - in other words, this
                        \ sets the colour of the character we just drew to COL2

.RR4

 LDY YSAV2
 LDX XSAV2
 LDA K3
 CLC
 RTS \must exit CHPR with C = 0

\ ******************************************************************************
\
\       Name: TTX66K
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the top part of the screen and draw a white border
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen (the space view) and draw a white border
\ along the top and sides.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BOX                 Just draw the white border along the top and sides
\
\ ******************************************************************************

.TTX66K

 LDA #4                 \ ???
 STA SC
 LDA #&60
 STA SC+1
 LDX #24

.BOL3

 LDA #&10
 LDY #31

.BOL4

 STA (SC),Y
 DEY
 BPL BOL4
 LDA SC
 CLC
 ADC #40
 STA SC
 BCC P%+4
 INC SC+1
 DEX
 BNE BOL3
 LDX #HI(SCBASE)

.BOL1

 JSR ZES1k
 INX
 CPX #HI(DLOC%)
 BNE BOL1
 LDY #LO(DLOC%)-1
 JSR ZES2k
 STA (SC),Y \ <<
 LDA #1
 STA XC
 STA YC
 LDA QQ11
 BEQ wantSTEP
 CMP #13
 BNE P%+5

.wantSTEP

 JMP wantdials
 LDA #&81
 STA abraxas
 LDA #&C0
 STA caravanserai

.BOL2

 JSR ZES1k
 INX
 CPX #HI(SCBASE)+&20
 BNE BOL2
 LDX #0
 STX COMC
 STX DFLAG
 INX
 STX XC
 STX YC
 JSR BLUEBAND
 JSR zonkscanners

 JSR NOSPRITES          \ Call NOSPRITES to disable all sprites and remove them
                        \ from the screen

 LDY #31
 LDA #&70

.BOL5

 STA &6004,Y
 DEY
 BPL BOL5 \Top Row Yellow
 LDX QQ11
 CPX #2
 BEQ BOX
 CPX #64
 BEQ BOX
 CPX #128
 BEQ BOX
 LDY #31

.BOL6

 STA &6054,Y
 DEY
 BPL BOL6 \Third Row Yellow

.BOX

 LDX #199
 JSR BOXS
 LDA #&FF
 STA SCBASE+&1F1F \ <<
 LDX #25
 EQUB &2C

.BOX2

 LDX #18
 STX T2
 LDY #LO(SCBASE+&18)
 STY SC
 LDY #HI(SCBASE+&18)
 LDA #3
 JSR BOXS2
 LDY #LO(SCBASE+&120)
 STY SC
 LDY #HI(SCBASE+&120)
 LDA #&C0
 LDX T2

 JSR BOXS2
 LDA #1
 STA SCBASE+&118 \ <<
 LDX #0

.BOXS

 STX Y1

 LDX #0
 STX X1
 DEX
 STX X2
 JMP HLOIN

.BOXS2

 STA R2
 STY SC+1

.BOXL2

 LDY #7

.BOXL3

 LDA R2
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL BOXL3
 LDA SC
 CLC
 ADC #&40
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 DEX
 BNE BOXL2

 RTS

\ ******************************************************************************
\
\       Name: wantdials
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.wantdials

 JSR BOX2
 LDA #&91
 STA abraxas
 LDA #&D0
 STA caravanserai
 LDA DFLAG
 BNE nearlyxmas
 LDX #8
 LDA #LO(DSTORE%)
 STA V
 LDA #HI(DSTORE%)
 STA V+1
 LDA #LO(DLOC%)
 STA SC
 LDA #HI(DLOC%)
 STA SC+1
 JSR mvblockK
 LDY #&C0
 LDX #1
 JSR mvbllop
 JSR zonkscanners
 JSR DIALS

.nearlyxmas

 JSR BLUEBAND

 JSR NOSPRITES          \ Call NOSPRITES to disable all sprites and remove them
                        \ from the screen

 LDA #&FF
 STA DFLAG
 RTS

\ ******************************************************************************
\
\       Name: zonkscanners
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.zonkscanners

 LDX #0

.zonkL

 LDA FRIN,X
 BEQ zonk1
 BMI zonk2
 JSR GINF
 LDY #31
 LDA (INF),Y
 AND #&EF
 STA (INF),Y

.zonk2

 INX
 BNE zonkL

.zonk1

 RTS

\ ******************************************************************************
\
\       Name: BLUEBAND
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.BLUEBAND

 LDX #LO(SCBASE)
 LDY #HI(SCBASE)
 JSR BLUEBANDS
 LDX #LO(SCBASE+&128)
 LDY #HI(SCBASE+&128)

.BLUEBANDS

 STX SC
 STY SC+1
 LDX #18

.BLUEL2

 LDY #23

.BLUEL1

 LDA #&FF
 STA (SC),Y
 DEY
 BPL BLUEL1
 LDA SC
 CLC
 ADC #&40
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 DEX
 BNE BLUEL2
 RTS

\ ******************************************************************************
\
\       Name: TT66simp
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.TT66simp

 LDX #8
 LDY #0
 CLC

.T6SL1

 LDA ylookupl,X
 STA SC
 LDA ylookuph,X
 STA SC+1
 TYA

.T6SL2

 STA (SC),Y
 DEY
 BNE T6SL2
 TXA
 ADC #8
 TAX
 CMP #24*8
 BCC T6SL1
 INY
 STY XC
 STY YC
 RTS

INCLUDE "library/advanced/main/subroutine/zes1k.asm"
INCLUDE "library/advanced/main/subroutine/zes2k.asm"
INCLUDE "library/advanced/main/subroutine/zesnew.asm"

\ ******************************************************************************
\
\       Name: SETXC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specific column
\
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text column
\
\ ******************************************************************************

.SETXC

 STA XC                 \ Store the new text column in XC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SETYC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specific row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text row
\
\ ******************************************************************************

.SETYC

 STA YC                 \ Store the new text row in YC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

INCLUDE "library/advanced/main/subroutine/mvblockk.asm"

\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the bottom two text rows of the visible screen ???
\
\ ******************************************************************************

.CLYNS

 LDA #0
 STA DLY
 STA de

.CLYNS2

 LDA #&FF
 STA DTW2
 LDA #128
 STA QQ17
 LDA #21
 STA YC
 LDA #1
 STA XC
 LDA #HI(SCBASE)+&1A
 STA SC+1
 LDA #&60
 STA SC
 LDX #3

.CLYLOOP2

 LDA #0
 TAY

.CLYLOOP

 STA (SC),Y
 DEY
 BNE CLYLOOP
 CLC
 LDA SC
 ADC #&40
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1
 DEX
 BNE CLYLOOP2

\ ******************************************************************************
\
\       Name: SCAN
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Display the current ship on the scanner
\  Deep dive: The 3D scanner
\
\ ******************************************************************************

.SCR1

 RTS                    \ Return from the subroutine

.SCAN

 LDA QQ11               \ ???
 BNE SCR1
 LDA INWK+31
 AND #16
 BEQ SCR1
 LDX TYPE
 BMI SCR1
 LDA scacol,X
 STA COL
 LDA INWK+1
 ORA INWK+4
 ORA INWK+7
 AND #&C0
 BNE SCR1
 LDA INWK+1
 CLC
 LDX INWK+2
 BPL SC2
 EOR #&FF
 ADC #1

.SC2

 ADC #123
 STA X1
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDX INWK+8
 BPL SC3
 EOR #&FF
 SEC

.SC3

 ADC #83 \35
 EOR #&FF
 STA SC
 LDA INWK+4
 LSR A
 CLC
 LDX INWK+5
 BMI SCD6
 EOR #&FF
 SEC

.SCD6

 ADC SC
\BPL ld246
 CMP #146 \194
 BCS P%+4
 LDA #146
 CMP #199 \247
 BCC P%+4

.ld246

 LDA #198 \246
 STA Y1
 SEC
 SBC SC
 PHP
\BCS SC48
\EOR #&FF
\ADC #1

.SC48

 PHA
 JSR CPIX4
 LDA CTWOS2+2,X
 AND COL
 STA X1
 PLA
 PLP
 TAX
 BEQ RTS
 BCC VL3

.VLL1

 DEY
 BPL VL1
 LDY #7
 LDA SC
 SEC
 SBC #&40
 STA SC
 LDA SC+1
 SBC #1
 STA SC+1

.VL1

 LDA X1
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS

.VL3

 INY
 CPY #8
 BNE VLL2
 LDY #0
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1

.VLL2

 INY
 CPY #8
 BNE VL2
 LDY #0
 LDA SC
 ADC #&3F
 STA SC
 LDA SC+1
 ADC #1
 STA SC+1

.VL2

 LDA X1
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE VLL2
 RTS

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

\ ******************************************************************************
\
\       Name: value0
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.value0

 EQUB 0

\ ******************************************************************************
\
\       Name: value1
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.value1

 EQUB 0

\ ******************************************************************************
\
\       Name: value2
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.value2

 EQUB 0

\ ******************************************************************************
\
\       Name: value3
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.value3

 EQUB 0

\ ******************************************************************************
\
\       Name: value4
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.value4

 EQUB 0

\ ******************************************************************************
\
\       Name: value5
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

IF _GMA85_NTSC OR _GMA86_PAL

.value5

 EQUW &8888

ENDIF

\ ******************************************************************************
\
\       Name: BDirqhere
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ The following comments appear in the original source:
\
\ Music driver by Dave Dunn.
\
\ BBC source code converted from Commodore disassembly extremely badly
\ Jez. 13/4/85.
\
\ Music system (c)1985 D.Dunn.
\ Modified by IB,DB
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BDskip1             ???
\
\ ******************************************************************************

.BDirqhere

 LDY #0
 CPY counter
 BEQ BDskip1
 DEC counter
 JMP BDlab1

.BDskip1

 LDA BDBUFF
 CMP #16
 BCS BDLABEL2
 TAX
 BNE BDLABEL
 JSR BDlab19
 STA BDBUFF

.BDLABEL2

 AND #&F
 TAX

.BDLABEL

 LDA BDBUFF
 LSR A
 LSR A
 LSR A
 LSR A
 STA BDBUFF
 LDA BDJMPTBL-1,X
 STA BDJMP+1
 LDA BDJMPTBH-1,X
 STA BDJMP+2

.BDJMP

 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO1
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO1

 JSR BDlab3
 JSR BDlab4
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO2
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO2

 JSR BDlab5
 JSR BDlab6
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO3
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO3

 JSR BDlab7
 JSR BDlab8
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO4
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO4

 JSR BDlab3
 JSR BDlab5
 JSR BDlab4
 JSR BDlab6
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO5
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO5

 JSR BDlab3
 JSR BDlab5
 JSR BDlab7
 JSR BDlab4
 JSR BDlab6
 JSR BDlab8
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO6
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO6

 INC value0
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO15
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO15

 LDA BDBUFF
 SEC
 ROL A
 ASL A
 ASL A
 ASL A
 STA BDBUFF

\ ******************************************************************************
\
\       Name: BDRO8
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO8

 LDA value4
 STA counter
 JMP BDirqhere

\ ******************************************************************************
\
\       Name: BDRO7
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO7

 JSR BDlab19
 STA &D405
 JSR BDlab19
 STA &D40C
 JSR BDlab19
 STA &D413
 JSR BDlab19
 STA &D406
 JSR BDlab19
 STA &D40D
 JSR BDlab19
 STA &D414
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO9
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO9

 LDA #0
 STA BDBUFF
 LDA BDdataptr3   \Repeat
 STA BDdataptr1
 LDA BDdataptr4
 STA BDdataptr2
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO10
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO10

 JSR BDlab19
 STA &D402
 JSR BDlab19
 STA &D403
 JSR BDlab19
 STA &D409
 JSR BDlab19
 STA &D40A
 JSR BDlab19
 STA &D410
 JSR BDlab19
 STA &D411
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO11
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO11

 JMP BDRO9

\ ******************************************************************************
\
\       Name: BDRO12
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO12

 JSR BDlab19
 STA value4
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO13
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO13

 JSR BDlab19
 STA value1
 JSR BDlab19
 STA value2
 JSR BDlab19
 STA value3
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDRO14
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDRO14

 JSR BDlab19
 STA &D418
 JSR BDlab19
 STA &D417
 JSR BDlab19
 STA &D416
 JMP BDskip1

\ ******************************************************************************
\
\       Name: BDlab4
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab4

 LDA value1
 STY &D404
 STA &D404
 RTS

\ ******************************************************************************
\
\       Name: BDlab6
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab6

 LDA value2
 STY &D40B
 STA &D40B
 RTS

\ ******************************************************************************
\
\       Name: BDlab8
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab8

 LDA value3
 STY &D412
 STA &D412
 RTS

\ ******************************************************************************
\
\       Name: BDlab19
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab19

 INC BDdataptr1
 BNE BDskipme1
 INC BDdataptr1+1

.BDskipme1

 LDA (BDdataptr1),Y
 RTS

\ ******************************************************************************
\
\       Name: BDlab3
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab3

 JSR BDlab19
 STA &D401
 JSR BDlab19
 STA &D400
 RTS

\ ******************************************************************************
\
\       Name: BDlab5
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab5

 JSR BDlab19
 STA &D408
 STA voice2lo1
 STA voice2lo2
 JSR BDlab19
 STA &D407
 STA voice2hi1
 STA voice2hi2
 CLC
 CLD
 LDA #&20
 ADC voice2hi2
 STA voice2hi2
 BCC BDruts1
 INC voice2lo2

.BDruts1

 RTS

\ ******************************************************************************
\
\       Name: BDlab7
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab7

 JSR BDlab19
 STA &D40F
 STA voice3lo1
 STA voice3lo2
 JSR BDlab19
 STA &D40E
 STA voice3hi1
 STA voice3hi2
 CLC
 CLD

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&25

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA #&20

ENDIF

 ADC voice3hi2
 STA voice3hi2
 BCC BDruts2
 INC voice3lo2

.BDruts2

 RTS

\ ******************************************************************************
\
\       Name: BDENTRY
\       Type: Subroutine
\   Category: Sound
\    Summary: Start playing background music
\
\ ******************************************************************************

.BDENTRY

 LDA #0
 STA BDBUFF
 STA counter
 STA vibrato2
 STA vibrato3
 LDX #&18

.BDloop2

 STA &D400,X
 DEX
 BNE BDloop2

IF _GMA85_NTSC OR _GMA86_PAL

 LDA value5             \ Set A to the low byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA #LO(musicstart)    \ Set A to the low byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr1
 STA BDdataptr3

IF _GMA85_NTSC OR _GMA86_PAL

 LDA value5+1           \ Set A to the high byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA #HI(musicstart)    \ Set A to the high byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr2
 STA BDdataptr4
 LDA #&0F
 STA &D418
\SEI
 RTS  \<<
 \ point IRQ to start
\LDA  #LO(BDirqhere)
\STA  &0314
\LDA  #HI(BDirqhere)
\STA  &0315
\CLI
\BRK  \ re enter monitor!
 \........
 LDA #0
 STA vibrato2
 LDA #&AE
 STA BDbeqmod1+1
 LDA voice2lo2
 STA &D408
 LDA voice2hi2
 STA &D407
 JMP BDlab21

\ ******************************************************************************
\
\       Name: BDlab24
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab24

 LDA #0
 STA vibrato2
 LDA #&98
 STA BDbeqmod1+1
 LDA voice2lo1
 STA &D408
 LDA voice2hi1
 STA &D407
 JMP BDlab21
 LDA #0
 STA vibrato3
 LDA #&E2
 STA BDbeqmod2+1
 LDA voice3lo2
 STA &D40F
 LDA voice3hi2
 STA &D40E
 JMP BDlab21

\ ******************************************************************************
\
\       Name: BDlab23
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab23

 LDA #0
 STA vibrato3
 LDA #&CC
 STA BDbeqmod2+1
 LDA voice3lo1
 STA &D40F
 LDA voice3hi1
 STA &D40E
 JMP BDlab21

\ ******************************************************************************
\
\       Name: BDlab1
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab1

 INC vibrato3

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #5

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA #6

ENDIF

 CMP vibrato3

.BDbeqmod2

 BEQ BDlab23
 INC vibrato2

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #4

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA #5

ENDIF

 CMP vibrato2

.BDbeqmod1

 BEQ BDlab24

\ ******************************************************************************
\
\       Name: BDlab21
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDlab21

 LDX counter

IF _GMA85_NTSC OR _GMA86_PAL

 CPX #0

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 CPX #2

ENDIF

 BNE BDexitirq
 LDX value1
 DEX
 STX &D404
 LDX value2
 DEX
 STX &D40B
 LDX value3
 DEX
 STX &D412

.BDexitirq

 RTS
 RTS  \JMP &EA31

\ ******************************************************************************
\
\       Name: BDJMPTBL
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDJMPTBL

 EQUB LO(BDRO1)
 EQUB LO(BDRO2)
 EQUB LO(BDRO3)
 EQUB LO(BDRO4)
 EQUB LO(BDRO5)
 EQUB LO(BDRO6)
 EQUB LO(BDRO7)
 EQUB LO(BDRO8)
 EQUB LO(BDRO9)
 EQUB LO(BDRO10)
 EQUB LO(BDRO11)
 EQUB LO(BDRO12)
 EQUB LO(BDRO13)
 EQUB LO(BDRO14)
 EQUB LO(BDRO15)

\ ******************************************************************************
\
\       Name: BDJMPTBH
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BDJMPTBH

 EQUB HI(BDRO1)
 EQUB HI(BDRO2)
 EQUB HI(BDRO3)
 EQUB HI(BDRO4)
 EQUB HI(BDRO5)
 EQUB HI(BDRO6)
 EQUB HI(BDRO7)
 EQUB HI(BDRO8)
 EQUB HI(BDRO9)
 EQUB HI(BDRO10)
 EQUB HI(BDRO11)
 EQUB HI(BDRO12)
 EQUB HI(BDRO13)
 EQUB HI(BDRO14)

.musicstart

 EQUB HI(BDRO15)

\ ******************************************************************************
\
\       Name: COMUDAT
\       Type: Variable
\   Category: Sound
\    Summary: Music data from the C.COMUDAT file
\
\ ******************************************************************************

IF _GMA85_NTSC OR _GMA86_PAL

 INCBIN "versions/c64/1-source-files/music/gma/C.COMUDAT.bin"

ELIF _SOURCE_DISC_FILES OR _SOURCE_DISK_BUILD

 INCBIN "versions/c64/1-source-files/music/source-disk/C.COMUDAT.bin"

ENDIF

.THEME

IF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 EQUB &28               \ C.THEME is not included in the encrypted HICODE binary
                        \ in the source disk variant, unlike the GMA85 variant

ELIF _GMA85_NTSC OR _GMA86_PAL

 INCBIN "versions/c64/1-source-files/music/gma/C.THEME.bin"

ENDIF

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

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-checksum.py.
\
\ ******************************************************************************

 CODE_SHIPS% = D%

 LOAD_SHIPS% = LOAD% + D% - CODE%

 ORG D%

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/kwl_per_cent.asm"
INCLUDE "library/master/data/variable/kwh_per_cent.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/enhanced/main/variable/ship_splinter.asm"
INCLUDE "library/enhanced/main/variable/ship_shuttle.asm"
INCLUDE "library/enhanced/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/enhanced/main/variable/ship_anaconda.asm"
INCLUDE "library/advanced/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/enhanced/main/variable/ship_adder.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_1.asm"
INCLUDE "library/enhanced/main/variable/ship_worm.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_3_p.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"

 EQUB &59, &3A          \ These bytes appear to be unused
 EQUB &43, &4D

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &4C, &44          \ These bytes appear to be unused
 EQUB &41, &52

\ ******************************************************************************
\
\ Save SHIPS.bin
\
\ ******************************************************************************

 PRINT "SHIPS"
 PRINT "Assembled at ", ~CODE_SHIPS%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_SHIPS%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_SHIPS%

 PRINT "S.SHIPS ", ~CODE_SHIPS%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_SHIPS%
 SAVE "versions/c64/3-assembled-output/SHIPS.bin", CODE_SHIPS%, P%, LOAD%
