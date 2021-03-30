\ ******************************************************************************
\
\ BBC MASTER ELITE GAME SOURCE
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/BCODE.bin
\
\ ******************************************************************************

INCLUDE "versions/master/sources/elite-header.h.asm"

CPU 1                   \ Switch to 65SC12 assembly, as this code runs on a
                        \ BBC Master

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

LS% = &0800             \ The start of the descending ship line heap

BRKV = &202             \ The break vector that we intercept to enable us to
                        \ handle and display system errors

NOST = 20               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 33                \ The number of different ship types

MSL = 1                 \ Ship type for a missile
SST = 2                 \ Ship type for a Coriolis space station
ESC = 3                 \ Ship type for an escape pod
PLT = 4                 \ Ship type for an alloy plate
OIL = 5                 \ Ship type for a cargo canister
AST = 7                 \ Ship type for an asteroid
SPL = 8                 \ Ship type for a splinter
SHU = 9                 \ Ship type for a Shuttle
CYL = 11                \ Ship type for a Cobra Mk III
ANA = 14                \ Ship type for an Anaconda
HER = 15                \ Ship type for a rock hermit (asteroid)
COPS = 16               \ Ship type for a Viper
SH3 = 17                \ Ship type for a Sidewinder
KRA = 19                \ Ship type for a Krait
ADA = 20                \ Ship type for a Adder
WRM = 23                \ Ship type for a Worm
CYL2 = 24               \ Ship type for a Cobra Mk III (pirate)
ASP = 25                \ Ship type for an Asp Mk II
THG = 29                \ Ship type for a Thargoid
TGL = 30                \ Ship type for a Thargon
CON = 31                \ Ship type for a Constrictor
COU = 32                \ Ship type for a Cougar
DOD = 33                \ Ship type for a Dodecahedron ("Dodo") space station

JL = ESC                \ Junk is defined as starting from the escape pod

JH = SHU+2              \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ Shuttle or Transporter

PACK = SH3              \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

NI% = 37                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

WRCHV = &20E            \ The WRCHV vector that we intercept to implement our
                        \ own custom OSWRCH commands for communicating over the
                        \ Tube

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &80                \ Internal key number for red key f0 (Launch, Front)
f1 = &81                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &82                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &83                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &84                \ Internal key number for red key f4 (Long-range Chart)
f5 = &85                \ Internal key number for red key f5 (Short-range Chart)
f6 = &86                \ Internal key number for red key f6 (Data on System)
f7 = &87                \ Internal key number for red key f7 (Market Price)
f8 = &88                \ Internal key number for red key f8 (Status Mode)
f9 = &89                \ Internal key number for red key f9 (Inventory)

YELLOW  = %00001111     \ Four mode 1 pixels of colour 1 (yellow)
RED     = %11110000     \ Four mode 1 pixels of colour 2 (red, magenta or white)
CYAN    = %11111111     \ Four mode 1 pixels of colour 3 (cyan or white)
GREEN   = %10101111     \ Four mode 1 pixels of colour 3, 1, 3, 1 (cyan/yellow)
WHITE   = %11111010     \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)
MAGENTA = RED           \ Four mode 1 pixels of colour 2 (red, magenta or white)
DUST    = WHITE         \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)

RED2    = %00000011     \ Two mode 2 pixels of colour 1    (red)
GREEN2  = %00001100     \ Two mode 2 pixels of colour 2    (green)
YELLOW2 = %00001111     \ Two mode 2 pixels of colour 3    (yellow)
BLUE2   = %00110000     \ Two mode 2 pixels of colour 4    (blue)
MAG2    = %00110011     \ Two mode 2 pixels of colour 5    (magenta)
CYAN2   = %00111100     \ Two mode 2 pixels of colour 6    (cyan)
WHITE2  = %00111111     \ Two mode 2 pixels of colour 7    (white)
STRIPE  = %00100011     \ Two mode 2 pixels of colour 5, 1 (magenta/red)

NRU% = 0                \ The number of planetary systems with extended system
                        \ description overrides in the RUTOK table. The value of
                        \ this variable is 0 in the original source, but this
                        \ appears to be a bug, as it should really be 26

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

XX21 = &8000            \ The address of the ship blueprints lookup table, as
                        \ set in elite-data.asm

E% = &8042              \ The address of the default NEWB ship bytes, as set in
                        \ elite-data.asm

TALLYFRAC = &8063       \ The address of the kill tally fraction table, as set
                        \ in elite-data.asm

