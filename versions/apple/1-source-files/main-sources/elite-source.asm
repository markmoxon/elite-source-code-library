\ ******************************************************************************
\
\ APPLE II ELITE MAIN GAME SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
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
\ This source file contains the main game code for Apple II Elite.
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
 _SOURCE_DISK               = (_VARIANT = 2) OR (_VARIANT = 3) OR (_VARIANT = 4)
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

 STORE = &0200          \ The address where the dashboard image is loaded

 CODE2 = &2000          \ The address where the dashboard image is stored

ELIF _SOURCE_DISK

 STORE = &D000          \ The address where the dashboard image is loaded

 CODE2 = &9000          \ The address where the dashboard image is stored

ENDIF

 Q% = _MAX_COMMANDER    \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander

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

 BLACK = 0              \ Offset into the MASKT table for black

 VIOLET = 4             \ Offset into the MASKT table for violet

 GREEN = 8              \ Offset into the MASKT table for green

 WHITE = 12             \ Offset into the MASKT table for white

 BLUE = 16              \ Offset into the MASKT table for blue

 RED = 20               \ Offset into the MASKT table for red

 FUZZY = 24             \ Offset into the MASKT table for the colour we use to
                        \ show Thargoids on the scanner

 CYAN = WHITE           \ Ships that are set to a scanner colour of CYAN in the
                        \ scacol table will actually be shown in white

 MAG = WHITE            \ Ships that are set to a scanner colour of MAG in the
                        \ scacol table will actually be shown in white

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

 CHRV = &0036           \ The CHRV vector that we intercept with our custom
                        \ text printing routine

 NMIV = &03FC           \ The NMI vector that we intercept with our custom NMI
                        \ handler, which just acknowledges NMI interrupts and
                        \ ignores them

 LS% = &0B5F            \ The start of the descending ship line heap

 TAP% = LS% - 111       \ The staging area where we copy files after loading and
                        \ before saving

 comsiz = 110           \ The size of the commander file structure that is saved
                        \ to disk (must be no more than 252 bytes so the file
                        \ fits into a 256-byte sector, along with the four seeds
                        \ used to encrypt and decrypt the file)

 comfil = TAP%-20       \ The address of the commander file structure that is
                        \ encrypted by MUTLIATE and decrypted by UNMUTILATE

 comfil2 = comfil + comsiz - 4  \ The address of the four seeds that are used to
                                \ encrypt and decrypt the commander file, which
                                \ are at the end of the commander file structure
                                \ that is saved to disk

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

 FONT = &1D00           \ The address of the game's text font

 SCBASE = &2000         \ The address of screen memory

 XX21 = &A300           \ The address of the ship blueprints lookup table, as
                        \ set in elite-data.asm

 E% = &A340             \ The address of the default NEWB ship bytes, as set in
                        \ elite-data.asm

 KWL% = &A360           \ The address of the kill tally fraction table, as set
                        \ in elite-data.asm

 KWH% = &A380           \ The address of the kill tally integer table, as set in
                        \ elite-data.asm

 R% = &BFFF             \ The address of the last byte of game code

                        \ Disk controller I/O addresses ???

 phsoff  =  &C080       \ stepper motor phase 0 off
 mtroff  =  &C088       \ turn motor off
 mtron   =  &C089       \ turn motor on
 drv1en  =  &C08A       \ enable drive 1
 drv2en  =  &C08B       \ enable drive 2
 Q6L     =  &C08C       \ strobe data latch for I/O
 Q6H     =  &C08D       \ load data latch
 Q7L     =  &C08E       \ prepare latch for input
 Q7H     =  &C08F       \ prepare latch for output

                        \ Disk controller buffers ???

 buffer  =  &0800       \ K%, 256 byte sector buffer
 fretrk  =  buffer+&30  \ last allocated track
 dirtrk  =  buffer+&31  \ direction of track allocation (+1 or -1)
 tracks  =  buffer+&34  \ number of tracks per disc
 bitmap  =  buffer+&38  \ bit map of free sectors in track 0

 buffr2  =  &0800+256   \ K%+256, 342 6 bit 'nibble' buffer

 track   =  buffr2+350  \ Disk routine variables &0A5E to &0A6C
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

INCLUDE "library/apple/main/subroutine/entry.asm"
INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog-alogh.asm"

\ ******************************************************************************
\
\       Name: SCTBX1
\       Type: Variable
\   Category: Screen
\    Summary: Lookup table for converting a pixel x-coordinate to the bit number
\             within the pixel row byte that corresponds to this pixel
\
\ ------------------------------------------------------------------------------
\
\ The SCTBX1 and SCTBX2 tables can be used to convert a pixel x-coordinate into
\ the byte number and bit number within that byte of the pixel in screen memory.
\
\ Given a pixel x-coordinate X in the range 0 to 255, the tables split this into
\ factors of 7, as follows:
\
\   X = (7 * SCTBX2,X) + SCTBX1,X - 8
\
\ Because each byte in screen memory contains seven pixels, this means SCTBX2,X
\ is the byte number on the pixel row. And because the seven pixel bits inside
\ that byte are ordered on-screen as bit 0, then bit 1, then bit 2 up to bit 6,
\ SCTBX1,X is the bit number within that byte.
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
\    Summary: Lookup table for converting a pixel x-coordinate to the byte
\             number in the pixel row that corresponds to this pixel
\
\ ------------------------------------------------------------------------------
\
\ The SCTBX1 and SCTBX2 tables can be used to convert a pixel x-coordinate into
\ the byte number and bit number within that byte of the pixel in screen memory.
\
\ Given a pixel x-coordinate X in the range 0 to 255, the tables split this into
\ factors of 7, as follows:
\
\   X = (7 * SCTBX2,X) + SCTBX1,X - 8
\
\ Because each byte in screen memory contains seven pixels, this means SCTBX2,X
\ is the byte number on the pixel row. And because the seven pixel bits inside
\ that byte are ordered on-screen as bit 0, then bit 1, then bit 2 up to bit 6,
\ SCTBX1,X is the bit number within that byte.
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
\    Summary: 6-bit to 7-bit nibble conversion table (part of DOS 3.3, where it
\             is called NIBL)
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

INCLUDE "library/advanced/main/workspace/option_variables.asm"
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

IF _SOURCE_DISK

 CLD                    \ Clear the D flag to make sure we are in binary mode

ENDIF

 LDA #LO(STORE)         \ Set SC(1 0) = STORE
 STA SC                 \
 LDA #HI(STORE)         \ So SC(1 0) contains the address where the dashboard
 STA SC+1               \ image was loaded

 LDA #LO(CODE2)         \ Set P(1 0) = CODE2
 STA P                  \
 LDA #HI(CODE2)         \ So P(1 0) contains the address where we want to store
 STA P+1                \ the dashboard image in screen memory

IF _IB_DISK

 LDX #7                 \ Set X = 7 so we copy eight pages of memory from
                        \ SC(1 0) to P(1 0) in the following loop

ELIF _SOURCE_DISK

 LDA &C08B              \ Set RAM bank 1 to read RAM and write RAM by reading
                        \ the RDWRBSR1 soft switch, with bit 3 set (bank 1),
                        \ bit 1 set (read RAM) and bit 0 set (write RAM)

 LDX #(&C0-&90)         \ This sets X = 48 so we copy 48 pages from SC(1 0) to
                        \ P(1 0) in the following loop
                        \
                        \ This would appear to copy the whole game into memory
                        \ at &9000, presumably as part of the development
                        \ process

ENDIF

 LDY #0                 \ Set Y = 0 to use as a byte counter

.Sept3

 LDA (SC),Y             \ Copy the Y-th byte of SC(1 0) to the Y-th byte of
 STA (P),Y              \ P(1 0)

 INY                    \ Increment the byte counter

 BNE Sept3              \ Loop back until we have copied a whole page of bytes

 INC SC+1               \ Increment the high bytes of SC(1 0) and P(1 0) so they
 INC P+1                \ point to the next page in memory

 DEX                    \ Decrement the page counter

IF _IB_DISK

 BPL Sept3              \ Loop back until we have copied X + 1 pages

ELIF _SOURCE_DISK

 BNE Sept3              \ Loop back until we have copied X pages

ENDIF

IF _SOURCE_DISK

 LDA &C081              \ Set ROM bank 2 to read ROM and write RAM by reading
                        \ the WRITEBSR2 soft switch, with bit 3 clear (bank 2),
                        \ bit 1 clear (read ROM) and bit 0 set (write RAM)

ENDIF

 JSR DEEOR              \ Decrypt the main game code between &1300 and &9FFF

\JSR Checksum           \ This instruction is commented out in the original
                        \ source

IF _IB_DISK

 LDA #&30               \ This modifies the RDKEY routine so the BPL at nokeys2
 STA nokeys2+4          \ jumps to nofast+2 rather than nojoyst (though this has
 NOP                    \ no effect as the binary has already been modified,
 NOP                    \ perhaps because the version on Ian Bell's site is a
                        \ hacked version that may have been extracted from
                        \ memory)

ENDIF

 JSR COLD               \ Initialise the screen mode, clear memory and set up
                        \ interrupt handlers

 JMP BEGIN              \ Jump to BEGIN to start the game

INCLUDE "library/master/main/subroutine/deeor.asm"
INCLUDE "library/master/main/subroutine/deeors.asm"
INCLUDE "library/c64/main/variable/g_per_cent.asm"
INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk-cold.asm"
INCLUDE "library/c64/main/variable/tribdir.asm"
INCLUDE "library/c64/main/variable/tribdirh.asm"
INCLUDE "library/c64/main/variable/spmask.asm"
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
\    Summary: Draw a line of dashes underneath a title on the text screen
\
\ ******************************************************************************

.NLI4

 LDX #39                \ We want to draw a line of dashes underneath the text
                        \ title, so set a column counter in X to work from the
                        \ right side of the screen to the left, from column 39
                        \ to 0, so we can draw the line one character at a time

.NLL1

 LDA &480,X             \ We only want to draw a dashes underneath characters in
                        \ the title, so set A to the character in column X of
                        \ the page title
                        \
                        \ The title is in row 1 of the screen (the second row),
                        \ which lives at memory location &480 in screen memory,
                        \ so this fetches the character at column X on row 1

 CMP #160               \ When we clear the text screen in the TTX66K routine,
 BEQ NLI5               \ we do this by filling it with character 160, so this
                        \ jumps to NLI5 to skip the following if the character
                        \ we just fetched is blank

 LDA #'-'+128           \ If we get here then there is a character in the title
 STA &500,X             \ in column X, so draw a dash in the same column in the
                        \ row below (which is row 2, at memory location &500 in
                        \ screen memory)
                        \
                        \ We add 128 to the ASCII code for a dash to set bit 7,
                        \ so the character is displayed in normal video (white
                        \ characters on a black background)

.NLI5

 DEX                    \ Decrement the column counter in X to move left to the
                        \ next text column

 BPL NLL1               \ Loop back until we have reached 

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

 LDY #0                 \ Set Y = 0 to use as an index into the dial tables as
                        \ we work our way through the various indicators

 LDA #210               \ Set K = 210 to use as the pixel x-coordinate of the
 STA K                  \ left end of the indicators in the right half of the
                        \ dashboard, which we draw first

 LDX #RED               \ Set X to the colour we should show for dangerous
                        \ values (i.e. red)

 LDA MCNT               \ A will be non-zero for 8 out of every 16 main loop
 AND #%00001000         \ counts, when bit 4 is set, so this is what we use to
                        \ flash the "danger" colour

 AND FLH                \ A will be zeroed if flashing colours are disabled

 BEQ P%+4               \ If A is zero, skip the next instruction

 LDX #WHITE             \ If we get here then flashing colours are configured
                        \ and it is the right time to flash the danger colour,
                        \ so set X to white

 STX K+2                \ Set K+2 to the colour to use for dangerous values

 LDA DELTA              \ Fetch our ship's speed into A, in the range 0-40

 JSR DIS2               \ Call DIS2 with Y = 0 to draw the speed indicator using
                        \ a range of 0-31, and increment Y to 1 to point to the
                        \ next indicator (the roll indicator)

