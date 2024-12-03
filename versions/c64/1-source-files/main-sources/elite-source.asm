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

 CODE% = &1D00          \ The address where the code will be run

 LOAD% = &1D00          \ The address where the code will be loaded

IF _GMA_RELEASE

 C% = &6A00             \ The address where the second block of game code will
                        \ be run (ELITE C onwards)

ELIF _SOURCE_DISK

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
INCLUDE "library/advanced/main/workspace/sound_variables.asm"
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
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/c64/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/c64/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"

 EQUD &F0E0C080         \ These bytes appear to be unused; they contain a copy
 EQUW &FCF8             \ of the TWFL variable, and the original source has a
 EQUB &FE               \ commented out label .TWFL

 EQUD &1F3F7FFF         \ These bytes appear to be unused; they contain a copy
 EQUD &0103070F         \ of the TWFR variable, and the original source has a
                        \ commented out label .TWFR

INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
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
INCLUDE "library/advanced/main/subroutine/tt67-tt67x.asm"
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

\ ******************************************************************************
\
\       Name: Music variables
\       Type: Workspace
\    Address: &B4CB to &B4D1
\   Category: Workspaces
\    Summary: Variables that are used by the music player
\
\ ******************************************************************************

.value0

 EQUB 0                 \ A counter that increments every time we process
                        \ command <#6>

.value1

 EQUB 0                 \ Stores the voice control register for voice 1

.value2

 EQUB 0                 \ Stores the voice control register for voice 2

.value3

 EQUB 0                 \ Stores the voice control register for voice 3

.value4

 EQUB 0                 \ Stores the rest length for commands #8 and #15

IF _GMA_RELEASE

.value5

 EQUW &8888             \ The address before the start of the music data for the
                        \ tune that is configured to play for docking, so this
                        \ can be changed to alter the docking music

ENDIF

\ ******************************************************************************
\
\       Name: BDirqhere
\       Type: Subroutine
\   Category: Sound
\    Summary: The interrupt routine for playing background music
\
\ ------------------------------------------------------------------------------
\
\ The label "BD" is used as a prefix throughout the music routines. This is a
\ reference to the Blue Danube, which is the only bit of music that was included
\ in the first release of Commodore 64 Elite (where it was used for the docking
\ computer). The Elite theme tune on the title screen was added in a later
\ release.
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
\   BDskip1             Process the next nibble of music data in BDBUFF
\
\ ******************************************************************************

.BDirqhere

 LDY #0                 \ If the music counter is zero then we are not currently
 CPY counter            \ processing a wait command, so jump to BDskip1 to
 BEQ BDskip1            \ process the current byte of music data in BDBUFF

 DEC counter            \ Otherwise we are processing a rest command, so
                        \ decrement the music counter while we continue to pause
                        \ the music

 JMP BDlab1             \ And jump to BDlab1 to update the vibrato and control
                        \ registers before returning from the subroutine

.BDskip1

                        \ When we get here, Y is set to 0
                        \
                        \ This value is retained throughout the entire music
                        \ interrupt routine, so whenever you see Y in these
                        \ routines, it has a value of 0

 LDA BDBUFF             \ Set A to the current byte of music data in BDBUFF

 CMP #&10               \ If A >= &10 then the high nibble of A is non-zero, so
 BCS BDLABEL2           \ jump to BDLABEL2 to extract and process the command in
                        \ the low nibble first, leaving the command in the high
                        \ nibble until later

 TAX                    \ Set X to the low nibble of music data in A, so X is
                        \ in the range 1 to 15 and contains the number of the
                        \ music command we now need to process

 BNE BDLABEL            \ If A > 0 then this is a valid command number in the
                        \ range 1 to 15, so jump to BDLABEL to process the
                        \ command

                        \ If we get here then the nibble of music data in A is
                        \ zero, which means "do nothing", so we just move on to
                        \ the next data byte

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA BDBUFF             \ Store the next music data byte in BDBUFF

.BDLABEL2

 AND #&0F               \ Extract the low nibble of the music data into A

 TAX                    \ Set X to the low nibble of music data in A, so X is
                        \ in the range 1 to 15 and contains the number of the
                        \ music command we now need to process