TALLYINT = &8084        \ The address of the kill tally integer table, as set in
                        \ elite-data.asm

QQ18 = &A000            \ The address of the text token table, as set in
                        \ elite-data.asm

SNE = &A3C0             \ The address of the sine lookup table, as set in
                        \ elite-data.asm

ACT = &A3E0             \ The address of the arctan lookup table, as set in
                        \ elite-data.asm

TKN1 = &A400            \ The address of the extended token table, as set in
                        \ elite-data.asm

RUPLA = &AF48           \ The address of the extended system description system
                        \ number table, as set in elite-data.asm

RUGAL = &AF62           \ The address of the extended system description galaxy
                        \ number table, as set in elite-data.asm

RUTOK = &AF7C           \ The address of the extended system description token
                        \ table, as set in elite-data.asm

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

CODE% = &1300
LOAD% = &1300

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "library/advanced/main/variable/tvt3.asm"
INCLUDE "library/common/main/variable/vec.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/master/main/subroutine/lowbeep.asm"
INCLUDE "library/common/main/subroutine/beep.asm"

\ ******************************************************************************
\
\       Name: L1358
\       Type: Variable
\   Category: Sound
\    Summary: ??? Sound data mask applied to top nibble of sound data in NS2
\
\ ******************************************************************************

.L1358

 EQUB %11000000
 EQUB %10100000
 EQUB %10000000

\ ******************************************************************************
\
\       Name: L135B
\       Type: Variable
\   Category: Sound
\    Summary: ??? Sound data passed to the sound chip, and a mask applied in NS7
\
\ ******************************************************************************

.L135B

 EQUB %11111111
 EQUB %10111111
 EQUB %10011111
 EQUB %11011111
 EQUB %11101111

INCLUDE "library/master/main/subroutine/sound.asm"

\ ******************************************************************************
\
\       Name: SRESET
\       Type: Subroutine
\   Category: Sound
\    Summary: Reset the sound buffers
\
\ ******************************************************************************

.SRESET

 LDY #3                 \ ???
 LDA #0

.L137B

 STA SBUF-1,Y
 DEY
 BNE L137B

 SEI

.L1382

 LDA L135B,Y
 JSR SOUND

 INY
 CPY #5
 BNE L1382

 CLI

 RTS

INCLUDE "library/master/main/subroutine/noisehit.asm"
INCLUDE "library/master/main/subroutine/noiselaser.asm"

\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound whose number is in Y
\
\ ------------------------------------------------------------------------------
\
\ The following sounds can be made by this routine. Two-part noises are made by
\ consecutive calls to this routine woth different values of Y.
\
\   0       Long, low beep
\   1       Short, high beep
\   3, 5    Lasers fired by us
\   4       We died / Collision / Our depleted shields being hit by lasers
\   6       We made a hit or kill / Energy bomb / Other ship exploding
\   7       E.C.M. on
\   8       Missile launched / Ship launched from station
\   9, 5    We're being hit by lasers
\   10, 11  Hyperspace drive engaged
\
\ Arguments:
\
\   Y                   The number of the sound to be made from the above table
\
\ ******************************************************************************

.NOISE

 LDA DNOIZ              \ ???
 BNE SRTS

 LDA SFX2,Y
 LSR A
 CLV
 LDX #0
 BCS NS1

 INX
 LDA SBUF+13
 CMP SBUF+14
 BCC NS1

 INX

.NS1

 LDA SFX1,Y
 CMP SBUF+12,X
 BCC SRTS

 SEI
 STA SBUF+12,X
 LSR A
 AND #&07
 STA SBUF+6,X
 LDA SFX4,Y
 STA SBUF+9,X
 LDA SFX2,Y
 STA SBUF+3,X
 AND #&0F
 LSR A
 STA SBUF+15,X
 LDA SFX3,Y
 BVC P%+3

 ASL A

 STA SBUF+18,X
 LDA #&80
 STA SBUF,X
 CLI

 SEC

 RTS

\ ******************************************************************************
\
\       Name: NOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.NOISE2

 LDY #2

.NSL1

 LDA SBUF,Y
 BEQ NS8

 BMI NS2

 LDA SBUF+15,Y
 BEQ NS3

 EQUB &2C

.NS2

 LDA #0
 CLC
 CLD
 ADC SBUF+18,Y
 STA SBUF+18,Y
 PHA
 ASL A
 ASL A
 AND #&0F
 ORA L1358,Y
 JSR SOUND

 PLA
 LSR A
 LSR A
 JSR SOUND

