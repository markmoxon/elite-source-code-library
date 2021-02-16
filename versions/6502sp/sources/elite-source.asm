\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE GAME SOURCE (PARASITE)
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary files:
\
\   * output/ELTA.bin
\   * output/ELTB.bin
\   * output/ELTC.bin
\   * output/ELTD.bin
\   * output/ELTE.bin
\   * output/ELTF.bin
\   * output/ELTG.bin
\   * output/ELTH.bin
\   * output/ELTI.bin
\   * output/ELTJ.bin
\   * output/SHIPS.bin
\   * output/WORDS.bin
\
\ ******************************************************************************

INCLUDE "versions/6502sp/sources/elite-header.h.asm"

CPU 1                   \ Switch to 65C02 assembly, as this code runs on the
                        \ 6502 Second Processor

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_SOURCE_DISC            = (_RELEASE = 1)
_SNG45                  = (_RELEASE = 2)
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

D% = &D000              \ The address where the ship blueprints get moved to
                        \ after loading, so they go from &D000 to &F200

LS% = D%-1              \ The start of the descending ship line heap

BRKV = &202             \ The break vector that we intercept to enable us to
                        \ handle and display system errors

NOST = 18               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 20               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 34                \ The number of different ship types

MSL = 1                 \ Ship type for a missile
SST = 2                 \ Ship type for a Coriolis space station
ESC = 3                 \ Ship type for an escape pod
PLT = 4                 \ Ship type for an alloy plate
OIL = 5                 \ Ship type for a cargo canister
AST = 7                 \ Ship type for an asteroid
SPL = 8                 \ Ship type for a splinter
SHU = 9                 \ Ship type for a shuttle
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
LGO = 32                \ Ship type for the Elite logo
COU = 33                \ Ship type for a Cougar
DOD = 34                \ Ship type for a Dodecahedron ("Dodo") space station

JL = ESC                \ Junk is defined as starting from the escape pod

JH = SHU+2              \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ shuttle, transporter

PACK = SH3              \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

NI% = 37                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSFILE = &FFDD          \ The address for the OSFILE routine
OSCLI = &FFF7           \ The address for the OSCLI routine

DOFE21 = 131            \ The OSWRCH number for the #DOFE21 command
DOhfx = 132             \ The OSWRCH number for the #DOhfx command
SETXC = 133             \ The OSWRCH number for the #SETXC command
SETYC = 134             \ The OSWRCH number for the #SETYC command
clyns = 135             \ The OSWRCH number for the #clyns command
RDPARAMS = 136          \ The OSWRCH number for the #RDPARAMS command
DODIALS = 138           \ The OSWRCH number for the #DODIALS command
VIAE = 139              \ The OSWRCH number for the #VIAE command
DOBULB = 140            \ The OSWRCH number for the #DOBULB command
DOCATF = 141            \ The OSWRCH number for the #DOCATF command
SETCOL = 142            \ The OSWRCH number for the #SETCOL command
SETVDU19 = 143          \ The OSWRCH number for the #SETVDU19 command
DOsvn = 144             \ The OSWRCH number for the #DOsvn command
printcode = 146         \ The OSWRCH number for the #printcode command
prilf = 147             \ The OSWRCH number for the #prilf command

DOmsbar = 242           \ The OSWORD number for the #DOmsbar command
wscn = 243              \ The OSWORD number for the #wscn command
onescan = 244           \ The OSWORD number for the #onescan command
DOdot = 245             \ The OSWORD number for the #DOdot command
DODKS4 = 246            \ The OSWORD number for the #DODKS4 command

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &20                \ Internal key number for red key f0 (Launch, Front)
f1 = &71                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &72                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &73                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &14                \ Internal key number for red key f4 (Long-range Chart)
f5 = &74                \ Internal key number for red key f5 (Short-range Chart)
f6 = &75                \ Internal key number for red key f6 (Data on System)
f7 = &16                \ Internal key number for red key f7 (Market Price)
f8 = &76                \ Internal key number for red key f8 (Status Mode)
f9 = &77                \ Internal key number for red key f9 (Inventory)

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