.BDLABEL

 LDA BDBUFF             \ Shift the high nibble of BDBUFF into the low nibble,
 LSR A                  \ so it is available as the next nibble of music data
 LSR A                  \ to be processed, once we have finished processing the
 LSR A                  \ command in X
 LSR A
 STA BDBUFF

                        \ We now process the current music command, which is in
                        \ the low nibble of X, and in the range 1 to 15

 LDA BDJMPTBL-1,X       \ Modify the JMP command at BDJMP to jump to the X-th
 STA BDJMP+1            \ address in the BDJMPTBL table, to process the music
 LDA BDJMPTBH-1,X       \ command in X
 STA BDJMP+2            \
                        \ This means that command <#1> jumps to BDRO1, command
                        \ <#2> jumps to BDRO2, and so on up to command <#15>,
                        \ which jumps to BDR15

.BDJMP

 JMP BDskip1            \ Jump to the correct routine for processing the music
                        \ command in X (as this instruction gets modified)

\ ******************************************************************************
\
\       Name: BDRO1
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#1 fh1 fl1> to set the frequency for voice
\             1 to (fh1 fl1) and the control register for voice 1 to value1
\
\ ******************************************************************************

.BDRO1

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO2
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#2 fh1 fl1> to set the frequency for voice
\             2 to (fh2 fl2) and the control register for voice 2 to value2
\
\ ******************************************************************************

.BDRO2

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#3 fh1 fl1> to set the frequency for voice
\             3 to (fh3 fl3) and the control register for voice 3 to value3
\
\ ******************************************************************************

.BDRO3

 JSR BDlab7             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 3 (high byte then low byte) and the
                        \ vibrato variables for voice 3

 JSR BDlab8             \ Set the voice control register for voice 3 to value3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO4
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#4 fh1 fl1 fh2 fl2> to set the frequencies
\             and voice control registers for voices 1 and 2
\
\ ******************************************************************************

.BDRO4

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO5
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#5 fh1 fl1 fh2 fl2 fh3 fl3> to set the
\             frequencies and voice control registers for voices 1, 2 and 3
\
\ ******************************************************************************

.BDRO5

 JSR BDlab3             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 1 (high byte then low byte)

 JSR BDlab5             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 2 (high byte then low byte) and the
                        \ vibrato variables for voice 2

 JSR BDlab7             \ Fetch the next two music data bytes and set the
                        \ frequency of voice 3 (high byte then low byte) and the
                        \ vibrato variables for voice 3

 JSR BDlab4             \ Set the voice control register for voice 1 to value1

 JSR BDlab6             \ Set the voice control register for voice 2 to value2

 JSR BDlab8             \ Set the voice control register for voice 3 to value3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO6
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#6> to increment value0 and move on to the
\             next nibble of music data
\
\ ******************************************************************************

.BDRO6

 INC value0             \ Increment the counter in value0
                        \
                        \ This value is never read, so it could be a debugging
                        \ command of some kind, or a counter that is not used
                        \ by the music in Elite

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO15
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#15> to rest for 2 * value4 interrupts
\
\ ******************************************************************************

.BDRO15

 LDA BDBUFF             \ Slide the value %1000 (8) into the low nibble of
 SEC                    \ BDBUFF while shifting the original low nibble into
 ROL A                  \ the high nibble
 ASL A                  \
 ASL A                  \ Because we process the low nibble first in each music
 ASL A                  \ data byte, this inserts command <#8> into the queue as
 STA BDBUFF             \ the next command to be processed, after we fall
                        \ through into BDRO8 to process another command <#8>
                        \ first
                        \
                        \ In other words, this processes two command <#8>s in a
                        \ row, which implements a double-length rest

                        \ Fall into BDRO8 to rest for value4 interrupts

\ ******************************************************************************
\
\       Name: BDRO8
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#8> to rest for value4 interrupts
\
\ ******************************************************************************

.BDRO8

 LDA value4             \ Set the music counter to value4, so we introduce a
 STA counter            \ rest of value4 interrupts (i.e. a pause where we play
                        \ no music)

 JMP BDirqhere          \ Jump back to the start of the interrupt routine so the
                        \ counter starts to count down

\ ******************************************************************************
\
\       Name: BDRO7
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#7 ad1 ad2 ad3 sr1 sr2 sr3> to set three
\             voices' attack and decay length, sustain volume and release length
\
\ ******************************************************************************

