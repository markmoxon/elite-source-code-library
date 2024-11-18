\ ******************************************************************************
\
\ APPLE II ELITE GAME SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
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

 INCLUDE "versions/apple/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_DISK                   = (_VARIANT = 1)
 _SOURCE_DISK_BUILD         = (_VARIANT = 2)
 _SOURCE_DISK_CODE_FILES    = (_VARIANT = 3)
 _SOURCE_DISK_ELT_FILES     = (_VARIANT = 4)
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

 CODE% = &4000          \ The address where the code will be run

 LOAD% = &4000          \ The address where the code will be loaded

IF _IB_DISK

 STORE = &0200          \ The address where the dashboard image is loaded ???

 CODE2 = &2000          \ The address where the dashboard image is run ???

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 STORE = &D000          \ The address where the dashboard image is loaded ???

 CODE2 = &9000          \ The address where the dashboard image is run ???

ENDIF

 D% = &A300             \ The address where the ship data will be loaded
                        \ (i.e. XX21)

 Q% = _MAX_COMMANDER    \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander

 USA% = FALSE           \ ???

 NOST = 12              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 8               \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 32               \ The number of different ship types

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

 DOD = 32               \ Ship type for a Dodecahedron ("Dodo") space station

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

 X = 128                \ The centre x-coordinate of the 256 x 136 space view

 Y = 68                 \ The centre y-coordinate of the 256 x 136 space view

 conhieght = 80         \ The size of the gap left for the rotating Constrictor
                        \ at the top of the briefing for mission 1

 GCYT = 19              \ The y-coordinate of the top of the Long-range Chart

 GCYB = GCYT + 0.75*128 \ The y-coordinate of the bottom of the Long-range chart

 f0 = &31               \ ASCII number for key "1" (Launch, Front)

 f1 = &32               \ ASCII number for key "1" (Buy Cargo)

 f2 = &33               \ ASCII number for key "2" (Sell Cargo)

 f3 = &34               \ ASCII number for key "3" (Equip Ship)

 f4 = &35               \ ASCII number for key "4" (Long-range Chart)

 f5 = &36               \ ASCII number for key "5" (Short-range Chart)

 f6 = &37               \ ASCII number for key "6" (Data on System)

 f7 = &38               \ ASCII number for key "7" (Market Price)

 f8 = &39               \ ASCII number for key "8" (Status Mode)

 f9 = &30               \ ASCII number for key "9" (Inventory)

 f12 = &32              \ ASCII number for key "2" (Rear)

 f22 = &33              \ ASCII number for key "3" (Left)

 f32 = &34              \ ASCII number for key "4" (Right)

 VIOLET = 4             \ ???
 GREEN = 8
 WHITE = 12
 BLUE = 16
 RED = 20
 FUZZY = 24
 BLACK = 0
 CYAN = WHITE
 MAG = WHITE

 sfxplas = 0            \ ???
 sfxelas = 1
 sfxhit = 2
 sfxexpl = 3
 sfxwhosh = 4
 sfxbeep = 5
 sfxboop = 6
 sfxhyp1 = 7
 sfxeng = 8
 sfxecm = 9
 sfxblas = 10
 sfxalas = 11
 sfxmlas = 12
 sfxbomb = 13
 sfxtrib = 14
 sfxelas2 = 15

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

 KEY1 = &15             \ The seed for encrypting CODE1 and CODE2 from G% to R%,
                        \ where CODE1 is the portion of ELTA-ELTK up to memory
                        \ location &9000, and CODE2 is the portion from &9000
                        \ onwards

 KEY2 = &69             \ The seed for encrypting DATA from WORDS to &2000,
                        \ which is the whole data file

 LL = 30                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

 BUF = &0100            \ The line buffer used by DASC to print justified text

 BRKV = &03F0           \ The break vector that we intercept to enable us to
                        \ handle and display system errors

 IRQV = &03FE           \ The IRQV vector that we intercept to implement the
                        \ split-screen mode ???

 CHRV = &0036           \ The CHRV vector that we intercept with our custom
                        \ text printing routine

 NMIV = &03FC           \ ???

 QQ18 = &0B60           \ The address of the text token table, as set in
                        \ elite-data.asm

 SNE = &0F20            \ The address of the sine lookup table, as set in
                        \ elite-data.asm

 TKN1 = &0F40           \ The address of the extended token table, as set in
                        \ elite-data.asm

 RUPLA = TKN1 + &B1E    \ The address of the extended system description system
                        \ number table, as set in elite-data.asm

 RUGAL = TKN1 + &B38    \ The address of the extended system description galaxy
                        \ number table, as set in elite-data.asm

 RUTOK = TKN1 + &B52    \ The address of the extended system description token
                        \ table, as set in elite-data.asm

 LS% = &0B5F            \ The start of the descending ship line heap

 TAP% = LS% - 111       \ The staging area where we copy files after loading and
                        \ before saving (though this isn't actually used in this
                        \ version, and is left-over Commodore 64 code)

 FONT = &1D00           \ The address of the game's text font

 SCBASE = &2000         \ The address of screen memory

 DLOC% = SCBASE         \ ???

 R% = &BFFF             \ The address of the last byte of game code

 comsiz  =  110         \ Commander file size (1-252 bytes)
 comfil  =  TAP%-20     \ Commander file (must not exceed 252 bytes)
 comfil2 =  comfil+comsiz-4
 buffer  =  &0800       \ K%, 256 byte sector buffer
 buffr2  =  &0800+256   \ K%+256, 342 6 bit 'nibble' buffer
 fretrk  =  buffer+&30  \ last allocated track
 dirtrk  =  buffer+&31  \ direction of track allocation (+1 or -1)
 tracks  =  buffer+&34  \ number of tracks per disc
 bitmap  =  buffer+&38  \ bit map of free sectors in track 0

                        \ Disc Controller Addresses

 phsoff  =  &C080       \ stepper motor phase 0 off
 mtroff  =  &C088       \ turn motor off
 mtron   =  &C089       \ turn motor on
 drv1en  =  &C08A       \ enable drive 1
 drv2en  =  &C08B       \ enable drive 2
 Q6L     =  &C08C       \ strobe data latch for I/O
 Q6H     =  &C08D       \ load data latch
 Q7L     =  &C08E       \ prepare latch for input
 Q7H     =  &C08F       \ prepare latch for output

 track   =  buffr2+350  \ ???
 sector  =  track+1
 curtrk  =  sector+1
 tsltrk  =  curtrk+1
 tslsct  =  tsltrk+1
 filtrk  =  tslsct+1
 filsct  =  filtrk+1
 mtimel  =  filsct+1
 mtimeh  =  mtimel+1
 seeks   =  mtimeh+1
 recals  =  seeks+1
 slot16  =  recals+1
 atemp0  =  slot16+1
 stkptr  =  atemp0+1
 idfld   =  stkptr+1

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/enhanced/main/workspace/up.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ Produces the binary file ELTA.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 ORG CODE%

 LOAD_A% = LOAD%

 JMP S%                 \ ???

INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog-alogh.asm"

\ ******************************************************************************
\
\       Name: SCTBX1
\       Type: Variable
\   Category: Screen
\    Summary: ???
\
\ ******************************************************************************

.SCTBX1

FOR I%, 0, 255

 EQUB (I% + 8) MOD 7

NEXT

\ ******************************************************************************
\
\       Name: SCTBX2
\       Type: Variable
\   Category: Screen
\    Summary: ???
\
\ ******************************************************************************

.SCTBX2

FOR I%, 0, 255

 EQUB (I% + 8) DIV 7

NEXT

\ ******************************************************************************
\
\       Name: wtable
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.wtable

 EQUD &9B9A9796
 EQUD &A69F9E9D
 EQUD &ADACABA7
 EQUD &B3B2AFAE
 EQUD &B7B6B5B4
 EQUD &BCBBBAB9
 EQUD &CBBFBEBD
 EQUD &D3CFCECD

 EQUD &DAD9D7D6
 EQUD &DEDDDCDB
 EQUD &E7E6E5DF
 EQUD &ECEBEAE9
 EQUD &F2EFEEED
 EQUD &F6F5F4F3
 EQUD &FBFAF9F7
 EQUD &FFFEFDFC

\ ******************************************************************************
\
\       Name: Option variables
\       Type: Workspace
\    Address: &4543 to &4562
\   Category: Workspaces
\    Summary: Variables used to store the game options
\
\ ******************************************************************************

INCLUDE "library/common/main/variable/comc.asm"
INCLUDE "library/advanced/main/variable/dials.asm"
INCLUDE "library/advanced/main/variable/mscol.asm"
INCLUDE "library/advanced/main/variable/dflag.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/djd.asm"
INCLUDE "library/common/main/variable/patg.asm"
INCLUDE "library/common/main/variable/flh.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/jste.asm"
INCLUDE "library/common/main/variable/jstk.asm"
INCLUDE "library/master/main/variable/uptog.asm"
INCLUDE "library/master/main/variable/disk.asm"
INCLUDE "library/advanced/main/variable/mulie.asm"