.NS3

 TYA
 TAX
 LDA SBUF,Y
 BMI NS5

 DEC SBUF+3,X
 BEQ NS4

 LDA SBUF+3,X
 AND SBUF+9,X
 BNE NS8

 DEC SBUF+6,X
 BNE NS6

.NS4

 LDA #0
 STA SBUF,Y
 STA SBUF+12,Y
 BEQ NS7

.NS5

 LSR SBUF,X

.NS6

 LDA SBUF+6,Y
 CLC
 ADC VOLUME

.NS7

 EOR L135B,Y
 JSR SOUND

.NS8

 DEY
 BPL NSL1

.NS9

 RTS

\ ******************************************************************************
\
\       Name: SBUF
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SBUF

 SKIP 21

\ ******************************************************************************
\
\       Name: SFX1
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFX1

 EQUB &4B, &5B, &3F
 EQUB &EB, &FF, &09
 EQUB &FF, &8B, &CF
 EQUB &E7, &FF, &EF

\ ******************************************************************************
\
\       Name: SFX2
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFX2

 EQUB &40, &10, &01
 EQUB &FC, &F3, &19
 EQUB &F9, &7C, &F1
 EQUB &FA, &FE, &FE

\ ******************************************************************************
\
\       Name: SFX3
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFX3

 EQUB &F0, &20, &10
 EQUB &30, &03, &01
 EQUB &08, &80, &16
 EQUB &38, &00, &80

\ ******************************************************************************
\
\       Name: SFX4
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.SFX4

 EQUB &FF, &FF, &00
 EQUB &03, &1F, &01
 EQUB &07, &07, &0F
 EQUB &03, &0F, &0F

INCLUDE "library/advanced/main/subroutine/startup.asm"
INCLUDE "library/advanced/main/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/master/main/variable/vscan.asm"
INCLUDE "library/master/main/variable/dlcnt.asm"
INCLUDE "library/advanced/main/subroutine/setvdu19-dovdu19.asm"
INCLUDE "library/master/main/subroutine/savezp.asm"
INCLUDE "library/master/main/subroutine/swapzp.asm"
INCLUDE "library/advanced/main/variable/ylookup.asm"
INCLUDE "library/common/main/subroutine/scan.asm"
INCLUDE "library/advanced/main/subroutine/ll30.asm"
INCLUDE "library/advanced/main/variable/twos.asm"
INCLUDE "library/advanced/main/variable/twos2.asm"
INCLUDE "library/advanced/main/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/advanced/main/variable/twfl.asm"
INCLUDE "library/advanced/main/variable/twfr.asm"
INCLUDE "library/advanced/main/variable/orange.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/advanced/main/variable/pxcl.asm"
INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
INCLUDE "library/master/main/variable/hcnt.asm"
INCLUDE "library/enhanced/main/subroutine/hanger.asm"
INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"
INCLUDE "library/common/main/subroutine/dvid4-dvid4_duplicate.asm"
INCLUDE "library/advanced/main/subroutine/cls.asm"
INCLUDE "library/advanced/main/subroutine/tt67-tt67_duplicate.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/advanced/main/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/advanced/main/subroutine/pzw2.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/master/main/subroutine/add_duplicate.asm"

IF _MATCH_EXTRACTED_BINARIES

 INCBIN "versions/master/extracted/sng47/workspaces/ELTA-align1.bin"

ELSE

 SKIP 845               \ These bytes appear to be unused

ENDIF

INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog.asm"

IF _MATCH_EXTRACTED_BINARIES

 INCBIN "versions/master/extracted/sng47/workspaces/ELTA-align2.bin"

ELSE

 SKIP 576               \ These bytes appear to be unused

ENDIF

INCLUDE "library/enhanced/main/workspace/up.asm"
INCLUDE "library/master/main/variable/ckeys.asm"
INCLUDE "library/master/main/subroutine/s_per_cent.asm"
INCLUDE "library/master/main/subroutine/scramble.asm"
INCLUDE "library/master/main/subroutine/decrypt.asm"

 EQUB &B7, &AA          \ These bytes appear to be unused
 EQUB &45, &23

INCLUDE "library/enhanced/main/subroutine/doentry.asm"

 EQUB &FB, &04, &F7     \ These bytes appear to be unused
 EQUB &08, &EF, &10
 EQUB &DF, &20, &BF
 EQUB &40, &7F, &80

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

\ ******************************************************************************
\
\       Name: BOMBLINES
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw the zigzag "electricity" lines for the energy bomb
\
\ ******************************************************************************