.BDRO7

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&5             \ Set SID register &5 to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 1 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&C             \ Set SID register &C to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 2 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&13            \ Set SID register &12 to the music data byte we just
                        \ fetched, which sets the attack and decay length for
                        \ voice 3 as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&6             \ Set SID register &6 to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 1 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&D             \ Set SID register &D to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 2 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&14            \ Set SID register &14 to the music data byte we just
                        \ fetched, which sets the release length and sustain
                        \ volume for voice 4 as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO9
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#9> to restart the current tune
\
\ ******************************************************************************

.BDRO9

 LDA #0                 \ Clear the current music data byte, which discards the
 STA BDBUFF             \ next nibble if there is one (so this flushes any data
                        \ from the current pipeline)

 LDA BDdataptr3         \ Set BDdataptr1(1 0) = BDdataptr3(1 0)
 STA BDdataptr1         \
 LDA BDdataptr4         \ So this sets the data pointer in BDdataptr1(1 0) back
 STA BDdataptr2         \ to the original value that we gave it at the start of
                        \ the BDENTRY routine when we started playing this tune,
                        \ which we stored in BDdataptr3(1 0)
                        \
                        \ In other words, this restarts the current tune

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO10
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#10 h1 l1 h2 l2 h3 l3> to set the pulse
\             width to all three voices
\
\ ******************************************************************************

.BDRO10

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&2             \ Set SID register &2 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&3             \ Set SID register &3 to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&9             \ Set SID register &9 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&A             \ Set SID register &A to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&10            \ Set SID register &10 to the music data byte we just
                        \ fetched, which sets the high byte of the pulse width
                        \ for voice 3

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&11            \ Set SID register &11 to the music data byte we just
                        \ fetched, which sets the low byte of the pulse width
                        \ for voice 3

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO11
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#11>, which does the same as command <#9>
\             and restarts the current tune
\
\ ******************************************************************************

.BDRO11

 JMP BDRO9              \ Jump to BDRO9 to process command <#9> (so command
                        \ <#11> is the same as command <#9> and restarts the
                        \ current tune)

\ ******************************************************************************
\
\       Name: BDRO12
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#12 n> to set value4 = n, which sets the
\             rest length for commands #8 and #15
\
\ ******************************************************************************

.BDRO12

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value4             \ Set value4 to the value of the byte we just fetched,
                        \ which sets the rest length used in commands #8 and #15

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO13
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#13 v1 v2 v3> to set value1, value2, value3
\             to the voice control register valuesm for commands <#1> to <#3>
\
\ ******************************************************************************

.BDRO13

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value1             \ Set value1 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 1 in command <#1>

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value2             \ Set value2 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 2 in command <#2>

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA value3             \ Set value3 to the value of the byte we just fetched,
                        \ which is used to set the voice control register for
                        \ voice 3 in command <#3>

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDRO14
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#14 vf fc cf> to set the volume and filter
\             modes, filter control and filter cut-off frequency
\
\ ******************************************************************************

.BDRO14

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&18            \ Set SID register &18 to the music data byte we just
                        \ fetched, which sets the volume and filter modes as
                        \ follows:
                        \
                        \   * Bits 0-3: volume (0 to 15)
                        \
                        \   * Bit 4 set: enable the low-pass filter
                        \
                        \   * Bit 5 set: enable the bandpass filter
                        \
                        \   * Bit 6 set: enable the high-pass filter
                        \
                        \   * Bit 7 set: disable voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&17            \ Set SID register &17 to the music data byte we just
                        \ fetched, which sets the filter control as follows:
                        \
                        \   * Bit 0 set: voice 1 filtered
                        \
                        \   * Bit 1 set: voice 2 filtered
                        \
                        \   * Bit 2 set: voice 3 filtered
                        \
                        \   * Bit 3 set: external voice filtered
                        \
                        \   * Bits 4-7: filter resonance

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&16            \ Set SID register &16 to the music data byte we just
                        \ fetched, which sets bits 3 to 10 of the filter cut-off
                        \ frequency

 JMP BDskip1            \ Jump to BDskip1 to process the next nibble of music
                        \ data

\ ******************************************************************************
\
\       Name: BDlab4
\       Type: Subroutine
\   Category: Sound
\    Summary: Set the voice control register for voice 1 to value1
\
\ ******************************************************************************