IF _IB_DISK

.L4562

 EQUB &0B               \ ??? Related to joystick fire button in TITLE

ENDIF

INCLUDE "library/master/main/variable/tgint.asm"

\ ******************************************************************************
\
\       Name: S%
\       Type: Subroutine
\   Category: Loader
\    Summary: Checksum, decrypt and unscramble the main game code, and start the
\             game
\
\ ******************************************************************************

 RTS                    \ The checksum byte goes here, at S%-1. In the original
                        \ source this byte is set by the first call to ZP in the
                        \ Big Code File, though in the BeebAsm version this is
                        \ populated by elite-checksum.py

.S%

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 CLD                    \ Clear the D flag to make sure we are in binary mode

ENDIF

 LDA #LO(STORE)
 STA SC
 LDA #HI(STORE)
 STA SC+1
 LDA #LO(CODE2)
 STA P
 LDA #HI(CODE2)
 STA P+1

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 LDA &C08B \ RAM card

ENDIF

IF _IB_DISK

 LDX #7

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 LDX #(&C0-&90)

ENDIF

 LDY #0

.Sept3

 LDA (SC),Y
 STA (P),Y
 INY
 BNE Sept3
 INC SC+1
 INC P+1
 DEX

IF _IB_DISK

 BPL Sept3

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 BNE Sept3

ENDIF

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 LDA &C081              \ ROMs ???

ENDIF

 JSR DEEOR              \ Decrypt the main game code between &1300 and &9FFF

\JSR Checksum           \ This instruction is commented out in the original
                        \ source

IF _IB_DISK

 LDA #&30               \ ???
 STA &8342
 NOP
 NOP

ENDIF

 JSR COLD               \ ???

 JMP BEGIN              \ Jump to BEGIN to start the game

INCLUDE "library/master/main/subroutine/deeor.asm"
INCLUDE "library/master/main/subroutine/deeors.asm"
INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk-cold.asm"
INCLUDE "library/advanced/main/variable/tribdir.asm"
INCLUDE "library/advanced/main/variable/tribdirh.asm"
INCLUDE "library/advanced/main/variable/spmask.asm"
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
INCLUDE "library/master/main/subroutine/bomboff.asm"
INCLUDE "library/master/main/subroutine/bombeff2.asm"
INCLUDE "library/master/main/subroutine/bombon.asm"
INCLUDE "library/master/main/variable/bombpos.asm"
INCLUDE "library/master/main/variable/bombtbx.asm"
INCLUDE "library/master/main/variable/bombtby.asm"
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
 SAVE "versions/apple/3-assembled-output/ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ Produces the binary file ELTB.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_B% = P%

 LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/univ.asm"

\ ******************************************************************************
\
\       Name: NLI4
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.NLI4

 LDX #39                \ ???

.NLL1

 LDA &480,X
 CMP #160
 BEQ NLI5
 LDA #&AD
 STA &500,X

.NLI5

 DEX
 BPL NLL1
 RTS

INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/apple/main/subroutine/pixel.asm"
INCLUDE "library/apple/main/variable/twos3.asm"
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