NRU% = 0                \ The number of planetary systems with special extended
                        \ descriptions in the RUTOK table. The value of this
                        \ variable is 0 in the original source, but this appears
                        \ to be a bug, as it should be 26

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

W2 = 16                 \ The horizontal character spacing in the scroll text
                        \ (i.e. the difference in x-coordinate between the
                        \ left edges of adjacent characters in words)

WY = 12                 \ The vertical spacing between points in the scroll text
                        \ grid for each character

W2Y = 2.5*WY            \ The vertical line spacing in the scroll text (i.e. the
                        \ difference in y-coordinate between the tops of the
                        \ characters in adjacent lines)

D = 80                  \ The distance from the camera (z-coordinate) of the
                        \ bottom of the visible part of the Star Wars scroll
                        \ text

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS.bin that gets loaded by elite-loader.asm.
\
\ The recursive token table is loaded at &81B0 and is moved down to &0400 as
\ part of elite-loader2.asm. The table binary also includes the sine and arctan
\ tables, so the three parts end up as follows:
\
\   * Recursive token table:    QQ18 = &0400 to &07C0
\   * Sine lookup table:        SNE  = &07C0 to &07DF
\   * Arctan lookup table:      ACT  = &07E0 to &07FF
\
\ ******************************************************************************

CODE_WORDS% = &0400
LOAD_WORDS% = &81B0

ORG CODE_WORDS%

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/ctrl.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"

\ ******************************************************************************
\
\ Save output/WORDS.bin
\
\ ******************************************************************************

PRINT "WORDS"
PRINT "Assembled at ", ~CODE_WORDS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_WORDS%)
PRINT "Execute at ", ~LOAD_WORDS%
PRINT "Reload at ", ~LOAD_WORDS%

PRINT "S.WORDS ",~CODE_WORDS%," ",~P%," ",~LOAD_WORDS%," ",~LOAD_WORDS%
SAVE "versions/6502sp/output/WORDS.bin", CODE_WORDS%, P%, LOAD_WORDS%

INCLUDE "library/6502sp/main/workspace/up.asm"
INCLUDE "library/common/main/workspace/wp.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/6502sp/main/workspace/lp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ Produces the binary file ELTA.bin that gets loaded by elite-bcfs.asm.
\
\ The main game code (ELITE A through G, plus the ship data) is loaded at &1128
\ and is moved down to &0F40 as part of elite-loader.asm.
\
\ ******************************************************************************