.BDlab4

 LDA value1             \ Set A to value1, to use as the new value of the voice
                        \ control register for voice 1

 STY SID+&4             \ Zero SID register &4 (the voice control register for
                        \ voice 1), to reset the voice control

 STA SID+&4             \ Set SID register &4 (the voice control register for
                        \ voice 1) to the music data byte that we just fetched
                        \ in A, so control the voice as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \   * Bit 1 set = synchronization enabled
                        \
                        \   * Bit 2 set = ring modulation enabled
                        \
                        \   * Bit 3 set = disable voice, reset noise generator
                        \
                        \   * Bit 4 set = triangle waveform enabled
                        \
                        \   * Bit 5 set = saw waveform enabled
                        \
                        \   * Bit 6 set = square waveform enabled
                        \
                        \   * Bit 7 set = noise waveform enabled

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab6
\       Type: Subroutine
\   Category: Sound
\    Summary: Set the voice control register for voice 2 to value2
\
\ ******************************************************************************

.BDlab6

 LDA value2             \ Set A to value2, to use as the new value of the voice
                        \ control register for voice 2

 STY SID+&B             \ Zero SID register &B (the voice control register for
                        \ voice 2), to reset the voice control

 STA SID+&B             \ Set SID register &B (the voice control register for
                        \ voice 2) to the music data byte that we just fetched
                        \ in A, so control the voice as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \   * Bit 1 set = synchronization enabled
                        \
                        \   * Bit 2 set = ring modulation enabled
                        \
                        \   * Bit 3 set = disable voice, reset noise generator
                        \
                        \   * Bit 4 set = triangle waveform enabled
                        \
                        \   * Bit 5 set = saw waveform enabled
                        \
                        \   * Bit 6 set = square waveform enabled
                        \
                        \   * Bit 7 set = noise waveform enabled

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab8
\       Type: Subroutine
\   Category: Sound
\    Summary: Set the voice control register for voice 3 to value3
\
\ ******************************************************************************

.BDlab8

 LDA value3             \ Set A to value3, to use as the new value of the voice
                        \ control register for voice 3

 STY SID+&12            \ Zero SID register &12 (the voice control register for
                        \ voice 3), to reset the voice control

 STA SID+&12            \ Set SID register &12 (the voice control register for
                        \ voice 3) to the music data byte that we just fetched
                        \ in A, so control the voice as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \   * Bit 1 set = synchronization enabled
                        \
                        \   * Bit 2 set = ring modulation enabled
                        \
                        \   * Bit 3 set = disable voice, reset noise generator
                        \
                        \   * Bit 4 set = triangle waveform enabled
                        \
                        \   * Bit 5 set = saw waveform enabled
                        \
                        \   * Bit 6 set = square waveform enabled
                        \
                        \   * Bit 7 set = noise waveform enabled

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab19
\       Type: Subroutine
\   Category: Sound
\    Summary: Increment the music data pointer in BDdataptr1(1 0) and fetch the
\             next data byte into A
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   Y is always 0
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   BDdataptr1(1 0)     Incremented to point to the next music data byte
\
\   A                   The next music data byte
\
\ ******************************************************************************

.BDlab19

 INC BDdataptr1         \ Increment the data pointer in BDdataptr1(1 0)
 BNE BDskipme1
 INC BDdataptr1+1

.BDskipme1

 LDA (BDdataptr1),Y     \ Y is zero, so this sets A to the next byte of music 
                        \ data from BDdataptr1(1 0)
                        \
                        \ We have to include an index of Y as the 6502 doesn't
                        \ have an instruction of the form LDA (BDdataptr1)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab3
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 1 (high byte then low byte)
\
\ ******************************************************************************

.BDlab3

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&1             \ Set SID register &1 to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 1

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&0             \ Set SID register &0 to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab5
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 2 (high byte then low byte) and the vibrato variables
\
\ ******************************************************************************