.BOMBLINES

 LDA #CYAN              \ Change the current colour to cyan
 STA COL

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE BOMBRTS            \ view), return from the subroutine (as L31DE contains
                        \ an RTS)

 LDY #1

 LDA L321D
 STA XX12

 LDA L3227
 STA XX12+1

.BOMBL1

 LDA XX12
 STA X1

 LDA XX12+1
 STA Y1

 LDA L321D,Y
 STA X2

 STA XX12

 LDA L3227,Y
 STA Y2

 STA XX12+1

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2)

 INY                    \ Increment the loop counter

 CPY #10                \ If Y < 10, loop back until we have drawn all the lines
 BCC BOMBL1

.BOMBRTS

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BOMBFX
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw the "electricity" lines and make the sound of the energy bomb
\             going off
\
\ ******************************************************************************

.BOMBFX

 JSR P%+3               \ This pair of JSRs runs the following code four times
 JSR P%+3

 LDY #6                 \ Call the NOISE routine with Y = 6 to make the sound of
 JSR NOISE              \ an energy bomb going off

 JSR BOMBLINES          \ Our energy bomb is going off, so call BOMBLINES to
                        \ draw the zigzag "electricity" lines

                        \ Fall through into BOMBSFX to make the sound of the
                        \ energy bomb going off

\ ******************************************************************************
\
\       Name: BOMBSFX
\       Type: Subroutine
\   Category: Flight
\    Summary: Make the sound of the energy bomb going off, randomise the energy
\             bomb "electricity" lines and draw them again
\
\ ******************************************************************************

.BOMBSFX

 LDY #0

.BOMBSL1

 JSR DORND

 AND #&7F
 ADC #&03
 STA L3227,Y

 TXA
 AND #&1F
 CLC
 ADC L3213,Y
 STA L321D,Y

 INY
 CPY #&0A
 BCC BOMBSL1

 LDX #&00
 STX L321D+9

 DEX

 STX L321D

 BCS BOMBLINES          \ Our energy bomb is going off, so call BOMBLINES to
                        \ draw the zigzag "electricity" lines and return from
                        \ the subroutine using a tail call (this BCS is
                        \ effectively a JMP as we passed through the BCC above)

\ ******************************************************************************
\
\       Name: L3213
\       Type: Variable
\   Category: Flight
\    Summary: ???
\
\ ******************************************************************************

.L3213

 EQUB &E0, &E0
 EQUB &C0, &A0
 EQUB &80, &60
 EQUB &40, &20
 EQUB &00, &00

\ EQUB %11100000
\ EQUB %11100000
\ EQUB %11000000
\ EQUB %10100000
\ EQUB %10000000
\ EQUB %01100000
\ EQUB %01000000
\ EQUB %00100000
\ EQUB %00000000
\ EQUB %00000000

\ ******************************************************************************
\
\       Name: L321D
\       Type: Variable
\   Category: Flight
\    Summary: ???
\
\ ******************************************************************************

.L321D

 SKIP 10

\ ******************************************************************************
\
\       Name: L3227
\       Type: Variable
\   Category: Flight
\    Summary: ???
\
\ ******************************************************************************

.L3227

 SKIP 10

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
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/enhanced/main/variable/s1_per_cent.asm"
INCLUDE "library/master/main/variable/na_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"

 SKIP 12                \ These bytes appear to be unused, though the first byte
                        \ in this block is included in the commander file (it
                        \ has no effect)

INCLUDE "library/common/main/variable/na_per_cent-default_per_cent.asm"

 SKIP 16                \ These bytes appear to be unused, though the first byte
                        \ in this block is included in the commander file (it
                        \ has no effect)

INCLUDE "library/advanced/main/variable/shpcol.asm"
INCLUDE "library/advanced/main/variable/scacol.asm"

\ ******************************************************************************
\
\ Save output/ELTA.bin
\
\ ******************************************************************************

PRINT "ELITE A"
PRINT "Assembled at ", ~S1%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - S1%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_A%

PRINT "S.ELTA ", ~S1%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
\SAVE "versions/master/output/ELTA.bin", S1%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ ******************************************************************************

CODE_B% = P%
LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
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
INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/enhanced/main/subroutine/hme2.asm"

\ ******************************************************************************
\
\ Save output/ELTB.bin
\
\ ******************************************************************************

PRINT "ELITE B"
PRINT "Assembled at ", ~CODE_B%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_B%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_B%