\ ******************************************************************************
\
\       Name: DIALS (Part 2 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: pitch and roll indicators
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA #WHITE             \ Set COL to white to use as the colour for the pitch
 STA COL                \ and roll indicators

 LDA ALP1               \ Fetch the roll angle alpha as a value between 0 and
 LSR A                  \ 31, and divide by 2 to get a value of 0 to 15

 BIT ALP2+1             \ Set the N flag according to the opposite sign of the
                        \ roll angle, which is stored in ALP2+1

 JSR DIS5               \ Call DIS5 with Y = 1 to draw the roll indicator using
                        \ a range of 0-15, and increment Y to 2 to point to the
                        \ next indicator (the pitch indicator)

 LDA BET1               \ Fetch the magnitude of the pitch angle beta as a
 ASL A                  \ positive value between 0 and 8, and multiply by 2 to
                        \ get a value of 0 to 16

 BIT BET2               \ Set the N flag according to the sign of the pitch
                        \ angle, which is stored in BET2

 JSR DIS5               \ Call DIS5 with Y = 2 to draw the pitch indicator using
                        \ a range of 0-15, and increment Y to 3 to point to the
                        \ next indicator (the bottom of the four energy banks)

\ ******************************************************************************
\
\       Name: DIALS (Part 3 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: four energy banks
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

 LDA ENERGY             \ Set A = ENERGY / 2, so it is in the range 0-127 (so
 LSR A                  \ that's a maximum of 32 in each of the banks, and a
                        \ maximum of 31 in the top bank)

.DIL1

 STA K+1                \ Store A in K+1 so we can retrieve it after the call
                        \ to DIS2

 JSR DIS2               \ Draw the energy bank specified in Y using a range of
                        \ 0-31, and increment Y to point to the next indicator
                        \ (the next energy bank up)

 LDA K+1                \ Restore A from K+1, so it once again contains the
                        \ remaining energy as we work our way through each bank,
                        \ from the full ones at the bottom to the empty ones at
                        \ the top

 SEC                    \ Set A = A - 32 to reduce the energy count by a full
 SBC #32                \ bank

 BCS P%+4               \ If the subtraction didn't underflow then we still have
                        \ some energy to draw in the banks above, so skip the
                        \ following instruction

 LDA #0                 \ We have now drawn all the energy in the energy banks,
                        \ so set A = 0 so we draw empty energy bars for the rest
                        \ of the banks, working upwards

 CPY #7                 \ Loop back until we have drawn all four energy banks
 BNE DIL1               \ (for Y = 3, 4, 5, 6)

INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"

\ ******************************************************************************
\
\       Name: DIS1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update a bar-based indicator on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ The range of values shown on the indicator depends on which entry point is
\ called. For the default entry point of DIS1, the range is 0-255 (as the value
\ passed in A is one byte), while for DIS2 the range is 0-31.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The value to be shown on the indicator (so the larger
\                       the value, the longer the bar)
\
\   Y                   The indicator number:
\
\                         *  0 = Speed indicator
\                         *  3 = Energy bank 4 (bottom)
\                         *  4 = Energy bank 3
\                         *  5 = Energy bank 2
\                         *  6 = Energy bank 1 (top)
\                         *  7 = Forward shield indicator
\                         *  8 = Aft shield indicator
\                         *  9 = Fuel level indicator
\                         * 10 = Altitude indicator
\                         * 11 = Cabin temperature indicator
\                         * 12 = Laser temperature indicator
\
\   K                   The screen x-coordinate of the left end of the indicator
\
\   K+2                 The colour we should use for dangerous values
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The value to be shown on the indicator, scaled to fit
\                       into the range 0 to 31
\
\   Y                   Y is incremented to the next indicator number
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DIR1                Contains an RTS
\
\ ******************************************************************************

.DIS1

 LSR A                  \ Set A = A / 16, so A is 0-31
 LSR A
 LSR A

.DIS2

 CMP #32                \ Cap A to a maximum value of 31, so A is in the range
 BCC P%+4               \ 0 to 31
 LDA #31

 LDX dialc1,Y           \ Set X to the low-value colour for indicator Y from the
                        \ dialc1 table 

 CMP dialle,Y           \ If A < dialle for indicator Y, then this is a low
 BCC DI3                \ value that is below the threshold for this indicator,
                        \ so jump to DI3 as we aleady have the correct colour

 LDX dialc2,Y           \ If we get here then A > dialle for indicator Y,
                        \ which is a high value that is on or above the
                        \ threshold for this indicator, so set X to the
                        \ high-value colour for indicator Y from the dialc2
                        \ table 

.DI3

 CPX #&FF               \ If the colour in X is not &FF, jump to DI4
 BNE DI4

 LDX K+2                \ If the colour in X is &FF, set X = K + 2, so X is
                        \ either red, or flashing red-and-white if flashing
                        \ colours are configured

 CLC                    \ Clear the C flag (though this doesn't seem to have any
                        \ effect, as we do a comparison almost straight away
                        \ that will override the C flag)

.DI4

 INY                    \ Increment Y to point to the next indicator, ready for
                        \ the next indicator to be drawn

 PHA                    \ Store the indicator value in A on the stack, so we can
                        \ retrieve it below

                        \ If we have already drawn this indicator in a previous
                        \ iteration of the main loop, then we will have stored
                        \ the indicator value and colour in the dials and dialc
                        \ tables, so we now check these to see whether we need
                        \ to update the indicator
                        \
                        \ If this is the first time we have drawn this indicator
                        \ then the values in dials and dialc will be zero, to
                        \ indicate that no bar is shown
                        \
                        \ Note that as we just incremented Y, we need to fetch
                        \ the values for this indicator from dials-1 + Y and
                        \ dialc-1 + Y, for example

 CMP dials-1,Y          \ If the indicator value in A does not match the
 BNE DI6                \ previous value for this indicator in dials, jump to
                        \ DI6 to update the indicator

 TXA                    \ If the colour in X matches the previous colour in
 CMP dialc-1,Y          \ dialc, then both the value and the colour of this
 BEQ DI8                \ indicator are unchanged, so jump to DI8 to return
                        \ from the subroutine without drawing anything

.DI6

 TXA                    \ Store the new colour of the bar in the dialc table,
 LDX dialc-1,Y          \ for use the next time the indicator is drawn, and
 STA dialc-1,Y          \ set X to the previous colour

 LDA dials-1,Y          \ Set A to the previous value of this indicator from
                        \ the dials table

 JSR DIS7               \ Call DIS7 below to draw this indicator using its
                        \ previous value and colour, which will remove it from
                        \ the screen as we draw indicators using EOR logic

 LDX dialc-1,Y          \ Set X to the new colour for the indicator, which we
                        \ just stored in the dialc table

 PLA                    \ Retrieve the new indicator value from the stack and
 STA dials-1,Y          \ store it in the dials table, for use the next time
                        \ the indicator is drawn

.DIS7

                        \ We now draw the indicator with the colour in X and
                        \ the value in A

 STX COL                \ Set the drawing colour to X

 LDX dialY-1,Y          \ Set Y1 to the screen y-coordinate of the indicator
 STX Y1                 \ from the dialY table (so this is the y-coordinate of
                        \ the top line of the four-line indicator)

 LDX K                  \ Set X1 to K, so it contains the x-coordinate of the
 STX X1                 \ left end of the indicator

 CLC                    \ Set X2 = K + A, so it contains the x-coordinate of the
 ADC K                  \ right end of the indicator bar (as we want to draw a
 AND #%11111110         \ bar of length A pixels)
 STA X2                 \
                        \ We round this down to an even number to ensure that
                        \ the two-bit colour pattern fits exactly (though this
                        \ isn't strictly necessary as the HLOIN routine also
                        \ does this)

 JSR P%+3               \ Call MSBARS twice to draw four pixel lines to form the
 JMP MSBARS             \ indicator bar, returning from the subroutine using a
                        \ tail call

.DI8

 PLA                    \ Retrieve the indicator value from the stack so we can
                        \ return it in A

.DIR1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DIS5
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the roll or pitch indicator on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The indicator number:
\
\                         * 1 = Roll indicator
\
\                         * 2 = Pitch indicator
\
\   A                   The magnitude of the pitch or roll, in the range 0 to 15
\                       (for roll) or 0 to 16 (for pitch)
\
\   N flag              The sign of the magnitude in A
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is incremented to the next indicator number
\
\ ******************************************************************************

.DIS5

 BPL DI9                \ If the angle whose magnitude in A is negative, negate
 EOR #&FF               \ A using two's complement, so A is now in the range
 CLC                    \ -15 to +15 (for roll) or -16 to +16 (for pitch)
 ADC #1

.DI9

 INY                    \ Increment Y to point to the next indicator, ready for
                        \ the next indicator to be drawn

                        \ If we have already drawn this indicator in a previous
                        \ iteration of the main loop, then we will have stored
                        \ the indicator value in the dials table, so we now
                        \ check this to see whether we need to update the
                        \ indicator
                        \
                        \ If this is the first time we have drawn this indicator
                        \ then the value in dials will be zero, to indicate that
                        \ no bar has yet been drawn
                        \
                        \ Note that as we just incremented Y, we need to fetch
                        \ the value for this indicator from dials-1 + Y

 CLC                    \ Set A = A + 224
 ADC #224               \
                        \ The x-coordinate of the centre point of the indicator
                        \ is 224, so this gives us the x-coordinate of the bar
                        \ that we need to draw to represent the angle in A

 CMP dials-1,Y          \ If the indicator value in A matches the previous value
 BEQ DIR1               \ for this indicator in dials, jump to DIR1 to return
                        \ from the subroutine without updating the indicator (as
                        \ DIR1 contains an RTS)

 PHA                    \ Store the indicator value in A on the stack, so we can
                        \ retrieve it below

 LDA dials-1,Y          \ If the previous value is zero, then skip the following
 BEQ P%+5               \ instruction as there is currently no bar to be removed

 JSR DIS6               \ Call DIS6 below to draw the indicator bar using its
                        \ previous value, which will remove it from the screen
                        \ as we draw indicators using EOR logic

 PLA                    \ Retrieve the new indicator value from the stack and
 STA dials-1,Y          \ store it in the dials table, for use the next time
                        \ the indicator is drawn

.DIS6

 STA X1                 \ Set X1 to the indicator value (which we converted into
                        \ the x-coordinate of the bar earlier)

 LDA dialY-1,Y          \ Set Y1 to the screen y-coordinate of the indicator
 STA Y1                 \ from the dialY table (so this is the y-coordinate of
                        \ the top line of the indicator)

 CLC                    \ Set Y2 = Y1 + 6, so we draw a vertical bar of six
 ADC #6                 \ pixels in height
 STA Y2

 JMP VLOIN              \ Jump to VLOIN to draw the indicator bar as a vertical
                        \ line from (X1, Y1) to (X1, Y2), returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: dialY
\       Type: Variable
\   Category: Dashboard
\    Summary: The screen y-coordinate of the top-left corner of each indicator
\
\ ******************************************************************************

.dialY

 EQUB 137               \  0 = Speed indicator
 EQUB 144               \  1 = Roll indicator
 EQUB 152               \  2 = Pitch indicator
 EQUB 185               \  3 = Energy bank 4 (bottom)
 EQUB 177               \  4 = Energy bank 3
 EQUB 169               \  5 = Energy bank 2
 EQUB 161               \  6 = Energy bank 1 (top)
 EQUB 137               \  7 = Forward shield indicator
 EQUB 145               \  8 = Aft shield indicator
 EQUB 153               \  9 = Fuel level indicator
 EQUB 177               \ 10 = Altitude indicator
 EQUB 161               \ 11 = Cabin temperature indicator
 EQUB 169               \ 12 = Laser temperature indicator

\ ******************************************************************************
\
\       Name: dialle
\       Type: Variable
\   Category: Dashboard
\    Summary: The threshold value for each indicator that defines low and high
\             values, and therefore the low and high colours for the indicator
\
\ ******************************************************************************

.dialle

 EQUB 28                \  0 = Speed indicator
 EQUB 0                 \  1 = Roll indicator
 EQUB 0                 \  2 = Pitch indicator
 EQUB 16                \  3 = Energy bank 4 (bottom)
 EQUB 0                 \  4 = Energy bank 3
 EQUB 0                 \  5 = Energy bank 2
 EQUB 0                 \  6 = Energy bank 1 (top)
 EQUB 8                 \  7 = Forward shield indicator
 EQUB 8                 \  8 = Aft shield indicator
 EQUB 0                 \  9 = Fuel level indicator
 EQUB 8                 \ 10 = Altitude indicator
 EQUB 24                \ 11 = Cabin temperature indicator
 EQUB 24                \ 12 = Laser temperature indicator

\ ******************************************************************************
\
\       Name: dialc1
\       Type: Variable
\   Category: Dashboard
\    Summary: The colour for each indicator for values that are below the
\             threshold in dialle
\
\ ------------------------------------------------------------------------------
\
\ A colour value of &FF represents the colour red, or flashing red-and-white if
\ flashing colours are configured.
\
\ ******************************************************************************

.dialc1

 EQUB WHITE             \  0 = Speed indicator
 EQUB WHITE             \  1 = Roll indicator
 EQUB WHITE             \  2 = Pitch indicator
 EQUB &FF               \  3 = Energy bank 4 (bottom)
 EQUB VIOLET            \  4 = Energy bank 3
 EQUB VIOLET            \  5 = Energy bank 2
 EQUB VIOLET            \  6 = Energy bank 1 (top)
 EQUB &FF               \  7 = Forward shield indicator
 EQUB &FF               \  8 = Aft shield indicator
 EQUB GREEN             \  9 = Fuel level indicator
 EQUB &FF               \ 10 = Altitude indicator
 EQUB BLUE              \ 11 = Cabin temperature indicator
 EQUB BLUE              \ 12 = Laser temperature indicator

\ ******************************************************************************
\
\       Name: dialc2
\       Type: Variable
\   Category: Dashboard
\    Summary: The colour for each indicator for values that are on or above the
\             threshold in dialle
\
\ ------------------------------------------------------------------------------
\
\ A colour value of &FF represents the colour red, or flashing red-and-white if
\ flashing colours are configured.
\
\ ******************************************************************************

.dialc2

 EQUB &FF               \  0 = Speed indicator
 EQUB WHITE             \  1 = Roll indicator
 EQUB WHITE             \  2 = Pitch indicator
 EQUB VIOLET            \  3 = Energy bank 4 (bottom)
 EQUB VIOLET            \  4 = Energy bank 3
 EQUB VIOLET            \  5 = Energy bank 2
 EQUB VIOLET            \  6 = Energy bank 1 (top)
 EQUB VIOLET            \  7 = Forward shield indicator
 EQUB VIOLET            \  8 = Aft shield indicator
 EQUB GREEN             \  9 = Fuel level indicator
 EQUB GREEN             \ 10 = Altitude indicator
 EQUB &FF               \ 11 = Cabin temperature indicator
 EQUB &FF               \ 12 = Laser temperature indicator

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
INCLUDE "library/c64/main/subroutine/tbrief.asm"
INCLUDE "library/enhanced/main/subroutine/brief.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"

\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Missions
\    Summary: Wait until a key is pressed for the Constrictor mission briefing
\             and then clear the text view to show the briefing text
\
\ ******************************************************************************

.PAUSE

 JSR PAUSE2             \ Call PAUSE2 to wait until a key is pressed, ignoring
                        \ any existing key press

\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: Missions
\    Summary: Change to the text view for the Constrictor mission briefing
\
\ ******************************************************************************

.PAS1

 LDA #1                 \ Jump to TT66 to clear the screen and set the current
 JMP TT66               \ view type to 1, for the mission briefing screen, and
                        \ return from the subroutine using a tail call

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
INCLUDE "library/c64/main/subroutine/check2.asm"
INCLUDE "library/master/main/subroutine/jameson.asm"

\ ******************************************************************************
\
\       Name: COPYNAME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from INWK+5 to comnam and pad
\             out the rest of comnam with spaces, so we can use it as a filename
\
\ ******************************************************************************

.COPYNAME

 LDX #0                 \ Set X = 0 to use as a character index for copying the
                        \ commander name from INWK+5 to comnam

.COPYL1

 LDA INWK+5,X           \ Set A to the X-th character of the name at INWK+5

 CMP #13                \ If A = 13 then we have reached the end of the name, so
 BEQ COPYL2             \ jump to COPYL2 to pad out the rest of comnam with
                        \ spaces

 STA comnam,X           \ Otherwise this is a character from the commander name,
                        \ so store it in the X-th character of comnam

 INX                    \ Increment X to move on to the next character

 CPX #7                 \ Loop back to copy the next character until we have
 BCC COPYL1             \ copied up to seven characters (the maximum size of the
                        \ commander name)

.COPYL2

 LDA #' '               \ We now want to pad out the rest of comnam with spaces,
                        \ so set A to the ASCII value for the space character

.COPYL3

 STA comnam,X           \ Store a space at the X-th character of comnam

 INX                    \ Increment X to move on to the next character

 CPX #30                \ Loop back until we have written spaces to all
 BCC COPYL3             \ remaining characters in the 30-character string at
                        \ comnam

 RTS                    \ Return from the subroutine

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
\    Summary: Print a disk error, make a beep and wait for a key press
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The error to display:
\
\                         * 1 = Disk write protected
\
\                         * 2 = Disk full
\
\                         * 3 = Catalog full
\
\                         * 4 = Disk I/O error
\
\                         * 5 = File not found
\
\ ******************************************************************************

.diskerror

 ASL A                  \ Set X to the error number in A, shifted left by one
 TAX                    \ place to double it, so X can be used as an index into
                        \ the ERTAB table, which contains two-byte addresses
                        \ that point to the relevant error messages

 LDA ERTAB-2,X          \ Set XX15(1 0) to the address of the error message, so
 STA XX15               \ that error number 1 points to the address in the first
 LDA ERTAB-1,X          \ entry at ERTAB
 STA XX15+1

 LDY #0                 \ Set Y to a character counter for printing the error
                        \ message one character at a time, starting at character
                        \ zero

.dskerllp

 LDA (XX15),Y           \ Set A to the Y-th character from the error message

 BEQ dskerllp2          \ If A = 0 then we have reached the end of the
                        \ null-terminated string, so jump to dskerllp2 to stop
                        \ printing characters

 JSR TT26               \ Print the character in A

 INY                    \ Increment the character counter

 BNE dskerllp           \ Loop back to print the next character

.dskerllp2

 JSR BOOP               \ Make a long, low beep

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
\    Summary: The error message for when a disk is write protected
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
\    Summary: The error message for when a disk is full
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
\    Summary: The error message for when a disk catalog is full
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
\    Summary: The error message for when there is a disk I/O error
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
\    Summary: The error message for when a file is not found
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
\    Summary: A lookup table for the five disk error messages
\
\ ******************************************************************************

.ERTAB

 EQUW DERR1             \ Error 1: Disk write protected

 EQUW DERR2             \ Error 2: Disk full

 EQUW DERR3             \ Error 3: Datalog full

 EQUW DERR4             \ Error 4: Disk I/O error

 EQUW DERR5             \ Error 5: File not found

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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the joystick to read (0 to 3)
\
\ ******************************************************************************

.RDS1

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

 BPL nofast+2           \ The destination for thie instruction is modified by S%

ELIF _SOURCE_DISK

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

 LDX #0                 \ ???
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

 LDY #99                \ Set the length of the loop below to 99 clicks, so we
                        \ make a total of 100 clicks in the call to SOBEEP, to
                        \ give a long beep

 LDX #255               \ Set the period of the sound at 255 for a low beep

 BNE SOBEEP             \ Jump to SOBEEP to make a long, low beep (this BNE is
                        \ effectively a JMP as X is never zero)

\ ******************************************************************************
\
\       Name: SOHISS
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a launch from the station, hyperspace or missile
\             launch
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The type of sound (i.e. the length of the explosion):
\
\                         * 0 = start of a launch from a station (called twice
\                               in succession from LAUN, with the 0 indicating
\                               a sound length of 256)
\
\                         * 10 = launch or hyperspace tunnel (called each time
\                                we draw a tunnel ring in HFS2)
\
\                         * 50 = enemy missile launch (SFRMIS)
\
\                         * 120 = our missile launch (FRMIS)
\
\ ******************************************************************************

.SOHISS

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

.SOHISS2

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

                        \ We now make a hissing sound by making Y clicks on the
                        \ speaker, and pausing for a random amount of time
                        \ between each successive click

 JSR DORND              \ Set A and X to random numbers

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for four CPU cycles (as each NOP takes two CPU
 NOP                    \ cycles)

 BNE P%-3               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 4 * X
                        \ CPU cycles

 DEY                    \ Decrement the sound length in Y

 BNE SOHISS2            \ Loop back to make another click and wait for a random
                        \ amount of time between clicks, until we have made a
                        \ sound consisting of Y clicks
                        \
                        \ An argument of Y = 0 will therefore make 256 clicks in
                        \ the above loop

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a collision, or an exploding cargo canister or
\             missile
\
\ ******************************************************************************

.EXNO3

 LDY #40                \ Set Y = 40 and fall through into SOEXPL to make the
                        \ sound of a collision, or an exploding cargo canister
                        \ or missile

\ ******************************************************************************
\
\       Name: SOEXPL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The type of sound (i.e. the length of the explosion):
\
\                         * 15 = the sound of a laser strike on another ship
\                                (EXNO)
\
\                         * 40 = the sound of a collision, or an exploding cargo
\                                canister or missile (EXNO3)
\
\                         * 55 = the sound of a ship exploding (EXNO2)
\
\                         * 210 = the sound of us dying (DEATH)
\
\ ******************************************************************************

.SOEXPL

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 LDX #50                \ Set T3 = 50 to use as the starting period for this
 STX T3                 \ sound (which increases as the sound continues, which
                        \ spaces out the clicks and makes the sound of the
                        \ explosion dissipate

.BEEPL4

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 INC T3                 \ Increment the period in T3

 LDX T3                 \ Loop around for T3 iterations, waiting for four cycles
 DEX                    \ in each iteration, so as the sound continues and T3
 NOP                    \ increases, the wait gets longer and the frequency of
 NOP                    \ the explosion tone lowers into a dissipated explosion
 BNE P%-3               \ noise

 JSR DORND              \ Set A and X to random numbers

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 2 * X
                        \ CPU cycles

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL4             \ Loop back to make another click and wait for a random
                        \ and (on average) increasing amount of time between
                        \ clicks, until we have made a sound consisting of Y
                        \ clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

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
\   SOBEEP              Make a beep as follows:
\
\                         * X = the period of the beep (a bigger value means a
\                               lower pitch)
\
\                         * Y = the length of the beep
\
\   SOUR                Contains an RTS
\
\ ******************************************************************************

.BEEP

 LDY #30                \ Set the length of the loop below to 30 clicks, so we
                        \ make a total of 31 clicks in the following

 LDX #110               \ Set the period of the sound at 110 for a high beep

.SOBEEP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL1

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 LDX T3                 \ Loop around for T3 iterations, so the higher the
 DEX                    \ period in X, the longer the wait
 BNE P%-1

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL1             \ Loop back to make another click until we have made a
                        \ sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

.SOUR

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SOBLIP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound sound of the hyperspace drive being engaged, or the
\             sound of the E.C.M.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The period of the sound (a bigger value means a lower
\                       pitch)
\
\   Y                   The type of sound (i.e. the length of the sound):
\
\                         * 20 = the sound of the E.C.M going off (part 16 of
\                                the main flight loop)
\
\                         * 90 = the sound of the hyperspace drive being engaged
\                                (LL164)
\
\ ******************************************************************************

.SOBLIP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL2

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 DEC T3                 \ Decrement the period in T3

 LDX T3                 \ Loop around for T3 iterations, waiting for two cycles
 DEX                    \ in each iteration, so as the sound continues and T3
 NOP                    \ decreases, the wait gets shorter and the frequency of
 BNE P%-2               \ the sound rises

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL2             \ Loop back to make another click and wait for a
                        \ decreasing amount of time between clicks, until we
                        \ have made a sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LASNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of our laser firing or the sound of us being hit by
\             lasers
\
\ ******************************************************************************

.LASNOISE

 LDY #11                \ Set the length of the loop below to 11 clicks, so we
                        \ make a total of 12 clicks in the following

 LDX #150               \ Set the period of the sound at 150, which increases
                        \ as the sound progresses

.SOBLOP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL3

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 INC T3                 \ Increment the period in T3 twice, so the tone of the
 INC T3                 \ sound falls rapidly

 LDX T3                 \ Loop around for T3 iterations, so as the sound
 DEX                    \ continues and T3 increases, the wait gets longer and
 BNE P%-1               \ the frequency of the laser tone lowers into a
                        \ dissipated explosion noise

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL3             \ Loop back to make another click and wait for a rapidly
                        \ increasing amount of time between clicks, until we
                        \ have made a sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LASNOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: An unused routine that makes the sound of the energy bomb going
\             off
\
\ ******************************************************************************

.LASNOISE2

 LDY #11                \ Set Y = 11, though this has no effect as Y is set to
                        \ 25 in the following

 LDX #130               \ Set X = 130, though this has no effect as X is
                        \ overwritten with a random number before it is used

                        \ Fall through into SOBOMB to make the sound of an
                        \ energy bomb going off
                        \
                        \ The above variables make no difference to the sound
                        \ made by SOBOMB, but given the title of the routine,
                        \ it was presumably designed to jump to the SOBLOP entry
                        \ point to make a higher-pitched variation of the laser
                        \ sound, rather than falling in to SOBOMB
                        \
                        \ All that is missing is a BNE SOBLOP instruction to do
                        \ the jump

\ ******************************************************************************
\
\       Name: SOBOMB
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of an energy bomb going off
\
\ ******************************************************************************

.SOBOMB

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 LDY #25                \ Set the length of the loop below to 25 clicks, so we
                        \ make a total of 26 clicks in the following

.SOHISS4

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 JSR DORND              \ Set A and X to random numbers

 AND #31                \ Reduce A to a random number in the range 0 to 31

 ORA #&E0               \ Increase A to a random number in the range 224 to 255

 TAX                    \ Set X to our random number in the range 224 to 255,
                        \ which we now use as the period for our sound (so this
                        \ is a low toned explosion sound with a random element
                        \ of white noise, like a dissipated explosion)

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 2 * X
                        \ CPU cycles

 DEY                    \ Decrement the sound length in Y

 BNE SOHISS4            \ Loop back to make another click and wait for a random
                        \ amount of time between clicks, until we have made a
                        \ sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CLICK
\       Type: Subroutine
\   Category: Sound
\    Summary: Toggle the state of the speaker (i.e. move it in or out) to make a
\             single click
\
\ ******************************************************************************

.CLICK

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR2              \ so jump to SOUR2 to return from the subroutine

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

.SOUR2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: COLD
\       Type: Subroutine
\   Category: Loader
\    Summary: Initialise the screen mode, clear memory and set up interrupt
\             handlers
\
\ ******************************************************************************

.COLD

 JSR HGR                \ Switch to the high-resolution graphics screen mode

                        \ We start by zeroing two pages of memory from &0800
                        \ to &09FF, so that zeroes the following:
                        \
                        \   * The disk sector buffer from &0800 to &08FF
                        \
                        \   * The disk 6-bit nibble buffer from &0900 to &09FF
                        \
                        \ So this initialises the disk buffers at buffer and
                        \ buffer2

 LDA #8                 \ Set the high byte of SC(1 0) to 8
 STA SC+1

 LDX #2                 \ Set X = 2 to act as a page counter, so we zero two
                        \ whole pages of memory

 LDA #0                 \ Set A = 0 so we can use this to zero memory locations

 STA SC                 \ Set the low byte of SC(1 0) to zero, so SC is now set
                        \ to &0800

 TAY                    \ Set Y = 0 to act as a byte counter within each page

.zerowksploop

 STA (SC),Y             \ Zero the Y-th byte of SC(1 0)

 INY                    \ Increment the byte counter

 BNE zerowksploop       \ Loop back until we have zeroed a whole page of memory

 INC SC+1               \ Increment the high byte of SC(1 0) to point to the
                        \ next page in memory

 DEX                    \ Decrement the page counter in X

 BNE zerowksploop       \ Loop back until we have zeroed all three pages

                        \ Next, we zero the page of memory from &0200 to &02FF,
                        \ so that zeroes the following:
                        \
                        \   * The UP from workspace &0200 to &02FF (though it
                        \     doesn't zero the last two bytes of the workspace
                        \     at &0300 and &0301)
                        \
                        \ At this point Y = 0, so we can use that as a byte
                        \ counter

.zerowkl2

 STA &0200,Y            \ Zero the Y-th byte of &0200

 DEY                    \ Decrement the byte counter

 BNE zerowkl2           \ Loop back until we have zeroed the whole page

 LDA #LO(NMIpissoff)    \ Set the NMI interrupt vector in NMIV to point to the
 STA NMIV               \ NMIpissoff routine, which acknowledges NMI interrupts
 LDA #HI(NMIpissoff)    \ and ignores them
 STA NMIV+1

 LDA #LO(CHPR2)         \ Set the CHRV interrupt vector in CHRV to point to the
 STA CHRV               \ CHPR2 routine, which prints valid ASCII characters
 LDA #HI(CHPR2)         \ using the CHPR routine (so this replaces the normal
 STA CHRV+1             \ text-printing routine with Elite's own CHPR routine)

 SEI                    \ Disable interrupts (though they will be re-enabled by
                        \ the first non-maskable interrupt that is handled by
                        \ NMIpissoff, so this probably won't disable interrupts
                        \ for long)

 RTS                    \ Return from the subroutine

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
\    Summary: Storage for the commander filename, padded out with spaces to a
\             fixed size of 30 characters, for the rfile and wfile routines
\
\ ******************************************************************************

.comnam

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
\    Summary: Write a commander file from the buffer to a DOS disk
\
\ ******************************************************************************

.wfile

 JSR MUTILATE           \ Encrypt the commander file in the buffer at comfil

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
 STA buffer+3,Y \ copy commander name to filename field
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
\    Summary: Encrypt the commander file in the buffer at comfil
\
\ ------------------------------------------------------------------------------
\
\ At this point, the commander file is set up in memory like this (as defined in
\ the configuration variables comsiz, comfil and comfil2):
\
\ .comfil
\
\  20 bytes
\
\ .TAP%
\
\  77 bytes containing the full commander file from byte #0 to byte #76
\
\  9 bytes
\
\ .comfil2
\
\  4 bytes
\
\ The entire structure above contains comsiz (110) bytes.
\
\ This routine encrypts the commander file by first calculating a set of four
\ random number seeds, using a set of bitwise operations that start with the
\ third checksum byte at CHK3. These seed values get stored in the four bytes at
\ comfil and are saved with the file, so they can be used by the UNMUTILATE
\ routine to reverse the encryption.
\
\ The encryption process simply takes the repeatable sequence of random numbers
\ that are generated from these four seeds, and EOR's the bytes in the commander
\ file with the numbers in the sequence. Because this is a simple EOR with a
\ number sequence that can be reproduced from the four seeds, the decryption
\ process just repeats the encryption process, generating the same sequence of
\ random numbers from the seeds in the commander file, and EOR'ing them with the
\ bytes in the encrypted file to produce the decrypted bytes (which works
\ because a EOR b EOR b = a).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MUTIL3              Decrypt the commander file
\
\ ******************************************************************************

.MUTILATE

 LDA CHK3               \ Set A to the third checksum byte at CHK3 for this
                        \ commander file

                        \ We now use this value to change the four random number
                        \ seeds in RAND to RAND+3 into four different values
                        \ that we can use to encrypt the file

 EOR RAND               \ EOR it into the first random number seed in RAND
 STA RAND

 STA comfil2            \ Store the seed value in comfil2, so it gets saved as
                        \ part of the commander file

 EOR #&A5               \ EOR and OR the result into the second random number
 ORA #17                \ seed in RAND+1
 EOR RAND+1
 STA RAND+1

 STA comfil2+1          \ Store the seed value in comfil2+1, so it gets saved as
                        \ part of the commander file

 EOR RAND+2             \ EOR the result into the third random number seed in
 EOR #&F8               \ RAND+2
 STA RAND+2

 STA comfil2+2          \ Store the seed value in comfil2+2, so it gets saved as
                        \ part of the commander file

 EOR RAND+3             \ EOR the result into the fourth random number seed in
 EOR #&12               \ RAND+3
 STA RAND+3

 STA comfil2+3          \ Store the seed value in comfil2+3, so it gets saved as
                        \ part of the commander file

                        \ We now have four random seeds that are partially based
                        \ on the third checksum and partially based on the
                        \ previous value of the four random seeds, so we now use
                        \ these seeds to encrypt the file
                        \
                        \ The encryption process uses a simple EOR with the next
                        \ random number from the repeatable sequence produced by
                        \ the four seeds we stored at comfil2, so repeating the
                        \ encryption process with the same four seeds will
                        \ decrypt the file

.MUTIL3

 LDY #comsiz-5          \ Set Y to a byte counter so we can work our way
                        \ backwards through the whole commander file structure,
                        \ omitting the four bytes at comfil2 at the end

.MUTIL1

 JSR DORND2             \ Set A and X to random numbers, making sure the C flag
                        \ doesn't affect the outcome

 EOR comfil,Y           \ EOR the Y-th byte in the commander file with the next
 STA comfil,Y           \ random number in the sequence generated by the four
                        \ seeds stored at comfil2

 DEY                    \ Decrement the byte counter

 BPL MUTIL1             \ Loop back until we have processed the whole commander
                        \ file structure

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: UNMUTILATE
\       Type: Variable
\   Category: Save and load
\    Summary: Decrypt the commander file in the buffer at comfil
\
\ ******************************************************************************

.UNMUTILATE

 LDY #3                 \ To decrypt the commander file, we need to set the four
                        \ random number seeds at RAND to RAND+3 to the four
                        \ bytes at comfil2 in the encrypted commander file, so
                        \ set a byte counter in Y to copy four bytes

.MUTIL2

 LDA comfil2,Y          \ Copy the Y-th seed from the commander file to the Y-th
 STA RAND,Y             \ random number seed at RAND

 DEY                    \ Decrement the byte counter

 BPL MUTIL2             \ Loop back until we have copied all four bytes

 BMI MUTIL3             \ Jump to MUTIL3 to apply the decryption process to the
                        \ commander file, which is simply a repeat of the
                        \ encryption process with the same seeds (this BMI is
                        \ effectively a JMP as we just passed through a BPL)

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

INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"

\ ******************************************************************************
\
\       Name: cellocl
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of that row in text screen memory (low byte)
\
\ ------------------------------------------------------------------------------
\
\ The text screen has the same kind of interleaved row layout in memory as the
\ Apple II high-res screen, except screen memory is at &400 rather than &2000.
\ We add 2 to indent the text by two characters.
\
\ ******************************************************************************

.cellocl

 EQUB LO(&0400 + 2)
 EQUB LO(&0480 + 2)
 EQUB LO(&0500 + 2)
 EQUB LO(&0580 + 2)
 EQUB LO(&0600 + 2)
 EQUB LO(&0680 + 2)
 EQUB LO(&0700 + 2)
 EQUB LO(&0780 + 2)
 EQUB LO(&0428 + 2)
 EQUB LO(&04A8 + 2)
 EQUB LO(&0528 + 2)
 EQUB LO(&05A8 + 2)
 EQUB LO(&0628 + 2)
 EQUB LO(&06A8 + 2)
 EQUB LO(&0728 + 2)
 EQUB LO(&07A8 + 2)
 EQUB LO(&0450 + 2)
 EQUB LO(&04D0 + 2)
 EQUB LO(&0550 + 2)
 EQUB LO(&05D0 + 2)
 EQUB LO(&0650 + 2)
 EQUB LO(&06D0 + 2)
 EQUB LO(&0750 + 2)
 EQUB LO(&07D0 + 2)

\ ******************************************************************************
\
\       Name: SCTBL
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of the top or bottom pixel line in that character row (low byte)
\
\ ------------------------------------------------------------------------------
\
\ The character rows in screen memory for the Apple II high-res screen are not
\ stored in the order in which they appear. The SCTBL, SCTBH and SCTBH2 tables
\ provide a lookup for the address of the start of each character row.
\
\ Also, the pixel rows within each character row are interleaved, so each pixel
\ row appears &400 bytes after the previous pixel row. The address of pixel row
\ n within character row Y is stored at the address given in the Y-th entry of
\ (SCTBH SCTBL), plus n * &400, so the addresses are as follows:
\
\   * Pixel row 0 is at the Y-th entry from (SCTBH SCTBL)
\   * Pixel row 1 is at the Y-th entry from (SCTBH SCTBL) + &400
\   * Pixel row 2 is at the Y-th entry from (SCTBH SCTBL) + &800
\   * Pixel row 3 is at the Y-th entry from (SCTBH SCTBL) + &C00
\   * Pixel row 4 is at the Y-th entry from (SCTBH SCTBL) + &1000
\   * Pixel row 5 is at the Y-th entry from (SCTBH SCTBL) + &1400
\   * Pixel row 6 is at the Y-th entry from (SCTBH SCTBL) + &1800
\   * Pixel row 7 is at the Y-th entry from (SCTBH SCTBL) + &1C00
\
\ To make life easier, the table at SCTBH2 contains the high byte for the final
\ row, where the high byte has &1C00 added to the address.
\
\ ******************************************************************************

.SCTBL

 EQUB LO(&2000)
 EQUB LO(&2080)
 EQUB LO(&2100)
 EQUB LO(&2180)
 EQUB LO(&2200)
 EQUB LO(&2280)
 EQUB LO(&2300)
 EQUB LO(&2380)
 EQUB LO(&2028)
 EQUB LO(&20A8)
 EQUB LO(&2128)
 EQUB LO(&21A8)
 EQUB LO(&2228)
 EQUB LO(&22A8)
 EQUB LO(&2328)
 EQUB LO(&23A8)
 EQUB LO(&2050)
 EQUB LO(&20D0)
 EQUB LO(&2150)
 EQUB LO(&21D0)
 EQUB LO(&2250)
 EQUB LO(&22D0)
 EQUB LO(&2350)
 EQUB LO(&23D0)

\ ******************************************************************************
\
\       Name: SCTBH
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of the top pixel line in that character row (high byte)
\
\ ------------------------------------------------------------------------------
\
\ The character rows in screen memory for the Apple II high-res screen are not
\ stored in the order in which they appear. The SCTBL, SCTBH and SCTBH2 tables
\ provide a lookup for the address of the start of each character row.
\
\ Also, the pixel rows within each character row are interleaved, so each pixel
\ row appears &400 bytes after the previous pixel row. The address of pixel row
\ n within character row Y is stored at the address given in the Y-th entry of
\ (SCTBH SCTBL), plus n * &400, so the addresses are as follows:
\
\   * Pixel row 0 is at the Y-th entry from (SCTBH SCTBL)
\   * Pixel row 1 is at the Y-th entry from (SCTBH SCTBL) + &400
\   * Pixel row 2 is at the Y-th entry from (SCTBH SCTBL) + &800
\   * Pixel row 3 is at the Y-th entry from (SCTBH SCTBL) + &C00
\   * Pixel row 4 is at the Y-th entry from (SCTBH SCTBL) + &1000
\   * Pixel row 5 is at the Y-th entry from (SCTBH SCTBL) + &1400
\   * Pixel row 6 is at the Y-th entry from (SCTBH SCTBL) + &1800
\   * Pixel row 7 is at the Y-th entry from (SCTBH SCTBL) + &1C00
\
\ To make life easier, the table at SCTBH2 contains the high byte for the final
\ row, where the high byte has &1C00 added to the address.
\
\ ******************************************************************************

.SCTBH

 EQUB HI(&2000)
 EQUB HI(&2080)
 EQUB HI(&2100)
 EQUB HI(&2180)
 EQUB HI(&2200)
 EQUB HI(&2280)
 EQUB HI(&2300)
 EQUB HI(&2380)
 EQUB HI(&2028)
 EQUB HI(&20A8)
 EQUB HI(&2128)
 EQUB HI(&21A8)
 EQUB HI(&2228)
 EQUB HI(&22A8)
 EQUB HI(&2328)
 EQUB HI(&23A8)
 EQUB HI(&2050)
 EQUB HI(&20D0)
 EQUB HI(&2150)
 EQUB HI(&21D0)
 EQUB HI(&2250)
 EQUB HI(&22D0)
 EQUB HI(&2350)
 EQUB HI(&23D0)

 EQUD &20202020         \ These bytes appear to be unused
 EQUD &20202020

\ ******************************************************************************
\
\       Name: SCTBH2
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a character row number to the address
\             of the bottom pixel line in that character row (high byte)
\
\ ------------------------------------------------------------------------------
\
\ The character rows in screen memory for the Apple II high-res screen are not
\ stored in the order in which they appear. The SCTBL, SCTBH and SCTBH2 tables
\ provide a lookup for the address of the start of each character row.
\
\ Also, the pixel rows within each character row are interleaved, so each pixel
\ row appears &400 bytes after the previous pixel row. The address of pixel row
\ n within character row Y is stored at the address given in the Y-th entry of
\ (SCTBH SCTBL), plus n * &400, so the addresses are as follows:
\
\   * Pixel row 0 is at the Y-th entry from (SCTBH SCTBL)
\   * Pixel row 1 is at the Y-th entry from (SCTBH SCTBL) + &400
\   * Pixel row 2 is at the Y-th entry from (SCTBH SCTBL) + &800
\   * Pixel row 3 is at the Y-th entry from (SCTBH SCTBL) + &C00
\   * Pixel row 4 is at the Y-th entry from (SCTBH SCTBL) + &1000
\   * Pixel row 5 is at the Y-th entry from (SCTBH SCTBL) + &1400
\   * Pixel row 6 is at the Y-th entry from (SCTBH SCTBL) + &1800
\   * Pixel row 7 is at the Y-th entry from (SCTBH SCTBL) + &1C00
\
\ To make life easier, the table at SCTBH2 contains the high byte for the final
\ row, where the high byte has &1C00 added to the address.
\
\ ******************************************************************************

.SCTBH2

 EQUB HI(&2000 + &1C00)
 EQUB HI(&2080 + &1C00)
 EQUB HI(&2100 + &1C00)
 EQUB HI(&2180 + &1C00)
 EQUB HI(&2200 + &1C00)
 EQUB HI(&2280 + &1C00)
 EQUB HI(&2300 + &1C00)
 EQUB HI(&2380 + &1C00)
 EQUB HI(&2028 + &1C00)
 EQUB HI(&20A8 + &1C00)
 EQUB HI(&2128 + &1C00)
 EQUB HI(&21A8 + &1C00)
 EQUB HI(&2228 + &1C00)
 EQUB HI(&22A8 + &1C00)
 EQUB HI(&2328 + &1C00)
 EQUB HI(&23A8 + &1C00)
 EQUB HI(&2050 + &1C00)
 EQUB HI(&20D0 + &1C00)
 EQUB HI(&2150 + &1C00)
 EQUB HI(&21D0 + &1C00)
 EQUB HI(&2250 + &1C00)
 EQUB HI(&22D0 + &1C00)
 EQUB HI(&2350 + &1C00)
 EQUB HI(&23D0 + &1C00)

INCLUDE "library/common/main/subroutine/loin_part_1_of_7-loinq_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7-loinq_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7-loinq_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7-loinq_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7-loinq_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7-loinq_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7-loinq_part_7_of_7.asm"

\ ******************************************************************************
\
\       Name: MSBARS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw two horizontal lines as part of an indicator bar, from
\             (X1, Y1+1) to (X2, Y1+1) and (X1, Y1+2) to (X2, Y1+2)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y1                  Y1 is incremented by 2
\
\ ******************************************************************************

.MSBARS

 JSR P%+3               \ Call the following instruction as a subroutine, to
                        \ draw a line from (X1, Y1+1) to (X2, Y1+1), and then
                        \ fall through to draw another line from (X1, Y1+2) to
                        \ (X2, Y1+2), as Y1 is incremented each time

 INC Y1                 \ Increment Y1 and fall through into HLOIN to draw a
                        \ horizontal line from (X1, Y1) to (X2, Y1)

\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
\
\ ------------------------------------------------------------------------------
\
\ We do not draw a pixel at the right end of the line.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   COL                 The line colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.HLOIN

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

                        \ We are going to draw the line like this:
                        \
                        \   * Draw the byte containing the start of the line
                        \     (and if it also happens to contain the end of the
                        \     line, draw both ends in one byte and terminate)
                        \
                        \   * Draw any full bytes in the middle of the line
                        \
                        \   * Draw the byte containing the end of the line, plus
                        \     one more pixel (which may spill over into the next
                        \     pixel byte)
                        \
                        \ We draw the end cap with an extra pixel to ensure that
                        \ there is room for a full two-bit colour number in the
                        \ last byte (i.e. %00 for two black pixels, %11 for two
                        \ white pixels, %01 or %10 for two coloured pixels)
                        \
                        \ To facilitate this approach, we need to make sure the
                        \ start and end x-coordinates are both even, so the
                        \ two-bit colour numbers start on even pixel numbers

 LDA X1                 \ Round the x-coordinate in X1 down to the nearest even
 AND #%11111110         \ coordinate, so we can draw the line in two-pixel steps
 STA X1

 TAX                    \ Set X to the rounded x-coordinate in X1

 LDA X2                 \ Round the x-coordinate in X2 down to the nearest even
 AND #%11111110         \ coordinate, setting A to the rounded coordinate in X2
 STA X2                 \ in the process, so we can draw the line in two-pixel
                        \ steps

 CMP X1                 \ If X1 = X2 then the start and end points are the same,
 BEQ HL6                \ so return from the subroutine (as HL6 contains an RTS)

 BCS HL5                \ If X1 < X2, jump to HL5 to skip the following code, as
                        \ (X1, Y1) is already the left point

 STX X2                 \ Swap the values of X1 and X2 (in X and X2), so we know
 TAX                    \ that (X1, Y1) is on the left and (X2, Y1) is on the
                        \ right
                        \
                        \ This does not update X1, but we don't use it in the
                        \ following (we use X instead)

.HL5

 LDA Y1                 \ Set A to the y-coordinate in Y1

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \
                        \ So A now contains the number of the character row
                        \ that will contain our horizontal line

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA Y1                 \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our line (as
                        \ each character block has 8 rows)

 ASL A                  \ Set the high byte of SC(1 0) as follows:
 ASL A                  \
 ADC SCTBH,Y            \   SC+1 = SCBTH for row Y + pixel row * 4 
 STA SC+1               \
                        \ Because this is the high byte, and because we already
                        \ set the low byte in SC to the Y-th entry from SCTBL,
                        \ this is the same as the following:
                        \
                        \   SC(1 0) = (SCBTH SCTBL) for row Y + pixel row * &400
                        \
                        \ So SC(1 0) contains the address in screen memory of
                        \ the pixel row containing the pixel we want to draw, as
                        \ (SCBTH SCTBL) gives us the address of the start of the
                        \ character row, and each pixel row within the character
                        \ row is offset by &400 bytes

 LDA SCTBX2,X           \ Using the lookup table at SCTBX2, set A to the byte
                        \ number within the pixel row that contains the pixel we
                        \ want to draw (as X contains the x-coordinate of the
                        \ start of the line)

 AND #1                 \ Set Y to the colour in COL, plus 1 if the byte number
 ORA COL                \ within the pixel row is odd
 TAY                    \
                        \ We can use this to fetch the correct pixel bytes from
                        \ MASKT that we can poke into screen memory to draw a
                        \ continuous line of the relevant colour
                        \
                        \ Bytes #0 and #1 of the relevant entry in MASKT contain
                        \ the bit pattern for when the first byte is placed in
                        \ an even-numbered pixel byte (counting along the pixel
                        \ row), while bytes #1 and #2 contain the bit pattern
                        \ for when the first byte is placed in an odd-numbered
                        \ pixel byte
                        \
                        \ So Y now points to the correct MASKT entry for the
                        \ start of the line, because it points to byte #0 in
                        \ offset COL if the byte number within the pixel row is
                        \ even, or byte #1 in offset COL if the byte number
                        \ within the pixel row is odd

 LDA MASKT,Y            \ Set T1 and T2 to the correct pixel bytes for drawing a
 STA T1                 \ continuous line in colour COL into the pixel byte that
 LDA MASKT+1,Y          \ contains the pixel we want to draw
 STA T2

                        \ So T1 contains the pattern for the byte at the start
                        \ of the line, and T2 contains the pattern for the next
                        \ byte along, and T1 contains the pattern for the byte
                        \ after that, and so on
                        \
                        \ In other words, we alternate between the patterns in
                        \ T1 and T2 as we work our way along the line, one byte
                        \ at a time

.HL1

 LDY X2                 \ Using the lookup table at SCTBX2, set A to the byte
 LDA SCTBX2-2,Y         \ number within the pixel row that contains the pixel
                        \ at X2 - 2, so we omit the last pixel (we subtract 2
                        \ as we draw the end of the line with an extra pixel)

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at the start of the line (as X contains the
                        \ x-coordinate of the start of the line)

 SEC                    \ SCTBX2,X is the byte number within the pixel row that
 SBC SCTBX2,X           \ contains the pixel at X, which is at the start of the
 STA R                  \ line, so this calculation:
                        \
                        \   R = A - SCTBX2,X
                        \
                        \ sets R to the number of pixel bytes between the start
                        \ and the end of the line

 LDA TWFR,Y             \ Fetch a ready-made byte with Y pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point Y and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

 AND T1                 \ Apply the pixel mask in A to the continuous block of
                        \ coloured pixels in T1, so we now know which bits to
                        \ set in screen memory to paint the relevant pixels in
                        \ the required colour for the pixel byte at the start
                        \ of the line

 LDY SCTBX2,X           \ Set Y to the byte number within the pixel row that
                        \ contains the pixel at X, which is at the start of the
                        \ line

 LDX R                  \ Set X = R, so X contains the number of pixel bytes
                        \ between the start and end of the line
                        \
                        \ We use X as a counter in the following to ensure we
                        \ draw the correct number of bytes for the line

 BEQ HL3                \ If X = 0 then there are no pixel bytes between the
                        \ start and end, which means the line starts and ends
                        \ within the same pixel byte, so jump to HL3 to draw
                        \ this single-byte line

                        \ Otherwise we need to draw the pixel byte containing
                        \ the left end of the line

 STA T4                 \ Store the pixel pattern for the left end of the line
                        \ in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte, so X now contains the number of
                        \ bytes left before we reach the pixel byte containing
                        \ the end of the line

 BEQ HL4                \ If X = 0 then there are no more pixel bytes before we
                        \ reach the end of the line, so jump to HL4 to skip
                        \ drawing any pixel bytes inbetween the start and end
                        \ bytes (as there aren't any)

                        \ Otherwise we now loop through all the pixel bytes in
                        \ the line between the start byte and the end byte,
                        \ using the counter in X to draw the correct number of
                        \ bytes
                        \
                        \ We draw the bytes in the middle of the line two at a
                        \ time, using pattern T2 for the first byte, then T1
                        \ for the next, and then T2 again, and so on
                        \
                        \ If we reach the end of the middle section having just
                        \ drawn a T2 byte, we jump to HL8 to make sure we draw
                        \ the end of the line using pattern T1, otherwise we
                        \ fall through into HL4 to draw it using pattern T2

.HLL1

 LDA (SC),Y             \ Draw the pixel pattern in T2 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T2                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T2

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte

 BEQ HL8                \ If X = 0 then we have drawn all the bytes between the
                        \ start and end bytes, so jump to HL8 to draw the byte
                        \ at the end of line using pattern T1

 LDA (SC),Y             \ Draw the pixel pattern in T1 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T1                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T1

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte

 BNE HLL1               \ Loop back until we have drawn all X bytes

                        \ We have finished drawing the middle of the line, so
                        \ fall through into HL4 to draw the end of the line
                        \ using the pattern in T2

.HL4

                        \ If we reach here then we only have one more pixel byte
                        \ to draw, the one for the end of the line

 LDA T2                 \ Set A to the pattern in T2, as we only get here if we
                        \ have just drawn a pixel byte with the pattern in T1

.HL2

 LDX X2                 \ Set X to the x-coordinate of the end of the line

 LDY SCTBX1-2,X         \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at x-coordinate X2 - 2, so we omit the last
                        \ pixel (we subtract 2 as we draw the end of the line
                        \ with an extra pixel)

 CPY #6                 \ If Y < 6 then clear the C flag, so we can use this to
                        \ check whether we need to spill into the next pixel
                        \ byte to draw the end of the line properly

 AND TWFL,Y             \ Apply the pixel pattern in A to a ready-made byte with
                        \ Y + 1 pixels filled in at the left end of the byte (so
                        \ the filled pixels start at the left edge and go up to
                        \ point Y + 1), which is the shape we want for the right
                        \ end of the line
                        \
                        \ Note that unlike TWFR, the minimum cap size is two
                        \ pixels, so it can take a full two-bit colour number
                        \ even if we only really need one pixel in the end cap

 LDY SCTBX2-2,X         \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the pixel
                        \ at X2 - 2, so we omit the last pixel (we subtract 2
                        \ as we draw the end of the line with an extra pixel)

 STA T4                 \ Store the pixel pattern for the right end of the line
                        \ in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

 BCC HL7                \ If the C flag is clear then the bit number for the
                        \ pixel at the end of the line is less than 6, so jump
                        \ to HL7 as the end of the line is not spilling into the
                        \ next pixel byte

                        \ If we get here then the last pixel in the line is at
                        \ bit number 6, so we need to spill over by one bit into
                        \ the next pixel byte, as the colour of a pixel is
                        \ defined by a two-bit sequence

 LDA #%10000001         \ We only want to draw one bit into the next pixel byte,
 AND T1                 \ and the bit we need to set is bit 0, as this is the
                        \ leftmost pixel in the pixel byte, so we take the pixel
                        \ pattern from T1 and extract just bits 0 (for the
                        \ overspill) and bit 7 (for the colour palette) to leave
                        \ the correct pixel byte for the overspill in A

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right, which is where we need to poke the overspill

 STA T4                 \ Store the pixel pattern for the overspill in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

.HL7

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.HL8

                        \ If we get here then we just finished drawing the
                        \ middle section of the line using pattern T2, so we
                        \ need to draw the end of the line using pattern T1

 LDA T1                 \ Set A to the colour pattern in T1, to use for the
                        \ last pixel byte at the end of the line

.HL3

                        \ If we jump directly here from above, then the line
                        \ starts and ends within the same pixel byte, and A
                        \ contains the pixel pattern for the left end of the
                        \ line, so we keep that pattern in A before jumping to
                        \ HL2
                        \
                        \ This means that when we apply the pattern in A to the
                        \ end of the line, we end up with a single-byte pixel
                        \ pattern that contains both ends of the line

 LDX T2                 \ Set T1 = T2
 STX T1                 \
                        \ We do this because the routine at HL2 draws the pixel
                        \ byte for the end of the line using the pattern in A,
                        \ which will either be T1 (if we got here via HL8 above)
                        \ or the single-byte pixel pattern that's based on T1
                        \ (if we got here by jumping to HL3)
                        \
                        \ In both cases the pattern of the next byte along after
                        \ the end of the line should therefore be in pattern T2,
                        \ and the code at HL2 uses the pattern in T1 to draw any
                        \ overspill after the byte containing the end of the
                        \ line, so this ensures that any overspill uses the
                        \ pattern in T2, rather than T1

 JMP HL2                \ Jump to HL2 to draw the last pixel byte of the line
                        \ using the pixel pattern in A

\ ******************************************************************************
\
\       Name: MASKT
\       Type: Variable
\   Category: Drawing lines
\    Summary: High-resolution pixel bytes for drawing continuous lines of solid
\             colour
\
\ ------------------------------------------------------------------------------
\
\ This table contains four bytes for each colour (the colour variables such as
\ VIOLET and RED are indexes into this table).
\
\ The first three bytes contain the values we need to store in screen memory to
\ draw a continuous line in the relevant colour; the fourth byte is ignored and
\ is zero. Bytes #0 and #1 contain the bit pattern for when the first byte is
\ placed in an even-numbered pixel byte (counting along the pixel row), while
\ bytes #1 and #2 contain the bit pattern for when the first byte is placed in
\ an odd-numbered pixel byte.
\
\ The comments show the on-off patterns that the high-resolution mode converts
\ into colours, with bit 7 removed for clarity.
\
\ ******************************************************************************

.MASKT

      \ Byte #2 Byte #1 Byte #0       Byte #0 Byte #1 Byte #2
      \ 6543210 6543210 6543210       0123456 0123456 0123456

 EQUD %000000000000000000000000     \ Black (00) in colour palette 0
                                    \ 0000000 0000000 0000000

 EQUD %010101010010101001010101     \ Violet (x0) in colour palette 0
                                    \ x0x0x0x 0x0x0x0 x0x0x0x

 EQUD %001010100101010100101010     \ Green (0x) in colour palette 0
                                    \ 0x0x0x0 x0x0x0x 0x0x0x0

 EQUD %011111110111111101111111     \ White (xx) in colour palette 0
                                    \ xxxxxxx xxxxxxx xxxxxxx

 EQUD %110101011010101011010101     \ Blue (x0) in colour palette 1
                                    \ x0x0x0x 0x0x0x0 x0x0x0x

 EQUD %101010101101010110101010     \ Red (0x) in colour palette 1
                                    \ 0x0x0x0 x0x0x0x 0x0x0x0

 EQUD %101010101010101010101010     \ Fuzzy (red/black/blue) in colour palette 1
                                    \ 0x0x0x0 0x0x0x0 0x0x0x0

\ ******************************************************************************
\
\       Name: VLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a vertical line from (X1, Y1) to (X1, Y2)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   R                   The line colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.VLOIN

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDA Y1                 \ Set A to the y-coordinate of the start of the line

 CMP Y2                 \ If Y1 >= Y2 then jump to VLO1 as the coordinates are
 BCS VLO1               \ already the correct way around

 LDY Y2                 \ Otherwise swap Y1 and Y2 around so that Y1 >= Y2
 STA Y2                 \ (with Y1 in A)
 TYA

.VLO1

                        \ We now want to draw a line from (X1, A) to (X1, Y2),
                        \ which goes up the screen from bottom to top

 LDX X1                 \ Draw a single pixel at screen coordinate (X1, A), at
 JSR CPIX               \ the start of the line
                        \
                        \ This also sets the following:
                        \
                        \   * T2 = the number of the pixel row within the
                        \          character block that contains the pixel,
                        \          which we use in the loop below to draw the
                        \          line
                        \
                        \   * R = the pixel byte for drawing the pixel
                        \
                        \   * Y = the byte offset within the pixel row of the
                        \         byte that contains the pixel

 LDA Y1                 \ Set A = Y1 - Y2
 SEC                    \
 SBC Y2                 \ So A contains the height of the vertical line in
                        \ pixels

 BEQ VLO5               \ If the start and end points are at the same height,
                        \ jump to VLO5 to return from the subroutine, as we
                        \ already drew a one-pixel vertical line

 TAX                    \ Set X to the height of the line, plus 1, so we can use
 INX                    \ this as a pixel counter in the loop below (the extra 1
                        \ is to take account of the pixel we just drew)

 JMP VLO4               \ Jump into the following loop at VLO4 to draw the rest
                        \ of the line

.VLOL1

 LDA R                  \ Set A to the pixel byte that was returned by the CPIX
                        \ routine when we drew the first pixel in the vertical
                        \ line, which is the same pixel byte that we need for
                        \ every pixel in the line (as it is a vertical line)

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 LDA T3                 \ Set A to the pattern for the next byte along, which
                        \ was returned by the CPIX

 BEQ VLO4               \ If T3 is zero then there is no need to write to the
                        \ next byte along, so jump to VLO4 to move on to drawing
                        \ the rest of the line

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 DEY                    \ Decrement Y to move back to the previous pixel byte,
                        \ so we keep drawing our line in the correct position

.VLO4

                        \ This is where we join the loop from above, at which
                        \ point we have the following variables set:
                        \
                        \   * T2 = the pixel row of the start of the line
                        \
                        \   * X = the height of the line we want to draw + 1
                        \
                        \   * Y = the byte offset within the pixel row of the
                        \         line
                        \
                        \ The height in X has an extra one added to it because
                        \ we are about to decrement it (so that extra one is
                        \ effectively counting the single pixel we already drew
                        \ before jumping here)

 DEC T2                 \ Decrement the pixel row number in T2 to move to the
                        \ pixel row above

 BMI VLO2               \ If T2 is negative then the we are no longer within the
                        \ same character block, so jump to VLO2 to move to the
                        \ bottom pixel row in the character row above

                        \ We now need to move up into the pixel row above

 LDA SC+1               \ Subtract 4 from the high byte of SC(1 0), so this does
 SEC                    \ the following:
 SBC #4                 \
 STA SC+1               \   SC(1 0) = SC(1 0) - &400
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ above the one we just drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

.VLO3

 DEX                    \ Decrement the pixel counter in X

 BNE VLOL1              \ Loop back until we have drawn X - 1 pixels

.VLO5

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.VLO2

                        \ If we get here then we need to move up into the bottom
                        \ pixel row in the character block above

 LDA #7                 \ Set the pixel line number within the character row
 STA T2                 \ (which we store in T2) to 7, which is the bottom pixel
                        \ row of the character block above

 STX T                  \ Store the current character row number in T, so we can
                        \ restore it below

 LDX T1                 \ Decrement the number of the character row in T1, as we
 DEX                    \ are moving up a row
 STX T1

 LDA SCTBL,X            \ Set SC(1 0) to the X-th entry from (SCTBH2 SCTBL), so
 STA SC                 \ it contains the address of the start of the bottom
 LDA SCTBH2,X           \ pixel row in character row X in screen memory (so
                        \ that's the bottom pixel row in the character row we
                        \ just moved up into)
                        \
                        \ We set the high byte below (though there's no reason
                        \ why it isn't done here)

 LDX T                  \ Restore the value of X that we stored, so X contains
                        \ the previous character row number, from before we
                        \ moved up a row (we need to do this as the following
                        \ jump returns us to a point where the previous row
                        \ number is still in X)

 STA SC+1               \ Set the high byte of SC(1 0) as above

 JMP VLO3               \ Jump back to keep drawing the line

\ ******************************************************************************
\
\       Name: CPIX
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a colour pixel
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The screen x-coordinate of the pixel
\
\   A                   The screen y-coordinate of the pixel
\
\   COL                 The pixel colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   The byte offset within the pixel row of the byte that
\                       contains the pixel
\
\   T2                  The number of the pixel row within the character block
\                       that contains the pixel
\
\   R                   The pixel byte for drawing the pixel
\
\ ******************************************************************************

.CPIX

 STA Y1                 \ Store the y-coordinate in Y1

 LSR A                  \ Set T1 = A >> 3
 LSR A                  \        = y div 8
 LSR A                  \
 STA T1                 \ So T1 now contains the number of the character row
                        \ that will contain the pixel we want to draw

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA Y1                 \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our pixel (as
                        \ each character block has 8 rows)

 STA T2                 \ Store the pixel row number in T2, so we can return it
                        \ from the subroutine

 ASL A                  \ Set the high byte of SC(1 0) as follows:
 ASL A                  \
 ADC SCTBH,Y            \   SC+1 = SCBTH for row Y + pixel row * 4 
 STA SC+1               \
                        \ Because this is the high byte, and because we already
                        \ set the low byte in SC to the Y-th entry from SCTBL,
                        \ this is the same as the following:
                        \
                        \   SC(1 0) = (SCBTH SCTBL) for row Y + pixel row * &400
                        \
                        \ So SC(1 0) contains the address in screen memory of
                        \ the pixel row containing the pixel we want to draw, as
                        \ (SCBTH SCTBL) gives us the address of the start of the
                        \ character row, and each pixel row within the character
                        \ row is offset by &400 bytes

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel we want to draw (as X contains the x-coordinate
                        \ of the pixel)

 LDA #0                 \ Set A = 0 to use as the pixel mask for the next pixel
                        \ byte along, so by default we don't change anything in
                        \ the next pixel byte

 CPY #6                 \ If Y = 6 then then the bit number for the pixel is bit
 BNE P%+4               \ 6 and we will need to spill into the next pixel byte,
 LDA #%10000001         \ so set A = %10000001 to use as the pixel mask for the
                        \ next pixel byte along

 STA T3                 \ Store the pixel mask for the next pixel byte in T3

 LDA TWOS2,Y            \ Fetch a two-bit pixel byte with the pixels set at
 STA R                  \ position Y and store it in R so we can use it as a
                        \ mask for the bits we want to change in the pixel byte

 LDA SCTBX2,X           \ Using the lookup table at SCTBX2, set A to the byte
                        \ number within the pixel row that contains the pixel we
                        \ want to draw (as X contains the x-coordinate of the
                        \ start of the line)

 AND #1                 \ Set Y to the colour in COL, plus 1 if the byte number
 ORA COL                \ within the pixel row is odd
 TAY                    \
                        \ We can use this to fetch the correct pixel bytes from
                        \ MASKT that we can poke into screen memory to draw a
                        \ continuous line of the relevant colour
                        \
                        \ Bytes #0 and #1 of the relevant entry in MASKT contain
                        \ the bit pattern for when the first byte is placed in
                        \ an even-numbered pixel byte (counting along the pixel
                        \ row), while bytes #1 and #2 contain the bit pattern
                        \ for when the first byte is placed in an odd-numbered
                        \ pixel byte
                        \
                        \ So Y now points to the correct MASKT entry for the
                        \ start of the line, because it points to byte #0 in
                        \ offset COL if the byte number within the pixel row is
                        \ even, or byte #1 in offset COL if the byte number
                        \ within the pixel row is odd

 LDA MASKT+1,Y          \ Set T3 to the correct pixel byte for drawing our pixel
 AND T3                 \ in the next pixel byte along, by combining the colour
 STA T3                 \ mask from MASKT+1 with the pixel mask in T3

 LDA MASKT,Y            \ Set A to the correct pixel byte for drawing our pixel
 AND R                  \ in the first pixel byte, by combining the colour mask
                        \ from MASKT with the pixel mask in A

 STA R                  \ Store the pixel byte for drawing our pixel in R, so it
                        \ can be returned by the subroutine

                        \ So A contains the pattern for the byte at the pixel
                        \ coordinates, and T3 contains the pattern for the next
                        \ byte along

 LDY SCTBX2,X           \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the pixel
                        \ at X

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 LDA T3                 \ Set A to the pattern for the next byte along

 BEQ CPR1               \ If T3 is zero then there is no need to write to the
                        \ next byte along, so jump to CPR1 to return from the
                        \ subroutine

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 DEY                    \ Decrement Y to move back to the previous pixel byte,
                        \ so we can return this value from the subroutine

.CPR1

 RTS                    \ Return from the subroutine

INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/original/main/subroutine/bulb.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/variable/spbt.asm"

\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ******************************************************************************

.MSBAR

 TYA                    \ ???
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

\ ******************************************************************************
\
\       Name: msloc
\       Type: Variable
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

.msloc

 EQUB &28
 EQUB &20
 EQUB &18
 EQUB &10

INCLUDE "library/6502sp/io/subroutine/newosrdch.asm"

\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Wait for the vertical sync (or pause for 15 * 256 loop iterations)
\
\ ------------------------------------------------------------------------------
\
\ In the version of Apple II Elite on the source disk on Ian Bell's site, this
\ routine waits for the vertical sync by checking the state of the VERTBLANK
\ soft switch.
\
\ In the released version of the game, this routine instead implements a
\ fixed-length pause of 15 * 256 iterations of an empty loop.
\
\ ******************************************************************************

.WSCAN

IF _IB_DISK

 PHA                    \ Store the A, X and Y registers on the stack
 TXA
 PHA
 TYA
 PHA

 LDY #15                \ Set an outer loop counter in Y, so we do a total of 15
                        \ outer loops to give a delay of 15 * 256 iterations

 LDX #0                 \ Set an inner loop counter in X to do 256 iterations of
                        \ each inner loop

.WSCL1

 DEX                    \ Decrement the inner loop counter

 BNE WSCL1              \ Loop back until we have done 256 iterations around the
                        \ inner loop

 DEY                    \ Decrement the outer loop counter

 BNE WSCL1              \ Loop back until we have done Y iterations around the
                        \ outer loop, to give Y * 256 iterations in all

 PLA                    \ Retrieve the A, X and Y registers from the stack
 TAY
 PLA
 TAX
 PLA

ELIF _SOURCE_DISK

 BIT &C019              \ Wait until bit 7 of the VERTBLANK soft switch is set,
 BPL WSCAN              \ which occurs when the vertical retrace is on

.WSCL1

 BIT &C019              \ Wait until bit 7 of the VERTBLANK soft switch is
 BMI WSCL1              \ clear, which occurs when the vertical retrace is off

ENDIF

 RTS                    \ Return from the subroutine

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

 BIT text               \ ???
 BPL clss1
 JSR cleartext
 LDA K3
 JMP RRafter

.clss1

 JSR cleargrap
 LDA K3
 JMP RRafter

\ ******************************************************************************
\
\       Name: RR5
\       Type: Subroutine
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.RR5

IF _IB_DISK

 BIT UPTOG              \ If bit 7 of UPTOG is set, jump to RR7 to skip the
 BMI RR7                \ following, so we print both upper and lower case
                        \ letters

ELIF _SOURCE_DISK

 BIT UPTOG              \ If bit 7 of UPTOG is clear, jump to RR7 to skip the
 BPL RR7                \ following, so we print both upper and lower case
                        \ letters (so in the source disk variants, the default
                        \ setting is to display upper case letters only)

ENDIF

 CMP #'['               \ If the character in A is less than ASCII '[' then it
 BCC RR7                \ is already an upper case letter, so jump to RR7 to
                        \ skip the following

 SBC #&20               \ This is a lower case letter, so subtract &20 to
                        \ convert it to the upper case letter equivalent

.RR7

 ORA #128               \ Set bit 7 of the character number so that we print it
                        \ in normal video (i.e. white characters on a black
                        \ background)

 PHA                    \ Store the character to print on the stack so we can
                        \ retrieve it below

 LDA cellocl,Y          \ ???
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

INCLUDE "library/advanced/main/subroutine/tt67-tt67k.asm"

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
\   RREN                Prints the character definition pointed to by P(2 1) at
\                       the screen address pointed to by (A SC). Used by the
\                       BULB routine
\
\   RR4                 Restore the registers and return from the subroutine
\
\   RR6                 ???
\
\ ******************************************************************************

.CHPR

 STA K3                 \ ???
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

\ ******************************************************************************
\
\       Name: letter
\       Type: Subroutine
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.letter

 \plot character A at X,YC*8

 LDY #HI(FONT)-1        \ ???
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

 LDY YC                 \ Set the low byte of SC(1 0) to the YC-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row YC in screen memory

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

\ ******************************************************************************
\
\       Name: TTX66K
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the whole screen or just the space view (as appropriate),
\             and draw a border box if required
\
\ ------------------------------------------------------------------------------
\
\ If this is a high-resolution graphics view, clear the top part of the screen
\ and draw a border box.
\
\ If this is a text view, clear the screen.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BOX                 Just draw the border box along the top of the screen
\                       (the sides are retained from the loading screen, along
\                       with the dashboard)
\
\ ******************************************************************************

.TTX66K

 LDA QQ11               \ If this is the space view, jump to wantgrap to set up
 BEQ wantgrap           \ the high-resolution graphics screen

 CMP #13                \ If QQ11 = 13 then this is either the title screen or
 BEQ wantgrap           \ the rotating ship screen in the mission 1 briefing, so
                        \ jump to wantgrap to set up the high-resolution
                        \ graphics screen

 AND #%11000000         \ If either bit 6 or 7 of the view type is set - so
 BNE wantgrap           \ this is either the Short-range or Long-range Chart -
                        \ then jump to wantgrap to set up the high-resolution
                        \ graphics screen

 JSR cleartext          \ This is a text view, so clear screen memory for the
                        \ text screen mode

 JMP TEXT               \ Switch to the text screen mode, returning from the
                        \ subroutine using a tail call

.cleartext

 LDY #0                 \ Set Y = 0 to use as a byte counter when clearing
                        \ screen memory for the text mode

 LDX #4                 \ Set X = 4 to use as a page counter when clearing the
                        \ four pages of screen memory from &0400 to &0800

 STY SC                 \ Set SC(1 0) = &0400, which is the address of screen
 STX SC+1               \ memory for bank 1 of the text screen mode

 LDA #160               \ Set A to 160, which is the ASCII for a space character
                        \ with bit 7 set, which is a space character in normal
                        \ video
                        \
                        \ We set bit 7 so it will show as a black block on
                        \ screen when we fill the text mode's screen memory with
                        \ this value, as opposed to a white block if it were in
                        \ inverse video

.cleartextl

 STA (SC),Y             \ Blank the Y-th byte of screen memory at SC(1 0)

 INY                    \ Increment the byte counter

 BNE cleartextl         \ Loop back until we have cleared a whole page of text
                        \ mode screen memory

 INC SC+1               \ Increment the high byte of SC(1 0) so it points to
                        \ the next page in screen memory

 DEX                    \ Decrement the page counter

 BNE cleartextl         \ Loop back until we have cleared four pages of memory

 RTS                    \ Return from the subroutine

.wantgrap

 JSR cleargrap          \ This is a high-resolution graphics view, so clear
                        \ screen memory for the top part of the graphics screen
                        \ mode (the space view)

 JSR BOX                \ Call BOX to draw a border box along the top edge of
                        \ the space view (the sides are retained from the
                        \ loading screen, along with the dashboard)

 JSR HGR                \ Switch to the high-resolution graphics screen mode

 RTS                    \ Return from the subroutine

.BOX

 LDX #0                 \ Set X1 = 0
 STX X1

 STX Y1                 \ Set Y1 = 0

 DEX                    \ Set X2 = 255
 STX X2

 LDA #BLUE              \ Switch to colour blue
 STA COL

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1) in
                        \ blue, which will draw a line along the top edge of the
                        \ screen from (0, 0) to (255, 0)

 LDA #%10101010         \ Draw the top-left corner of the box as a continuous
 STA SCBASE+1           \ line of blue

 LDA #%10101010         \ Draw the top-right corner of the box as a continuous
 STA SCBASE+37          \ line of blue

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: cleargrap
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear screen memory for the top part of the graphics screen mode
\             (the space view), drawing blue borders along the sides as we do so
\
\ ******************************************************************************

.cleargrap

 LDY #16                \ Set a counter in Y to clear the 17 character rows of
                        \ the space view

.cleargl

 JSR clearrow           \ Clear character row Y in screen memory, drawing blue
                        \ borders along the left and right edges as we do so

 DEY                    \ Decrement the row counter

 BPL cleargl            \ Loop back until we have cleared all 17 character rows

 INY                    \ Y is decremented to 255 by the loop, so this sets Y to
                        \ zero

 STY XC                 \ Move the text cursor to column 0 on row 0
 STY YC

 RTS                    \ Return from the subroutine

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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text column
\
\ ******************************************************************************

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETXC                 \ These instructions are commented out in the original
\                       \ source
\STA XC
\JMP PUTBACK

 RTS                    \ Return from the subroutine

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES

.SETXC

 STA XC                 \ Store the new text column in XC

ENDIF

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

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETYC                 \ These instructions are commented out in the original
\                       \ source
\STA YC

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES

.SETYC

 STA YC                 \ Store the new text row in YC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

ENDIF

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

 LDA #0                 \ ???
 STA DLY
 STA de

.CLYNS2

 JSR CLYS1
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

.CLY1

 LDY #15
 STY YC
 LDA #1
 STA XC

 JSR clearrow           \ Clear character row Y in screen memory, drawing blue
                        \ borders along the left and right edges as we do so

 INY

\ ******************************************************************************
\
\       Name: clearrow
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear a character row of screen memory, drawing blue borders along
\             the left and right edges as we do so
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The character row number
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.clearrow

 LDA #8                 \ Set T2 = 8 to act as a pixel row counter
 STA T2

 LDX SCTBL,Y            \ Set the low byte of SC(1 0) to the Y-th entry from
 STX SC                 \ SCTBL, which contains the low byte of the address of
                        \ the start of character row Y in screen memory

 LDX SCTBH,Y            \ Set X to the Y-th entry from SCTBH, which contains
                        \ the high byte of the address of the start of character
                        \ row Y in screen memory

 TYA                    \ Store the number of the character row we are clearing
 PHA                    \ on the stack, so we can retrieve it below

.cleargl2

 STX SC+1               \ Set the high byte of SC(1 0) to X, so it contains the
                        \ address of the start of the pixel row we want to clear

 LDA #%10100000         \ Set A to the pixel byte for the right end of the pixel
                        \ row, containing a blue border in the second-to-last
                        \ pixel (bit 7 is set to choose colour palette 1)

 LDY #37                \ We now clear the pixel row, starting from the right
                        \ end of the line, so set a pixel byte counter in Y to
                        \ count down from byte #37 to byte #1

.cleargl3

 STA (SC),Y             \ Set the Y-th pixel byte of the row to the pixel byte
                        \ in A

 LDA #0                 \ Set A = 0 so the last byte contains the border, but
                        \ the rest of them are blank

 DEY                    \ Decrement the byte counter

 BNE cleargl3           \ Loop back until we have drawn bytes #37 to #1, leaving
                        \ Y = 0

 LDA #%11000000         \ Set A to the pixel byte for the left end of the pixel
                        \ row, containing a blue border in the seventh pixel
                        \ (bit 7 is set to choose colour palette 1)

 STA (SC),Y             \ Draw the pixel byte for the left end of the pixel row
                        \ in the first byte of the row at SC(1 0)

 INY                    \ Increment Y to point to the second pixel byte in the
                        \ row

 ASL A                  \ Set A = %10000000, which is a pixel byte in colour
                        \ palette 1 with no pixels set

 STA (SC),Y             \ Draw this as the second pixel byte in the row to set
                        \ the colour palette for the second pixel to palette 1,
                        \ so the left edge is drawn correctly in blue

 INX                    \ Set X = X + 4, so the high byte of SC(1 0) gets
 INX                    \ increased by 4 when we loop back, which means we do
 INX                    \ the following:
 INX                    \
                        \   SC(1 0) = SC(1 0) + &400
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ below the one we just drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

 DEC T2                 \ Decrement the pixel row counter in T2

 BNE cleargl2           \ Loop back until we have cleared all eight pixel rows
                        \ in the character row

 PLA                    \ Restore the number of the character row into Y, so we
 TAY                    \ can return it unchanged

                        \ Fall through into SCAN to return from the subroutine,
                        \ as it starts with an RTS

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

\LDA QQ11               \ These instructions are commented out in the original
\BNE SCR1               \ source

 LDA INWK+31            \ ???
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

\ ******************************************************************************
\
\       Name: HGR
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Switch to the high-resolution graphics screen mode
\
\ ******************************************************************************

.HGR

 LDA &C054              \ Select page 1 display (i.e. main screen memory) by
                        \ reading the PAGE20FF soft switch

 LDA &C052              \ Configure graphics on the whole screen by reading the
                        \ MIXEDOFF soft switch

 LDA &C057              \ Select high-resolution graphics by reading the HIRESON
                        \ soft switch

 LDA &C050              \ Select the graphics mode by eading the TEXTOFF soft
                        \ switch

 LSR text               \ Clear bit 7 of text to indicate that we are now in the
                        \ high-resolution graphics screen mode

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TEXT
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Switch to the text screen mode
\
\ ******************************************************************************

.TEXT

 LDA &C054              \ Select page 1 display (i.e. main screen memory) by
                        \ reading the PAGE20FF soft switch

 LDA &C051              \ Select the text mode by eading the TEXTON soft switch

 SEC                    \ Set bit 7 of text to indicate that we are now in the
 ROR text               \ text screen mode

 RTS                    \ Return from the subroutine

INCLUDE "library/advanced/main/variable/f_per_cent.asm"

IF _IB_DISK

 EQUB &83, &6F          \ These bytes appear to be unused
 EQUB &63, &6F
 EQUB &75

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