.BDlab5

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&8             \ Set SID register &8 to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 2

 STA voice2lo1          \ Store the high byte in the voice2lo variables
 STA voice2lo2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&7             \ Set SID register &7 to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 2

 STA voice2hi1          \ Store the low byte in the voice2hi variables
 STA voice2hi2

                        \ So by this point we have the following:
                        \
                        \   (voice2lo1 voice2hi1) = frequency
                        \
                        \   (voice2lo2 voice2hi2) = frequency
                        \
                        \ Note that the variable naming here is a bit odd, as
                        \ the high bytes are in the voice2lo variables, and the
                        \ low bytes are in the voice2hi variables
                        \
                        \ These are the names from the original source code, so
                        \ let's roll with it

 CLC                    \ Clear the C flag for the addition below

 CLD                    \ Clear the D flag to make sure we are in binary mode,
                        \ as we are in an interrupt handler and can't be sure of
                        \ the flag state on entry

 LDA #32                \ Set (voice2lo2 voice2hi2) = (voice2lo2 voice2hi2) + 32
 ADC voice2hi2          \
 STA voice2hi2          \ So the second frequency in (voice2lo2 voice2hi2) is
 BCC BDruts1            \ now a bit higher than the first frequency, which we
 INC voice2lo2          \ can use to add vibrato to voice 2

.BDruts1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDlab7
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 3 (high byte then low byte) and the vibrato variables
\
\ ******************************************************************************

.BDlab7

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&F             \ Set SID register &F to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 3

 STA voice3lo1          \ Store the high byte in the voice3lo variables
 STA voice3lo2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&E             \ Set SID register &E to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 3

 STA voice3hi1          \ Store the low byte in the voice3hi variables
 STA voice3hi2

                        \ So by this point we have the following:
                        \
                        \   (voice3lo1 voice3hi1) = frequency
                        \
                        \   (voice3lo2 voice3hi2) = frequency
                        \
                        \ Note that the variable naming here is a bit odd, as
                        \ the high bytes are in the voice3lo variables, and the
                        \ low bytes are in the voice3hi variables
                        \
                        \ These are the names from the original source code, so
                        \ let's roll with it

 CLC                    \ Clear the C flag for the addition below

 CLD                    \ Clear the D flag to make sure we are in binary mode,
                        \ as we are in an interrupt handler and can't be sure of
                        \ the flag state on entry

IF _GMA_RELEASE

 LDA #37                \ Set A to the frequency change used when applying
                        \ vibrato to voice 3 (voice 2 applies a vibrato of 32,
                        \ so this sets a bigger vibrato frequency change for
                        \ voice 3)

ELIF _SOURCE_DISK

 LDA #32                \ Set A to the frequency change used when applying
                        \ vibrato to voice 3 (this is the same value as for
                        \ voice 2)

ENDIF

 ADC voice3hi2          \ Set (voice3lo2 voice3hi2) = (voice3lo2 voice3hi2) + A
 STA voice3hi2          \
 BCC BDruts2            \ So the second frequency in (voice3lo2 voice3hi2) is
 INC voice3lo2          \ now a bit higher than the first frequency, which we
                        \ can use to add vibrato to voice 3

.BDruts2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BDENTRY
\       Type: Subroutine
\   Category: Sound
\    Summary: Start playing a new tune as background music
\
\ ******************************************************************************

.BDENTRY

 LDA #0                 \ Set BDBUFF = 0 to reset the current music data byte in
 STA BDBUFF             \ BDBUFF

 STA counter            \ Set counter = 0 to reset the rest counter

 STA vibrato2           \ Set vibrato2 = 0 to reset the vibrato counter for
                        \ voice 2

 STA vibrato3           \ Set vibrato3 = 0 to reset the vibrato counter for
                        \ voice 3

                        \ We now zero all the SID registers from &01 to &18 to
                        \ reset the sound chip (though it doesn't zero the first
                        \ byte at &00, for some reason)

 LDX #&18               \ Set a byte counter in X

.BDloop2

 STA SID,X              \ Zero the X-th byte of the SID registers

 DEX                    \ Decrement the counter in X

 BNE BDloop2            \ Loop back until we have zeroed all the registers from
                        \ &01 to &18

IF _GMA_RELEASE

 LDA value5             \ Set A to the low byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK

 LDA #LO(musicstart)    \ Set A to the low byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr1         \ Set BDdataptr1 to the low byte of the music to play

 STA BDdataptr3         \ Set BDdataptr3 to the low byte of the music to play