CODE% = &1000
LOAD% = &1000

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "library/6502sp/main/workspace/parasite_variables.asm"
INCLUDE "library/6502sp/main/variable/s1_per_cent.asm"
INCLUDE "library/common/main/variable/na_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"
INCLUDE "library/6502sp/main/subroutine/s_per_cent.asm"
INCLUDE "library/6502sp/main/subroutine/deeor.asm"
INCLUDE "library/6502sp/main/subroutine/doentry.asm"
INCLUDE "library/6502sp/main/subroutine/brkbk.asm"
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
INCLUDE "library/6502sp/main/subroutine/spin.asm"
INCLUDE "library/6502sp/main/subroutine/mt27.asm"
INCLUDE "library/6502sp/main/subroutine/mt28.asm"
INCLUDE "library/6502sp/main/subroutine/detok3.asm"
INCLUDE "library/6502sp/main/subroutine/detok.asm"
INCLUDE "library/6502sp/main/subroutine/detok2.asm"
INCLUDE "library/6502sp/main/subroutine/mt1.asm"
INCLUDE "library/6502sp/main/subroutine/mt2.asm"
INCLUDE "library/6502sp/main/subroutine/mt8.asm"
INCLUDE "library/6502sp/main/subroutine/mt9.asm"
INCLUDE "library/6502sp/main/subroutine/mt13.asm"
INCLUDE "library/6502sp/main/subroutine/mt6.asm"
INCLUDE "library/6502sp/main/subroutine/mt5.asm"
INCLUDE "library/6502sp/main/subroutine/mt14.asm"
INCLUDE "library/6502sp/main/subroutine/mt15.asm"
INCLUDE "library/6502sp/main/subroutine/mt17.asm"
INCLUDE "library/6502sp/main/subroutine/mt18.asm"
INCLUDE "library/6502sp/main/subroutine/mt19.asm"
INCLUDE "library/6502sp/main/subroutine/vowel.asm"
INCLUDE "library/6502sp/main/subroutine/whitetext.asm"
INCLUDE "library/6502sp/main/variable/jmtb.asm"
INCLUDE "library/6502sp/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/6502sp/main/variable/shpcol.asm"
INCLUDE "library/6502sp/main/variable/scacol.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"

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
SAVE "versions/6502sp/output/ELTA.bin", S1%, P%, LOAD%

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
INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/6502sp/main/subroutine/ll30.asm"
INCLUDE "library/6502sp/main/subroutine/loin.asm"
INCLUDE "library/6502sp/main/subroutine/lbfl.asm"
INCLUDE "library/6502sp/main/variable/lbuf.asm"
INCLUDE "library/6502sp/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/6502sp/main/subroutine/hloin.asm"
INCLUDE "library/6502sp/main/subroutine/hbfl.asm"
INCLUDE "library/6502sp/main/subroutine/hbze.asm"
INCLUDE "library/6502sp/main/variable/hbuf.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/6502sp/main/subroutine/pixel.asm"
INCLUDE "library/6502sp/main/subroutine/pbfl.asm"
INCLUDE "library/6502sp/main/subroutine/pbze.asm"
INCLUDE "library/6502sp/main/subroutine/pixel3.asm"
INCLUDE "library/6502sp/main/variable/pbuf.asm"
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
INCLUDE "library/6502sp/main/variable/dtw1.asm"
INCLUDE "library/6502sp/main/variable/dtw2.asm"
INCLUDE "library/6502sp/main/variable/dtw3.asm"
INCLUDE "library/6502sp/main/variable/dtw4.asm"
INCLUDE "library/6502sp/main/variable/dtw5.asm"
INCLUDE "library/6502sp/main/variable/dtw6.asm"
INCLUDE "library/6502sp/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/subroutine/feed.asm"
INCLUDE "library/6502sp/main/subroutine/mt16.asm"
INCLUDE "library/6502sp/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/6502sp/main/subroutine/chpr.asm"
INCLUDE "library/6502sp/main/variable/printflag.asm"
INCLUDE "library/6502sp/main/subroutine/dials.asm"
INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/6502sp/main/subroutine/hme2.asm"

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
SAVE "versions/6502sp/output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ Produces the binary file ELTC.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/6502sp/main/variable/hatb.asm"
INCLUDE "library/6502sp/main/subroutine/hall.asm"
INCLUDE "library/6502sp/main/subroutine/has1.asm"
INCLUDE "library/6502sp/main/subroutine/unwise.asm"
INCLUDE "library/common/main/subroutine/tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_7_of_7.asm"
INCLUDE "library/6502sp/main/subroutine/dockit.asm"
INCLUDE "library/6502sp/main/subroutine/vcsu1.asm"
INCLUDE "library/6502sp/main/subroutine/vcsub.asm"
INCLUDE "library/common/main/subroutine/tas1.asm"
INCLUDE "library/6502sp/main/subroutine/tas4.asm"
INCLUDE "library/6502sp/main/subroutine/tas6.asm"
INCLUDE "library/6502sp/main/subroutine/dcs1.asm"
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
INCLUDE "library/6502sp/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
INCLUDE "library/6502sp/main/subroutine/pdesc.asm"
INCLUDE "library/6502sp/main/subroutine/brief2.asm"
INCLUDE "library/6502sp/main/subroutine/brp.asm"
INCLUDE "library/6502sp/main/subroutine/brief3.asm"
INCLUDE "library/6502sp/main/subroutine/debrief2.asm"
INCLUDE "library/6502sp/main/subroutine/debrief.asm"
INCLUDE "library/6502sp/main/subroutine/brief.asm"
INCLUDE "library/6502sp/main/subroutine/bris.asm"
INCLUDE "library/6502sp/main/subroutine/pause.asm"
INCLUDE "library/6502sp/main/subroutine/mt23.asm"
INCLUDE "library/6502sp/main/subroutine/mt29.asm"
INCLUDE "library/6502sp/main/subroutine/pas1.asm"
INCLUDE "library/6502sp/main/subroutine/pause2.asm"

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
SAVE "versions/6502sp/output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/subroutine/tnpr1.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/6502sp/main/subroutine/doxc.asm"
INCLUDE "library/6502sp/main/subroutine/doyc.asm"
INCLUDE "library/6502sp/main/subroutine/label.asm"
INCLUDE "library/6502sp/main/subroutine/incyc.asm"
INCLUDE "library/6502sp/main/subroutine/docol.asm"
INCLUDE "library/6502sp/main/subroutine/dovdu19.asm"
INCLUDE "library/6502sp/main/subroutine/trademode.asm"
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
INCLUDE "library/6502sp/main/subroutine/nwdav4.asm"
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
INCLUDE "library/6502sp/main/subroutine/ttx110.asm"
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
INCLUDE "library/6502sp/main/variable/rdli.asm"
INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
INCLUDE "library/common/main/subroutine/hm.asm"
INCLUDE "library/6502sp/main/subroutine/refund.asm"
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
SAVE "versions/6502sp/output/ELTD.bin", CODE_D%, P%, LOAD%

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
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/6502sp/main/subroutine/det1.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/sps4.asm"
INCLUDE "library/common/main/subroutine/sp1.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/6502sp/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/6502sp/main/subroutine/ecblb.asm"
INCLUDE "library/6502sp/main/subroutine/spblb.asm"
INCLUDE "library/6502sp/main/subroutine/msbar.asm"
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
INCLUDE "library/6502sp/main/subroutine/ls2fl.asm"
INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"
INCLUDE "library/common/main/subroutine/tt17.asm"
INCLUDE "library/common/main/subroutine/ping.asm"

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
SAVE "versions/6502sp/output/ELTE.bin", CODE_E%, P%, LOAD%

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
INCLUDE "library/common/main/variable/sfx.asm"
INCLUDE "library/6502sp/main/subroutine/there.asm"
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
INCLUDE "library/6502sp/main/variable/brkd.asm"
INCLUDE "library/6502sp/main/subroutine/brbr.asm"
INCLUDE "library/common/main/subroutine/death.asm"
INCLUDE "library/6502sp/main/variable/spasto.asm"
INCLUDE "library/6502sp/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/6502sp/main/subroutine/br1.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/6502sp/main/subroutine/dfault.asm"
INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/check.asm"
INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/6502sp/main/subroutine/gtnmew.asm"
INCLUDE "library/6502sp/main/subroutine/mt26.asm"
INCLUDE "library/6502sp/main/variable/rline.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/6502sp/main/subroutine/zebc.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/6502sp/main/variable/ctli.asm"
INCLUDE "library/6502sp/main/variable/deli.asm"
INCLUDE "library/6502sp/main/subroutine/cats.asm"
INCLUDE "library/6502sp/main/subroutine/delt.asm"
INCLUDE "library/6502sp/main/variable/stack.asm"
INCLUDE "library/6502sp/main/subroutine/mebrk.asm"
INCLUDE "library/6502sp/main/subroutine/cat.asm"
INCLUDE "library/6502sp/main/subroutine/retry.asm"
INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/common/main/subroutine/qus1.asm"
INCLUDE "library/6502sp/main/subroutine/gtdrv.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/common/main/subroutine/fx200.asm"
INCLUDE "library/6502sp/main/subroutine/backtonormal.asm"
INCLUDE "library/6502sp/main/subroutine/scli2.asm"
INCLUDE "library/6502sp/main/subroutine/dodosvn.asm"
INCLUDE "library/6502sp/main/subroutine/cldelay.asm"
INCLUDE "library/6502sp/main/subroutine/zektran.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/6502sp/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/variable/kytb.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/6502sp/main/subroutine/dks4.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dkj1.asm"
INCLUDE "library/common/main/subroutine/u_per_cent.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"
INCLUDE "library/6502sp/main/subroutine/savscr.asm"
INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/subroutine/ouch.asm"
INCLUDE "library/common/main/subroutine/ou2.asm"
INCLUDE "library/common/main/subroutine/ou3.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/6502sp/main/variable/oscobl.asm"
INCLUDE "library/6502sp/main/variable/scname.asm"
INCLUDE "library/6502sp/main/variable/oscobl2.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"
INCLUDE "library/6502sp/main/variable/ktran.asm"
INCLUDE "library/6502sp/main/variable/trantable.asm"

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
SAVE "versions/6502sp/output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_G% = P%
LOAD_G% = LOAD% + P% - CODE%

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ELTG-align.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ELTG-align.bin"
 ENDIF