\ ******************************************************************************
\
\       Name: DIALS (Part 1 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: speed indicator
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ This routine updates the dashboard. First we draw all the indicators in the
\ right part of the dashboard, from top (speed) to bottom (energy banks), and
\ then we move on to the left part, again drawing from top (forward shield) to
\ bottom (altitude).
\
\ This first section starts us off with the speedometer in the top right.
\
\ ******************************************************************************

.DIALS

 LDY #0                 \ ???

 LDA #210
 STA K

 LDX #RED

 LDA MCNT               \ A will be non-zero for 8 out of every 16 main loop
 AND #%00001000         \ counts, when bit 4 is set, so this is what we use to
                        \ flash the "danger" colour

 AND FLH                \ A will be zeroed if flashing colours are disabled

 BEQ P%+4               \ If A is zero, skip the next instruction

 LDX #WHITE             \ ???

 STX K+2

 LDA DELTA
 JSR DIS2

\ ******************************************************************************
\
\       Name: DIALS (Part 2 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: pitch and roll indicators
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA #WHITE             \ ???
 STA COL
 LDA ALP1
 LSR A
 BIT ALP2+1
 JSR DIS5
 LDA BET1
 ASL A
 BIT BET2
 JSR DIS5

\ ******************************************************************************
\
\       Name: DIALS (Part 3 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: four energy banks
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA ENERGY             \ ???
 LSR A

.DIL1

 STA K+1                \ ???
 JSR DIS2
 LDA K+1
 SEC
 SBC #32
 BCS P%+4
 LDA #0
 CPY #7
 BNE DIL1

INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"

\ ******************************************************************************
\
\       Name: DIS1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update a bar-based indicator on the dashboard
\
\ ******************************************************************************

.DIS1

 LSR A                  \ Like DILX
 LSR A
 LSR A

.DIS2

 CMP #32
 BCC P%+4
 LDA #31
 LDX dialc1,Y
 CMP dialle,Y
 BCC DI3
 LDX dialc2,Y

.DI3

 CPX #&FF
 BNE DI4
 LDX K+2
 CLC

.DI4

 INY
 PHA
 CMP dials-1,Y
 BNE DI6
 TXA
 CMP dialc-1,Y
 BEQ DI8

.DI6

 TXA
 LDX dialc-1,Y
 STA dialc-1,Y
 LDA dials-1,Y
 JSR DIS7
 LDX dialc-1,Y
 PLA
 STA dials-1,Y

.DIS7

 STX COL
 LDX dialY-1,Y
 STX Y1
 LDX K
 STX X1
 CLC
 ADC K
 AND #&FE
 STA X2
 JSR P%+3
 JMP MSBARS

.DI8

 PLA

.DIR1

 RTS

\ ******************************************************************************
\
\       Name: DIS5
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the roll or pitch indicator on the dashboard
\
\ ******************************************************************************

.DIS5

 BPL DI9                \ Like DIL2
 EOR #&FF
 CLC
 ADC #1

.DI9

 INY
 CLC
 ADC #224
 CMP dials-1,Y
 BEQ DIR1
 PHA
 LDA dials-1,Y
 BEQ P%+5
 JSR DIS6
 PLA
 STA dials-1,Y

.DIS6

 STA X1
 LDA dialY-1,Y
 STA Y1
 CLC
 ADC #6
 STA Y2
 JMP VLOIN

\ ******************************************************************************
\
\       Name: dialY
\       Type: Variable
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

.dialY

 EQUB &89
 EQUB &90
 EQUB &98
 EQUB &B9
 EQUB &B1
 EQUB &A9
 EQUB &A1
 EQUB &89
 EQUB &91
 EQUB &99
 EQUB &B1
 EQUB &A1
 EQUB &A9

\ ******************************************************************************
\
\       Name: dialle
\       Type: Variable
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

.dialle

 EQUB 28
 EQUB  0
 EQUB  0
 EQUB 16
 EQUB  0
 EQUB  0
 EQUB  0
 EQUB  8
 EQUB  8
 EQUB  0
 EQUB  8
 EQUB 24
 EQUB 24

\ ******************************************************************************
\
\       Name: dialc1
\       Type: Variable
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

.dialc1

 EQUB WHITE
 EQUB WHITE
 EQUB WHITE
 EQUB &FF
 EQUB VIOLET
 EQUB VIOLET
 EQUB VIOLET
 EQUB &FF
 EQUB &FF
 EQUB GREEN
 EQUB &FF
 EQUB BLUE
 EQUB BLUE

\ ******************************************************************************
\
\       Name: dialc2
\       Type: Variable
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

.dialc2

 EQUB &FF
 EQUB WHITE
 EQUB WHITE
 EQUB VIOLET
 EQUB VIOLET
 EQUB VIOLET
 EQUB VIOLET
 EQUB VIOLET
 EQUB VIOLET
 EQUB GREEN
 EQUB GREEN
 EQUB &FF
 EQUB &FF

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
 SAVE "versions/apple/3-assembled-output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ Produces the binary file ELTC.bin that gets loaded by elite-bcfs.asm.
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

\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Missions
\    Summary: Wait until a key is pressed for the Constrictor mission briefing
\
\ ******************************************************************************

.PAUSE

 JSR PAUSE2             \ ???

\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: Missions
\    Summary: Scan the keyboard for the Constrictor mission briefing
\
\ ******************************************************************************

.PAS1

 LDA #1                 \ ???
 JMP TT66

INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"

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
 SAVE "versions/apple/3-assembled-output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_D% = P%

 LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/master/main/subroutine/scaley.asm"
INCLUDE "library/master/main/subroutine/scaley2.asm"
INCLUDE "library/master/main/subroutine/scalex.asm"
INCLUDE "library/master/main/subroutine/dvloin.asm"
INCLUDE "library/enhanced/main/subroutine/tnpr1.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/advanced/main/subroutine/setxc-doxc.asm"
INCLUDE "library/advanced/main/subroutine/setyc-doyc.asm"
INCLUDE "library/advanced/main/subroutine/incyc.asm"
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
 SAVE "versions/apple/3-assembled-output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ Produces the binary file ELTE.bin that gets loaded by elite-bcfs.asm.
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
INCLUDE "library/master/main/subroutine/swappzero.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/master/main/variable/exlook.asm"
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
INCLUDE "library/common/main/subroutine/dot.asm"
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
INCLUDE "library/common/main/subroutine/pls6.asm"
INCLUDE "library/master/main/subroutine/yesno.asm"
INCLUDE "library/apple/main/subroutine/tt17.asm"

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
 SAVE "versions/apple/3-assembled-output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ Produces the binary file ELTF.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_F% = P%

 LOAD_F% = LOAD% + P% - CODE%

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

\ ******************************************************************************
\
\       Name: COPYNAME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from ??? to ???
\
\ ******************************************************************************

.COPYNAME

 LDX #0                 \ ???

.COPYL1

 LDA INWK+5,X
 CMP #13
 BEQ COPYL2
 STA comnam,X
 INX
 CPX #7
 BCC COPYL1

.COPYL2

 LDA #&20

.COPYL3

 STA comnam,X
 INX
 CPX #30
 BCC COPYL3
 RTS

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

\ ******************************************************************************
\
\       Name: diskerror
\       Type: Subroutine
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.diskerror

 ASL A                  \ ???
 TAX
 LDA ERTAB-2,X
 STA XX15
 LDA ERTAB-1,X
 STA XX15+1
 LDY #0

.dskerllp

 LDA (XX15),Y
 BEQ dskerllp2
 JSR TT26
 INY
 BNE dskerllp

.dskerllp2

 JSR BOOP

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disc access menu and return
                        \ from the subroutine using a tail call

INCLUDE "library/master/main/variable/thislong.asm"
INCLUDE "library/master/main/variable/oldlong.asm"
INCLUDE "library/common/main/subroutine/lod.asm"

\ ******************************************************************************
\
\       Name: DERR1
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.DERR1

 EQUS "DISK WRITE PROTECTED"
 EQUB 0

\ ******************************************************************************
\
\       Name: DERR2
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.DERR2

 EQUS "DISK FULL"
 EQUB 0

\ ******************************************************************************
\
\       Name: DERR3
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.DERR3

 EQUS "CATALOG FULL"
 EQUB 0

\ ******************************************************************************
\
\       Name: DERR4
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.DERR4

 EQUS "DISK I/O ERROR"
 EQUB 0

\ ******************************************************************************
\
\       Name: DERR5
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.DERR5

 EQUS "FILE NOT FOUND"
 EQUB 0

\ ******************************************************************************
\
\       Name: ERTAB
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.ERTAB

 EQUW DERR1
 EQUW DERR2
 EQUW DERR3
 EQUW DERR4
 EQUW DERR5

INCLUDE "library/6502sp/main/subroutine/backtonormal.asm"
INCLUDE "library/6502sp/main/subroutine/cldelay.asm"
INCLUDE "library/6502sp/main/subroutine/zektran.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"

\ ******************************************************************************
\
\       Name: RDS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the joysticks
\
\ ******************************************************************************

.RDS1

 \Read Joystick X
 LDA &C064,X            \ ???
 BMI RDS1
 LDY &C070
 LDY #0
 NOP
 NOP

.RDL2

 LDA &C064,X
 BPL RDR1
 INY
 BNE RDL2
 DEY

.RDR1

 TYA
 EOR JSTE
 RTS

\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses
\
\ ******************************************************************************

.RDKEY

 TYA                    \ ???
 PHA
 JSR ZEKTRAN

.scanmatrix

 CLC
 LDA &C000
 BPL nokeys2
 BIT &C010
 AND #127
 STA thiskey
 LDX #16

.RDL1

 CMP KYTB,X
 BNE RD1
 DEC KEYLOOK,X

.RD1

 DEX
 BNE RDL1
 SEC

.nokeys2

 LDA JSTK

IF _IB_DISK

 BPL nofast+2

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 BPL nojoyst

ENDIF

IF _IB_DISK OR _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

 LDX auto
 BNE nojoyst
\LDX #0

ELIF _SOURCE_DISK_CODE_FILES

 LDX #0

ENDIF

 JSR RDS1
 EOR #&FF
 STA JSTX
 INX
 JSR RDS1
 EOR JSTGY
 STA JSTY

.nojoyst

 LDA #&FF
 BIT &C061
 BPL nofire
 BIT &C062
 BPL noslow
 STA KY1
 BMI nofast

.noslow

 STA KY7

.nofire

 BIT &C062
 BPL nofast
 STA KY2

.nofast

 LDA QQ11
 BEQ allkeys
 LDA #0
 STA KY12
 STA KY13
 STA KY14
 STA KY15
 STA KY16
 STA KY17
 STA KY18
 STA KY19
 STA KY20

.allkeys

 PLA
 TAY
 LDA thiskey
 TAX
 RTS

INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/variable/kytb-ikns.asm"

\ ******************************************************************************
\
\       Name: DKSANYKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: ???
\
\ ******************************************************************************

.DKSANYKEY

 LDX #0
 BIT &C000
 BPL P%+6
 DEX
 BIT &C010
 TXA
 RTS

INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
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
INCLUDE "library/advanced/main/variable/ktran.asm"

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
 SAVE "versions/apple/3-assembled-output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_G% = P%

 LOAD_G% = LOAD% + P% - CODE%

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
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
INCLUDE "library/master/main/subroutine/lsput.asm"

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
 SAVE "versions/apple/3-assembled-output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ Produces the binary file ELTH.bin that gets loaded by elite-bcfs.asm.
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
INCLUDE "library/common/main/subroutine/plut-pu1.asm"
INCLUDE "library/common/main/subroutine/look1.asm"
INCLUDE "library/common/main/subroutine/sight.asm"
INCLUDE "library/master/main/variable/sightcol.asm"
INCLUDE "library/master/main/variable/beamcol.asm"
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
 SAVE "versions/apple/3-assembled-output/ELTH.bin", CODE_H%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE I FILE
\
\ Produces the binary file ELTI.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_I% = P%

 LOAD_I% = LOAD% + P% - CODE%

INCLUDE "library/master/main/subroutine/yetanotherrts.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"

\ ******************************************************************************
\
\       Name: BOOP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a long, low beep
\
\ ******************************************************************************

.BOOP

 LDY #99                \ ???
 LDX #&FF
 BNE SOBEEP

\ ******************************************************************************
\
\       Name: SOHISS
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SOHISS

 BIT DNOIZ              \ ???
 BMI SOUR

.SOHISS2

 LDA &C030
 JSR DORND
 DEX
 NOP
 NOP
 BNE P%-3
 DEY
 BNE SOHISS2
 LDA &C030
 RTS

\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ******************************************************************************

.EXNO3

 LDY #40                \ ???

\ ******************************************************************************
\
\       Name: SOEXPL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ******************************************************************************

.SOEXPL

 BIT DNOIZ              \ ???
 BMI SOUR
 LDX #50
 STX T3

.BEEPL4

 LDA &C030
 INC T3
 LDX T3
 DEX
 NOP
 NOP
 BNE P%-3
 JSR DORND
 DEX
 NOP
 BNE P%-2
 DEY
 BNE BEEPL4
 LDA &C030
 RTS

\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SOBEEP              ???
\
\   SOUR                Contains an RTS
\
\ ******************************************************************************

.BEEP

 LDY #30                \ ???
 LDX #110

.SOBEEP

 BIT DNOIZ
 BMI SOUR
 STX T3

.BEEPL1

 LDA &C030
 LDX T3
 DEX
 BNE P%-1
 DEY
 BNE BEEPL1
 LDA &C030

.SOUR

 RTS

\ ******************************************************************************
\
\       Name: SOBLIP
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SOBLIP

 BIT DNOIZ              \ ???
 BMI SOUR
 STX T3

.BEEPL2

 LDA &C030
 DEC T3
 LDX T3
 DEX
 NOP
 BNE P%-2
 DEY
 BNE BEEPL2
 LDA &C030
 RTS

\ ******************************************************************************
\
\       Name: LASNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.LASNOISE

 LDY #11                \ ???
 LDX #150

.SOBLOP

 BIT DNOIZ
 BMI SOUR
 STX T3

.BEEPL3

 LDA &C030
 INC T3
 INC T3
 LDX T3
 DEX
 BNE P%-1
 DEY
 BNE BEEPL3
 LDA &C030
 RTS

\ ******************************************************************************
\
\       Name: LASNOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.LASNOISE2

 LDY #11                \ ???
 LDX #130

\ ******************************************************************************
\
\       Name: SOBOMB
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SOBOMB

 BIT DNOIZ              \ ???
 BMI SOUR
 LDY #25

.SOHISS4

 LDA &C030
 JSR DORND
 AND #31
 ORA #&E0
 TAX
 DEX
 NOP
 BNE P%-2
 DEY
 BNE SOHISS4
 LDA &C030
 RTS

\ ******************************************************************************
\
\       Name: CLICK
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.CLICK

 BIT DNOIZ              \ ???
 BMI SOUR2
 LDA &C030

.SOUR2

 RTS

\ ******************************************************************************
\
\       Name: COLD
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure memory and set up NMI and character handlers ???
\
\ ******************************************************************************

.COLD

 \Page out KERNAL etc
 JSR HGR                \ ???
 LDA #8
 STA SC+1
 LDX #2
 LDA #0
 STA SC
 TAY

.zerowksploop

 STA (SC),Y
 INY
 BNE zerowksploop
 INC SC+1
 DEX
 BNE zerowksploop

.zerowkl2

 STA &200,Y
 DEY
 BNE zerowkl2
 LDA #LO(NMIpissoff)
 STA NMIV
 LDA #HI(NMIpissoff)
 STA NMIV+1
 LDA #LO(CHPR2)
 STA CHRV
 LDA #HI(CHPR2)
 STA CHRV+1
 SEI

IF NOT(USA%)
 \UK CHECK
ENDIF

 RTS

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
 SAVE "versions/apple/3-assembled-output/ELTI.bin", CODE_I%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE J FILE
\
\ Produces the binary file ELTJ.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_J% = P%

 LOAD_J% = LOAD% + P% - CODE%

\ ******************************************************************************
\
\       Name: comnam
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

\ DOS_RW1

.comnam

 \ (must be 30 characters long - pad with spaces)
 EQUS "COMMANDER                     "

\ ******************************************************************************
\
\       Name: rfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a Commander file from a DOS disk into buffer
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              C = 1 file not found, C = 0 file found and in buffer
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   rfile3              Contains an RTS
\
\ ******************************************************************************

.rfile

 TSX                    \ ???
 STX stkptr
 JSR findf
 LDA #5
 BCS rfile3 \ branch if file not found
 JSR gettsl \ get track/sector list of file
 JSR rsect \ read first sector of file
 LDY #0

.rfile2

 LDA buffer+4,Y
 STA comfil,Y \ copy buffer to commander file
 INY
 CPY #comsiz \loop other way ## <2BS>
 BNE rfile2
 CLC

.rfile3

 RTS

\ ******************************************************************************
\
\       Name: wfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a commander file from buffer to a DOS disk
\
\ ******************************************************************************

.wfile

 JSR MUTILATE           \ ???
 TSX
 STX stkptr
 JSR findf
 BCC oldfil \ branch if file already exists

.newfil

 \ save a new commander file
 JSR isfull \ check for at least two free sectors
 LDA #2
 BCS rfile3 \ branch if disc full
 JSR finde \ find an empty file entry
 LDA #3
 BCS rfile3 \ branch if cat full
 LDA tsltrk
 STA buffer,Y \ tsl track field
 LDA tslsct
 STA buffer+1,Y \ tsl sector field
 LDA #4
 STA buffer+2,Y \ file type = BINARY file
 LDA #2
 STA buffer+&21,Y \ sectors lo = 2
 LDA #0
 STA buffer+&22,Y \ sectors hi = 0
 TAX

.newfl2

 LDA comnam,X
 ORA #&80
 STA buffer+3,Y \ copy commander name to file name field
 INY
 INX
 CPX #30
 BNE newfl2
 JSR wsect \ write catalog sector to disc
 JSR isfull \ allocate two free sectors
 JSR wsect \ write VTOC

.newfl3

 LDA #0
 TAY

.newfl4

 STA buffer,Y \ init tsl
 INY
 BNE newfl4
 LDA filtrk
 STA buffer+12 \ track of commander file
 LDA filsct
 STA buffer+13 \ sector of commander file
 LDA tsltrk
 STA track
 LDA tslsct
 STA sector
 JSR wsect \ write tsl sector
 LDA filtrk
 STA track
 LDA filsct
 STA sector
 BPL oldfl2 \ always

.oldfil

 \ update an existing commander file
 JSR gettsl \ get tsl of file

.oldfl2

 LDY #0

.oldfl3

 LDA comfil,Y
 STA buffer+4,Y \ copy commander file to buffer
 INY
 CPY #comsiz
 BNE oldfl3
 JMP wsect \ write first sector of commander file

\ ******************************************************************************
\
\       Name: findf
\       Type: Subroutine
\   Category: Save and load
\    Summary: Find an existing file
\
\ ******************************************************************************

.findf

 CLC                    \ ???
 BCC rentry \ always

\ ******************************************************************************
\
\       Name: finde
\       Type: Subroutine
\   Category: Save and load
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   rentry              ???
\
\ ******************************************************************************

.finde

 \ find a new entry
 SEC

.rentry

 ROR atemp0
 JSR rvtoc \ read VTOC

.rentr2

 LDA buffer+1 \ read track of next catalog
 STA track
 LDA buffer+2 \ read sector of next catalog
 STA sector
 JSR rsect \ read catalog sector
 LDY #&B \ point to first entry in sector

.rentr3

 LDA buffer,Y
 BIT atemp0
 BPL rentr4 \ branch if searching catalog for a file
 TAX
 BEQ rentr6 \ branch if found blank entry
 CMP #&FF \INX ##
 BEQ rentr6 \ branch if found deleted entry
 BNE rentr8 \ branch if used entry

.rentr4

 TAX
 BEQ rentr9 \ branch if last catalog entry
 CMP #&FF
 BEQ rentr8 \ branch if deleted file
 TYA
 PHA
 LDX #0

.rentr5

 LDA buffer+3,Y
 AND #&7F
 CMP comnam,X
 BNE rentr7 \ branch if names don't match
 INY
 INX
 CPX #30
 BNE rentr5
 PLA
 TAY \ Y points to start of file entry

.rentr6

 CLC \ signifies file found
 RTS

.rentr7

 PLA
 TAY

.rentr8

 TYA
 CLC
 ADC #35
 TAY
 BNE rentr3 \ branch if not reached last entry
 LDA buffer+1
 BNE rentr2 \ branch if not last catalog sector

.rentr9

 SEC \ signifies file not found
 RTS

\ ******************************************************************************
\
\       Name: getsct
\       Type: Subroutine
\   Category: Save and load
\    Summary: Allocate one free sector from VTOC - doesn't update VTOC on disk
\
\ ******************************************************************************

.getsct

 LDA #0                 \ ???
 STA ztemp0 \ init allocation flag
 BEQ getsc4 \ always

.getsc3

 LDA dirtrk

.getsc4

 CLC
 ADC fretrk \ add last allocated track to direction of allocation
 BEQ getsc5 \ branch if track 0
 CMP tracks
 BCC getsc7 \ branch if not last track+1
 LDA #&FF
 BNE getsc6 \ always - direction  =  backwards

.getsc5

 LDA ztemp0
 BNE getscB \ branch if no free sectors - disc full
 LDA #1 \ direction = forwards
 STA ztemp0

.getsc6

 STA dirtrk \ change direction
 CLC
 ADC #17

.getsc7

 STA fretrk
 ASL A
 ASL A
 TAY
 LDX #16
 LDA bitmap,Y
 BNE getsc8 \ branch if not all allocated
 INY
 LDX #8
 LDA bitmap,Y
 BEQ getsc3 \ branch if all allocated

.getsc8

 STX ztemp0
 LDX #0

.getsc9

 INX
 DEC ztemp0 \ sector = sector-1
 ROL A
 BCC getsc9 \ loop until got a free sector
 CLC \ allocate sector by clearing bit

.getscA

 ROR A \ shift bits back again
 DEX
 BNE getscA
 STA bitmap,Y \ update VTOC
 LDX fretrk \ next free track
 LDY ztemp0 \ next free sector
 CLC \ signifies one sector has been allocated
 RTS

.getscB

 SEC \ signifies disc full
 RTS

\ ******************************************************************************
\
\       Name: isfull
\       Type: Subroutine
\   Category: Save and load
\    Summary: Search VTOC for tsl sector and commander file sector
\
\ ******************************************************************************

.isfull

 JSR rvtoc              \ read VTOC ???
 JSR getsct \ find free sector for tsl
 BCS isful2 \ branch if disc full
 STX tsltrk
 STY tslsct
 JSR getsct \ find free sector for commander file
 STX filtrk
 STY filsct

.isful2

 RTS \ C = 0 = disc full, C = 1 = enough space

\ ******************************************************************************
\
\       Name: gettsl
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read a file's track sector list
\
\ ******************************************************************************

.gettsl

 LDA buffer,Y           \ get track of tsl ???
 STA track
 LDA buffer+1,Y \ get sector of tsl
 STA sector
 JSR rsect \ read tsl
 LDY #&C
 LDA buffer,Y \ get track of first sector of file
 STA track
 LDA buffer+1,Y \ get sector of first sector of file
 STA sector
 RTS

\ ******************************************************************************
\
\       Name: rvtoc
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read VTOC sector into buffer
\
\ ******************************************************************************

.rvtoc

 LDA #17                \ ???
 STA track
 LDA #0
 STA sector

\ ******************************************************************************
\
\       Name: rsect
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read sector from disk into buffer
\
\ ******************************************************************************

 \REM DOS_RW2

.rsect

 CLC                    \ ???
 BCC wsect2 \ always

\ ******************************************************************************
\
\       Name: wsect
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write sector from buffer to disk
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   wsect2              ???
\
\ ******************************************************************************

.wsect

 SEC                    \ ???

.wsect2

 \ drive = 1, track = ?track, sector = ?sector
 PHP
 LDA #&60
 STA slot16
 LDA #2
 STA recals \ init max number of arm recalibrations
 LDA #4
 STA seeks \ init max number of seeks
 LDA #&D8
 STA mtimeh \ init motor on time hi
 LDX slot16 \ get slot number*16 of controller card
 LDA Q7L,X \ prepare latch for input
 LDA Q6L,X \ strobe data latch for I/O
 LDY #8

.rwts2

 LDA Q6L,X \ read data
 PHA \ short delay
 PLA
 PHA
 PLA
 CMP &100
 CMP Q6L,X
 BNE rwts3 \ branch if data latch changed ie. disc is spinning
 DEY
 BNE rwts2

.rwts3

 PHP \ save result - Z = 0 = disc is spinning, Z = 1 = disc not spinning
 LDA mtron,X \ turn motor on - if disc was not spinning
 LDA drv1en,X \ enable drive 1
 PLP
 PHP
 BNE rwts5 \ branch if disc is spinning
 LDY #7

.rwts4

 JSR armwat \ wait for capacitor to discharge
 DEY
 BNE rwts4
 LDX slot16

.rwts5

 LDA track
 JSR seek
 PLP
 BNE trytrk \ branch if disc is spinning
 LDY mtimeh
 BPL trytrk \ branch if motor reached correct speed

.rwts6

 LDY #18 \ delay for motor to reach correct speed

.rwts7

 DEY
 BNE rwts7
 INC mtimel
 BNE rwts6
 INC mtimeh
 BNE rwts6

.trytrk

 PLP \ get read/write status
 PHP
 BCC trytr2 \ branch if read sector
 JSR prenib \ convert sector to 6 bit 'nibbles'

.trytr2

 LDY #48
 STY ztemp2

.trytr3

 LDX slot16
 JSR rdaddr \ find track address
 BCC rdrght \ branch if no error

.trytr4

 DEC ztemp2
 BPL trytr3 \ branch if not last try

.trytr5

 DEC recals
 BEQ drverr \ branch if last try
 LDA #4
 STA seeks
 LDA #&60
 STA curtrk
 LDA #0
 JSR seek \ reset head

.trytr6

 LDA track
 JSR seek \ seek to desired track
 JMP trytr2

.rdrght

 LDY idfld+2
 CPY track
 BEQ rttrk \ branch if track does match track id
 DEC seeks
 BNE trytr6
 BEQ trytr5 \ always

.prterr

 \ disc write protected
 LDA #1
 BPL drver2_copy

{
.drverr     \ Removed as it isn't used and clashes with drverr below
}

 \ disc I/O error
 LDA #4 \ I/O error

.drver2

 LDX stkptr
 TXS
 LDX slot16
 LDY mtroff,X \ turn motor off
 SEC \ signify error has occured
 RTS

.rttrk

 LDY sector
 LDA scttab,Y
 CMP idfld+1
 BNE trytr4 \ branch if sector doesn't match sector id
 PLP
 BCS rttrk2 \ branch if write sector
 JSR read
 PHP
 BCS trytr4 \ branch if read error
 PLP
 JSR pstnib \ convert sector to 8 bit bytes
 JMP rttrk3

.rttrk2

 JSR write
 BCC rttrk3 \ branch if no error
 LDA #1

 BPL drver2

.drverr

 \ disc I/O error
 LDA #4 \ I/O error

\.drver2

.drver2_copy            \ Added as drver2 is repeated

 LDX stkptr
 TXS
 SEC
 BCS rttrk4

.rttrk3

 LDA #0
 CLC

.rttrk4

 LDX slot16
 LDY mtroff,X \ turn motor off
 RTS \ C = 0 = no error, C = 1 = error, A = error code

\ ******************************************************************************
\
\       Name: read
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read sector
\
\ ******************************************************************************

.read

 LDY #32                \ ???

.read2

 DEY
 BEQ readE

.read3

 LDA Q6L,X
 BPL read3

.read4

 EOR #&D5
 BNE read2
 NOP

.read5

 LDA Q6L,X
 BPL read5
 CMP #&AA
 BNE read4
 LDY #&56

.read6

 LDA Q6L,X
 BPL read6
 CMP #&AD
 BNE read4
 LDA #0

.read7

 DEY
 STY ztemp0

.read8

 LDY Q6L,X
 BPL read8
 EOR rtable-&96,Y
 LDY ztemp0
 STA buffr2+256,Y
 BNE read7

.read9

 STY ztemp0

.readA

 LDY Q6L,X
 BPL readA
 EOR rtable-&96,Y
 LDY ztemp0
 STA buffr2,Y
 INY
 BNE read9

.readB

 LDY Q6L,X
 BPL readB
 CMP rtable-&96,Y
 BNE readE

.readC

 LDA Q6L,X
 BPL readC
 CMP #&DE
 BNE readE
 NOP

.readD

 LDA Q6L,X
 BPL readD
 CMP #&AA
 BEQ readF

.readE

 SEC
 RTS

.readF

 CLC
 RTS

\ ******************************************************************************
\
\       Name: write
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write sector
\
\ ******************************************************************************

.write

 SEC                    \ ???
 STX ztemp1
 LDA Q6H,X
 LDA Q7L,X
 BMI write6
 LDA buffr2+256
 STA ztemp0
 LDA #&FF
 STA Q7H,X
 ORA Q6L,X
 PHA
 PLA
 NOP
 LDY #4

.write2

 PHA
 PLA
 JSR wbyte2
 DEY
 BNE write2
 LDA #&D5
 JSR wbyte
 LDA #&AA
 JSR wbyte
 LDA #&AD
 JSR wbyte
 TYA
 LDY #&56
 BNE write4

.write3

 LDA buffr2+256,Y

.write4

 EOR buffr2+255,Y
 TAX
 LDA wtable,X
 LDX ztemp1
 STA Q6H,X
 LDA Q6L,X
 DEY
 BNE write3
 LDA ztemp0
 NOP

.write5

 EOR buffr2,Y
 TAX
 LDA wtable,X
 LDX slot16
 STA Q6H,X
 LDA Q6L,X
 LDA buffr2,Y
 INY
 BNE write5
 TAX
 LDA wtable,X
 LDX ztemp1
 JSR wbyte3
 LDA #&DE
 JSR wbyte
 LDA #&AA
 JSR wbyte
 LDA #&EB
 JSR wbyte
 LDA #&FF
 JSR wbyte
 LDA Q7L,X

.write6

 LDA Q6L,X
 RTS

\ ******************************************************************************
\
\       Name: rdaddr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read track address field
\
\ ******************************************************************************

 \REM DOS_RW3

.rdaddr

 \ read track address field
 LDY #&FC
 STY ztemp0

.rdadr2

 INY
 BNE rdadr3
 INC ztemp0
 BEQ rdadrD

.rdadr3

 LDA Q6L,X
 BPL rdadr3

.rdadr4

 CMP #&D5
 BNE rdadr2
 NOP

.rdadr5

 LDA Q6L,X
 BPL rdadr5
 CMP #&AA
 BNE rdadr4
 LDY #3

.rdadr6

 LDA Q6L,X
 BPL rdadr6
 CMP #&96
 BNE rdadr4
 LDA #0

.rdadr7

 STA ztemp1

.rdadr8

 LDA Q6L,X
 BPL rdadr8
 ROL A
 STA ztemp0

.rdadr9

 LDA Q6L,X
 BPL rdadr9
 AND ztemp0
 STA idfld,Y
 EOR ztemp1
 DEY
 BPL rdadr7
 TAY
 BNE rdadrD

.rdadrA

 LDA Q6L,X
 BPL rdadrA
 CMP #&DE
 BNE rdadrD
 NOP

.rdadrB

 LDA Q6L,X
 BPL rdadrB
 CMP #&AA
 BNE rdadrD

.rdadrC

 CLC
 RTS

.rdadrD

 SEC
 RTS

\ ******************************************************************************
\
\       Name: seek
\       Type: Subroutine
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.seek

 \ A = desired track
 STX ztemp0             \ ???
 ASL A
 CMP curtrk
 BEQ step3 \ branch if head already over desired track
 STA ztemp1 \ save desired track*2
 LDA #0
 STA ztemp2

.seek2

 LDA curtrk
 STA ztemp3
 SEC
 SBC ztemp1
 BEQ seek7 \ branch if reached desired track
 BCS seek3 \ branch if step back
 EOR #&FF
 INC curtrk \ track = track+1
 BCC seek4 \ always

.seek3

 ADC #&FE
 DEC curtrk \ track = track-1

.seek4

 CMP ztemp2
 BCC seek5
 LDA ztemp2

.seek5

 CMP #12
 BCS seek6
 TAY

.seek6

 SEC
 JSR step
 LDA armtab,Y
 JSR armwat
 LDA ztemp3
 CLC
 JSR step2
 LDA armtb2,Y
 JSR armwat
 INC ztemp2
 BNE seek2 \ always

.seek7

 JSR armwat
 CLC

\ ******************************************************************************
\
\       Name: step
\       Type: Subroutine
\   Category: Save and load
\    Summary: Step drive head
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   step2               ???
\
\   step3               Contains an RTS
\
\ ******************************************************************************

.step

 LDA curtrk             \ ???

.step2

 AND #3
 ROL A
 ORA ztemp0
 TAX
 LDA phsoff,X \ stepper motor phase 0-3 on/off
 LDX ztemp0

.step3

 RTS

\ ******************************************************************************
\
\       Name: armwat
\       Type: Subroutine
\   Category: Save and load
\    Summary: Arm move delay
\
\ ******************************************************************************

.armwat

 LDX #17                \ ???

.armwt2

 DEX
 BNE armwt2
 INC mtimel
 BNE armwt3
 INC mtimeh

.armwt3

 SEC
 SBC #1
 BNE armwat
 RTS

\ ******************************************************************************
\
\       Name: armtab
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.armtab

 EQUB 1
 EQUB &30
 EQUB &28
 EQUB &24
 EQUB &20
 EQUB &1E
 EQUB &1D
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C

\ ******************************************************************************
\
\       Name: armtb2
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.armtb2

 EQUB &70
 EQUB &2C
 EQUB &26
 EQUB &22
 EQUB &1F
 EQUB &1E
 EQUB &1D
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C
 EQUB &1C

\ ******************************************************************************
\
\       Name: prenib
\       Type: Subroutine
\   Category: Save and load
\    Summary: Convert 256*8 bit bytes to 342*6 bit 'nibbles'
\
\ ******************************************************************************

.prenib

 LDX #0                 \ ???
 LDY #2

.prenb2

 DEY
 LDA buffer,Y
 LSR A
 ROL buffr2+256,X
 LSR A
 ROL buffr2+256,X
 STA buffr2,Y
 INX
 CPX #&56
 BCC prenb2
 LDX #0
 TYA
 BNE prenb2
 LDX #&55

.prenb3

 LDA buffr2+256,X
 AND #&3F
 STA buffr2+256,X
 DEX
 BPL prenb3
 RTS

\ ******************************************************************************
\
\       Name: pstnib
\       Type: Subroutine
\   Category: Save and load
\    Summary: Convert 342*6 bit 'nibbles' to 256*8 bit bytes
\
\ ******************************************************************************

.pstnib

 LDY #0                 \ ???

.pstnb2

 LDX #&56

.pstnb3

 DEX
 BMI pstnb2
 LDA buffr2,Y
 LSR buffr2+256,X
 ROL A
 LSR buffr2+256,X
 ROL A
 STA buffer,Y
 INY
 BNE pstnb3
 RTS

\ ******************************************************************************
\
\       Name: wbyte
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write one byte to disk
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   wbyte2              ???
\
\   wbyte3              ???
\
\ ******************************************************************************

.wbyte

 CLC                    \ ???

.wbyte2

 PHA
 PLA

.wbyte3

 STA Q6H,X
 ORA Q6L,X
 RTS

\ ******************************************************************************
\
\       Name: scttab
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.scttab

 EQUD &090B0D00
 EQUD &01030507
 EQUD &080A0C0E
 EQUD &0F020406

\ ******************************************************************************
\
\       Name: rtable
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.rtable

 EQUD &99980100
 EQUD &049C0302
 EQUD &A1A00605
 EQUD &A5A4A3A2
 EQUD &A9A80807
 EQUD &0B0A09AA
 EQUD &B1B00D0C
 EQUD &11100F0E
 EQUD &14B81312
 EQUD &18171615
 EQUD &C1C01A19
 EQUD &C5C4C3C2
 EQUD &C9C8C7C6
 EQUD &1CCC1BCA
 EQUD &D1D01E1D
 EQUD &D5D41FD2
 EQUD &22D82120
 EQUD &26252423
 EQUD &E1E02827
 EQUD &29E4E3E2
 EQUD &2CE82B2A
 EQUD &302F2E2D
 EQUD &F1F03231
 EQUD &36353433
 EQUD &39F83837
 EQUD &3D3C3B3A
 EQUW &3F3E

\ ******************************************************************************
\
\       Name: MUTILATE
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MUTIL3              ???
\
\ ******************************************************************************

.MUTILATE

 LDA CHK3
 EOR RAND
 STA RAND
 STA comfil2
 EOR #&A5
 ORA #17
 EOR RAND+1
 STA RAND+1
 STA comfil2+1
 EOR RAND+2
 EOR #&F8
 STA RAND+2
 STA comfil2+2
 EOR RAND+3
 EOR #&12
 STA RAND+3
 STA comfil2+3

.MUTIL3

 LDY #comsiz-5

.MUTIL1

 JSR DORND2
 EOR comfil,Y
 STA comfil,Y
 DEY
 BPL MUTIL1
 RTS

\ ******************************************************************************
\
\       Name: UNMUTILATE
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.UNMUTILATE

 LDY #3

.MUTIL2

 LDA comfil2,Y
 STA RAND,Y
 DEY
 BPL MUTIL2
 BMI MUTIL3

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
 SAVE "versions/apple/3-assembled-output/ELTJ.bin", CODE_J%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE K FILE
\
\ Produces the binary file ELTK.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_K% = P%

 LOAD_K% = LOAD% + P% - CODE%

 OSWRCH = &FFEE
 OSBYTE = &FFF4
 OSWORD = &FFF1
 OSFILE = &FFDD
 SCLI = &FFF7
 VIA = &FE40
 USVIA = VIA
 IRQ1V = &204
 VSCAN = 57
 WRCHV = &20E
 WORDV = &20C
 RDCHV = &210
 protlen = 0
 BULBCOL = &E0

INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"

\ ******************************************************************************
\
\       Name: cellocl
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.cellocl

 EQUD &82028202
 EQUD &82028202
 EQUD &AA2AAA2A
 EQUD &AA2AAA2A
 EQUD &D252D252
 EQUD &D252D252

\ ******************************************************************************
\
\       Name: SCTBL
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.SCTBL

 EQUW &8000
 EQUW &8000
 EQUW &8000
 EQUW &8000
 EQUW &A828
 EQUW &A828
 EQUW &A828
 EQUW &A828
 EQUW &D050
 EQUW &D050
 EQUW &D050
 EQUW &D050

\ ******************************************************************************
\
\       Name: SCTBH
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.SCTBH

 EQUW &2020
 EQUW &2121
 EQUW &2222
 EQUW &2323
 EQUW &2020
 EQUW &2121
 EQUW &2222
 EQUW &2323
 EQUW &2020
 EQUW &2121
 EQUW &2222
 EQUW &2323
 EQUW &2020
 EQUW &2020
 EQUW &2020
 EQUW &2020   \safety

\ ******************************************************************************
\
\       Name: SCTBH2
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.SCTBH2

 \ can loose this table by adding &1C00 to SCTBH references

 EQUW &3C3C
 EQUW &3D3D
 EQUW &3E3E
 EQUW &3F3F
 EQUW &3C3C
 EQUW &3D3D
 EQUW &3E3E
 EQUW &3F3F
 EQUW &3C3C
 EQUW &3D3D
 EQUW &3E3E
 EQUW &3F3F

\ ******************************************************************************
\
\       Name: LOIN (Part 1 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Calculate the line gradient in the form of deltas
\
\ ******************************************************************************

\.grubbyline
\RTS

.LL30

.LOIN

 STY YSAV
\LDA Y1
\CMP #Y*2
\BCS grubbyline
\LDA Y2
\CMP #Y*2
\BCS grubbyline
 \**
 LDA #128
 STA S
 ASL A
 STA SWAP
 LDA X2
 SBC X1
 BCS LI1
 EOR #&FF
 ADC #1
 SEC

.LI1

 STA P
 LDA Y2
 SBC Y1
 BCS LI2
 EOR #&FF
 ADC #1

.LI2

 STA Q
 CMP P
 BCC STPX
 JMP STPY

.STPX

 LDX X1
 CPX X2
 BCC LI3
 DEC SWAP
 LDA X2
 STA X1
 STX X2
 TAX
 LDA Y2
 LDY Y1
 STA Y1
 STY Y2

.LI3

 LDA Y1
 LSR A
 LSR A
 LSR A
 STA T1
 TAY
 LDA SCTBL,Y
 STA SC
 LDA Y1
 AND #7
 STA T2
 ASL A
 ASL A
 ADC SCTBH,Y
 STA SC+1 \SC = address of leftmost byte in correct row
 LDY SCTBX1,X
 LDA TWOS,Y
 STA R
 LDY SCTBX2,X
 LDX Q
 BNE LIlog7
 TXA
 BEQ LIlog6

.LIlog7

 LDA logL,X
 LDX P
 SEC
 SBC logL,X
 LDX Q
 LDA log,X
 LDX P
 SBC log,X
 BCC P%+6
 LDA #&FF
 BNE LIlog6
 TAX
 LDA alogh,X

.LIlog6

 STA Q
 SEC
 LDX P
 INX
 LDA Y2
 SBC Y1
 BCS DOWN
 \...
 LDA SWAP
 BNE LI6
 DEX

.LIL2

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI6

 ASL R
 BPL LI7
 LDA #1
 STA R
 INY

.LI7

 LDA S
 ADC Q
 STA S
 BCC LIC2
 DEC T2
 BMI LI20
 LDA SC+1
 SBC #4
 STA SC+1

.LIC2

 DEX
 BNE LIL2
 LDY YSAV
 RTS

.LI20

 LDA #7
 STA T2
 STX T
 LDX T1
 DEX
 STX T1
 LDA SCTBL,X
 STA SC
 LDA SCTBH2,X
 LDX T
 STA SC+1
 JMP LIC2
 \.....

.DOWN

 LDA T2
 EOR #7
 STA T2
 LDA SWAP
 BEQ LI9
 DEX

.LIL3

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI9

 ASL R
 BPL LI10
 LDA #1
 STA R
 INY

.LI10

 LDA S
 ADC Q
 STA S
 BCC LIC3
 DEC T2
 BMI LI21
 LDA SC+1
 ADC #3
 STA SC+1

.LIC3

 DEX
 BNE LIL3
 LDY YSAV
 RTS

.LI21

 LDA #7
 STA T2
 STX T
 LDX T1
 INX
 STX T1
 LDA SCTBL,X
 STA SC
 LDA SCTBH,X
 STA SC+1
 LDX T
 JMP LIC3
 \.....

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

 LSR A
 LSR A
 LSR A
 STA T1
 TAY
 LDA SCTBL,Y
 STA SC
 LDA Y1
 AND #7
 STA T2
 ASL A
 ASL A
 ADC SCTBH,Y
 STA SC+1
 LDY SCTBX1,X
 LDA TWOS,Y
 STA R
 LDY SCTBX2,X
 LDX P
 BEQ LIfudge
 LDA logL,X
 LDX Q
 SEC
 SBC logL,X
 LDX P
 LDA log,X
 LDX Q
 SBC log,X
 BCC P%+6
 LDA #&FF
 BNE LIlog2
 TAX
 LDA alogh,X

.LIlog2

 STA P

.LIfudge

 SEC
 LDX Q
 INX
 LDA X2
 SBC X1
 BCC LFT
 \....
 CLC
 LDA SWAP
 BEQ LI17
 DEX

.LIL5

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI17

 DEC T2
 BMI LI22
 LDA SC+1
 SBC #3
 STA SC+1
 CLC

.LI16

 LDA S
 ADC P
 STA S
 BCC LIC5
 ASL R
 BPL LIC5
 LDA #1
 STA R
 INY

.LIC5

 DEX
 BNE LIL5
 LDY YSAV
 RTS

.LI22

 LDA #7
 STA T2
 STX T
 LDX T1
 DEX
 STX T1
 LDA SCTBL,X
 STA SC
 LDA SCTBH2,X
 LDX T
 STA SC+1
 JMP LI16
 \.....

.LFT

 LDA SWAP
 BEQ LI18
 DEX

.LIL6

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI18

 DEC T2
 BMI LI23
 LDA SC+1
 SBC #3
 STA SC+1
 CLC

.LI19

 LDA S
 ADC P
 STA S
 BCC LIC6
 LSR R
 BCC LIC6
 LDA #64
 STA R
 DEY
 CLC

.LIC6

 DEX
 BNE LIL6
 LDY YSAV

.HL6

 RTS

.LI23

 LDA #7
 STA T2
 STX T
 LDX T1
 DEX
 STX T1
 LDA SCTBL,X
 STA SC
 LDA SCTBH2,X
 LDX T
 STA SC+1
 JMP LI19
 \...................................

.MSBARS

 JSR P%+3
 INC Y1
 \ ............HLOIN..........

.HLOIN

 STY YSAV
 LDA X1
 AND #&FE
 STA X1
 TAX
 LDA X2
 AND #&FE
 STA X2
 CMP X1
 BEQ HL6
 BCS HL5
 STX X2
 TAX

.HL5

 LDA Y1
 LSR A
 LSR A
 LSR A
 TAY
 LDA SCTBL,Y
 STA SC
 LDA Y1
 AND #7
 ASL A
 ASL A
 ADC SCTBH,Y
 STA SC+1
 LDA SCTBX2,X
 AND #1
 ORA COL
 TAY
 LDA MASKT,Y
 STA T1
 LDA MASKT+1,Y
 STA T2

.HL1

 LDY X2
 LDA SCTBX2-2,Y
 LDY SCTBX1,X
 SEC
 SBC SCTBX2,X
 STAR \R = no bytes apart
 LDA TWFR,Y
 AND T1
 LDY SCTBX2,X
 LDX R
 BEQ HL3
 STA T4
 LDA (SC),Y
 AND #&7F
 EOR T4
 STA (SC),Y
 INY
 DEX
 BEQ HL4

.HLL1

 LDA (SC),Y
 AND #&7F
 EOR T2
 STA (SC),Y
 INY
 DEX
 BEQ HL8
 LDA (SC),Y
 AND #&7F
 EOR T1
 STA (SC),Y
 INY
 DEX
 BNE HLL1

.HL4

 LDA T2

.HL2

 LDX X2
 LDY SCTBX1-2,X
 CPY #6
 AND TWFL,Y
 LDY SCTBX2-2,X
 STA T4
 LDA (SC),Y
 AND #&7F
 EOR T4
 STA (SC),Y
 BCC HL7
 LDA #&81
 AND T1
 INY
 STA T4
 LDA (SC),Y
 AND #&7F
 EOR T4
 STA (SC),Y

.HL7

 LDY YSAV
 RTS

.HL8

 LDA T1

.HL3

 LDX T2
 STX T1
 JMP HL2
 \.....

.MASKT

 EQUD 0
 EQUD &552A55
 EQUD &2A552A
 EQUD &7F7F7F
 EQUD &D5AAD5
 EQUD &AAD5AA
 EQUD &AAAAAA

.VLOIN

 STY YSAV
 LDA Y1
 CMP Y2
 BCS VLO1
 LDY Y2
 STA Y2
 TYA

.VLO1

 LDX X1
 JSR CPIX
 LDA Y1
 SEC
 SBC Y2
 BEQ VLO5
 TAX
 INX
 JMP VLO4

.VLOL1

 LDA R
 EOR (SC),Y
 STA (SC),Y
 LDA T3
 BEQ VLO4
 INY
 EOR (SC),Y
 STA (SC),Y
 DEY

.VLO4

 DEC T2
 BMI VLO2
 LDA SC+1
 SEC
 SBC #4
 STA SC+1

.VLO3

 DEX
 BNE VLOL1

.VLO5

 LDY YSAV
 RTS

.VLO2

 LDA #7
 STA T2
 STX T
 LDX T1
 DEX
 STX T1
 LDA SCTBL,X
 STA SC
 LDA SCTBH2,X
 LDX T
 STA SC+1
 JMP VLO3
 \.....

.CPIX

 STA Y1
 LSR A
 LSR A
 LSR A
 STA T1
 TAY
 LDA SCTBL,Y
 STA SC
 LDA Y1
 AND #7
 STA T2
 ASL A
 ASL A
 ADC SCTBH,Y
 STA SC+1
 LDY SCTBX1,X
 LDA #0
 CPY #6
 BNE P%+4
 LDA #&81
 STA T3
 LDA TWOS2,Y
 STA R
 LDA SCTBX2,X
 AND #1
 ORA COL
 TAY
 LDA MASKT+1,Y
 AND T3
 STA T3
 LDA MASKT,Y
 AND R
 STA R
 LDY SCTBX2,X
 EOR (SC),Y
 STA (SC),Y
 LDA T3
 BEQ CPR1
 INY
 EOR (SC),Y
 STA (SC),Y
 DEY

.CPR1

 RTS
 \...................

 \...........

.ECBLB2

 LDA #32
 STA ECMA
\LDY #sfxecm
\JSR NOISE \ @@

.ECBLB

 LDA #LO(ECBT)
 LDX #56
 BNE BULB

.SPBLB

 LDA #LO(SPBT)
 LDX #192

.BULB

 STA P
 LDA #HI(SPBT)
 STA P+1
 LDA #22
 STA YC
 JMP letter2

.ECBT

 EQUW &7F7F
 EQUB &07

.SPBT

 EQUD &7F077F7F
 EQUD &7F7F707F

.MSBAR

 TYA
 PHA
 JSR MSBAR2
 PLA
 STA mscol-1,X

.MSBAR2

 LDA mscol-1,X
 BEQ coolkey
 STA COL
 LDA msloc-1,X
 STA X1
 CLC
 ADC #6
 STA X2
 TXA
 PHA
 LDA #184
 STA Y1
 JSR MSBARS
 JSR MSBARS
 PLA
 TAX
 TYA
 LDY #0
 RTS

.msloc

 EQUB &28
 EQUB &20
 EQUB &18
 EQUB &10
 \....

.newosrdch

 JSR &FFFF
 CMP #128
 BCC P%+6

.badkey

 LDA #7
 CLC
 RTS
 CMP #32
 BCS coolkey
 CMP #13
 BEQ coolkey
 CMP #21
 BNE badkey

.coolkey

 CLC
 RTS
 \ADD AX = AP+SR  Should be in ELITEC (?)

 \..........Bay View..........

.WSCAN

IF _IB_DISK

 PHA
 TXA
 PHA
 TYA
 PHA
 LDY #&0F
 LDX #0

.LA087

 DEX
 BNE LA087
 DEY
 BNE LA087
 PLA
 TAY
 PLA
 TAX
 PLA

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 BIT &C019
 BPL WSCAN

.WSCL1

 BIT &C019
 BMI WSCL1

ENDIF




 RTS

 \ ............. Character Print .....................

.CHPR2

 CMP #123
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

.R5

 JSR BEEP
 JMP RR4

.clss

 BIT text
 BPL clss1
 JSR cleartext
 LDA K3
 JMP RRafter

.clss1

 JSR cleargrap
 LDA K3
 JMP RRafter

.RR5

 \text chpr
 BIT UPTOG

IF _IB_DISK

 BMI RR7

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 BPL RR7

ENDIF

 CMP #&5B
 BCC RR7
 SBC #&20

.RR7

 ORA #128
 PHA
 LDA cellocl,Y
 STA SC
 TYA
 AND #7
 LSR A
 CLC
 ADC #4
 STA SC+1
 TXA
 TAY
 PLA
 STA (SC),Y
 JMP RR6

.TT67X

                        \ This does the same as the existing TT67 routine, which
                        \ is also present in this source, so it isn't clear why
                        \ this duplicate exists
                        \
                        \ In the original source, this version also has the name
                        \ TT67, but because BeebAsm doesn't allow us to redefine
                        \ labels, this one has been renamed TT67X

 LDA #12

.CHPR

 STA K3
 STY YSAV2
 STX XSAV2
 LDY QQ17
 CPY #&FF
 BEQ RR4

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
 BEQ RR4
 INC YC
 BNE RR4

.RR1

 LDX XC
 CPX #31
 BCC RRa
 JSR RRX2
 LDX XC \ David@@

.RRa

 LDY YC
 CPY #24
 BCS clss
 BIT text
 BMI RR5
 PHA
 LDA XC
 ASL A
 ASL A
 ASL A
 ADC #13
 SBC XC
 TAX  \7*XC+12
 PLA
 JSR letter

.RR6

 INC XC

.RR4

 LDY YSAV2
 LDX XSAV2
 LDA K3
 CLC
 RTS \must exit CHPR with C = 0
 \.....

.letter

 \plot character A at X,YC*8
 LDY #HI(FONT)-1
 ASL A
 ASL A
 BCC P%+4
 LDY #HI(FONT)+1
 ASL A
 BCC RR9
 INY

.RR9

\CLC
\ADC #LO(FONT)
 STA P
\BCC P%+3
\INY
 STY P+1

.letter2

 LDY YC
 LDA SCTBL,Y
 STA SC
 LDA SCTBH,Y
 STA SC+1
 LDY SCTBX1,X
 STY P+2
 LDY SCTBX2,X
 STY T1
 LDY #0

.RRL1

 LDA #0
 STA T3
 LDA (P),Y
 LDX P+2

.RRL2

 CMP #128
 ROL T3
 DEX
 BMI RR8
 ASL A
 JMP RRL2

.RR8

 AND #127
 CLC
 STY T2
 LDY T1
 EOR (SC),Y
 STA (SC),Y
 INY
 LDA T3
 EOR (SC),Y
 STA (SC),Y
 LDY T2
 LDA SC+1
 ADC #4
 STA SC+1
 INY
 CPY #8
 BNE RRL1
 RTS
 \
 \.....TTX66K......
 \

.TTX66K

 LDA QQ11
 BEQ wantgrap
 CMP #13
 BEQ wantgrap
 AND #&C0
 BNE wantgrap
 JSR cleartext
 JMP TEXT

.cleartext

 LDY #0
 LDX #4
 STY SC
 STX SC+1
 LDA #160

.cleartextl

 STA (SC),Y
 INY
 BNE cleartextl
 INC SC+1
 DEX
 BNE cleartextl
 RTS
 \...........
 \....

.wantgrap

 JSR cleargrap
 JSR BOX
 JSR HGR
 RTS
 \........

.BOX

 LDX #0
 STX X1
 STX Y1
 DEX
 STX X2
 LDA #BLUE
 STA COL
 JSR HLOIN
 LDA #&AA
 STA SCBASE+1
 LDA #&AA
 STA SCBASE+37
 RTS
 \....
 \.......

.cleargrap

 LDY #16

.cleargl

 JSR clearrow
 DEY
 BPL cleargl
 INY
 STY XC
 STY YC
 RTS
 \....

.ZES1k

 LDY #0
 STY SC

.ZES2k

 LDA #0
 STX SC+1

.ZEL1k

 STA (SC),Y
 DEY
 BNE ZEL1k
 RTS

.ZESNEW

 LDA #0

.ZESNEWL

 STA (SC),Y
 INY
 BNE ZESNEWL
 RTS

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETXC
\
\STA XC

 RTS  \JMPPUTBACK

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES

.SETXC

 STA XC

ENDIF

 RTS  \JMPPUTBACK

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETYC
\
\STA YC

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES

.SETYC

 STA YC

 RTS  \JMPPUTBACK

ENDIF

.mvblockK

 LDY #0

.mvbllop

 LDA (V),Y
 STA (SC),Y
 DEY
 BNE mvbllop
 INC V+1
 INC SC+1
 DEX
 BNE mvbllop
 RTS  \remember ELITEK has different SC!  (NO LONGER)

.CLYNS

 LDA #0
 STA DLY
 STA de

.CLYNS2

 JSR CLYS1 \ @@
 LDA #&FF
 STA DTW2
 LDA #128
 STA QQ17
 LDA text
 BPL CLY1
 LDA #32
 LDX #64

.CLYL1

 JSR CHPR
 DEX
 BNE CLYL1

.CLYS1

 LDA #21
 STA YC
 LDA #1
 STA XC
 RTS
 \...

.CLY1

 LDY #15
 STY YC
 LDA #1
 STA XC
 JSR clearrow
 INY

.clearrow

 LDA #8
 STA T2
 LDX SCTBL,Y
 STX SC
 LDX SCTBH,Y
 TYA
 PHA

.cleargl2

 STX SC+1
 LDA #&A0
 LDY #37

.cleargl3

 STA (SC),Y
 LDA #0
 DEY
 BNE cleargl3
 LDA #&C0
 STA (SC),Y
 INY
 ASL A
 STA (SC),Y
 INX
 INX
 INX
 INX
 DEC T2
 BNE cleargl2
 PLA
 TAY

.SCR1

 RTS
 \................

.SCAN

\LDA QQ11
\BNE SCR1
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
 CLC

.SC2

 ADC #125
 AND #&FE
 STA X1
 TAX
 DEX
 DEX
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDY INWK+8
 BPL SC3
 EOR #&FF
 SEC

.SC3

 ADC #91 \83
 EOR #&FF
 STA Y2
 LDA INWK+4
 LSR A
 CLC
 LDY INWK+5
 BMI SCD6
 EOR #&FF
 SEC

.SCD6

 ADC Y2
\BPL ld246
 CMP #146 \194
 BCS P%+4
 LDA #146
 CMP #191 \199
 BCC P%+4

.ld246

 LDA #190 \198
 JSR CPIX
 JMP VLOIN
 \.......

.HGR

 LDA &C054
 LDA &C052
 LDA &C057
 LDA &C050
 LSR text
 RTS

.TEXT

 LDA &C054
 LDA &C051
 SEC
 ROR text
 RTS

.F%

IF _IB_DISK

 EQUB &83, &6F, &63, &6F, &75

ENDIF

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
 SAVE "versions/apple/3-assembled-output/ELTK.bin", CODE_K%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "B% = ", ~CODE%
 PRINT "G% = ", ~G%
 PRINT "NA2% = ", ~NA2%

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
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

 EQUB &E7, &33          \ These bytes appear to be unused
 EQUB &53, &08

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &08, &08          \ These bytes appear to be unused
 EQUB &03, &FE

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
 SAVE "versions/apple/3-assembled-output/SHIPS.bin", CODE_SHIPS%, P%, LOAD%