IF _GMA_RELEASE

 LDA value5+1           \ Set A to the high byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK

 LDA #HI(musicstart)    \ Set A to the high byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr2         \ Set BDdataptr2 to the high byte of the music to play,
                        \ so BDdataptr1(1 0) is the address of the music to play
                        \ (as BDdataptr2 = BDdataptr1 + 1)

 STA BDdataptr4         \ Set BDdataptr4 to the high byte of the music to play,
                        \ so BDdataptr3(1 0) is the address of the music to play
                        \ (as BDdataptr4 = BDdataptr3 + 1)

 LDA #%00001111         \ Set SID register &18 to control the sound as follows:
 STA SID+&18            \
                        \   * Bits 0-3: set the volume to 15 (maximum)
                        \
                        \   * Bit 4 clear: disable the low-pass filter
                        \
                        \   * Bit 5 clear: disable the bandpass filter
                        \
                        \   * Bit 6 clear: disable the high-pass filter
                        \
                        \   * Bit 7 clear: enable voice 3

\SEI                    \ This instruction is commented out in the original
                        \ source

 RTS

\point IRQ to start     \ These instructions are commented out in the original
\LDA  #LO(BDirqhere)    \ source
\STA  &0314
\LDA  #HI(BDirqhere)
\STA  &0315
\CLI
\BRK
\re enter monitor!

\ ******************************************************************************
\
\       Name: BDlab24
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply a vibrato frequency change to voice 2
\
\ ******************************************************************************

 LDA #0                 \ Reset the vibrato counter for voice 2 so it starts to
 STA vibrato2           \ count up towards the next vibrato change once again

 LDA #&AE               \ Modify the BEQ instruction at BDbeqmod1 so next time
 STA BDbeqmod1+1        \ it jumps to the second half of this routine

 LDA voice2lo2          \ Set SID registers &7 and &8 to the vibrato frequency
 STA SID+&8             \ in (voice2lo2 voice2hi2), which sets the frequency
 LDA voice2hi2          \ for voice 2 to the second (i.e. the higher) frequency
 STA SID+&7             \ that we set up for vibrato in BDlab5

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

.BDlab24

 LDA #0                 \ Reset the vibrato counter for voice 2 so it starts to
 STA vibrato2           \ count up towards the next vibrato change once again

 LDA #&98               \ Modify the BEQ instruction at BDbeqmod1 so next time
 STA BDbeqmod1+1        \ it jumps to the first half of this routine

 LDA voice2lo1          \ Set SID registers &7 and &8 to the vibrato frequency
 STA SID+&8             \ in (voice2lo1 voice2hi1), which sets the frequency
 LDA voice2hi1          \ for voice 2 to the first (i.e. the lower) frequency
 STA SID+&7             \ that we set up for vibrato in BDlab5

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

\ ******************************************************************************
\
\       Name: BDlab23
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply a vibrato frequency change to voice 3
\
\ ******************************************************************************

 LDA #0                 \ Reset the vibrato counter for voice 3 so it starts to
 STA vibrato3           \ count up towards the next vibrato change once again

 LDA #&E2               \ Modify the BEQ instruction at BDbeqmod2 so next time
 STA BDbeqmod2+1        \ it jumps to the second half of this routine

 LDA voice3lo2          \ Set SID registers &E and &F to the vibrato frequency
 STA SID+&F             \ in (voice3lo2 voice3hi2), which sets the frequency
 LDA voice3hi2          \ for voice 3 to the second (i.e. the higher) frequency
 STA SID+&E             \ that we set up for vibrato in BDlab7

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

.BDlab23

 LDA #0                 \ Reset the vibrato counter for voice 3 so it starts to
 STA vibrato3           \ count up towards the next vibrato change once again

 LDA #&CC               \ Modify the BEQ instruction at BDbeqmod2 so next time
 STA BDbeqmod2+1        \ it jumps to the first half of this routine

 LDA voice3lo1          \ Set SID registers &E and &F to the vibrato frequency
 STA SID+&F             \ in (voice3lo1 voice3hi1), which sets the frequency
 LDA voice3hi1          \ for voice 3 to the second (i.e. the higher) frequency
 STA SID+&E             \ that we set up for vibrato in BDlab7

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

\ ******************************************************************************
\
\       Name: BDlab1
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply vibrato before cleaning up and returning from the interrupt
\             routine
\
\ ******************************************************************************

.BDlab1

 INC vibrato3           \ Increment the vibrato counter for voice 3

IF _GMA_RELEASE

 LDA #5                 \ Set A = 5 so the period of the vibrato for voice 3 is
                        \ five interrupts