ELSE
 ALIGN &100
ENDIF

INCLUDE "library/6502sp/main/variable/log.asm"
INCLUDE "library/6502sp/main/variable/logl.asm"
INCLUDE "library/6502sp/main/variable/antilog.asm"
INCLUDE "library/6502sp/main/variable/antilogodd.asm"
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
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"

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
SAVE "versions/6502sp/output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ Produces the binary file ELTH.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_H% = P%
LOAD_H% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/subroutine/catlod.asm"
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
INCLUDE "library/common/main/subroutine/plut.asm"
INCLUDE "library/common/main/subroutine/look1.asm"
INCLUDE "library/common/main/subroutine/sight.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/6502sp/main/subroutine/clyns.asm"
INCLUDE "library/6502sp/main/variable/scanpars.asm"
INCLUDE "library/common/main/subroutine/scan.asm"
INCLUDE "library/6502sp/main/subroutine/wscan.asm"

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
SAVE "versions/6502sp/output/ELTH.bin", CODE_H%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE I FILE
\
\ Produces the binary file ELTI.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_I% = P%
LOAD_I% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/variable/himcnt.asm"
INCLUDE "library/6502sp/main/subroutine/zinf2.asm"
INCLUDE "library/6502sp/main/subroutine/twist.asm"
INCLUDE "library/6502sp/main/subroutine/store.asm"
INCLUDE "library/6502sp/main/subroutine/demon.asm"
INCLUDE "library/6502sp/main/subroutine/slide.asm"
INCLUDE "library/6502sp/main/subroutine/zevb.asm"
INCLUDE "library/6502sp/main/subroutine/gridset.asm"
INCLUDE "library/6502sp/main/subroutine/grs1.asm"
INCLUDE "library/6502sp/main/subroutine/zzaap.asm"
INCLUDE "library/6502sp/main/variable/ltdef.asm"
INCLUDE "library/6502sp/main/variable/nofx.asm"
INCLUDE "library/6502sp/main/variable/nofy.asm"
INCLUDE "library/6502sp/main/variable/acorn.asm"
INCLUDE "library/6502sp/main/variable/byian.asm"
INCLUDE "library/6502sp/main/variable/true3.asm"