PRINT "S.ELTB ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_B%
\SAVE "versions/master/output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
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
INCLUDE "library/enhanced/main/subroutine/brief.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/pas1.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"

\ ******************************************************************************
\
\ Save output/ELTC.bin
\
\ ******************************************************************************

PRINT "ELITE C"
PRINT "Assembled at ", ~CODE_C%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_C%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_C%

PRINT "S.ELTC ", ~CODE_C%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_C%
\SAVE "versions/master/output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
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
INCLUDE "library/master/main/subroutine/outx.asm"
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
\ Save output/ELTD.bin
\
\ ******************************************************************************

PRINT "ELITE D"
PRINT "Assembled at ", ~CODE_D%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_D%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_D%

PRINT "S.ELTD ", ~CODE_D%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_D%
\SAVE "versions/master/output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
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
INCLUDE "library/master/main/subroutine/swapzp2.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"

 EQUB 0, 2              \ These bytes appear to be unused

INCLUDE "library/master/main/variable/excol.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/master/main/subroutine/solarx.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
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

 EQUB 4                 \ These bytes appear to be unused
 SKIP 4

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
INCLUDE "library/master/main/subroutine/getyn.asm"
INCLUDE "library/common/main/subroutine/tt17.asm"

\ ******************************************************************************
\
\ Save output/ELTE.bin
\
\ ******************************************************************************

PRINT "ELITE E"
PRINT "Assembled at ", ~CODE_E%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_E%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_E%

PRINT "S.ELTE ", ~CODE_E%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_E%
\SAVE "versions/master/output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
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
INCLUDE "library/master/main/subroutine/hexprnt.asm"
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
INCLUDE "library/enhanced/main/variable/stack.asm"
INCLUDE "library/enhanced/main/subroutine/brbr.asm"
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
INCLUDE "library/master/main/subroutine/jameson.asm"
INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/common/main/subroutine/gtnme-gtnmew.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/common/main/variable/rline.asm"
INCLUDE "library/master/main/subroutine/mt30.asm"
INCLUDE "library/master/main/subroutine/mt31.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/enhanced/main/subroutine/cats.asm"
INCLUDE "library/enhanced/main/subroutine/delt.asm"
INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/master/main/variable/namelen1.asm"
INCLUDE "library/master/main/variable/namelen2.asm"
INCLUDE "library/enhanced/main/subroutine/gtdrv.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/enhanced/main/variable/ctli.asm"
INCLUDE "library/enhanced/main/variable/deli.asm"
INCLUDE "library/master/main/variable/svli.asm"
INCLUDE "library/master/main/variable/ldli.asm"
INCLUDE "library/master/main/subroutine/save.asm"
INCLUDE "library/master/main/subroutine/load.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
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
\ Save output/ELTF.bin
\
\ ******************************************************************************

PRINT "ELITE F"
PRINT "Assembled at ", ~CODE_F%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_F%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_F%

PRINT "S.ELTF ", ~CODE_F%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_F%
\SAVE "versions/master/output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
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
INCLUDE "library/master/main/subroutine/llx30.asm"

\ ******************************************************************************
\
\ Save output/ELTG.bin
\
\ ******************************************************************************

PRINT "ELITE G"
PRINT "Assembled at ", ~CODE_G%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_G%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_G%

PRINT "S.ELTG ", ~CODE_G%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_G%
\SAVE "versions/master/output/ELTG.bin", CODE_G%, P%, LOAD%

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
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66-ttx662.asm"
INCLUDE "library/advanced/main/variable/trantable.asm"

\ ******************************************************************************
\
\       Name: KYTB
\       Type: Variable
\   Category: Keyboard
\    Summary: ???
\
\ ******************************************************************************

.KYTB

 EQUB &22,&23,&35,&37,&41,&42,&45,&51  \ ETUPAXJSC TAB Space M<>? ESCAPE
 EQUB &52,&60,&62,&65,&66,&67,&68,&70  \ Contains key number EOR &FF
 EQUB &F0

\ ******************************************************************************
\
\       Name: DKS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a flight key and update the key logger
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\ ******************************************************************************

.DKS1

 JSR U%                 \ Call U% to clear the key logger, which also sets X to
                        \ 0 (so we can use X as an index for working our way
                        \ through the flight keys in RDK3 below)

 LDA #16                \ Start the scan with internal key number 16 (COPY)

 CLC                    \ Clear the C flag so we can do the additions below