ELIF _SOURCE_DISK

 LDA #6                 \ Set A = 6 so the period of the vibrato for voice 3 is
                        \ six interrupts

ENDIF

 CMP vibrato3           \ If the vibrato counter for voice 3 has reached the
                        \ the value in A, then it is time to change the voice 3
                        \ frequency to implement vibrato, so jump to the address
                        \ in the following BEQ instruction, which gets modified
                        \ by the BDlab23 routine to oscillate between the two
                        \ halves of the BDlab23 routine
                        \
                        \ One half applies the lower vibrato frequency, and the
                        \ other applies the higher vibrato frequency, so the
                        \ effect is to flip between the two frequencies every A
                        \ interrupts

.BDbeqmod2

 BEQ BDlab23            \ Jump to the BDlab23 routine to switch to the correct
                        \ vibrato frequency and jump back to BDlab21 to clean up
                        \ and return from the interrupt routine

 INC vibrato2           \ Increment the vibrato counter for voice 2

IF _GMA_RELEASE

 LDA #4                 \ Set A = 5 so the period of the vibrato for voice 2 is
                        \ four interrupts

ELIF _SOURCE_DISK

 LDA #5                 \ Set A = 5 so the period of the vibrato for voice 2 is
                        \ five interrupts

ENDIF

 CMP vibrato2           \ If the vibrato counter for voice 2 has reached the
                        \ the value in A, then it is time to change the voice 2
                        \ frequency to implement vibrato, so jump to the address
                        \ in the following BEQ instruction, which gets modified
                        \ by the BDlab24 routine to oscillate between the two
                        \ halves of the BDlab24 routine
                        \
                        \ One half applies the lower vibrato frequency, and the
                        \ other applies the higher vibrato frequency, so the
                        \ effect is to flip between the two frequencies every A
                        \ interrupts

.BDbeqmod1

 BEQ BDlab24            \ Jump to the BDlab24 routine to switch to the correct
                        \ vibrato frequency and jump back to BDlab21 to clean up
                        \ and return from the interrupt routine

\ ******************************************************************************
\
\       Name: BDlab21
\       Type: Subroutine
\   Category: Sound
\    Summary: Clean up and return from the interrupt routine
\
\ ******************************************************************************

.BDlab21

IF _GMA_RELEASE

 LDX counter            \ If the rest counter is non-zero, jump to BDexitirq to
 CPX #0                 \ return from the interrupt routine
 BNE BDexitirq

ELIF _SOURCE_DISK

 LDX counter            \ If the rest counter is not 2, jump to BDexitirq to
 CPX #2                 \ return from the interrupt routine
 BNE BDexitirq

ENDIF

                        \ The rest counter is ticking down, which means no new
                        \ notes are being played for the time being, so we need
                        \ to silence all three voices

 LDX value1             \ Set SID register &4 (the voice control register for
 DEX                    \ voice 1) to value1 - 1
 STX SID+&4             \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 1 and starts the release cycle (so this
                        \ effectively terminates any music on voice 1)

 LDX value2             \ Set SID register &B (the voice control register for
 DEX                    \ voice 1) to value2 - 1
 STX SID+&B             \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 2 and starts the release cycle (so this
                        \ effectively terminates any music on voice 2)

 LDX value3             \ Set SID register &12 (the voice control register for
 DEX                    \ voice 1) to value3 - 1
 STX SID+&12            \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 3 and starts the release cycle (so this
                        \ effectively terminates any music on voice 3)

.BDexitirq

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect as we have already
                        \ returned from the subroutine

\ ******************************************************************************
\
\       Name: BDJMPTBL
\       Type: Variable
\   Category: Sound
\    Summary: A jump table containing addresses for processing music commands 1
\             through 15 (low bytes)
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
\    Summary: A jump table containing addresses for processing music commands 1
\             through 15 (high bytes)
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

IF _GMA_RELEASE

 INCBIN "versions/c64/1-source-files/music/gma/C.COMUDAT.bin"

ELIF _SOURCE_DISK

 INCBIN "versions/c64/1-source-files/music/source-disk/C.COMUDAT.bin"

ENDIF

.THEME

IF _SOURCE_DISK

 EQUB &28               \ C.THEME is not included in the encrypted HICODE binary
                        \ in the source disk variant, unlike the GMA85 variant

ELIF _GMA_RELEASE

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