\ ******************************************************************************
\
\ Save output/ELTI.bin
\
\ ******************************************************************************

PRINT "ELITE I"
PRINT "Assembled at ", ~CODE_I%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_I%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_I%

PRINT "S.ELTI ", ~CODE_I%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
SAVE "versions/6502sp/output/ELTI.bin", CODE_I%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE J FILE
\
\ Produces the binary file ELTJ.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_J% = P%
LOAD_J% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/macro/ejmp.asm"
INCLUDE "library/6502sp/main/macro/echr.asm"
INCLUDE "library/6502sp/main/macro/etok.asm"
INCLUDE "library/6502sp/main/macro/etwo.asm"
INCLUDE "library/6502sp/main/macro/ernd.asm"
INCLUDE "library/6502sp/main/macro/tokn.asm"
INCLUDE "library/6502sp/main/variable/tkn1.asm"
INCLUDE "library/6502sp/main/variable/rupla.asm"
INCLUDE "library/6502sp/main/variable/rugal.asm"
INCLUDE "library/6502sp/main/variable/rutok.asm"
INCLUDE "library/6502sp/main/variable/mtin.asm"
INCLUDE "library/6502sp/main/subroutine/cold.asm"
INCLUDE "library/6502sp/main/variable/f_per_cent.asm"