.RDK1

 LDY #%00000011         \ Set Y to %00000011, so it's ready to send to SHEILA
                        \ once interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STY VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDY #%01111111         \ Set 6522 System VIA data direction register DDRA
 STY VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STA VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to A, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDY VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into Y; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDA #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STA VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

 TYA                    \ Transfer Y into A

 BMI RDK3               \ If the key was pressed then Y is negative, so jump to
                        \ RDK3

.RDK2

 ADC #1                 \ Increment A to point to the next key to scan for

 BPL RDK1               \ If A is positive, we still have keys to check, so loop
                        \ back to scan for the next one

                        \ If we get here then no keys are being pressed

 CLD                    \ Clear the D flag to return to binary mode (for cases
                        \ where this routine is called in BCD mode)

 LDA KY6                \ If KY6 ("S") is being pressed, then KY6 is &FF, and
 EOR #&FF               \ KY6 EOR &FF AND KY19 will be zero, so this stops "C"
 AND KY19               \ from being registered as being pressed if "S" is being
 STA KY19               \ pressed. This code isn't necessary on a BBC Master, as
                        \ it's from other versions of Elite where there were
                        \ issues with "ghost keys", which the Master didn't have

 LDA KL                 \ Fetch the last key pressed from KL

 TAX                    \ Copy the key value into X

 RTS                    \ Return from the subroutine

.RDK3

                        \ If we get here then the key in A is being pressed. We
                        \ now work our way through the KYTB table, looking for
                        \ a match against the flight keys, using X as an index
                        \ into the table (X was initialised to 0 by the call to
                        \ U% above, and it keeps track of our progress through
                        \ the table between calls to RDK3)

 EOR #%10000000         \ The key in A is being pressed and the number of the
                        \ key is in A with bit 7 set, so flip bit 7 back to 0

 STA KL                 \ Store the number of the key pressed in KL

.DKL5

 CMP KYTB,X             \ If A is less than the X-th byte in KYTB, jump back to
 BCC RDK2               \ RDK2 to continue scanning for more keys

 BEQ P%+5               \ If A is equal to the X-th byte in KYTB, skip the next
                        \ two instructions

 INX                    \ Increment X so next time we check KYTB from the next
                        \ key in the table

 BNE DKL5               \ Loop back to DKL5 to test against the next flight key
                        \ in KYTB (this BNE is effectively a JMP as X won't get
                        \ high enough to wrap around to zero)

 DEC KY17,X             \ We got a match in the KYTB table for our key, at
                        \ position X, so we decrement the corresponding key
                        \ logger byte for this key at KY17+X (KY17 is the first
                        \ key in the key logger)

 INX                    \ Increment X so next time we check KYTB from the next
                        \ key in the table

 CLC                    \ Clear the C flag so we can do more additions

 BCC RDK2               \ Jump back to RDK2 to continue scanning for more keys
                        \ (this BCC is effectively a JMP as we just cleared the C flag)

INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/common/main/subroutine/dks4.asm"
INCLUDE "library/common/main/subroutine/u_per_cent.asm"

\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\   A                   Contains the same as X
\
\   Y                   Y is preserved
\
\ Other entry points:
\
\   RDKEY-1             Only scan the keyboard for valid BCD key numbers
\
\ ******************************************************************************

 SED                    \ Set the D flag to enter decimal mode. Because
                        \ internal key numbers are all valid BCD (Binary Coded
                        \ Decimal) numbers, setting this flag ensures we only
                        \ loop through valid key numbers

.RDKEY

 TYA                    \ Store Y on the stack so we can retrieve it later
 PHA

 JSR DKS1               \ Call DKS1 to scan the keyboard, update the key logger
                        \ and return any non-logger key presses in X

 PLA                    \ Retrieve the value of Y we stored above
 TAY

 LDA TRANTABLE,X        \ Fetch the internal key number for the key pressed

 STA KL                 \ Store the key pressed in KL

 TAX                    \ Copy the key value into X

 RTS                    \ Return from the subroutine

INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/common/main/subroutine/exno.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk.asm"
INCLUDE "library/advanced/main/variable/f_per_cent.asm"

\ ******************************************************************************
\
\ Save output/ELTH.bin
\
\ ******************************************************************************

PRINT "ELITE H"
PRINT "Assembled at ", ~CODE_H%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_H%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_H%

PRINT "S.ELTH ", ~CODE_H%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
\SAVE "versions/master/output/ELTH.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ Save output/BCODE.unprot.bin
\
\ ******************************************************************************

PRINT "S.BCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/master/output/BCODE.unprot.bin", CODE%, P%, LOAD%