\ ******************************************************************************
\
\ Save output/ELTJ.bin
\
\ ******************************************************************************

PRINT "ELITE J"
PRINT "Assembled at ", ~CODE_J%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_J%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_J%

PRINT "S.ELTJ ", ~CODE_J%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_J%
SAVE "versions/6502sp/output/ELTJ.bin", CODE_J%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_SHIPS% = &D000
LOAD_SHIPS% = &D000

ORG CODE_SHIPS%

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/6502sp/main/variable/e_per_cent.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/6502sp/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/6502sp/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/6502sp/main/variable/ship_splinter.asm"
INCLUDE "library/6502sp/main/variable/ship_shuttle.asm"
INCLUDE "library/6502sp/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/6502sp/main/variable/ship_boa.asm"
INCLUDE "library/6502sp/main/variable/ship_anaconda.asm"
INCLUDE "library/6502sp/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/6502sp/main/variable/ship_krait.asm"
INCLUDE "library/6502sp/main/variable/ship_adder.asm"
INCLUDE "library/6502sp/main/variable/ship_gecko.asm"
INCLUDE "library/6502sp/main/variable/ship_cobra_mk_i.asm"
INCLUDE "library/6502sp/main/variable/ship_worm.asm"
INCLUDE "library/6502sp/main/variable/ship_cobra_mk_iii_pirate.asm"
INCLUDE "library/6502sp/main/variable/ship_asp_mk_ii.asm"

 EQUB &38, &E5          \ This data appears to be unused
 EQUB &2C, &C5

INCLUDE "library/6502sp/main/variable/ship_python_pirate.asm"
INCLUDE "library/6502sp/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/6502sp/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/6502sp/main/variable/ship_constrictor.asm"
INCLUDE "library/6502sp/main/variable/ship_logo.asm"
INCLUDE "library/6502sp/main/variable/ship_cougar.asm"
INCLUDE "library/6502sp/main/variable/ship_dodo.asm"

 EQUB &A9, &80          \ This data appears to be unused
 EQUB &14, &2B
 EQUB &20, &FD
 EQUB &B8, &90
 EQUB &01, &60

\ ******************************************************************************
\
\ Save output/SHIPS.bin
\
\ ******************************************************************************

PRINT "SHIPS"
PRINT "Assembled at ", ~CODE_SHIPS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_SHIPS%)
PRINT "Execute at ", ~LOAD_SHIPS%
PRINT "Reload at ", ~LOAD_SHIPS%

PRINT "S.SHIPS ", ~CODE_SHIPS%, " ", ~P%, " ", ~LOAD_SHIPS%, " ", ~LOAD_SHIPS%
SAVE "versions/6502sp/output/SHIPS.bin", CODE_SHIPS%, P%, LOAD_SHIPS%

\ ******************************************************************************
\
\ Show free space
\
\ ******************************************************************************

PRINT "ELITE game code ", ~(K%-F%), " bytes free"
PRINT "F% = ", ~F%
PRINT "Ends at ", ~P%
