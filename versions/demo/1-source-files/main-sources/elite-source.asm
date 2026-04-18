\ ******************************************************************************
\
\ BBC MICRO ELITE DEMO MAIN GAME SOURCE
\
\ The BBC Micro Elite demo was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1984
\
\ The code in this file is identical to the source discs released on Ian Bell's
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
\ This source file contains the main game code for BBC Micro cassette Elite. It
\ also contains the ship blueprints and game text.
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
\   * PYTHON.bin
\   * SHIPS.bin
\   * WORDS9.bin
\
\ ******************************************************************************

 INCLUDE "versions/demo/1-source-files/main-sources/elite-build-options.asm"

 _DEMO_VERSION          = (_VERSION = 0)
 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _SOURCE_DISC           = (_VARIANT = 1)
 _TEXT_SOURCES          = (_VARIANT = 2)
 _STH_CASSETTE          = (_VARIANT = 3)
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

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &0F40          \ The address where the code will be run

 LOAD% = &1128          \ The address where the code will be loaded

 CODE_WORDS% = &0400    \ The address where the text data will be run

 LOAD_WORDS% = &1100    \ The address where the text data will be loaded

 Q% = _MAX_COMMANDER    \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander

 NOST = 18              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 12              \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 13               \ The number of different ship types

 COPS = 2               \ Ship type for a Viper

 THG = 6                \ Ship type for a Thargoid

 CYL = 7                \ Ship type for a Cobra Mk III (trader)

 SST = 8                \ Ship type for the space station

 MSL = 9                \ Ship type for a missile

 AST = 10               \ Ship type for an asteroid

 OIL = 11               \ Ship type for a cargo canister

 TGL = 12               \ Ship type for a Thargon

 ESC = 13               \ Ship type for an escape pod

 POW = 15               \ Pulse laser power

 NI% = 36               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 VSCAN = 57             \ Defines the split position in the split-screen mode

 X = 128                \ The centre x-coordinate of the 256 x 192 space view

 Y = 96                 \ The centre y-coordinate of the 256 x 192 space view

 f0 = &20               \ Internal key number for red key f0 (Launch, Front)

 f1 = &71               \ Internal key number for red key f1 (Buy Cargo, Rear)

 f2 = &72               \ Internal key number for red key f2 (Sell Cargo, Left)

 f3 = &73               \ Internal key number for red key f3 (Equip Ship, Right)

 f4 = &14               \ Internal key number for red key f4 (Long-range Chart)

 f5 = &74               \ Internal key number for red key f5 (Short-range Chart)

 f6 = &75               \ Internal key number for red key f6 (Data on System)

 f7 = &16               \ Internal key number for red key f7 (Market Price)

 f8 = &76               \ Internal key number for red key f8 (Status Mode)

 f9 = &77               \ Internal key number for red key f9 (Inventory)

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSBYTE = &FFF4         \ The address for the OSBYTE routine, which is used
                        \ three times in the main game code

 OSWORD = &FFF1         \ The address for the OSWORD routine, which is used
                        \ twice in the main game code

 OSFILE = &FFDD         \ The address for the OSFILE routine, which is used
                        \ once in the main game code

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/original/main/workspace/t_per_cent.asm"

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS9.bin that gets loaded by elite-loader.asm.
\
\ The recursive token table is loaded at &1100 and is moved down to &0400 as
\ part of elite-loader.asm, so it ends up at &0400 to &07FF.
\
\ ******************************************************************************

 ORG CODE_WORDS%        \ Set the assembly address to CODE_WORDS%

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"

\ ******************************************************************************
\
\ Save WORDS9.bin
\
\ ******************************************************************************

 PRINT "WORDS9"
 PRINT "Assembled at ", ~CODE_WORDS%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_WORDS%)
 PRINT "Execute at ", ~LOAD_WORDS%
 PRINT "Reload at ", ~LOAD_WORDS%

 PRINT "S.WORDS9 ", ~CODE_WORDS%, " ", ~P%, " ", ~LOAD_WORDS%, " ", ~LOAD_WORDS%
 SAVE "versions/demo/3-assembled-output/WORDS9.bin", CODE_WORDS%, P%, LOAD_WORDS%

INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

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

 ORG CODE%              \ Set the assembly address to CODE%

 LOAD_A% = LOAD%

INCLUDE "library/cassette/main/workspace/s_per_cent.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_3_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_4_of_16.asm"
\\INCLUDE "library/common/main/subroutine/main_flight_loop_part_5_of_16.asm"
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
INCLUDE "library/common/main/subroutine/mas1.asm"
INCLUDE "library/common/main/subroutine/mas2.asm"
INCLUDE "library/common/main/subroutine/mas3.asm"
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
INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/subroutine/mvt6.asm"
INCLUDE "library/common/main/subroutine/mv40.asm"

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
 SAVE "versions/demo/3-assembled-output/ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ Produces the binary file ELTB.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_B% = P%

 LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/na_per_cent-na2_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"
INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7-loinq_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7-loinq_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7-loinq_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7-loinq_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7-loinq_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7-loinq_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7-loinq_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/original/main/subroutine/px3.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
\\INCLUDE "library/common/main/subroutine/flip.asm"
\\INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
\\INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/variable/prxs.asm"
INCLUDE "library/common/main/subroutine/status.asm"
INCLUDE "library/common/main/subroutine/plf2.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/original/main/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"

\ ???

.L2049
 TAX
 LDA #$03
 STA $AA
 LDA #$02
 STA $AB
 LDA #$14
 STA $A5
 LDA $17E8,X
 STA $22
 LDA $17E9,X
 STA $23
 LDY #$08
.L2062
 LDA ($22),Y
 STA $00D2,Y
 DEY
 BPL L2062
 JSR $462D
 JSR $22C3
 LDA $33
 ASL A
 CMP #$C0
 BCC L208C
 LDA $0F14
 STA $48
 JSR $23CB
 JSR L208D
 BCS L208C
 LDA $32
 ASL A
 LDA #$02
 ROR A
 STA $71
.L208C
 RTS
.L208D
 LDX #$00
 STX $AB
 STX $71
 EOR $31
 EOR $32
 ASL A
 LDA #$02
 ROR A
 STA $70
 LDA $31
 ASL A
 CMP #$0C
 RTS
 JSR $461E
 JMP $22C3

\\INCLUDE "library/common/main/subroutine/escape.asm"

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
 SAVE "versions/demo/3-assembled-output/ELTB.bin", CODE_B%, P%, LOAD%

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

.L22C3
 LDY #$0A               \ ???
 JSR $274F
 CMP #$98
 BCC L22D0
 LDX #$00
 STX $AB
.L22D0
 JMP $2268
 LDA #$06
 STA $AB
 LSR A
 STA $AA
 LDA #$1D
 STA $A5
 LDA $0D55
 BNE L22E6
.L22E3
 JMP $20A3
.L22E6
 JSR L2371
 LDA $D4
 ORA $D7
 ORA $DA
 AND #$7F
 BNE L22E3
 JSR $4650
 LDA $90
 STA $3D
 JSR $462D
 LDY #$0A
 JSR $23A9
 BMI L2327
 CMP #$23
 BCC L2327
 LDY #$0A
 JSR $274F
 CMP #$A2
 BCS L2341
 LDA $3D
 CMP #$9D
 BCC L2319
 BCS L2341
.L2319
 JSR $23CB
 JSR L22C3
.L231F
 LDX #$00
 STX $6F
 INX
 STX $6E
 RTS
.L2327
 JSR L2371
 JSR $23DE
 JSR $23DE
 JSR $462D
 JSR $23CB
 JMP L22C3
.L2339
 INC $6F
 LDA #$7F
 STA $70
 BNE L2370
.L2341
 JSR $208D
 BCS L231F
 LDA $32
 ASL A
 LDA #$02
 ROR A
 STA $71
 LDA $32
 ASL A
 CMP #$0C
 BCS L231F
 STX $70
 LDA $69
 STA $31
 LDA $6B
 STA $32
 LDA $6D
 STA $33
 LDY #$10
 JSR $23A9
 ASL A
 CMP #$42
 BCS L2339
 JSR L231F
.L2370
 RTS
.L2371
 LDA #$24
 STA $22
 LDA #$09
 STA $23
 LDY #$02
 JSR $2385
 LDY #$05
 JSR $2385
 LDY #$08

INCLUDE "library/common/main/subroutine/tas1.asm"

 LDX $0924,Y            \ ???
 STX $90
 LDA $31
 JSR $2745
 LDX $0926,Y
 STX $90
 LDA $32
 JSR $276B
 STA $92
 STX $91
 LDX $0928,Y
 STX $90
 LDA $33
 JMP $276B
 LDA $31
 EOR #$80
 STA $31
 LDA $32
 EOR #$80
 STA $32
 LDA $33
 EOR #$80
 STA $33
 RTS
 JSR L23E1
.L23E1
 LDA $092E
 LDX #$00
 JSR L23F6
 LDA $0930
 LDX #$03
 JSR L23F6
 LDA $0932
 LDX #$06
.L23F6
 ASL A
 STA $91
 LDA #$00
 ROR A
 EOR #$80
 EOR $D4,X
 BMI L240D
 LDA $91
 ADC $D2,X
 STA $D2,X
 BCC L240C
 INC $D3,X
.L240C
 RTS
.L240D
 LDA $D2,X
 SEC
 SBC $91
 STA $D2,X
 LDA $D3,X
 SBC #$00
 STA $D3,X
 BCS L240C
 LDA $D2,X
 EOR #$FF
 ADC #$01
 STA $D2,X
 LDA $D3,X
 EOR #$FF
 ADC #$00
 STA $D3,X
 LDA $D4,X
 EOR #$80
 STA $D4,X
 JMP L240C

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
\\INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/original/main/subroutine/unused_duplicate_of_multu.asm"
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
INCLUDE "library/common/main/subroutine/dvid4-dvid4_duplicate.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/variable/act.asm"
\\INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
\\INCLUDE "library/common/main/subroutine/plut-pu1.asm"
INCLUDE "library/common/main/subroutine/look1.asm"
INCLUDE "library/common/main/subroutine/sight.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66-ttx66k.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/common/main/subroutine/hm.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/original/main/subroutine/lyn.asm"
INCLUDE "library/common/main/subroutine/scan.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"

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
 SAVE "versions/demo/3-assembled-output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_D% = P%

 LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/tnpr.asm"
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
\\INCLUDE "library/common/main/subroutine/mjp.asm"
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
 SAVE "versions/demo/3-assembled-output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ Produces the binary file ELTE.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_E% = P%

 LOAD_E% = LOAD% + P% - CODE%

INCLUDE "library/original/main/variable/authors_names.asm"
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
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/sps4.asm"
INCLUDE "library/common/main/subroutine/sp1.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2-cpixk.asm"
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/original/main/subroutine/bulb.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
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
INCLUDE "library/common/main/subroutine/tt17.asm"
INCLUDE "library/common/main/subroutine/ping.asm"

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
 SAVE "versions/demo/3-assembled-output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ Produces the binary file ELTF.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_F% = P%

 LOAD_F% = LOAD% + P% - CODE%

\ ******************************************************************************
\
\       Name: KS3
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the SLSP ship line heap pointer after shuffling ship slots
\
\ ------------------------------------------------------------------------------
\
\ The final part of the KILLSHP routine, called after we have shuffled the ship
\ slots and sorted out our missiles. This simply sets SLSP to the new bottom of
\ the ship line heap.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              Points to the ship line heap of the ship in the last
\                       occupied slot (i.e. it points to the bottom of the
\                       descending heap)
\
\ ******************************************************************************

.KS3

 LDA P                  \ After shuffling the ship slots, P(1 0) will point to
 STA SLSP               \ the new bottom of the ship line heap, so store this in
 LDA P+1                \ SLSP(1 0), which stores the bottom of the heap
 STA SLSP+1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: KS1
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove the current ship from our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ Part 12 of the main flight loop calls this routine to remove the ship that is
\ currently being analysed by the flight loop. Once the ship is removed, it
\ jumps back to MAL1 to rejoin the main flight loop, with X pointing to the
\ same slot that we just cleared (and which now contains the next ship in the
\ local bubble of universe).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX0                 The address of the blueprint for this ship
\
\   INF                 The address of the data block for this ship
\
\ ******************************************************************************

.KS1

 LDX XSAV               \ Fetch the current ship's slot number from XSAV

 JSR KILLSHP            \ Call KILLSHP to remove the ship in slot X from our
                        \ local bubble of universe

 LDX XSAV               \ Restore the current ship's slot number from XSAV,
                        \ which now points to the next ship in the bubble

 JMP MAL1               \ Jump to MAL1 to rejoin the main flight loop at the
                        \ start of the ship analysis loop

\ ******************************************************************************
\
\       Name: KS4
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove the space station and replace it with the sun
\
\ ******************************************************************************

.KS4

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR FLFLLS             \ Reset the LSO block, returns with A = 0

 STA FRIN+1             \ Set the second slot in the FRIN table to 0, which
                        \ sets this slot to empty, so when we call NWSHP below
                        \ the new sun that gets created will go into FRIN+1

 STA SSPR               \ Set the "space station present" flag to 0, as we are
                        \ no longer in the space station's safe zone

 JSR SPBLB              \ Call SPBLB to redraw the space station bulb, which
                        \ will erase it from the dashboard

 LDA #6                 \ Set the sun's y_sign to 6
 STA INWK+5

 LDA #129               \ Set A = 129, the ship type for the sun

 JMP NWSHP              \ Call NWSHP to set up the sun's data block and add it
                        \ to FRIN, where it will get put in the second slot as
                        \ we just cleared out the second slot, and the first
                        \ slot is already taken by the planet

\ ******************************************************************************
\
\       Name: KS2
\       Type: Subroutine
\   Category: Universe
\    Summary: Check the local bubble for missiles with target lock
\
\ ------------------------------------------------------------------------------
\
\ Check the local bubble of universe to see if there are any missiles with
\ target lock in the vicinity. If there are, then check their targets; if we
\ just removed their target in the KILLSHP routine, then switch off their AI so
\ they just drift in space, otherwise update their targets to reflect the newly
\ shuffled slot numbers.
\
\ This is called from KILLSHP once the slots have been shuffled down, following
\ the removal of a ship.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX4                 The slot number of the ship we removed just before
\                       calling this routine
\
\ ******************************************************************************

.KS2

 LDX #&FF               \ We want to go through the ships in our local bubble
                        \ and pick out all the missiles, so set X to &FF to
                        \ use as a counter

.KSL4

 INX                    \ Increment the counter (so it starts at 0 on the first
                        \ iteration)

 LDA FRIN,X             \ If slot X is empty then we have worked our way through
 BEQ KS3                \ all the slots, so jump to KS3 to stop looking

 CMP #MSL               \ If the slot does not contain a missile, loop back to
 BNE KSL4               \ KSL4 to check the next slot

                        \ We have found a slot containing a missile, so now we
                        \ want to check whether it has target lock

 TXA                    \ Set Y = X * 2 and fetch the Y-th address from UNIV
 ASL A                  \ and store it in SC and SC+1 - in other words, set
 TAY                    \ SC(1 0) to point to the missile's ship data block
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1

 LDY #32                \ Fetch byte #32 from the missile's ship data (AI)
 LDA (SC),Y

 BPL KSL4               \ If bit 7 of byte #32 is clear, then the missile is
                        \ dumb and has no AI, so loop back to KSL4 to move on
                        \ to the next slot

 AND #%01111111         \ Otherwise this missile has AI, so clear bit 7 and
 LSR A                  \ shift right to set the C flag to the missile's "is
                        \ locked" flag, and A to the target's slot number

 CMP XX4                \ If this missile's target is less than XX4, then the
 BCC KSL4               \ target's slot isn't being shuffled down, so jump to
                        \ KSL4 to move on to the next slot

 BEQ KS6                \ If this missile was locked onto the ship that we just
                        \ removed in KILLSHP, jump to KS6 to stop the missile
                        \ from continuing to hunt it down

 SBC #1                 \ Otherwise this missile is locked and has AI enabled,
                        \ and its target will have moved down a slot, so
                        \ subtract 1 from the target number (we know C is set
                        \ from the BCC above)

 ASL A                  \ Shift the target number left by 1, so it's in bits
                        \ 1-6 once again, and also set bit 0 to 1, as the C
                        \ flag is still set, so this makes sure the missile is
                        \ still set to being locked

 ORA #%10000000         \ Set bit 7, so the missile's AI is enabled

 STA (SC),Y             \ Update the missile's AI flag to the value in A

 BNE KSL4               \ Loop back to KSL4 to move on to the next slot (this
                        \ BNE is effectively a JMP as A will never be zero)

.KS6

 LDA #0                 \ The missile's target lock just got removed, so set the
 STA (SC),Y             \ AI flag to 0 to make it dumb and not locked

 BEQ KSL4               \ Loop back to KSL4 to move on to the next slot (this
                        \ BEQ is effectively a JMP as A is always zero)

\ ******************************************************************************
\
\       Name: KILLSHP
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove a ship from our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ Remove the ship in slot X from our local bubble of universe. This happens
\ when we kill a ship, collide with a ship and destroy it, or when a ship moves
\ outside our local bubble.
\
\ We also use this routine when we move out of range of the space station, in
\ which case we replace it with the sun.
\
\ When removing a ship, this creates a gap in the ship slots at FRIN, so we
\ shuffle all the later slots down to close the gap. We also shuffle the ship
\ data blocks at K% and ship line heap at WP, to reclaim all the memory that
\ the removed ship used to occupy.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The slot number of the ship to remove
\
\   XX0                 The address of the blueprint for the ship to remove
\
\   INF                 The address of the data block for the ship to remove
\
\ ******************************************************************************

.KILLSHP

 STX XX4                \ Store the slot number of the ship to remove in XX4

IF _SOURCE_DISC

 LDA MSTG               \ Check whether this slot matches the slot number in
 CMP XX4                \ MSTG, which is the target of our missile lock

ELIF _TEXT_SOURCES OR _STH_CASSETTE

 CPX MSTG               \ Check whether this slot matches the slot number in
                        \ MSTG, which is the target of our missile lock
                        \
                        \ This instructions saves two bytes of memory over the
                        \ LDA and CMP-based code in the source disc version, as
                        \ CPX MSTG is a two-byte opcode, while LDA MSTG and
                        \ CMP XX4 take up four bytes between them (the code does
                        \ the same thing)

ENDIF

 BNE KS5                \ If our missile is not locked on this ship, jump to KS5

 LDY #&EE               \ Otherwise we need to remove our missile lock, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green/cyan (Y = &EE)

 LDA #200               \ Print recursive token 40 ("TARGET LOST") as an
 JSR MESS               \ in-flight message

.KS5

\MOD
EQUB &AD, &5B, &0D, &C5, &A7, &D0, &09, &A0, &00, &8C, &5B, &0D, &88
EQUB &8C, &14, &0F

 LDY XX4                \ Restore the slot number of the ship to remove into Y

 LDX FRIN,Y             \ Fetch the contents of the slot, which contains the
                        \ ship type

 CPX #SST               \ If this is the space station, then jump to KS4 to
 BEQ KS4                \ replace the space station with the sun

 DEC MANY,X             \ Decrease the number of this type of ship in our little
                        \ bubble, which is stored in MANY+X (where X is the ship
                        \ type)

 LDX XX4                \ Restore the slot number of the ship to remove into X

                        \ We now want to remove this ship and reclaim all the
                        \ memory that it uses. Removing the ship will leave a
                        \ gap in three places, which we need to close up:
                        \
                        \   * The ship slots in FRIN
                        \
                        \   * The ship data blocks in K%
                        \
                        \   * The descending ship line heap at WP down
                        \
                        \ The rest of this routine closes up these gaps by
                        \ looping through all the occupied ship slots after the
                        \ slot we are removing, one by one, and shuffling each
                        \ ship's slot, data block and line heap down to close
                        \ up the gaps left by the removed ship. As part of this,
                        \ we have to make sure we update any address pointers
                        \ so they point to the newly shuffled data blocks and
                        \ line heaps
                        \
                        \ In the following, when shuffling a ship's data down
                        \ into the preceding empty slot, we call the ship that
                        \ we are shuffling down the "source", and we call the
                        \ empty slot we are shuffling it into the "destination"
                        \
                        \ Before we start looping through the ships we need to
                        \ shuffle down, we need to set up some variables to
                        \ point to the source and destination line heaps

 LDY #5                 \ Fetch byte #5 of the removed ship's blueprint into A,
 LDA (XX0),Y            \ which gives the ship's maximum heap size for the ship
                        \ we are removing (i.e. the size of the gap in the heap
                        \ created by the ship removal)

                        \ INF currently contains the ship data for the ship we
                        \ are removing, and INF(34 33) contains the address of
                        \ the bottom of the ship's heap, so we can calculate
                        \ the address of the top of the heap by adding the heap
                        \ size to this address

 LDY #33                \ First we add A and the address in INF+33, to get the
 CLC                    \ low byte of the top of the heap, which we store in P
 ADC (INF),Y
 STA P

 INY                    \ And next we add A and the address in INF+34, with any
 LDA (INF),Y            \ carry from the previous addition, to get the high byte
 ADC #0                 \ of the top of the heap, which we store in P+1, so
 STA P+1                \ P(1 0) points to the top of this ship's heap

                        \ Now, we're ready to start looping through the ships
                        \ we want to move, moving the slots, data blocks and
                        \ line heap from the source to the destination. In the
                        \ following, we set up SC to point to the source data,
                        \ and INF (which currently points to the removed ship's
                        \ data that we can now overwrite) points to the
                        \ destination
                        \
                        \ So P(1 0) now points to the top of the line heap for
                        \ the destination

.KSL1

 INX                    \ On entry, X points to the empty slot we want to
                        \ shuffle the next ship into (the destination), so
                        \ this increment points X to the next slot - i.e. the
                        \ source slot we want to shuffle down

 LDA FRIN,X             \ Copy the contents of the source slot into the
 STA FRIN-1,X           \ destination slot

\MOD
EQUB &D0, &03, &4C, &C3, &40
\BEQ KS2                \ If the slot we just shuffled down contains 0, then
                        \ the source slot is empty and we are done shuffling,
                        \ so jump to KS2 to move on to processing missiles

 ASL A                  \ Otherwise we have a source ship to shuffle down into
 TAY                    \ the destination, so set Y = A * 2 so it can act as an
                        \ index into the two-byte ship blueprint lookup table
                        \ at XX21 for the source ship

 LDA XX21-2,Y           \ Set SC(0 1) to point to the blueprint data for the
 STA SC                 \ source ship
 LDA XX21-1,Y
 STA SC+1

 LDY #5                 \ Fetch blueprint byte #5 for the source ship, which
 LDA (SC),Y             \ gives us its maximum heap size, and store it in T
 STA T

                        \ We now subtract T from P(1 0), so P(1 0) will point to
                        \ the bottom of the line heap for the destination
                        \ (which we will use later when closing up the gap in
                        \ the heap space)

 LDA P                  \ First, we subtract the low bytes
 SEC
 SBC T
 STA P

 LDA P+1                \ And then we do the high bytes, for which we subtract
 SBC #0                 \ 0 to include any carry, so this is effectively doing
 STA P+1                \ P(1 0) = P(1 0) - (0 T)

                        \ Next, we want to set SC(1 0) to point to the source
                        \ ship's data block

 TXA                    \ Set Y = X * 2 so it can act as an index into the
 ASL A                  \ two-byte lookup table at UNIV, which contains the
 TAY                    \ addresses of the ship data blocks. In this case we are
                        \ multiplying X by 2, and X contains the source ship's
                        \ slot number so Y is now an index for the source ship's
                        \ entry in UNIV

 LDA UNIV,Y             \ Set SC(1 0) to the address of the data block for the
 STA SC                 \ source ship
 LDA UNIV+1,Y
 STA SC+1

                        \ We have now set up our variables as follows:
                        \
                        \   SC(1 0) points to the source's ship data block
                        \
                        \   INF(1 0) points to the destination's ship data block
                        \
                        \   P(1 0) points to the destination's line heap
                        \
                        \ so let's start copying data from the source to the
                        \ destination

 LDY #35                \ We are going to be using Y as a counter for the 36
                        \ bytes of ship data we want to copy from the source
                        \ to the destination, so we set it to 35 to start things
                        \ off, and will decrement Y for each byte we copy

 LDA (SC),Y             \ Fetch byte #35 of the source's ship data block at SC,
 STA (INF),Y            \ and store it in byte #35 of the destination's block
                        \ at INF, so that's the ship's energy copied from the
                        \ source to the destination. One down, quite a few to
                        \ go...

 DEY                    \ Fetch byte #34 of the source ship, which is the
 LDA (SC),Y             \ high byte of the source ship's line heap, and store
 STA K+1                \ in K+1

 LDA P+1                \ Set the low byte of the destination's heap pointer
 STA (INF),Y            \ to P+1

 DEY                    \ Fetch byte #33 of the source ship, which is the
 LDA (SC),Y             \ low byte of the source ship's heap, and store in K
 STA K                  \ so now we have the following:
                        \
                        \   K(1 0) points to the source's line heap

 LDA P                  \ Set the low byte of the destination's heap pointer
 STA (INF),Y            \ to P, so now the destination's heap pointer is to
                        \ P(1 0), so that's the heap pointer in bytes #33 and
                        \ #34 done

 DEY                    \ Luckily, we can just copy the rest of the source's
                        \ ship data block into the destination, as there are no
                        \ more address pointers, so first we decrement our
                        \ counter in Y to point to the next byte (the AI flag)
                        \ in byte #32) and then start looping

.KSL2

 LDA (SC),Y             \ Copy the Y-th byte of the source to the Y-th byte of
 STA (INF),Y            \ the destination

 DEY                    \ Decrement the counter

 BPL KSL2               \ Loop back to KSL2 to copy the next byte until we have
                        \ copied the whole block

                        \ We have now shuffled the ship's slot and the ship's
                        \ data block, so we only have the heap data itself to do

 LDA SC                 \ First, we copy SC into INF, so when we loop round
 STA INF                \ again, INF will correctly point to the destination for
 LDA SC+1               \ the next iteration
 STA INF+1

 LDY T                  \ Now we want to move the contents of the heap, as all
                        \ we did above was to update the pointers, so first
                        \ we set a counter in Y that is initially set to T
                        \ (which we set above to the maximum heap size for the
                        \ source ship)
                        \
                        \ As a reminder, we have already set the following:
                        \
                        \   K(1 0) points to the source's line heap
                        \
                        \   P(1 0) points to the destination's line heap
                        \
                        \ so we can move the heap data by simply copying the
                        \ correct number of bytes from K(1 0) to P(1 0)
.KSL3

 DEY                    \ Decrement the counter

 LDA (K),Y              \ Copy the Y-th byte of the source heap at K(1 0) to
 STA (P),Y              \ the destination heap at P(1 0)

 TYA                    \ Loop back to KSL3 to copy the next byte, until we
 BNE KSL3               \ have done them all

 BEQ KSL1               \ We have now shuffled everything down one slot, so
                        \ jump back up to KSL1 to see if there is another slot
                        \ that needs shuffling down (this BEQ is effectively a
                        \ JMP as A will always be zero)

\ ******************************************************************************
\
\       Name: SFX
\       Type: Variable
\   Category: Sound
\    Summary: Sound data
\
\ ------------------------------------------------------------------------------
\
\ Sound data. To make a sound, the NOS1 routine copies the four relevant sound
\ bytes to XX16, and NO3 then makes the sound. The sound numbers are shown in
\ the table, and are always multiples of 8. Generally, sounds are made by
\ calling the NOISE routine with the sound number in A.
\
\ These bytes are passed to OSWORD 7, and are the equivalents to the parameters
\ passed to the SOUND keyword in BASIC. The parameters therefore have these
\ meanings:
\
\   channel/flush, amplitude (or envelope number if 1-4), pitch, duration
\
\ For the channel/flush parameter, the high nibble of the low byte is the flush
\ control (where a flush control of 0 queues the sound, and a flush control of
\ 1 makes the sound instantly), while the low nibble of the low byte is the
\ channel number. When written in hexadecimal, the first figure gives the flush
\ control, while the second is the channel (so &13 indicates flush control = 1
\ and channel = 3).
\
\ So when we call NOISE with A = 40 to make a long, low beep, then this is
\ effectively what the NOISE routine does:
\
\   SOUND &13, &F4, &0C, &08
\
\ which makes a sound with flush control 1 on channel 3, and with amplitude &F4
\ (-12), pitch &0C (2) and duration &08 (8). Meanwhile, to make the hyperspace
\ sound, the NOISE routine does this:
\
\   SOUND &10, &02, &60, &10
\
\ which makes a sound with flush control 1 on channel 0, using envelope 2,
\ and with pitch &60 (96) and duration &10 (16). The four sound envelopes (1-4)
\ are set up by the loading process.
\
\ ******************************************************************************

.SFX

 EQUB &12, &01, &00, &10    \ 0  - Lasers fired by us
 EQUB &12, &02, &2C, &08    \ 8  - We're being hit by lasers
 EQUB &11, &03, &F0, &18    \ 16 - We died 1 / We made a hit or kill 2
 EQUB &10, &F1, &07, &1A    \ 24 - We died 2 / We made a hit or kill 1
 EQUB &03, &F1, &BC, &01    \ 32 - Short, high beep
 EQUB &13, &F4, &0C, &08    \ 40 - Long, low beep
 EQUB &10, &F1, &06, &0C    \ 48 - Missile launched / Ship launched from station
 EQUB &10, &02, &60, &10    \ 56 - Hyperspace drive engaged
 EQUB &13, &04, &C2, &FF    \ 64 - E.C.M. on
 EQUB &13, &00, &00, &00    \ 72 - E.C.M. off

\ ******************************************************************************
\
\       Name: RESET
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most variables
\
\ ------------------------------------------------------------------------------
\
\ Reset our ship and various controls, recharge shields and energy, and then
\ fall through into RES2 to reset the stardust and the ship workspace at INWK.
\
\ In this subroutine, this means zero-filling the following locations:
\
\   * Pages &9, &A, &B, &C and &D
\
\   * BETA to BETA+6, which covers the following:
\
\     * BETA, BET1 - Set pitch to 0
\
\     * XC, YC - Set text cursor to (0, 0)
\
\     * QQ22 - Set hyperspace counters to 0
\
\     * ECMA - Turn E.C.M. off
\
\ It also sets QQ12 to &FF, to indicate we are docked, recharges the shields and
\ energy banks, and then falls through into RES2.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RES4                Reset the shields and energy banks, then fall through
\                       into RES2 to reset the stardust and the ship workspace
\                       at INWK
\
\ ******************************************************************************

.RESET

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

\MOD
EQUB &8D, &5D, &0D

 LDX #6                 \ Set up a counter for zeroing BETA through BETA+6

.SAL3

 STA BETA,X             \ Zero the X-th byte after BETA

 DEX                    \ Decrement the loop counter

 BPL SAL3               \ Loop back for the next byte to zero

 STX QQ12               \ X is now negative - i.e. &FF - so this sets QQ12 to
                        \ &FF to indicate we are docked

                        \ We now fall through into RES4 to restore shields and
                        \ energy, and reset the stardust and ship workspace at
                        \ INWK

.RES4

 LDA #&FF               \ Set A to &FF so we can fill up the shields and energy
                        \ bars with a full charge

 LDX #2                 \ We're now going to recharge both shields and the
                        \ energy bank, which live in the three bytes at FSH,
                        \ ASH (FSH+1) and ENERGY (FSH+2), so set a loop counter
                        \ in X for 3 bytes

.REL5

 STA FSH,X              \ Set the X-th byte of FSH to &FF to charge up that
                        \ shield/bank

 DEX                    \ Decrement the loop counter

 BPL REL5               \ Loop back to REL5 until we have recharged both shields
                        \ and the energy bank

                        \ Fall through into RES2 to reset the stardust and ship
                        \ workspace at INWK

\ ******************************************************************************
\
\       Name: RES2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset a number of flight variables and workspaces
\
\ ------------------------------------------------------------------------------
\
\ This is called after we launch from a space station, arrive in a new system
\ after hyperspace, launch an escape pod, or die a cold, lonely death in the
\ depths of space.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is set to &FF
\
\ ******************************************************************************

.RES2

 LDA #NOST              \ Reset NOSTM, the number of stardust particles, to the
 STA NOSTM              \ maximum allowed (18)

 LDX #&FF               \ Reset LSX2 and LSY2, the ball line heaps used by the
 STX LSX2               \ BLINE routine for drawing circles, to &FF, to set the
 STX LSY2               \ heap to empty

 STX MSTG               \ Reset MSTG, the missile target, to &FF (no target)

 LDA #128               \ Set the current pitch rate to the mid-point, 128
 STA JSTY

 STA ALP2               \ Reset ALP2 (roll sign) and BET2 (pitch sign)
 STA BET2               \ to negative, i.e. pitch and roll negative

 ASL A                  \ This sets A to 0

 STA ALP2+1             \ Reset ALP2+1 (flipped roll sign) and BET2+1 (flipped
 STA BET2+1             \ pitch sign) to positive, i.e. pitch and roll negative

 STA MCNT               \ Reset MCNT (the main loop counter) to 0

 LDA #3                 \ Reset DELTA (speed) to 3
 STA DELTA

 STA ALPHA              \ Reset ALPHA (roll angle alpha) to 3

 STA ALP1               \ Reset ALP1 (magnitude of roll angle alpha) to 3

 LDA SSPR               \ Fetch the "space station present" flag, and if we are
 BEQ P%+5               \ not inside the safe zone, skip the next instruction

 JSR SPBLB              \ Light up the space station bulb on the dashboard

 LDA ECMA               \ Fetch the E.C.M. status flag, and if E.C.M. is off,
 BEQ yu                 \ skip the next instruction

 JSR ECMOF              \ Turn off the E.C.M. sound

.yu

 JSR WPSHPS             \ Wipe all ships from the scanner

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

 LDA #LO(WP-1)          \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to the byte before the WP workspace to indicate
 LDA #HI(WP-1)          \ that the heap is empty
 STA SLSP+1

 JSR DIALS              \ Update the dashboard

                        \ Finally, fall through into ZINF to reset the INWK
                        \ ship workspace

\ ******************************************************************************
\
\       Name: ZINF
\       Type: Subroutine
\   Category: Universe
\    Summary: Reset the INWK workspace and orientation vectors
\  Deep dive: Orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ Zero-fill the INWK ship workspace and reset the orientation vectors, with
\ nosev pointing out of the screen, towards us.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is set to &FF
\
\ ******************************************************************************

.ZINF

 LDY #NI%-1             \ There are NI% bytes in the INWK workspace, so set a
                        \ counter in Y so we can loop through them

 LDA #0                 \ Set A to 0 so we can zero-fill the workspace

.ZI1

 STA INWK,Y             \ Zero the Y-th byte of the INWK workspace

 DEY                    \ Decrement the loop counter

 BPL ZI1                \ Loop back for the next byte, ending when we have
                        \ zero-filled the last byte at INWK, which leaves Y
                        \ with a value of &FF

                        \ Finally, we reset the orientation vectors as follows:
                        \
                        \   sidev = (1,  0,  0)
                        \   roofv = (0,  1,  0)
                        \   nosev = (0,  0, -1)
                        \
                        \ 96 * 256 (&6000) represents 1 in the orientation
                        \ vectors, while -96 * 256 (&E000) represents -1. We
                        \ already set the vectors to zero above, so we just
                        \ need to set up the high bytes of the diagonal values
                        \ and we're done. The negative nosev makes the ship
                        \ point towards us, as the z-axis points into the screen

 LDA #96                \ Set A to represent a 1 (in vector terms)

 STA INWK+18            \ Set byte #18 = roofv_y_hi = 96 = 1

 STA INWK+22            \ Set byte #22 = sidev_x_hi = 96 = 1

 ORA #%10000000         \ Flip the sign of A to represent a -1

 STA INWK+14            \ Set byte #14 = nosev_z_hi = -96 = -1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: msblob
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Display the dashboard's missile indicators in green
\
\ ------------------------------------------------------------------------------
\
\ Display the dashboard's missile indicators, with all the missiles reset to
\ green/cyan (i.e. not armed or locked).
\
\ ******************************************************************************

.msblob

 LDX #4                 \ Set up a loop counter in X to count through all four
                        \ missile indicators

.ss

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SAL8 to draw the remaining missiles, as
                        \ the rest of them are present and should be drawn in
                        \ green/cyan

 LDY #0                 \ Draw the missile indicator at position X in black
 JSR MSBAR

 DEX                    \ Decrement the counter to point to the next missile

 BNE ss                 \ Loop back to ss if we still have missiles to draw

 RTS                    \ Return from the subroutine

.SAL8

 LDY #&EE               \ Draw the missile indicator at position X in green/cyan
 JSR MSBAR

 DEX                    \ Decrement the counter to point to the next missile

 BNE SAL8               \ Loop back to SAL8 if we still have missiles to draw

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: me2
\       Type: Subroutine
\   Category: Flight
\    Summary: Remove an in-flight message from the space view
\
\ ******************************************************************************

.me2

 LDA MCH                \ Fetch the token number of the current message into A

 JSR MESS               \ Call MESS to print the token, which will remove it
                        \ from the screen as printing uses EOR logic

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

 JMP me3                \ Jump back into the main spawning loop at me3

\ ******************************************************************************
\
\       Name: Ze
\       Type: Subroutine
\   Category: Universe
\    Summary: Initialise the INWK workspace to a fairly aggressive ship
\  Deep dive: Fixing ship positions
\             Aggression and hostility in ship tactics
\
\ ------------------------------------------------------------------------------
\
\ Specifically, this routine does the following:
\
\   * Reset the INWK ship workspace
\
\   * Set the ship to a fair distance away in all axes, in front of us but
\     randomly up or down, left or right
\
\   * Give the ship a 4% chance of having E.C.M.
\
\   * Set the ship's aggression level to at least 32 out of 63, with AI enabled
\
\ This routine also sets A, X, T1 and the C flag to random values.
\
\ Note that because this routine uses the value of X returned by DORND, and X
\ contains the value of A returned by the previous call to DORND, this routine
\ does not necessarily set the new ship to a totally random location.
\
\ ******************************************************************************

.Ze

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR DORND              \ Set A and X to random numbers

 STA T1                 \ Store A in T1

 AND #%10000000         \ Extract the sign of A and store in x_sign
 STA INWK+2

 TXA                    \ Extract the sign of X and store in y_sign
 AND #%10000000
 STA INWK+5

 LDA #32                \ Set x_hi = y_hi = z_hi = 32, a fair distance away
 STA INWK+1
 STA INWK+4
 STA INWK+7

 TXA                    \ Set the C flag if X >= 245 (4% chance)
 CMP #245

 ROL A                  \ Set bit 0 of A to the C flag (i.e. there's a 4%
                        \ chance of this ship having E.C.M.)

 ORA #%11000000         \ Set bits 6 and 7 of A, so the ship has AI (bit 7) and
                        \ an aggression level of at least 32 out of 63

 STA INWK+32            \ Store A in the AI flag of this ship

                        \ Fall through into DORND2 to set A, X and the C flag
                        \ randomly

\ ******************************************************************************
\
\       Name: DORND
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Generate random numbers
\  Deep dive: Generating random numbers
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ Set A and X to random numbers (though note that X is set to the random number
\ that was returned in A the last time DORND was called).
\
\ The C and V flags are also set randomly.
\
\ If we want to generate a repeatable sequence of random numbers, when
\ generating explosion clouds, for example, then we call DORND2 to ensure that
\ the value of the C flag on entry doesn't affect the outcome, as otherwise we
\ might not get the same sequence of numbers if the C flag changes.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DORND2              Make sure the C flag doesn't affect the outcome
\
\ ******************************************************************************

.DORND2

 CLC                    \ Clear the C flag so the value of the C flag on entry
                        \ doesn't affect the outcome

.DORND

 LDA RAND               \ Calculate the next two values f2 and f3 in the feeder
 ROL A                  \ sequence:
 TAX                    \
 ADC RAND+2             \   * f2 = (f1 << 1) mod 256 + C flag on entry
 STA RAND               \   * f3 = f0 + f2 + (1 if bit 7 of f1 is set)
 STX RAND+2             \   * C flag is set according to the f3 calculation

 LDA RAND+1             \ Calculate the next value m2 in the main sequence:
 TAX                    \
 ADC RAND+3             \   * A = m2 = m0 + m1 + C flag from feeder calculation
 STA RAND+1             \   * X = m1
 STX RAND+3             \   * C and V flags set according to the m2 calculation

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: Main game loop (Part 1 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Spawn a trader (a peaceful Cobra Mk III)
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Aggression and hostility in ship tactics
\
\ ------------------------------------------------------------------------------
\
\ This is part of the main game loop. This is where the core loop of the game
\ lives, and it's in two parts. The shorter loop (just parts 5 and 6) is
\ iterated when we are docked, while the entire loop from part 1 to 6 iterates
\ if we are in space.
\
\ This section covers the following:
\
\   * Spawn a trader, i.e. a Cobra Mk III with AI disabled, a 50% chance of it
\     having an E.C.M., a speed between 16 and 31, a random aggression level
\     and a gentle clockwise roll
\
\ We call this from within the main loop, with A set to a random number.
\
\ ******************************************************************************

.MTT4

 LSR A                  \ Clear bit 7 of our random number in A and set the C
                        \ flag to bit 0 of A, which is random

 STA INWK+32            \ Store this in the ship's AI flag, so this ship does
                        \ not have AI

 STA INWK+29            \ Store A in the ship's roll counter, giving it a
                        \ clockwise roll (as bit 7 is clear), and a 1 in 127
                        \ chance of it having no damping

 ROL INWK+31            \ This instruction would appear to set bit 0 of the
                        \ ship's missile count randomly (as the C flag was set),
                        \ giving the ship either no missiles or one missile
                        \
                        \ However, INWK+31 is overwritten in the call to the
                        \ NWSHP routine below, where it is set to the number of
                        \ missiles from the ship blueprint, and the value of the
                        \ C flag is not used, so this instruction actually has
                        \ no effect
                        \
                        \ Interestingly, the original source code for the NWSPS
                        \ routine also has an instruction that sets INWK+31 and
                        \ which gets overwritten when it falls through into
                        \ NWSHP, but in this case the instruction is commented
                        \ out in the source. Perhaps the original version of
                        \ NWSHP didn't set the missile count and instead relied
                        \ on the calling code to set it, and when the authors
                        \ changed it, they commented out the INWK+31 instruction
                        \ in NWSPS and forgot about this one. Who knows?

 AND #31                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

 LDA #CYL               \ Add a new Cobra Mk III to the local bubble and fall
 JSR NWSHP              \ through into the main game loop again

\ ******************************************************************************
\
\       Name: Main game loop (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Call the main flight loop, and potentially spawn a trader, an
\             asteroid, or a cargo canister
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ This section covers the following:
\
\   * Call M% to do the main flight loop
\
\   * Potentially spawn a trader, asteroid or cargo canister
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TT100               The entry point for the start of the main game loop,
\                       which calls the main flight loop and the moves into the
\                       spawning routine
\
\   me3                 Used by me2 to jump back into the main game loop after
\                       printing an in-flight message
\
\ ******************************************************************************

.TT100

 JSR M%                 \ Call M% to iterate through the main flight loop

 DEC DLY                \ Decrement the delay counter in DLY, so any in-flight
                        \ messages get removed once the counter reaches zero

 BEQ me2                \ If DLY is now 0, jump to me2 to remove any in-flight
                        \ message from the space view, and once done, return to
                        \ me3 below, skipping the following two instructions

 BPL me3                \ If DLY is positive, jump to me3 to skip the next
                        \ instruction

 INC DLY                \ If we get here, DLY is negative, so we have gone too
                        \ and need to increment DLY back to 0

.me3

 DEC MCNT               \ Decrement the main loop counter in MCNT

 BEQ P%+5               \ If the counter has reached zero, which it will do
                        \ every 256 main loops, skip the next JMP instruction
                        \ (or to put it another way, if the counter hasn't
                        \ reached zero, jump down to MLOOP, skipping all the
                        \ following checks)

.ytq

 JMP MLOOP              \ Jump down to MLOOP to do some end-of-loop tidying and
                        \ restart the main loop

                        \ We only get here once every 256 iterations of the
                        \ main loop. If we aren't in witchspace and don't
                        \ already have 3 or more asteroids in our local bubble,
                        \ then this section has a 13% chance of spawning
                        \ something benign (the other 87% of the time we jump
                        \ down to consider spawning cops, pirates and bounty
                        \ hunters)
                        \
                        \ If we are in that 13%, then 50% of the time this will
                        \ be a trader, and the other 50% of the time it will
                        \ either be an asteroid (98.5% chance) or, very rarely,
                        \ a cargo canister (1.5% chance)

 LDA MJ                 \ If we are in witchspace following a mis-jump, skip the
 BNE ytq                \ following by jumping down to MLOOP (via ytq above)

 JSR DORND              \ Set A and X to random numbers

 CMP #35                \ If A >= 35 (87% chance), jump down to MTT1 to skip
 BCS MTT1               \ the spawning of an asteroid or cargo canister and
                        \ potentially spawn something else

 LDA MANY+AST           \ If we already have 3 or more asteroids in the local
 CMP #3                 \ bubble, jump down to MTT1 to skip the following and
 BCS MTT1               \ potentially spawn something else

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #38                \ Set z_hi = 38 (far away)
 STA INWK+7

 JSR DORND              \ Set A, X and C flag to random numbers

 STA INWK               \ Set x_lo = random

 STX INWK+3             \ Set y_lo = random
                        \
                        \ Note that because we use the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location

 AND #%10000000         \ Set x_sign = bit 7 of x_lo
 STA INWK+2

 TXA                    \ Set y_sign = bit 7 of y_lo
 AND #%10000000
 STA INWK+5

 ROL INWK+1             \ Set bit 1 of x_hi to the C flag, which is random, so
 ROL INWK+1             \ this randomly moves us off-centre by 512 (as if x_hi
                        \ is %00000010, then (x_hi x_lo) is 512 + x_lo)

 JSR DORND              \ Set A, X and V flag to random numbers

 BVS MTT4               \ If V flag is set (50% chance), jump up to MTT4 to
                        \ spawn a trader

 ORA #%01101111         \ Take the random number in A and set bits 0-3 and 5-6,
 STA INWK+29            \ so the result has a 50% chance of being positive or
                        \ negative, and a 50% chance of bits 0-6 being 127.
                        \ Storing this number in the roll counter therefore
                        \ gives our new ship a fast roll speed with a 50%
                        \ chance of having no damping, plus a 50% chance of
                        \ rolling clockwise or anti-clockwise

 LDA SSPR               \ If we are inside the space station safe zone, jump
 BNE MTT1               \ down to MTT1 to skip the following and potentially
                        \ spawn something else

 TXA                    \ Set A to the random X we set above, which we haven't
 BCS MTT2               \ used yet, and if the C flag is set (50% chance) jump
                        \ down to MTT2 to skip the following

 AND #31                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

 BCC MTT3               \ Jump down to MTT3, skipping the following (this BCC
                        \ is effectively a JMP as we know the C flag is clear,
                        \ having passed through the BCS above)

.MTT2

 ORA #%01111111         \ Set bits 0-6 of A to 127, leaving bit 7 as random, so
 STA INWK+30            \ storing this number in the pitch counter means we have
                        \ full pitch with no damping, with a 50% chance of
                        \ pitching up or down

.MTT3

 JSR DORND              \ Set A and X to random numbers

 CMP #5                 \ Set A to the ship number of an asteroid, and keep
 LDA #AST               \ this value for 98.5% of the time (i.e. if random
 BCS P%+4               \ A >= 5 then skip the following instruction)

 LDA #OIL               \ Set A to the ship number of a cargo canister

 JSR NWSHP              \ Add our new asteroid or canister to the universe

\ ******************************************************************************
\
\       Name: Main game loop (Part 3 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Potentially spawn a cop, particularly if we've been bad
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ This section covers the following:
\
\   * Potentially spawn a cop (in a Viper), very rarely if we have been good,
\     more often if have been naughty, and very often if we have been properly
\     bad
\
\ ******************************************************************************

.MTT1

 LDA SSPR               \ If we are inside the space station's safe zone, jump
 BNE MLOOP              \ to MLOOP to skip the following

 JSR BAD                \ Call BAD to work out how much illegal contraband we
                        \ are carrying in our hold (A is up to 40 for a
                        \ standard hold crammed with contraband, up to 70 for
                        \ an extended cargo hold full of narcotics and slaves)

 ASL A                  \ Double A to a maximum of 80 or 140

 LDX MANY+COPS          \ If there are no cops in the local bubble, skip the
 BEQ P%+5               \ next instruction

 ORA FIST               \ There are cops in the vicinity and we've got a hold
                        \ full of jail time, so OR the value in A with FIST to
                        \ get a new value that is at least as high as both
                        \ values, to reflect the fact that they have almost
                        \ certainly scanned our ship

 STA T                  \ Store our badness level in T

 JSR Ze                 \ Call Ze to initialise INWK to a fairly aggressive
                        \ ship, and set A and X to random values
                        \
                        \ Note that because Ze uses the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location

 CMP T                  \ If the random value in A >= our badness level, which
 BCS P%+7               \ will be the case unless we have been really, really
                        \ bad, then skip the following two instructions (so
                        \ if we are really bad, there's a higher chance of
                        \ spawning a cop, otherwise we got away with it, for
                        \ now)

 LDA #COPS              \ Add a new police ship to the local bubble
 JSR NWSHP

 LDA MANY+COPS          \ If we now have at least one cop in the local bubble,
 BNE MLOOP              \ jump down to MLOOP, otherwise fall through into the
                        \ next part to look at spawning something else

\ ******************************************************************************
\
\       Name: Main game loop (Part 4 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Potentially spawn a lone bounty hunter, a Thargoid, or up to four
\             pirates
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Fixing ship positions
\             Aggression and hostility in ship tactics
\
\ ------------------------------------------------------------------------------
\
\ This section covers the following:
\
\   * Potentially spawn (35% chance) either a lone bounty hunter (a Mamba,
\     Python or Cobra Mk III), a Thargoid, or a group of up to 4 pirates
\     (Sidewinders and/or Mambas)
\
\ ******************************************************************************

 DEC EV                 \ Decrement EV, the extra vessels spawning delay, and
 BPL MLOOP              \ jump to MLOOP if it is still positive, so we only
                        \ do the following when the EV counter runs down

 INC EV                 \ EV is negative, so bump it up again, setting it back
                        \ to 0

 JSR DORND              \ Set A and X to random numbers

 LDY gov                \ If the government of this system is 0 (anarchy), jump
 BEQ LABEL_2            \ straight to LABEL_2 to start spawning pirates or a
                        \ lone bounty hunter

 CMP #90                \ If the random number in A >= 90 (65% chance), jump to
 BCS MLOOP              \ MLOOP to stop spawning (so there's a 35% chance of
                        \ spawning pirates or a lone bounty hunter)

 AND #7                 \ Reduce the random number in A to the range 0-7, and
 CMP gov                \ if A is less than government of this system, jump
 BCC MLOOP              \ to MLOOP to stop spawning (so safer governments with
                        \ larger gov numbers have a greater chance of jumping
                        \ out, which is another way of saying that more
                        \ dangerous systems spawn pirates and bounty hunters
                        \ more often)

.LABEL_2

                        \ Now to spawn a lone bounty hunter, a Thargoid or a
                        \ group of pirates

 JSR Ze                 \ Call Ze to initialise INWK to a fairly aggressive
                        \ ship, and set A and X to random values
                        \
                        \ Note that because Ze uses the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location

 CMP #200               \ If the random number in A >= 200 (13% chance), jump
 BCS mt1                \ to mt1 to spawn pirates, otherwise keep going to
                        \ spawn a lone bounty hunter or a Thargoid

 INC EV                 \ Increase the extra vessels spawning counter, to
                        \ prevent the next attempt to spawn extra vessels

 AND #3                 \ Set A = Y = random number in the range 3-6, which
 ADC #3                 \ we will use to determine the type of ship
 TAY

                        \ We now build the AI flag for this ship in A

 TXA                    \ First, copy the random number in X to A

 CMP #200               \ First, set the C flag if X >= 200 (22% chance)

 ROL A                  \ Set bit 0 of A to the C flag (i.e. there's a 22%
                        \ chance of this ship having E.C.M.)

 ORA #%11000000         \ Set bits 6 and 7 of A, so the ship has AI (bit 7) and
                        \ an aggression level of at least 32 out of 63

 CPY #6                 \ If Y = 6 (i.e. a Thargoid), jump down to the tha
 BEQ tha                \ routine in part 6 to decide whether or not to spawn it
                        \ (where there's a 22% chance of this happening)

 STA INWK+32            \ Store A in the AI flag of this ship

 TYA                    \ Add a new ship of type Y to the local bubble, so
 JSR NWSHP              \ that's a Mamba, Cobra Mk III or Python

.mj1

 JMP MLOOP              \ Jump down to MLOOP, as we are done spawning ships

.mt1

 AND #3                 \ It's time to spawn a group of pirates, so set A to a
                        \ random number in the range 0-3, which will be the
                        \ loop counter for spawning pirates below (so we will
                        \ spawn 1-4 pirates)

 STA EV                 \ Delay further spawnings by this number

 STA XX13               \ Store the number in XX13, the pirate counter

.mt3

 JSR DORND              \ Set A and X to random numbers

 AND #3                 \ Set A to a random number in the range 0-3

 ORA #1                 \ Set A to %01 or %11 (Sidewinder or Mamba)

 JSR NWSHP              \ Try adding a new ship of type A to the local bubble

 DEC XX13               \ Decrement the pirate counter

 BPL mt3                \ If we need more pirates, loop back up to mt3,
                        \ otherwise we are done spawning, so fall through into
                        \ the end of the main loop at MLOOP

\ ******************************************************************************
\
\       Name: Main game loop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Cool down lasers, make calls to update the dashboard
\  Deep dive: Program flow of the main game loop
\             The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ This is the first half of the minimal game loop, which we iterate when we are
\ docked. This section covers the following:
\
\   * Cool down lasers
\
\   * Make calls to update the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MLOOP               The entry point for the main game loop. This entry point
\                       comes after the call to the main flight loop and
\                       spawning routines, so it marks the start of the main
\                       game loop for when we are docked (as we don't need to
\                       call the main flight loop or spawning routines if we
\                       aren't in space)
\
\ ******************************************************************************

.MLOOP

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDX GNTMP              \ If the laser temperature in GNTMP is non-zero,
 BEQ EE20               \ decrement it (i.e. cool it down a bit)
 DEC GNTMP

.EE20

 JSR DIALS              \ Call DIALS to update the dashboard

 LDA QQ11               \ If this is a space view, skip the following four
 BEQ P%+11              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+5               \ then skip the following instruction

 JSR DELAY-5            \ Wait for 8/50 of a second (0.16 seconds), to slow the
                        \ main loop down a bit

 JSR TT17               \ Scan the keyboard for the cursor keys or joystick,
                        \ returning the cursor's delta values in X and Y and
                        \ the key pressed in A

\ ******************************************************************************
\
\       Name: Main game loop (Part 6 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Process non-flight key presses (red function keys, docked keys)
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
\ This is the second half of the minimal game loop, which we iterate when we are
\ docked. This section covers the following:
\
\   * Process more key presses (red function keys, docked keys etc.)
\
\ It also supports joining the main loop with a key already "pressed", so we can
\ jump into the main game loop to perform a specific action. In practice, this
\ is used when we enter the docking bay in BAY to display Status Mode (red key
\ f8), and when we finish buying or selling cargo in BAY2 to jump to the
\ Inventory (red key f9).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   FRCE                The entry point for the main game loop if we want to
\                       jump straight to a specific screen, by pretending to
\                       "press" a key, in which case A contains the internal key
\                       number of the key we want to "press"
\
\   tha                 Consider spawning a Thargoid (22% chance)
\
\ ******************************************************************************

.FRCE

 JSR TT102              \ Call TT102 to process the key pressed in A

 LDA QQ12               \ Fetch the docked flag from QQ12 into A

 BNE MLOOP              \ If we are docked, loop back up to MLOOP just above
                        \ to restart the main loop, but skipping all the flight
                        \ and spawning code in the top part of the main loop

 JMP TT100              \ Otherwise jump to TT100 to restart the main loop from
                        \ the start

.tha

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), skip the next instruction
 BCC P%+5

 JSR GTHG               \ Call GTHG to spawn a Thargoid ship and a Thargon
                        \ companion

 JMP MLOOP              \ Jump back into the main loop at MLOOP, which is just
                        \ after the ship-spawning section

\ ******************************************************************************
\
\       Name: TT102
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process function key, save key, hyperspace and chart key presses
\             and update the hyperspace counter
\
\ ------------------------------------------------------------------------------
\
\ Process function key presses, plus "@" (save commander), "H" (hyperspace),
\ "D" (show distance to system) and "O" (move chart cursor back to current
\ system). We can also pass cursor position deltas in X and Y to indicate that
\ the cursor keys or joystick have been used (i.e. the values that are returned
\ by routine TT17).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The internal key number of the key pressed (see page 142
\                       of the "Advanced User Guide for the BBC Micro" by Bray,
\                       Dickens and Holmes for a list of internal key numbers)
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   T95                 Print the distance to the selected system
\
\ ******************************************************************************

.TT102

\MOD
 CMP #f8                \ If red key f8 was pressed, jump to STATUS to show the
\BNE P%+5               \ Status Mode screen, returning from the subroutine
 BNE P%+8               \ Status Mode screen, returning from the subroutine

\MOD
\JMP STATUS             \ using a tail call
 JSR STATUS
 EQUB &4C, &67, &2C

 CMP #f4                \ If red key f4 was pressed, jump to TT22 to show the
 BNE P%+5               \ Long-range Chart, returning from the subroutine using
 JMP TT22               \ a tail call

 CMP #f5                \ If red key f5 was pressed, jump to TT23 to show the
 BNE P%+5               \ Short-range Chart, returning from the subroutine using
 JMP TT23               \ a tail call

 CMP #f6                \ If red key f6 was pressed, call TT111 to select the
 BNE TT92               \ system nearest to galactic coordinates (QQ9, QQ10)
 JSR TT111              \ (the location of the chart crosshairs) and jump to
 JMP TT25               \ TT25 to show the Data on System screen, returning
                        \ from the subroutine using a tail call

.TT92

 CMP #f9                \ If red key f9 was pressed, jump to TT213 to show the
 BNE P%+5               \ Inventory screen, returning from the subroutine
 JMP TT213              \ using a tail call

 CMP #f7                \ If red key f7 was pressed, jump to TT167 to show the
 BNE P%+5               \ Market Price screen, returning from the subroutine
 JMP TT167              \ using a tail call

 CMP #f0                \ If red key f0 was pressed, jump to TT110 to launch our
 BNE fvw                \ ship (if docked), returning from the subroutine using
 JMP TT110              \ a tail call

.fvw

 BIT QQ12               \ If bit 7 of QQ12 is clear (i.e. we are not docked, but
 BPL INSP               \ in space), jump to INSP to skip the following checks
                        \ for f1-f3 and "@" (save commander file) key presses

 CMP #f3                \ If red key f3 was pressed, jump to EQSHP to show the
 BNE P%+5               \ Equip Ship screen, returning from the subroutine using
 JMP EQSHP              \ a tail call

 CMP #f1                \ If red key f1 was pressed, jump to TT219 to show the
 BNE P%+5               \ Buy Cargo screen, returning from the subroutine using
 JMP TT219              \ a tail call

\MOD
\CMP #&47               \ If "@" was pressed, jump to SVE to save the commander
\BNE P%+5               \ file, returning from the subroutine using a tail call
\JMP SVE

 CMP #f2                \ If red key f2 was pressed, jump to TT208 to show the
 BNE LABEL_3            \ Sell Cargo screen, returning from the subroutine using
 JMP TT208              \ a tail call

.INSP

 CMP #f1                \ If the key pressed is < red key f1 or > red key f3,
 BCC LABEL_3            \ jump to LABEL_3 (so only do the following if the key
 CMP #f3+1              \ pressed is f1, f2 or f3)
 BCS LABEL_3

 AND #3                 \ If we get here then we are either in space, or we are
 TAX                    \ docked and none of f1-f3 were pressed, so we can now
 JMP LOOK1              \ process f1-f3 with their in-flight functions, i.e.
                        \ switching space views
                        \
                        \ A will contain &71, &72 or &73 (for f1, f2 or f3), so
                        \ set X to the last digit (1, 2 or 3) and jump to LOOK1
                        \ to switch to view X (rear, left or right), returning
                        \ from the subroutine using a tail call

.LABEL_3

 CMP #&54               \ If "H" was pressed, jump to hyp to do a hyperspace
 BNE P%+5               \ jump (if we are in space), returning from the
 JMP hyp                \ subroutine using a tail call

 CMP #&32               \ If "D" was pressed, jump to T95 to print the distance
 BEQ T95                \ to a system (if we are in one of the chart screens)

 STA T1                 \ Store A (the key that's been pressed) in T1

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise jump down to TT107 to skip the
 BEQ TT107              \ following

 LDA QQ22+1             \ If the on-screen hyperspace counter is non-zero,
 BNE TT107              \ then we are already counting down, so jump to TT107
                        \ to skip the following

 LDA T1                 \ Restore the original value of A (the key that's been
                        \ pressed) from T1

 CMP #&36               \ If "O" was pressed, do the following three jumps,
 BNE ee2                \ otherwise skip to ee2 to continue

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

.ee2

 JSR TT16               \ Call TT16 to move the crosshairs by the amount in X
                        \ and Y, which were passed to this subroutine as
                        \ arguments

.TT107

 LDA QQ22+1             \ If the on-screen hyperspace counter is zero, return
 BEQ t95                \ from the subroutine (as t95 contains an RTS), as we
                        \ are not currently counting down to a hyperspace jump

 DEC QQ22               \ Decrement the internal hyperspace counter

 BNE t95                \ If the internal hyperspace counter is still non-zero,
                        \ then we are still counting down, so return from the
                        \ subroutine (as t95 contains an RTS)

                        \ If we get here then the internal hyperspace counter
                        \ has just reached zero and it wasn't zero before, so
                        \ we need to reduce the on-screen counter and update
                        \ the screen. We do this by first printing the next
                        \ number in the countdown sequence, and then printing
                        \ the old number, which will erase the old number
                        \ and display the new one because printing uses EOR
                        \ logic

 LDX QQ22+1             \ Set X = the on-screen hyperspace counter - 1
 DEX                    \ (i.e. the next number in the sequence)

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1)

 LDA #5                 \ Reset the internal hyperspace counter to 5
 STA QQ22

 LDX QQ22+1             \ Set X = the on-screen hyperspace counter (i.e. the
                        \ current number in the sequence, which is already
                        \ shown on-screen)

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1),
                        \ i.e. print the hyperspace countdown in the top-left
                        \ corner

 DEC QQ22+1             \ Decrement the on-screen hyperspace countdown

 BNE t95                \ If the countdown is not yet at zero, return from the
                        \ subroutine (as t95 contains an RTS)

 JMP TT18               \ Otherwise the countdown has finished, so jump to TT18
                        \ to do a hyperspace jump, returning from the subroutine
                        \ using a tail call

.t95

 RTS                    \ Return from the subroutine

.T95

                        \ If we get here, "D" was pressed, so we need to show
                        \ the distance to the selected system (if we are in a
                        \ chart view)

 LDA QQ11               \ If the current view is a chart (QQ11 = 64 or 128),
 AND #%11000000         \ keep going, otherwise return from the subroutine (as
 BEQ t95                \ t95 contains an RTS)

 JSR hm                 \ Call hm to move the crosshairs to the target system
                        \ in (QQ9, QQ10), returning with A = 0

 STA QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

 JSR cpl                \ Print control code 3 (the selected system name)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STA QQ17               \ next letter in capitals

 LDA #1                 \ Move the text cursor to column 1 and down one line
 STA XC                 \ (in other words, to the start of the next line)
 INC YC

 JMP TT146              \ Print the distance to the selected system and return
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: BAD
\       Type: Subroutine
\   Category: Status
\    Summary: Calculate how bad we have been
\
\ ------------------------------------------------------------------------------
\
\ Work out how bad we are from the amount of contraband in our hold. The
\ formula is:
\
\   (slaves + narcotics) * 2 + firearms
\
\ so slaves and narcotics are twice as illegal as firearms. The value in FIST
\ (our legal status) is set to at least this value whenever we launch from a
\ space station, and a FIST of 50 or more gives us fugitive status, so leaving a
\ station carrying 25 tonnes of slaves/narcotics, or 50 tonnes of firearms
\ across multiple trips, is enough to make us a fugitive.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A value that determines how bad we are from the amount
\                       of contraband in our hold
\
\ ******************************************************************************

.BAD

 LDA QQ20+3             \ Set A to the number of tonnes of slaves in the hold

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 ADC QQ20+6             \ Add the number of tonnes of narcotics in the hold

 ASL A                  \ Double the result and add the number of tonnes of
 ADC QQ20+10            \ firearms in the hold

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: FAROF
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with 224
\  Deep dive: A sense of scale
\
\ ------------------------------------------------------------------------------
\
\ Compare x_hi, y_hi and z_hi with 224, and set the C flag if all three <= 224,
\ otherwise clear the C flag.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if x_hi <= 224 and y_hi <= 224 and z_hi <= 224
\
\                       Clear otherwise (i.e. if any one of them are bigger than
\                       224)
\
\ ******************************************************************************

.FAROF

 LDA #224               \ Set A = 224 and fall through into FAROF2 to do the
                        \ comparison

\ ******************************************************************************
\
\       Name: FAROF2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with A
\
\ ------------------------------------------------------------------------------
\
\ Compare x_hi, y_hi and z_hi with A, and set the C flag if all three <= A,
\ otherwise clear the C flag.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if x_hi <= A and y_hi <= A and z_hi <= A
\
\                       Clear otherwise (i.e. if any one of them are bigger than
\                       A)
\
\ ******************************************************************************

.FAROF2

 CMP INWK+1             \ If A < x_hi, C will be clear so jump to MA34 to
 BCC MA34               \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

 CMP INWK+4             \ If A < y_hi, C will be clear so jump to MA34 to
 BCC MA34               \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

 CMP INWK+7             \ If A < z_hi, C will be clear, otherwise C will be set

.MA34

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MAS4
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate a cap on the maximum distance to a ship
\
\ ------------------------------------------------------------------------------
\
\ Logical OR the value in A with the high bytes of the ship's position (x_hi,
\ y_hi and z_hi).
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A OR x_hi OR y_hi OR z_hi
\
\ ******************************************************************************

.MAS4

 ORA INWK+1             \ OR A with x_hi, y_hi and z_hi
 ORA INWK+4
 ORA INWK+7

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DEATH
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display the death screen
\
\ ------------------------------------------------------------------------------
\
\ We have been killed, so display the chaos of our destruction above a "GAME
\ OVER" sign, and clean up the mess ready for the next attempt.
\
\ ******************************************************************************

.DEATH

 JSR EXNO3              \ Make the sound of us dying

 JSR RES2               \ Reset a number of flight variables and workspaces

 ASL DELTA              \ Divide our speed in DELTA by 4
 ASL DELTA

 LDX #24                \ Set the screen to only show 24 text rows, which hides
 JSR DET1               \ the dashboard, setting A to 6 in the process

 JSR TT66               \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 6 (death
                        \ screen)

 JSR BOX                \ Call BOX to redraw the same border box (BOX is part
                        \ of TT66), which removes the border as it is drawn
                        \ using EOR logic

 JSR nWq                \ Create a cloud of stardust containing the correct
                        \ number of dust particles (i.e. NOSTM of them)

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA YC
 STA XC

 LDA #146               \ Print recursive token 146 ("{all caps}GAME OVER")
 JSR ex

.D1

 JSR Ze                 \ Call Ze to initialise INWK to a fairly aggressive
                        \ ship, and set A and X to random values

 LSR A                  \ Set A = A / 4, so A is now between 0 and 63, and
 LSR A                  \ store in byte #0 (x_lo)
 STA INWK

 LDY #0                 \ Set the following to 0: the current view in QQ11
 STY QQ11               \ (space view), x_hi, y_hi, z_hi and the AI flag (no AI
 STY INWK+1             \ or E.C.M. and zero aggression)
 STY INWK+4
 STY INWK+7
 STY INWK+32

 DEY                    \ Set Y = 255

 STY MCNT               \ Reset the main loop counter to 255, so all timer-based
                        \ calls will be stopped

 STY LASCT              \ Set the laser count to 255 to act as a counter in the
                        \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 5.1 seconds, as LASCT is
                        \ decremented every vertical sync, or 50 times a second,
                        \ and 255 / 50 = 5.1)

 EOR #%00101010         \ Flip bits 1, 3 and 5 in A (x_lo) to get another number
 STA INWK+3             \ between 48 and 63, and store in byte #3 (y_lo)

 ORA #%01010000         \ Set bits 4 and 6 of A to bump it up to between 112 and
 STA INWK+6             \ 127, and store in byte #6 (z_lo)

 TXA                    \ Set A to the random number in X and keep bits 0-3 and
 AND #%10001111         \ the sign in bit 7 to get a number between -15 and +15,
 STA INWK+29            \ and store in byte #29 (roll counter) to give our ship
                        \ a gentle roll with damping

 ROR A                  \ The C flag is randomly set from the above call to Ze,
 AND #%10000111         \ so this sets A to a number between -7 and +7, which
 STA INWK+30            \ we store in byte #30 (the pitch counter) to give our
                        \ ship a very gentle pitch with damping

 PHP                    \ Store the processor flags

 LDX #OIL               \ Call fq1 with X set to #OIL, which adds a new cargo
 JSR fq1                \ canister to our local bubble of universe and points it
                        \ away from us with double DELTA speed (i.e. 6, as DELTA
                        \ was set to 3 by the call to RES2 above). INF is set to
                        \ point to the canister's ship data block in K%

 PLP                    \ Restore the processor flags, including our random C
                        \ flag from before

 LDA #0                 \ Set bit 7 of A to our random C flag and store in byte
 ROR A                  \ #31 of the ship's data block, so this has a 50% chance
 LDY #31                \ of marking our new canister as being killed (so it
 STA (INF),Y            \ will explode)

 LDA FRIN+3             \ The call we made to RES2 before we entered the loop at
 BEQ D1                 \ D1 will have reset all the ship slots at FRIN, so this
                        \ checks to see if the fourth slot is empty, and if it
                        \ is we loop back to D1 to add another canister, until
                        \ we have added four of them

 JSR U%                 \ Clear the key logger, which also sets A = 0

 STA DELTA              \ Set our speed in DELTA to 0, as we aren't going
                        \ anywhere any more

.D2

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about

 LDA LASCT              \ Loop back to D2 to run the main flight loop until
 BNE D2                 \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard

                        \ Fall through into DEATH2 to reset and restart the game

\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ------------------------------------------------------------------------------
\
\ This routine is called following death, and when the game is quit by pressing
\ ESCAPE when paused.
\
\ ******************************************************************************

.DEATH2

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

\ ******************************************************************************
\
\       Name: TT170
\       Type: Subroutine
\   Category: Start and end
\    Summary: Main entry point for the Elite game code
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
\ This is the main entry point for the main game code.
\
\ ******************************************************************************

.TT170

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack. We need to do this
                        \ because the loader code in elite-loader.asm pushes
                        \ code onto the stack, and this effectively removes that
                        \ code so we start afresh

                        \ Fall through into BR1 to start the game

\ ******************************************************************************
\
\       Name: BR1 (Part 1 of 2)
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Load New Commander (Y/N)?" screen and start the game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to point to BR1 by the loading process.
\
\ ******************************************************************************

.BR1

 LDX #3                 \ Set XC = 3 (set text cursor to column 3)
 STX XC

 JSR FX200              \ Disable the ESCAPE key and clear memory if the BREAK
                        \ key is pressed (*FX 200,3)

 LDX #CYL               \ Call TITLE to show a rotating Cobra Mk III (#CYL) and
 LDA #128               \ token 128 ("  LOAD NEW COMMANDER (Y/N)?{crlf}{crlf}"),
 JSR TITLE              \ returning with the internal number of the key pressed
                        \ in A

\MOD
\CMP #&44               \ Did we press "Y"? If not, jump to QU5, otherwise
\BNE QU5                \ continue on to load a new commander
\
\\.BR1                   \ These instructions are commented out in the original
\\
\\LDX #3                 \ source. This block starts with the same *FX call as
\\STX XC                 \ above, then clears the screen, calls a routine to
\\                       \ flush the keyboard buffer (FLKB) that isn't present
\\JSR FX200              \ in the cassette version but is in other versions,
\\                       \ and then it displays "LOAD NEW COMMANDER (Y/N)?" and
\\LDA #1                 \ lists the current cargo, before falling straight into
\\JSR TT66               \ the load routine below, whether or not we have
\\                       \ pressed "Y". This may be a bit of testing code, as the
\\JSR FLKB               \ first line is a commented label, BR1, which is where
\\                       \ BRKV points, so when this is uncommented, any BRK
\\LDA #14                \ instructions will jump straight to the load screen
\\JSR TT214
\\
\\BCC QU5
\
\JSR GTNME              \ We want to load a new commander, so we need to get
\                       \ the commander name to load
\
\JSR LOD                \ We then call the LOD subroutine to load the commander
\                       \ file to address NA%+8, which is where we store the
\                       \ commander save file
\
\JSR TRNME              \ Once loaded, we copy the commander name to NA%
\
\JSR TTX66              \ And we clear the top part of the screen and draw a
\                       \ border box

\ ******************************************************************************
\
\       Name: QU5
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the current commander data block to the last saved commander
\
\ ******************************************************************************

.QU5

                        \ By the time we get here, the correct commander name
                        \ is at NA% and the correct commander data is at NA%+8.
                        \ Specifically:
                        \
                        \   * If we loaded a commander file, then the name and
                        \     data from that file will be at NA% and NA%+8
                        \
                        \   * If this is a brand new game, then NA% will contain
                        \     the default starting commander name ("JAMESON")
                        \     and NA%+8 will contain the default commander data
                        \
                        \   * If this is not a new game (because they died or
                        \     quit) and we didn't want to load a commander file,
                        \     then NA% will contain the last saved commander
                        \     name, and NA%+8 the last saved commander data. If
                        \     the game has never been saved, this will still be
                        \     the default commander

\JSR TTX66              \ This instruction is commented out in the original
                        \ source; it clears the screen and draws a border

 LDX #NT%               \ The size of the commander data block is NT% bytes,
                        \ and it starts at NA%+8, so we need to copy the data
                        \ from the "last saved" buffer at NA%+8 to the current
                        \ commander workspace at TP. So we set up a counter in X
                        \ for the NT% bytes that we want to copy

.QUL1

 LDA NA%+7,X            \ Copy the X-th byte of NA%+7 to the X-th byte of TP-1,
 STA TP-1,X             \ (the -1 is because X is counting down from NT% to 1)

 DEX                    \ Decrement the loop counter

 BNE QUL1               \ Loop back for the next byte of the commander data
                        \ block

 STX QQ11               \ X is 0 by the end of the above loop, so this sets QQ11
                        \ to 0, which means we will be showing a view without a
                        \ boxed title at the top (i.e. we're going to use the
                        \ screen layout of a space view in the following)

                        \ If the commander check below fails, we keep jumping
                        \ back to here to crash the game with an infinite loop

\MOD
\JSR CHECK              \ Call the CHECK subroutine to calculate the checksum
\                       \ for the current commander block at NA%+8 and put it
\                       \ in A
\
\CMP CHK                \ Test the calculated checksum against CHK
\
\IF _REMOVE_CHECKSUMS
\
\NOP                    \ If we have disabled checksums, then ignore the result
\NOP                    \ of the comparison and fall through into the next part
\
\ELSE
\
\BNE P%-6               \ If the calculated checksum does not match CHK, then
\                       \ loop back to repeat the check - in other words, we
\                       \ enter an infinite loop here, as the checksum routine
\                       \ will keep returning the same incorrect value
\
\ENDIF
\
\                       \ The checksum CHK is correct, so now we check whether
\                       \ CHK2 = CHK EOR A9, and if this check fails, bit 7 of
\                       \ the competition flags at COK gets set, to indicate
\                       \ to Acornsoft via the competition code that there has
\                       \ been some hacking going on with this competition entry
\
\EOR #&A9               \ X = checksum EOR &A9
\TAX
\
\LDA COK                \ Set A to the competition flags in COK
\
\CPX CHK2               \ If X = CHK2, then skip the next instruction
\BEQ tZ
\
\ORA #%10000000         \ Set bit 7 of A to indicate this commander file has
\                       \ been tampered with
\
\.tZ
\
\ORA #%00000010         \ Set bit 1 of A to denote that this is the cassette
\                       \ version
\
\STA COK                \ Store the updated competition flags in COK

\ ******************************************************************************
\
\       Name: BR1 (Part 2 of 2)
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Press Fire or Space, Commander" screen and start the
\             game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to point to BR1 by the loading process.
\
\ ******************************************************************************

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

 LDA #147               \ Call TITLE to show a rotating Mamba (#3) and token
 LDX #3                 \ 147 ("PRESS FIRE OR SPACE,COMMANDER.{crlf}{crlf}"),
 JSR TITLE              \ returning with the internal number of the key pressed
                        \ in A

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

 JSR hyp1               \ Arrive in the system closest to (QQ9, QQ10)

                        \ Fall through into the docking bay routine below

\ ******************************************************************************
\
\       Name: BAY
\       Type: Subroutine
\   Category: Status
\    Summary: Go to the docking bay (i.e. show the Status Mode screen)
\
\ ------------------------------------------------------------------------------
\
\ We end up here after the start-up process (load commander etc.), as well as
\ after a successful save, an escape pod launch, a successful docking, the end
\ of a cargo sell, and various errors (such as not having enough cash, entering
\ too many items when buying, trying to fit an item to your ship when you
\ already have it, running out of cargo space, and so on).
\
\ ******************************************************************************

\.BAY

 LDA #&FF               \ Set QQ12 = &FF (the docked flag) to indicate that we
 STA QQ12               \ are docked

 LDA #f8                \ Jump into the main loop at FRCE, setting the key

\MOD

EQUB &20, &D2, &43, &A9, &16, &20, &D2, &43, &A9, &75, &20, &D2, &43
EQUB &A9, &73, &20, &D2, &43, &A9, &20, &4C, &BB, &43, &A9, &FF, &85
EQUB &9F, &A9, &76

 JMP FRCE               \ that's "pressed" to red key f8 (so we show the Status
                        \ Mode screen)

\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display a title screen with a rotating ship and prompt
\
\ ------------------------------------------------------------------------------
\
\ Display the title screen, with a rotating ship and a text token at the bottom
\ of the screen.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the recursive token to show below the
\                       rotating ship (see variable QQ18 for details of
\                       recursive tokens)
\
\   X                   The type of the ship to show (see variable XX21 for a
\                       list of ship types)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\ ******************************************************************************

.TITLE

 PHA                    \ Store the token number on the stack for later

 STX TYPE               \ Store the ship type in location TYPE

 JSR RESET              \ Reset our ship so we can use it for the rotating
                        \ title ship

 LDA #1                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 1

 DEC QQ11               \ Decrement QQ11 to 0, so from here on we are using a
                        \ space view

 LDA #96                \ Set nosev_z hi = 96 (96 is the value of unity in the
 STA INWK+14            \ rotation vector)

\LSR A                  \ This instruction is commented out in the original
                        \ source. It would halve the value of z_hi to 48, so the
                        \ ship would start off closer to the viewer

 STA INWK+7             \ Set z_hi, the high byte of the ship's z-coordinate,
                        \ to 96, which is the distance at which the rotating
                        \ ship starts out before coming towards us

 LDX #127               \ Set roll counter = 127, so don't dampen the roll and
 STX INWK+29            \ make the roll direction clockwise

 STX INWK+30            \ Set pitch counter = 127, so don't dampen the pitch and
                        \ set the pitch direction to dive

 INX                    \ Set QQ17 to 128 (so bit 7 is set) to switch to
 STX QQ17               \ Sentence Case, with the next letter printing in upper
                        \ case

 LDA TYPE               \ Set up a new ship, using the ship type in TYPE
 JSR NWSHP

 LDY #6                 \ Move the text cursor to column 6
 STY XC

 JSR DELAY              \ Wait for 6/50 of a second (0.12 seconds)

 LDA #30                \ Print recursive token 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

 LDY #6                 \ Move the text cursor to column 6 again
 STY XC

 INC YC                 \ Move the text cursor down a row

 LDA PATG               \ If PATG = 0, skip the following two lines, which
 BEQ awe                \ print the author credits (PATG can be toggled by
                        \ pausing the game and pressing "X")

 LDA #254               \ Print recursive token 94 ("BY D.BRABEN & I.BELL")
 JSR TT27

.awe

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to the first cleared row.
                        \ It also returns with Y = 0

 STY DELTA              \ Set DELTA = 0 (i.e. ship speed = 0)

 STY JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

 PLA                    \ Restore the recursive token number we stored on the
 JSR ex                 \ stack at the start of this subroutine, and print that
                        \ token

 LDA #148               \ Set A to recursive token 148

 LDX #7                 \ Move the text cursor to column 7
 STX XC

 JSR ex                 \ Print recursive token 148 ("(C) ACORNSOFT 1984")

.TLL2

\MOD
EQUB &A9, &FF, &85, &99

 LDA INWK+7             \ If z_hi (the ship's distance) is 1, jump to TL1 to
 CMP #1                 \ skip the following decrement
 BEQ TL1

 DEC INWK+7             \ Decrement the ship's distance, to bring the ship
                        \ a bit closer to us

.TL1

 JSR MVEIT              \ Move the ship in space according to the orientation
                        \ vectors and the new value in z_hi

 LDA #128               \ Set z_lo = 128, so the closest the ship gets to us is
 STA INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

 ASL A                  \ Set A = 0

 STA INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STA INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

 JSR LL9                \ Call LL9 to display the ship

 DEC MCNT               \ Decrement the main loop counter

\MOD

EQUB &D0, &E5, &60

\LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)
\
\AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
\                       \ button is pressed, otherwise it is set, so AND'ing
\                       \ the value of IRB with %10000 extracts this bit
\
\\TAX                    \ This instruction is commented out in the original
\                       \ source; it would have no effect, as the comparison
\                       \ flags are already set by the AND, and the value of X
\                       \ is not used anywhere
\
\BEQ TL2                \ If the joystick fire button is pressed, jump to TL2
\
\JSR RDKEY              \ Scan the keyboard for a key press and return the
\                       \ internal key number in A and X (or 0 for no key press)
\
\BEQ TLL2               \ If no key was pressed, loop back up to move/rotate
\                       \ the ship and check again for a key press
\
\RTS                    \ Return from the subroutine
\
\.TL2
\
\DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
\                       \ (it was set to 0 above), to disable keyboard and
\                       \ enable joysticks
\
\RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CHECK
\       Type: Subroutine
\   Category: Save and load
\    Summary: Calculate the checksum for the last saved commander data block
\  Deep dive: Commander save files
\
\ ------------------------------------------------------------------------------
\
\ The checksum for the last saved commander data block is saved as part of the
\ commander file, in two places (CHK AND CHK2), to protect against file
\ tampering. This routine calculates the checksum and returns it in A.
\
\ This algorithm is also implemented in elite-checksum.py.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The checksum for the last saved commander data block
\
\ ******************************************************************************

\MOD

.CHECK
\
\LDX #NT%-2             \ Set X to the size of the commander data block, less
\                       \ 2 (to omit the checksum bytes and the save count)
\
\CLC                    \ Clear the C flag so we can do addition without the
\                       \ C flag affecting the result
\
\TXA                    \ Seed the checksum calculation by setting A to the
\                       \ size of the commander data block, less 2
\
\                       \ We now loop through the commander data block,
\                       \ starting at the end and looping down to the start
\                       \ (so at the start of this loop, the X-th byte is the
\                       \ last byte of the commander data block, i.e. the save
\                       \ count)
\
\.QUL2
\
\ADC NA%+7,X            \ Add the X-1-th byte of the data block to A, plus the
\                       \ C flag
\
\EOR NA%+8,X            \ EOR A with the X-th byte of the data block
\
\DEX                    \ Decrement the loop counter
\
\BNE QUL2               \ Loop back for the next byte in the calculation, until
\                       \ we have added byte #0 and EOR'd with byte #1 of the
\                       \ data block
\
\RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TRNME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from INWK to NA%
\
\ ******************************************************************************

\MOD

\.TRNME
\
\LDX #7                 \ The commander's name can contain a maximum of 7
\                       \ characters, and is terminated by a carriage return,
\                       \ so set up a counter in X to copy 8 characters
\
\.GTL1
\
\LDA INWK,X             \ Copy the X-th byte of INWK to the X-th byte of NA%
\STA NA%,X
\
\DEX                    \ Decrement the loop counter
\
\BPL GTL1               \ Loop back until we have copied all 8 bytes
\
\                       \ Fall through into TR1 to copy the name back from NA%
\                       \ to INWK. This isn't necessary as the name is already
\                       \ there, but it does save one byte, as we don't need an
\                       \ RTS here

\ ******************************************************************************
\
\       Name: TR1
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from NA% to INWK
\
\ ******************************************************************************\MOD

\MOD

\.TR1
\
\LDX #7                 \ The commander's name can contain a maximum of 7
\                       \ characters, and is terminated by a carriage return,
\                       \ so set up a counter in X to copy 8 characters
\
\.GTL2
\
\LDA NA%,X              \ Copy the X-th byte of NA% to the X-th byte of INWK
\STA INWK,X
\
\DEX                    \ Decrement the loop counter
\
\BPL GTL2               \ Loop back until we have copied all 8 bytes
\
\RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GTNME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fetch the name of a commander file to save or load
\
\ ------------------------------------------------------------------------------
\
\ Get the commander's name for loading or saving a commander file. The name is
\ stored in the INWK workspace and is terminated by a return character (13).
\
\ If ESCAPE is pressed or a blank name is entered, then the name stored is set
\ to the name from the last saved commander block.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   INWK                The commander name entered, terminated by a return
\                       character (13)
\
\ ******************************************************************************

\MOD

\.GTNME
\
\LDA #1                 \ Clear the top part of the screen, draw a border box,
\JSR TT66               \ and set the current view type in QQ11 to 1
\
\LDA #123               \ Print recursive token 123 ("{crlf}COMMANDER'S NAME? ")
\JSR TT27
\
\JSR DEL8               \ Wait for 8/50 of a second (0.16 seconds)
\
\LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
\STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
\                       \ which comes from the keyboard)
\
\LDA #15                \ Call OSBYTE with A = 15 (flush all buffers)
\TAX
\JSR OSBYTE
\
\LDX #LO(RLINE)         \ Set (Y X) to point to the RLINE parameter block
\LDY #HI(RLINE)         \ configuration block below
\
\LDA #0                 \ Call OSWORD with A = 0 to read a line from the current
\JSR OSWORD             \ input stream (i.e. the keyboard)
\
\\LDA #%00000001         \ These instructions are commented out in the original
\\STA VIA+&4E            \ source, but they would set 6522 System VIA interrupt
\                       \ enable register IER (SHEILA &4E) bit 1 (i.e. disable
\                       \ the CA2 interrupt, which comes from the keyboard)
\
\BCS TR1                \ The C flag will be set if we pressed ESCAPE when
\                       \ entering the name, in which case jump to TR1 to copy
\                       \ the last saved commander's name from NA% to INWK
\                       \ and return from the subroutine there
\
\TYA                    \ The OSWORD call returns the length of the commander's
\                       \ name in Y, so transfer this to A
\
\BEQ TR1                \ If A = 0, no name was entered, so jump to TR1 to copy
\                       \ the last saved commander's name from NA% to INWK
\                       \ and return from the subroutine there
\
\JMP TT67               \ We have a name, so jump to TT67 to print a newline
\                       \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: RLINE
\       Type: Variable
\   Category: Text
\    Summary: The OSWORD configuration block used to fetch a line of text from
\             the keyboard
\
\ ******************************************************************************

\MOD

\.RLINE
\
\EQUW INWK              \ The address to store the input, so the commander's
\                       \ name will be stored in INWK as it is typed
\
\EQUB 7                 \ Maximum line length = 7, as that's the maximum size
\                       \ for a commander's name
\
\EQUB '!'               \ Allow ASCII characters from "!" through to "z" in
\EQUB 'z'               \ the name

\ ******************************************************************************
\
\       Name: ZERO
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill pages &9, &A, &B, &C and &D
\
\ ------------------------------------------------------------------------------
\
\ This resets the following workspaces to zero:
\
\   * The ship data blocks ascending from K% at &0900
\
\   * The ship line heap descending from WP at &0D40
\
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
\     (only a portion of the LSX/LSO sun line heap is cleared)
\
\ ******************************************************************************

.ZERO

 LDX #&D                \ Point X to page &D

.ZEL

 JSR ZES1               \ Call ZES1 to zero-fill the page in X

 DEX                    \ Decrement X to point to the next page

 CPX #9                 \ If X is > 9 (i.e. is &A, &B or &C), then loop back
 BNE ZEL                \ up to clear the next page

                        \ Then fall through into ZES1 with X set to 9, so we
                        \ clear page &9 too

\ ******************************************************************************
\
\       Name: ZES1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill the page whose number is in X
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The page we want to zero-fill
\
\ ******************************************************************************

.ZES1

 LDY #0                 \ If we set Y = SC = 0 and fall through into ZES2
 STY SC                 \ below, then we will zero-fill 255 bytes starting from
                        \ SC - in other words, we will zero-fill the whole of
                        \ page X

\ ******************************************************************************
\
\       Name: ZES2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill a specific page
\
\ ------------------------------------------------------------------------------
\
\ Zero-fill from address (X SC) + Y to (X SC) + &FF.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The high byte (i.e. the page) of the starting point of
\                       the zero-fill
\
\   Y                   The offset from (X SC) where we start zeroing, counting
\                       up to &FF
\
\   SC                  The low byte (i.e. the offset into the page) of the
\                       starting point of the zero-fill
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Z flag              Z flag is set
\
\ ******************************************************************************

.ZES2

 LDA #0                 \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

 STX SC+1               \ We want to zero-fill page X, so store this in the
                        \ high byte of SC, so the 16-bit address in SC and
                        \ SC+1 is now pointing to the SC-th byte of page X

.ZEL1

 STA (SC),Y             \ Zero the Y-th byte of the block pointed to by SC,
                        \ so that's effectively the Y-th byte before SC

 INY                    \ Increment the loop counter

 BNE ZEL1               \ Loop back to zero the next byte

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save the commander file
\  Deep dive: Commander save files
\             The competition code
\
\ ******************************************************************************

.SVE

\JSR GTNME              \ Clear the screen and ask for the commander filename
\                       \ to save, storing the name at INWK
\
\JSR TRNME              \ Transfer the commander filename from INWK to NA%
\
\JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
\                       \ the ship data blocks, the ship line heap, the ship
\                       \ slots for the local bubble of universe, and various
\                       \ flight and ship status variables
\
\LSR SVC                \ Halve the save count value in SVC
\
\LDX #NT%               \ We now want to copy the current commander data block
\                       \ from location TP to the last saved commander block at
\                       \ NA%+8, so set a counter in X to copy the NT% bytes in
\                       \ the commander data block
\                       \
\                       \ We also want to copy the data block to another
\                       \ location &0B00, which is normally used for the ship
\                       \ lines heap
\
\.SVL1
\
\LDA TP,X               \ Copy the X-th byte of TP to the X-th byte of &0B00
\STA &0B00,X            \ and NA%+8
\STA NA%+8,X
\
\DEX                    \ Decrement the loop counter
\
\BPL SVL1               \ Loop back until we have copied all the bytes in the
\                       \ commander data block
\
\JSR CHECK              \ Call CHECK to calculate the checksum for the last
\                       \ saved commander and return it in A
\
\STA CHK                \ Store the checksum in CHK, which is at the end of the
\                       \ last saved commander block
\
\PHA                    \ Store the checksum on the stack
\
\ORA #%10000000         \ Set K = checksum with bit 7 set
\STA K
\
\EOR COK                \ Set K+2 = K EOR COK (the competition flags)
\STA K+2
\
\EOR CASH+2             \ Set K+1 = K+2 EOR CASH+2 (the third cash byte)
\STA K+1
\
\EOR #&5A               \ Set K+3 = K+1 EOR &5A EOR TALLY+1 (the high byte of
\EOR TALLY+1            \ the kill tally)
\STA K+3
\
\JSR BPRNT              \ Print the competition number stored in K to K+3. The
\                       \ value of U might affect how this is printed, and as
\                       \ it's a temporary variable in zero page that isn't
\                       \ reset by ZERO, it might have any value, but as the
\                       \ competition code is a 10-digit number, this just means
\                       \ it may or may not have an extra space of padding
\
\JSR TT67               \ Call TT67 twice to print two newlines
\JSR TT67
\
\PLA                    \ Restore the checksum from the stack
\
\STA &0B00+NT%          \ Store the checksum in the last byte of the save file
\                       \ at &0B00 (the equivalent of CHK in the last saved
\                       \ block)
\
\EOR #&A9               \ Store the checksum EOR &A9 in CHK2, the penultimate
 STA CHK2               \ byte of the last saved commander block

 STA &0AFF+NT%          \ Store the checksum EOR &A9 in the penultimate byte of
                        \ the save file at &0B00 (the equivalent of CHK2 in the
                        \ last saved block)

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &0C0B              \
 INY                    \ Start address for save = &00000B00 in &0C0A to &0C0D
 STY &0C0F              \
                        \ End address for save = &00000C00 in &0C0E to &0C11
                        \
                        \ Y is left containing &C which we use below

\MOD

\LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
\STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
\                       \ which comes from the keyboard)
\
\INC SVN                \ Increment SVN to indicate we are about to start saving
\
\LDA #0                 \ Call QUS1 with A = 0, Y = &C to save the commander
\JSR QUS1               \ file with the filename we copied to INWK at the start
\                       \ of this routine
\
\LDX #0                 \ Set X = 0 for storing in SVN below
\
\\STX VIA+&4E            \ This instruction is commented out in the original
\                       \ source. It would affect the 6522 System VIA interrupt
\                       \ enable register IER (SHEILA &4E) if any of bits 0-6
\                       \ of X were set, but they aren't, so this instruction
\                       \ would have no effect anyway
\
\\DEX                    \ This instruction is commented out in the original
\                       \ source. It would end up setting SVN to &FF, which
\                       \ affects the logic in the IRQ1 handler
\
\STX SVN                \ Set SVN to 0 to indicate we are done saving
\
\JMP BAY                \ Go to the docking bay (i.e. show Status Mode)

\ ******************************************************************************
\
\       Name: QUS1
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save or load the commander file
\  Deep dive: Commander save files
\
\ ------------------------------------------------------------------------------
\
\ The filename should be stored at INWK, terminated with a carriage return (13).
\ The routine should be called with Y set to &C.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   File operation to be performed. Can be one of the
\                       following:
\
\                         * 0 (save file)
\
\                         * &FF (load file)
\
\   Y                   Points to the page number containing the OSFILE block,
\                       which must be &C because that's where the pointer to the
\                       filename in INWK is stored below (by the STX &0C00
\                       instruction)
\
\ ******************************************************************************

\MOD

\.QUS1
\
\LDX #INWK              \ Store a pointer to INWK at the start of the block at
\STX &0C00              \ &0C00, storing #INWK in the low byte because INWK is
\                       \ in zero page
\
\LDX #0                 \ Set X to 0 so (Y X) = &0C00
\
\JMP OSFILE             \ Jump to OSFILE to do the file operation specified in
\                       \ &0C00 (i.e. save or load a file depending on the value
\                       \ of A), returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: LOD
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load a commander file
\
\ ------------------------------------------------------------------------------
\
\ The filename should be stored at INWK, terminated with a carriage return (13).
\
\ ******************************************************************************

\MOD

\.LOD
\
\LDX #2                 \ Enable the ESCAPE key and clear memory if the BREAK
\JSR FX200              \ key is pressed (*FX 200,2)
\
\JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
\                       \ the ship data blocks, the ship line heap, the ship
\                       \ slots for the local bubble of universe, and various
\                       \ flight and ship status variables
\
\LDY #&B                \ Set up an OSFILE block at &0C00, containing:
\STY &0C03              \
\INC &0C0B              \ Load address = &00000B00 in &0C02 to &0C05
\                       \
\                       \ Length of file = &00000100 in &0C0A to &0C0D
\
\INY                    \ Increment Y to &C, which we use next
\
\LDA #&FF               \ Call QUS1 with A = &FF, Y = &C to load the commander
\JSR QUS1               \ file to address &0B00
\
\LDA &0B00              \ If the first byte of the loaded file has bit 7 set,
\BMI SPS1+1             \ jump to SPS+1, which is the second byte of an LDA #0
\                       \ instruction, i.e. a BRK instruction, which will force
\                       \ an interrupt to call the address in BRKV, which is set
\                       \ to BR1... so this instruction restarts the game from
\                       \ the title screen. Valid commander files for the
\                       \ cassette version of Elite only have 0 for the first
\                       \ byte, as there are no missions in this version, so
\                       \ having bit 7 set is invalid anyway
\
\LDX #NT%               \ We have successfully loaded the commander file at
\                       \ &0B00, so now we want to copy it to the last saved
\                       \ commander data block at NA%+8, so we set up a counter
\                       \ in X to copy NT% bytes
\
\.LOL1
\
\LDA &0B00,X            \ Copy the X-th byte of &0B00 to the X-th byte of NA%+8
\STA NA%+8,X
\
\DEX                    \ Decrement the loop counter
\
\BPL LOL1               \ Loop back until we have copied all NT% bytes
\
\LDX #3                 \ Fall through into FX200 to disable the ESCAPE key and
\                       \ clear memory if the BREAK key is pressed (*FX 200,3)
\                       \ and return from the subroutine there

\ ******************************************************************************
\
\       Name: FX200
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Set the behaviour of the ESCAPE and BREAK keys
\
\ ------------------------------------------------------------------------------
\
\ This is the equivalent of a *FX 200 command, which controls the behaviour of
\ the ESCAPE and BREAK keys.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Controls the behaviour as follows:
\
\                         * 0 = Enable ESCAPE key
\                               Normal BREAK key action
\
\                         * 1 = Disable ESCAPE key
\                               Normal BREAK key action
\
\                         * 2 = Enable ESCAPE key
\                               Clear memory if the BREAK key is pressed
\
\                         * 3 = Disable ESCAPE key
\                               Clear memory if the BREAK key is pressed
\
\ ******************************************************************************

.FX200

 LDY #0                 \ Call OSBYTE 200 with Y = 0, so the new value is set to
 LDA #200               \ X, and return from the subroutine using a tail call
 JMP OSBYTE

 RTS                    \ This instruction has no effect, as we already returned
                        \ from the subroutine

\ ******************************************************************************
\
\       Name: SPS1
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the vector to the planet and store it in XX15
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SPS1+1              A BRK instruction
\
\ ******************************************************************************

.SPS1

 LDX #0                 \ Copy the two high bytes of the planet's x-coordinate
 JSR SPS3               \ into K3(2 1 0), separating out the sign bit into K3+2

 LDX #3                 \ Copy the two high bytes of the planet's y-coordinate
 JSR SPS3               \ into K3(5 4 3), separating out the sign bit into K3+5

 LDX #6                 \ Copy the two high bytes of the planet's z-coordinate
 JSR SPS3               \ into K3(8 7 6), separating out the sign bit into K3+8

                        \ Fall through into TAS2 to build XX15 from K3

\ ******************************************************************************
\
\       Name: TAS2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Normalise the three-coordinate vector in K3
\
\ ------------------------------------------------------------------------------
\
\ Normalise the vector in K3, which has 16-bit values and separate sign bits,
\ and store the normalised version in XX15 as a signed 8-bit vector.
\
\ A normalised vector (also known as a unit vector) has length 1, so this
\ routine takes an existing vector in K3 and scales it so the length of the
\ new vector is 1. This is used in a number of places: when drawing the compass,
\ when applying AI tactics to ships (so traders fly towards planets and missiles
\ fly towards their targets, for example), and when implementing the docking
\ computer in the enhanced versions of Elite.
\
\ We do this in two stages. This stage shifts the 16-bit vector coordinates in
\ K3 to the left as far as they will go without losing any bits off the end, so
\ we can then take the high bytes and use them as the most accurate 8-bit vector
\ to normalise. Then the next stage (in routine NORM) does the normalisation.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K3(2 1 0)           The 16-bit x-coordinate as (x_sign x_hi x_lo), where
\                       x_sign is just bit 7
\
\   K3(5 4 3)           The 16-bit y-coordinate as (y_sign y_hi y_lo), where
\                       y_sign is just bit 7
\
\   K3(8 7 6)           The 16-bit z-coordinate as (z_sign z_hi z_lo), where
\                       z_sign is just bit 7
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX15                The normalised vector, with:
\
\                         * The x-coordinate in XX15
\
\                         * The y-coordinate in XX15+1
\
\                         * The z-coordinate in XX15+2
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TA2                 Calculate the length of the vector in XX15 (ignoring the
\                       low coordinates), returning it in Q
\
\ ******************************************************************************

.TAS2

 LDA K3                 \ OR the three low bytes and 1 to get a byte that has
 ORA K3+3               \ a 1 wherever any of the three low bytes has a 1
 ORA K3+6               \ (as well as always having bit 0 set), and store in
 ORA #1                 \ K3+9
 STA K3+9

 LDA K3+1               \ OR the three high bytes to get a byte in A that has a
 ORA K3+4               \ 1 wherever any of the three high bytes has a 1
 ORA K3+7

                        \ (A K3+9) now has a 1 wherever any of the 16-bit
                        \ values in K3 has a 1
.TAL2

 ASL K3+9               \ Shift (A K3+9) to the left, so bit 7 of the high byte
 ROL A                  \ goes into the C flag

 BCS TA2                \ If the left shift pushed a 1 out of the end, then we
                        \ know that at least one of the coordinates has a 1 in
                        \ this position, so jump to TA2 as we can't shift the
                        \ values in K3 any further to the left

 ASL K3                 \ Shift K3(1 0), the x-coordinate, to the left
 ROL K3+1

 ASL K3+3               \ Shift K3(4 3), the y-coordinate, to the left
 ROL K3+4

 ASL K3+6               \ Shift K3(6 7), the z-coordinate, to the left
 ROL K3+7

 BCC TAL2               \ Jump back to TAL2 to do another shift left (this BCC
                        \ is effectively a JMP as we know bit 7 of K3+7 is not a
                        \ 1, as otherwise bit 7 of A would have been a 1 and we
                        \ would have taken the BCS above)

.TA2

 LDA K3+1               \ Fetch the high byte of the x-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+2               \ sign bit in there from the x_sign part of K3, and
 STA XX15               \ store the resulting signed 8-bit x-coordinate in XX15

 LDA K3+4               \ Fetch the high byte of the y-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+5               \ sign bit in there from the y_sign part of K3, and
 STA XX15+1             \ store the resulting signed 8-bit y-coordinate in
                        \ XX15+1

 LDA K3+7               \ Fetch the high byte of the z-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+8               \ sign bit in there from the z_sign part of K3, and
 STA XX15+2             \ store the resulting signed 8-bit  z-coordinate in
                        \ XX15+2

                        \ Now we have a signed 8-bit version of the vector K3 in
                        \ XX15, so fall through into NORM to normalise it

\ ******************************************************************************
\
\       Name: NORM
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Normalise the three-coordinate vector in XX15
\  Deep dive: Tidying orthonormal vectors
\             Orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ We do this by dividing each of the three coordinates by the length of the
\ vector, which we can calculate using Pythagoras. Once normalised, 96 (&60) is
\ used to represent a value of 1, and 96 with bit 7 set (&E0) is used to
\ represent -1. This enables us to represent fractional values of less than 1
\ using integers.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15                The vector to normalise, with:
\
\                         * The x-coordinate in XX15
\
\                         * The y-coordinate in XX15+1
\
\                         * The z-coordinate in XX15+2
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX15                The normalised vector
\
\   Q                   The length of the original XX15 vector
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   NO1                 Contains an RTS
\
\ ******************************************************************************

.NORM

 LDA XX15               \ Fetch the x-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = x^2

 STA R                  \ Set (R Q) = (A P) = x^2
 LDA P
 STA Q

 LDA XX15+1             \ Fetch the y-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = y^2

 STA T                  \ Set (T P) = (A P) = y^2

 LDA P                  \ Set (R Q) = (R Q) + (T P) = x^2 + y^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 LDA T                  \ And then the high bytes, R = R + T
 ADC R
 STA R

 LDA XX15+2             \ Fetch the z-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = z^2

 STA T                  \ Set (T P) = (A P) = z^2

 LDA P                  \ Set (R Q) = (R Q) + (T P) = x^2 + y^2 + z^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 LDA T                  \ And then the high bytes, R = R + T
 ADC R
 STA R

 JSR LL5                \ We now have the following:
                        \
                        \ (R Q) = x^2 + y^2 + z^2
                        \
                        \ so we can call LL5 to use Pythagoras to get:
                        \
                        \ Q = SQRT(R Q)
                        \   = SQRT(x^2 + y^2 + z^2)
                        \
                        \ So Q now contains the length of the vector (x, y, z),
                        \ and we can normalise the vector by dividing each of
                        \ the coordinates by this value, which we do by calling
                        \ routine TIS2. TIS2 returns the divided figure, using
                        \ 96 to represent 1 and 96 with bit 7 set for -1

 LDA XX15               \ Call TIS2 to divide the x-coordinate in XX15 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15

 LDA XX15+1             \ Call TIS2 to divide the y-coordinate in XX15+1 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15+1

 LDA XX15+2             \ Call TIS2 to divide the z-coordinate in XX15+2 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15+2

.NO1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers (see page 142 of the "Advanced User
\ Guide for the BBC Micro" by Bray, Dickens and Holmes for a list of internal
\ key numbers).
\
\ This routine is effectively the same as OSBYTE 122, though the OSBYTE call
\ preserves A, unlike this routine.
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
\ ******************************************************************************

.RDKEY

\MOD
EQUB &A9, &00

\LDX #16                \ Start the scan with internal key number 16 ("Q")
\
\.Rd1
\
\JSR DKS4               \ Scan the keyboard to see if the key in X is currently
\                       \ being pressed, returning the result in A and X
\
\BMI Rd2                \ Jump to Rd2 if this key is being pressed (in which
\                       \ case DKS4 will have returned the key number with bit
\                       \ 7 set, which is negative)
\
\INX                    \ Increment the key number, which was unchanged by the
\                       \ above call to DKS4
\
\BPL Rd1                \ Loop back to test the next key, ending the loop when
\                       \ X is negative (i.e. 128)
\
\TXA                    \ If we get here, nothing is being pressed, so copy X
\                       \ into A so that X = A = 128 = %10000000
\
\.Rd2
\
\EOR #%10000000         \ EOR A with #%10000000 to flip bit 7, so A now contains
\                       \ 0 if no key has been pressed, or the internal key
\                       \ number if a key has been pressed

 TAX                    \ Copy A into X

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ECMOF
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Switch off the E.C.M. and turn off the dashboard bulb
\
\ ******************************************************************************

.ECMOF

 LDA #0                 \ Set ECMA and ECMP to 0 to indicate that no E.C.M. is
 STA ECMA               \ currently running
 STA ECMP

 JSR ECBLB              \ Update the E.C.M. indicator bulb on the dashboard

 LDA #72                \ Call the NOISE routine with A = 72 to make the sound
 BNE NOISE              \ of the E.C.M. being turned off and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ------------------------------------------------------------------------------
\
\ Make the sound of death in the cold, hard vacuum of space. Apparently, in
\ Elite space, everyone can hear you scream.
\
\ This routine also makes the sound of a destroyed cargo canister if we don't
\ get scooping right, the sound of us colliding with another ship, and the sound
\ of us being hit with depleted shields. It is not a good sound to hear.
\
\ ******************************************************************************

.EXNO3

 LDA #16                \ Call the NOISE routine with A = 16 to make the first
 JSR NOISE              \ death sound

 LDA #24                \ Call the NOISE routine with A = 24 to make the second
 BNE NOISE              \ death sound and return from the subroutine using a
                        \ tail call (this BNE is effectively a JMP as A will
                        \ never be zero)

\ ******************************************************************************
\
\       Name: SFRMIS
\       Type: Subroutine
\   Category: Tactics
\    Summary: Add an enemy missile to our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ An enemy has fired a missile, so add the missile to our universe if there is
\ room, and if there is, make the appropriate warnings and noises.
\
\ ******************************************************************************

.SFRMIS

 LDX #MSL               \ Set X to the ship type of a missile, and call SFS1-2
 JSR SFS1-2             \ to add a missile to our universe that has AI (bit 7
                        \ set), is hostile (bit 6 set) and has been launched
                        \ (bit 0 clear); the target slot number is set to 31,
                        \ but this is ignored as the hostile flags means we
                        \ are the target

 BCC NO1                \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to NO1 to return from
                        \ the subroutine (as NO1 contains an RTS)

 LDA #120               \ Print recursive token 120 ("INCOMING MISSILE") as an
 JSR MESS               \ in-flight message

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 BNE NOISE              \ of the missile being launched and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

\ ******************************************************************************
\
\       Name: EXNO2
\       Type: Subroutine
\   Category: Status
\    Summary: Process us making a kill
\  Deep dive: Combat rank
\
\ ------------------------------------------------------------------------------
\
\ We have killed a ship, so increase the kill tally, displaying an iconic
\ message of encouragement if the kill total is a multiple of 256, and then
\ make a nearby explosion sound.
\
\ ******************************************************************************

.EXNO2

 INC TALLY              \ Increment the low byte of the kill count in TALLY

 BNE EXNO-2             \ If there is no carry, jump to the LDX #7 below (at
                        \ EXNO-2)

 INC TALLY+1            \ Increment the high byte of the kill count in TALLY

 LDA #101               \ The kill total is a multiple of 256, so it's time
 JSR MESS               \ for a pat on the back, so print recursive token 101
                        \ ("RIGHT ON COMMANDER!") as an in-flight message

 LDX #7                 \ Set X = 7 and fall through into EXNO to make the
                        \ sound of a ship exploding

\ ******************************************************************************
\
\       Name: EXNO
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a laser strike on another ship or a ship
\             explosion
\
\ ------------------------------------------------------------------------------
\
\ Make the two-part explosion sound of us making a laser strike, or of another
\ ship exploding.
\
\ The volume of the first explosion is affected by the distance of the ship
\ being hit, with more distant ships being quieter. The value in X also affects
\ the volume of the first explosion, with a higher X giving a quieter sound
\ (so X can be used to differentiate a laser strike from an explosion).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The larger the value of X, the fainter the explosion.
\                       Allowed values are:
\
\                         * 7  = explosion is louder (i.e. the ship has just
\                                exploded)
\
\                         * 15 = explosion is quieter (i.e. this is just a laser
\                                strike)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   EXNO-2              Set X = 7 and fall through into EXNO to make the sound
\                       of a ship exploding
\
\ ******************************************************************************

.EXNO

 STX T                  \ Store the distance in T

 LDA #24                \ Set A = 24 to denote the sound of us making a hit or
 JSR NOS1               \ kill (part 1 of the explosion), and call NOS1 to set
                        \ up the sound block in XX16

 LDA INWK+7             \ Fetch z_hi, the distance of the ship being hit in
 LSR A                  \ terms of the z-axis (in and out of the screen), and
 LSR A                  \ divide by 4. If z_hi has either bit 6 or 7 set then
                        \ that ship is too far away to be shown on the scanner
                        \ (as per the SCAN routine), so we know the maximum
                        \ z_hi at this point is %00111111, and shifting z_hi
                        \ to the right twice gives us a maximum value of
                        \ %00001111

 AND T                  \ This reduces A to a maximum of X; X can be either
                        \ 7 = %0111 or 15 = %1111, so AND'ing with 15 will
                        \ not affect A, while AND'ing with 7 will clear bit
                        \ 3, reducing the maximum value in A to 7

 ORA #%11110001         \ The SOUND statement's amplitude ranges from 0 (for no
                        \ sound) to -15 (full volume), so we can set bits 0 and
                        \ 4-7 in A, and keep bits 1-3 from the above to get
                        \ a value between -15 (%11110001) and -1 (%11111111),
                        \ with lower values of z_hi and argument X leading
                        \ to a more negative, or quieter number (so the closer
                        \ the ship, i.e. the smaller the value of X, the louder
                        \ the sound)

 STA XX16+2             \ The amplitude byte of the sound block in XX16 is in
                        \ byte #3 (where it's the low byte of the amplitude), so
                        \ this sets the amplitude to the value in A

 JSR NO3                \ Make the sound from our updated sound block in XX16

 LDA #16                \ Set A = 16 to denote we have made a hit or kill
                        \ (part 2 of the explosion), and fall through into NOISE
                        \ to make the sound

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &20, or BIT &20A9, which does nothing apart
                        \ from affect the flags

\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ******************************************************************************

.BEEP

 LDA #32                \ Set A = 32 to denote a short, high beep, and fall
                        \ through into the NOISE routine to make the sound

\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound whose number is in A
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound to be made. See the
\                       documentation for variable SFX for a list of sound
\                       numbers
\
\ ******************************************************************************

.NOISE

 JSR NOS1               \ Set up the sound block in XX16 for the sound in A and
                        \ fall through into NO3 to make the sound

\ ******************************************************************************
\
\       Name: NO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound from a prepared sound block
\
\ ------------------------------------------------------------------------------
\
\ Make a sound from a prepared sound block in XX16 (if sound is enabled). See
\ routine NOS1 for details of preparing the XX16 sound block.
\
\ ******************************************************************************

.NO3

 LDX DNOIZ              \ Set X to the DNOIZ configuration setting

 BNE NO1                \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as NO1 contains an RTS)

 LDX #LO(XX16)          \ Otherwise set (Y X) to point to the sound block in
 LDY #HI(XX16)          \ XX16

 LDA #7                 \ Call OSWORD 7 to makes the sound, as described in the
 JMP OSWORD             \ documentation for variable SFX, and return from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: NOS1
\       Type: Subroutine
\   Category: Sound
\    Summary: Prepare a sound block
\
\ ------------------------------------------------------------------------------
\
\ Copy four sound bytes from SFX into XX16, interspersing them with null bytes,
\ with Y indicating the sound number to copy (from the values in the sound
\ table at SFX). So, for example, if we call this routine with A = 40 (long,
\ low beep), the following bytes will be set in XX16 to XX16+7:
\
\   &13 &00 &F4 &00 &0C &00 &08 &00
\
\ This block will be passed to OSWORD 7 to make the sound, which expects the
\ four sound attributes as 16-bit big-endian values - in other words, with the
\ low byte first. So the above block would pass the values &0013, &00F4, &000C
\ and &0008 to the SOUND statement when used with OSWORD 7, or:
\
\   SOUND &13, &F4, &0C, &08
\
\ as the high bytes are always zero.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The sound number to copy from SFX to XX16, which is
\                       always a multiple of 8
\
\ ******************************************************************************

.NOS1

 LSR A                  \ Divide A by 2, and also clear the C flag, as bit 0 of
                        \ A is always zero (as A is a multiple of 8)

 ADC #3                 \ Set Y = A + 3, so Y now points to the last byte of
 TAY                    \ four within the block of four-byte values

 LDX #7                 \ We want to copy four bytes, spread out into an
                        \ eight-byte block, so set a counter in Y to cover eight
                        \ bytes

.NOL1

 LDA #0                 \ Set the X-th byte of XX16 to 0
 STA XX16,X

 DEX                    \ Decrement the destination byte pointer

 LDA SFX,Y              \ Set the X-th byte of XX16 to the value from SFX+Y
 STA XX16,X

 DEY                    \ Decrement the source byte pointer again

 DEX                    \ Decrement the destination byte pointer again

 BPL NOL1               \ Loop back for the next source byte

                        \ Fall through into KYTB to return from the subroutine,
                        \ as the first byte of KYTB is an RTS

\ ******************************************************************************
\
\       Name: KYTB
\       Type: Variable
\   Category: Keyboard
\    Summary: Lookup table for in-flight keyboard controls
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see page 142 of the "Advanced User Guide for the
\ BBC Micro" by Bray, Dickens and Holmes for a list of internal key numbers).
\
\ The pitch, roll, speed and laser keys (i.e. the seven primary flight
\ control keys) have bit 7 set, so they have 128 added to their internal
\ values. This doesn't appear to be used anywhere.
\
\ Note that KYTB actually points to the byte before the start of the table, so
\ the offset of the first key value is 1 (i.e. KYTB+1), not 0.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   KYTB                Contains an RTS
\
\ ******************************************************************************

.KYTB

 RTS                    \ Return from the subroutine (used as an entry point and
                        \ a fall-through from above)

                        \ These are the primary flight controls (pitch, roll,
                        \ speed and lasers):

 EQUB &68 + 128         \ ?         KYTB+1      Slow down
 EQUB &62 + 128         \ Space     KYTB+2      Speed up
 EQUB &66 + 128         \ <         KYTB+3      Roll left
 EQUB &67 + 128         \ >         KYTB+4      Roll right
 EQUB &42 + 128         \ X         KYTB+5      Pull up
 EQUB &51 + 128         \ S         KYTB+6      Pitch down
 EQUB &41 + 128         \ A         KYTB+7      Fire lasers

                        \ These are the secondary flight controls:

 EQUB &60               \ TAB       KYTB+8      Energy bomb
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &52               \ C         KYTB+15     Docking computer

\ ******************************************************************************
\
\       Name: DKS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a flight key
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard for the flight key given in register Y, where Y is the
\ offset into the KYTB table above (so we can scan for Space by setting Y to
\ 2, for example). If the key is pressed, set the corresponding byte in the
\ key logger at KL to &FF.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset into the KYTB table above of the key that we
\                       want to scan on the keyboard
\
\ ******************************************************************************

\MOD
EQUB &09, &80, &85, &41, &60

.DKS1

 LDX KYTB,Y             \ Get the internal key number from the Y-th byte of the
                        \ KYTB table above

 JSR DKS4               \ Call DKS4, which will set A and X to a negative value
                        \ if the key is being pressed

 BPL DKS2-1             \ The key is not being pressed, so return from the
                        \ subroutine (as DKS2-1 contains an RTS)

 LDX #&FF               \ Store &FF in the Y-th byte of the key logger at KL
 STX KL,Y

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CTRL
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard to see if CTRL is currently pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X = %10000001 (i.e. 129 or -127) if CTRL is being
\                       pressed
\
\                       X = 1 if CTRL is not being pressed
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.CTRL

 LDX #1                 \ Set X to the internal key number for CTRL and fall
                        \ through into DKS4 to scan the keyboard

\ ******************************************************************************
\
\       Name: DKS4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard to see if a specific key is being pressed
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The internal number of the key to check (see page 142 of
\                       the "Advanced User Guide for the BBC Micro" by Bray,
\                       Dickens and Holmes for a list of internal key numbers)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   If the key in A is being pressed, A contains the
\                       original argument A, but with bit 7 set (i.e. A + 128).
\                       If the key in A is not being pressed, the value in A is
\                       unchanged
\
\   X                   Contains the same as A
\
\ ******************************************************************************

.DKS4

 LDA #%00000011         \ Set A to %00000011, so it's ready to send to SHEILA
                        \ once interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STA VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDA #%01111111         \ Set 6522 System VIA data direction register DDRA
 STA VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STX VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to X, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDX VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into X; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDA #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STA VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

 TXA                    \ Transfer X into A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DKS2
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read the joystick position
\
\ ------------------------------------------------------------------------------
\
\ Return the value of ADC channel in X (used to read the joystick). The value
\ will be inverted if the game has been configured to reverse both joystick
\ channels (which can be done by pausing the game and pressing J).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The ADC channel to read:
\
\                         * 1 = joystick X
\
\                         * 2 = joystick Y
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   (A X)               The 16-bit value read from channel X, with the value
\                       inverted if the game has been configured to reverse the
\                       joystick
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DKS2-1              Contains an RTS
\
\ ******************************************************************************

.DKS2

 LDA #128               \ Call OSBYTE with A = 128 to fetch the 16-bit value
 JSR OSBYTE             \ from ADC channel X, returning (Y X), i.e. the high
                        \ byte in Y and the low byte in X
                        \
                        \   * Channel 1 is the x-axis: 0 = right, 65520 = left
                        \
                        \   * Channel 2 is the y-axis: 0 = down,  65520 = up

 TYA                    \ Copy Y to A, so the result is now in (A X)

 EOR JSTE               \ The high byte A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the high byte but inverted, if that's what
                        \ the current settings say)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DKS3
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Toggle a configuration setting and emit a beep
\
\ ------------------------------------------------------------------------------
\
\ This is called when the game is paused and a key is pressed that changes the
\ game's configuration.
\
\ Specifically, this routine toggles the configuration settings for the
\ following keys:
\
\   * CAPS LOCK toggles keyboard flight damping (&40)
\   * A toggles keyboard auto-recentre (&41)
\   * X toggles author names on start-up screen (&42)
\   * F toggles flashing console bars (&43)
\   * Y toggles reverse joystick Y channel (&44)
\   * J toggles reverse both joystick channels (&45)
\   * K toggles keyboard and joystick (&46)
\
\ The numbers in brackets are the internal key numbers (see page 142 of the
\ "Advanced User Guide for the BBC Micro" by Bray, Dickens and Holmes for a list
\ of internal key numbers). We pass the key that has been pressed in X, and the
\ configuration option to check it against in Y, so this routine is typically
\ called in a loop that loops through the various configuration options.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The internal number of the key that's been pressed
\
\   Y                   The internal number of the configuration key to check
\                       against, from the list above (i.e. Y must be from &40 to
\                       &46)
\
\ ******************************************************************************

\MOD

.DKS3
\
\STY T                  \ Store the configuration key argument in T
\
\CPX T                  \ If X <> Y, jump to Dk3 to return from the subroutine
\BNE Dk3
\
\                       \ We have a match between X and Y, so now to toggle
\                       \ the relevant configuration byte. CAPS LOCK has a key
\                       \ value of &40 and has its configuration byte at
\                       \ location DAMP, A has a value of &41 and has its byte
\                       \ at location DJD, which is DAMP+1, and so on. So we
\                       \ can toggle the configuration byte by changing the
\                       \ byte at DAMP + (X - &40), or to put it in indexing
\                       \ terms, DAMP-&40,X. It's no coincidence that the
\                       \ game's configuration bytes are set up in this order
\                       \ and with these keys (and this is also why the sound
\                       \ on/off keys are dealt with elsewhere, as the internal
\                       \ key for S and Q are &51 and &10, which don't fit
\                       \ nicely into this approach)
\
\LDA DAMP-&40,X         \ Fetch the byte from DAMP + (X - &40), invert it and
\EOR #&FF               \ put it back (0 means no and &FF means yes in the
\STA DAMP-&40,X         \ configuration bytes, so this toggles the setting)
\
\JSR BELL               \ Make a beep sound so we know something has happened
\
\JSR DELAY              \ Wait for Y/50 seconds (Y is between 64 and 70, so this
\                       \ is always a bit longer than a second)
\
\LDY T                  \ Restore the configuration key argument into Y
\
\.Dk3
\
\RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DKJ1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read joystick and flight controls
\
\ ------------------------------------------------------------------------------
\
\ Specifically, scan the keyboard for the speed up and slow down keys, and read
\ the joystick's fire button and X and Y axes, storing the results in the key
\ logger and the joystick position variables.
\
\ This routine is only called if joysticks are enabled (JSTK = non-zero).
\
\ ******************************************************************************

.DKJ1

 LDY #1                 \ Update the key logger for key 1 in the KYTB table, so
 JSR DKS1               \ KY1 will be &FF if "?" (slow down) is being pressed

 INY                    \ Update the key logger for key 2 in the KYTB table, so
 JSR DKS1               \ KY2 will be &FF if Space (speed up) is being pressed

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 TAX                    \ This instruction doesn't seem to have any effect, as
                        \ X is overwritten in a few instructions. When the
                        \ joystick is checked in a similar way in the TITLE
                        \ subroutine for the "Press Fire Or Space,Commander."
                        \ stage of the start-up screen, there's another
                        \ unnecessary TAX instruction present, but there it's
                        \ commented out

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 EOR #%00010000         \ Flip bit 4 so that it's set if the fire button has
 STA KY7                \ been pressed, and store the result in the keyboard
                        \ logger at location KY7, which is also where the A key
                        \ (fire lasers) key is logged

 LDX #1                 \ Call DKS2 to fetch the value of ADC channel 1 (the
 JSR DKS2               \ joystick X value) into (A X), and OR A with 1. This
 ORA #1                 \ ensures that the high byte is at least 1, and then we
 STA JSTX               \ store the result in JSTX

 LDX #2                 \ Call DKS2 to fetch the value of ADC channel 2 (the
 JSR DKS2               \ joystick Y value) into (A X), and EOR A with JSTGY.
 EOR JSTGY              \ JSTGY will be &FF if the game is configured to
 STA JSTY               \ reverse the joystick Y channel, so this EOR does
                        \ exactly that, and then we store the result in JSTY

 JMP DK4                \ We are done scanning the joystick flight controls,
                        \ so jump to DK4 to scan for other keys, using a tail
                        \ call so we can return from the subroutine there

\ ******************************************************************************
\
\       Name: U%
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Clear the key logger
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 0
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.U%

 LDA #0                 \ Set A to 0, as this means "key not pressed" in the
                        \ key logger at KL

 LDY #15                \ We want to clear the 15 key logger locations from
                        \ KY1 to KY19, so set a counter in Y

.DKL3

 STA KL,Y               \ Store 0 in the Y-th byte of the key logger

 DEY                    \ Decrement the counter

\MOD
\BNE DKL3               \ And loop back for the next key, until we have just
 BPL DKL3               \ And loop back for the next key, until we have just
                        \ KL+1. We don't want to clear the first key logger
                        \ location at KL, as the keyboard table at KYTB starts
                        \ with offset 1, not 0, so KL is not technically part of
                        \ the key logger (it's actually used for logging keys
                        \ that don't appear in the keyboard table, and which
                        \ therefore don't use the key logger)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DOKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for the seven primary flight controls
\  Deep dive: The key logger
\             The docking computer
\
\ ------------------------------------------------------------------------------
\
\ Scan for the seven primary flight controls (or the equivalent on joystick),
\ pause and configuration keys, and secondary flight controls, and update the
\ key logger accordingly. Specifically:
\
\   * If we are on keyboard configuration, clear the key logger and update it
\     for the seven primary flight controls, and update the pitch and roll
\     rates accordingly.
\
\   * If we are on joystick configuration, clear the key logger and jump to
\     DKJ1, which reads the joystick equivalents of the primary flight
\     controls.
\
\ Both options end up at DK4 to scan for other keys, beyond the seven primary
\ flight controls.
\
\ ******************************************************************************


\MOD
EQUB &48

 JSR U%                 \ Call U% to clear the key logger

\MOD
EQUB &68, &29, &7F, &85, &41, &4C, &49, &48

.DOKEY

EQUB &A5, &41, &30, &F0, &20, &97, &47, &AD, &5D, &0D, &F0, &63, &20, &31, &42
EQUB &A9, &60, &85, &61, &09, &80, &85, &69, &85, &9B, &A5, &8C, &85, &6E, &AD
EQUB &5B, &0D, &F0, &07, &0A, &20, &49, &20, &4C, &DA, &47, &20, &D3, &22, &A5
EQUB &6E, &C9, &20, &90, &02, &A9, &20, &85, &8C, &A9, &FF, &A2, &00, &A4, &6F
EQUB &F0, &05, &30, &01, &E8, &95, &42, &A9, &80, &A2, &00, &06, &70, &F0, &11
EQUB &90, &01, &E8, &24, &70, &10, &06, &A9, &40, &85, &9C, &A9, &00, &95, &44
EQUB &A5, &9C, &85, &9C, &A9, &80, &A2, &00, &06, &71, &F0, &07, &B0, &01, &E8
EQUB &95, &46, &A5, &9D, &85, &9D, &A6, &9C, &A9, &07, &A4, &44, &F0, &03, &20
EQUB &7B, &28, &A4, &45, &F0, &03, &20, &8B, &28, &86, &9C, &0A, &A6, &9D, &A4
EQUB &46, &F0, &03, &20, &8B, &28, &A4, &47, &F0, &03, &20, &7B, &28, &86, &9D

\LDA JSTK               \ If JSTK is non-zero, then we are configured to use
\BNE DKJ1               \ the joystick rather than keyboard, so jump to DKJ1
\                       \ to read the joystick flight controls, before jumping
\                       \ to DK4 to scan for pause, configuration and secondary
\                       \ flight keys
\
\LDY #7                 \ We're going to work our way through the primary flight
\                       \ control keys (pitch, roll, speed and laser), so set a
\                       \ counter in Y so we can loop through all 7
\
\.DKL2
\
\JSR DKS1               \ Call DKS1 to see if the KYTB key at offset Y is being
\                       \ pressed, and set the key logger accordingly
\
\DEY                    \ Decrement the loop counter
\
\BNE DKL2               \ Loop back for the next key, working our way from A at
\                       \ KYTB+7 down to ? at KYTB+1
\
\LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
\                       \ RL indicator on the dashboard)
\
\LDA #7                 \ Set A to 7, which is the amount we want to alter the
\                       \ roll rate by if the roll keys are being pressed
\
\LDY KL+3               \ If the "<" key is being pressed, then call the BUMP2
\BEQ P%+5               \ routine to increase the roll rate in X by A
\JSR BUMP2
\
\LDY KL+4               \ If the ">" key is being pressed, then call the REDU2
\BEQ P%+5               \ routine to decrease the roll rate in X by A, taking
\JSR REDU2              \ the keyboard auto re-centre setting into account
\
\STX JSTX               \ Store the updated roll rate in JSTX
\
\ASL A                  \ Double the value of A, to 14
\
\LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
\                       \ DC indicator on the dashboard)
\
\LDY KL+5               \ If the "X" key is being pressed, then call the REDU2
\BEQ P%+5               \ routine to decrease the pitch rate in X by A, taking
\JSR REDU2              \ the keyboard auto re-centre setting into account
\
\LDY KL+6               \ If the "S" key is being pressed, then call the BUMP2
\BEQ P%+5               \ routine to increase the pitch rate in X by A
\JSR BUMP2
\
\STX JSTY               \ Store the updated roll rate in JSTY
\
\                       \ Fall through into DK4 to scan for other keys

\ ******************************************************************************
\
\       Name: DK4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for pause, configuration and secondary flight keys
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Scan for pause and configuration keys, and if this is a space view, also scan
\ for secondary flight controls.
\
\ Specifically:
\
\   * Scan for the pause button (COPY) and if it's pressed, pause the game and
\     process any configuration key presses until the game is unpaused (DELETE)
\
\   * If this is a space view, scan for secondary flight keys and update the
\     relevant bytes in the key logger
\
\ ******************************************************************************

\MOD

.DK4
EQUB &20, &61, &48, &A6, &41

\
\JSR RDKEY              \ Scan the keyboard for a key press and return the
\                       \ internal key number in A and X (or 0 for no key press)
\
\STX KL                 \ Store X in KL, byte #0 of the key logger
\
\CPX #&69               \ If COPY is not being pressed, jump to DK2 below,
\BNE DK2                \ otherwise let's process the configuration keys
\
\.FREEZE
\
\                       \ COPY is being pressed, so we enter a loop that
\                       \ listens for configuration keys, and we keep looping
\                       \ until we detect a DELETE key press. This effectively
\                       \ pauses the game when COPY is pressed, and unpauses
\                       \ it when DELETE is pressed
\
\JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
\                       \ screen gets drawn
\
\JSR RDKEY              \ Scan the keyboard for a key press and return the
\                       \ internal key number in A and X (or 0 for no key press)
\
\CPX #&51               \ If "S" is not being pressed, skip to DK6
\BNE DK6
\
\LDA #0                 \ "S" is being pressed, so set DNOIZ to 0 to turn the
\STA DNOIZ              \ sound on
\
\.DK6
\
\LDY #&40               \ We now want to loop through the keys that toggle
\                       \ various settings. These have internal key numbers
\                       \ between &40 (CAPS LOCK) and &46 ("K"), so we set up
\                       \ the first key number in Y to act as a loop counter.
\                       \ See subroutine DKS3 for more details on this
\
\.DKL4
\
\JSR DKS3               \ Call DKS3 to scan for the key given in Y, and toggle
\                       \ the relevant setting if it is pressed
\
\INY                    \ Increment Y to point to the next toggle key
\
\CPY #&47               \ The last toggle key is &46 (K), so check whether we
\                       \ have just done that one
\
\BNE DKL4               \ If not, loop back to check for the next toggle key
\
\.DK55
\
\CPX #&10               \ If "Q" is not being pressed, skip to DK7
\BNE DK7
\
\STX DNOIZ              \ "Q" is being pressed, so set DNOIZ to X, which is
\                       \ non-zero (&10), so this will turn the sound off
\
\.DK7
\
\CPX #&70               \ If ESCAPE is not being pressed, skip over the next
\BNE P%+5               \ instruction
\
\JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end
\                       \ the game
\
\CPX #&59               \ If DELETE is not being pressed, we are still paused,
\BNE FREEZE             \ so loop back up to keep listening for configuration
\                       \ keys, otherwise fall through into the rest of the
\                       \ key detection code, which unpauses the game

.DK2

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE DK5                \ view), return from the subroutine (as DK5 contains
                        \ an RTS)

 LDY #15                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+15, and their key logger locations are from KL+8
                        \ to KL+15. So set a decreasing counter in Y for the
                        \ index, starting at 15, so we can loop through them

 LDA #&FF               \ Set A to &FF so we can store this in the keyboard
                        \ logger for keys that are being pressed

.DKL1

 LDX KYTB,Y             \ Get the internal key number of the Y-th flight key
                        \ the KYTB keyboard table

 CPX KL                 \ We stored the key that's being pressed in KL above,
                        \ so check to see if the Y-th flight key is being
                        \ pressed

 BNE DK1                \ If it is not being pressed, skip to DK1 below

 STA KL,Y               \ The Y-th flight key is being pressed, so set that
                        \ key's location in the key logger to &FF

.DK1

 DEY                    \ Decrement the loop counter

 CPY #7                 \ Have we just done the last key?

 BNE DKL1               \ If not, loop back to process the next key

.DK5

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TT217
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard until a key is pressed
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard until a key is pressed, and return the key's ASCII code.
\ If, on entry, a key is already being held down, then wait until that key is
\ released first (so this routine detects the first key down event following
\ the subroutine call).
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The ASCII code of the key that was pressed
\
\   A                   Contains the same as X
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   out                 Contains an RTS
\
\ ******************************************************************************

\MOD

EQUB &A2, &10, &20, &4B, &47, &10, &05, &A9, &FF, &8D, &49, &0F, &A2
EQUB &51, &20, &4B, &47, &10, &05, &A9, &00, &8D, &49, &0F, &A2, &70
EQUB &20, &4B, &47, &10, &03, &4C, &26, &45, &A2, &69, &20, &4B, &47
EQUB &10, &07, &A2, &59, &20, &4B, &47, &10, &F9, &60

.TT217

 STY YSAV               \ Store Y in temporary storage, so we can restore it
                        \ later

\MOD
EQUB &A9, &00, &8A

\
\.t
\
\JSR DELAY-5            \ Wait for 8/50 of a second (0.16 seconds) to implement
\                       \ a simple keyboard debounce and prevent multiple key
\                       \ presses being recorded
\
\JSR RDKEY              \ Scan the keyboard for a key press and return the
\                       \ internal key number in A and X (or 0 for no key press)
\
\BNE t                  \ If a key was already being held down when we entered
\                       \ this routine, keep looping back up to t, until the
\                       \ key is released
\
\.t2
\
\JSR RDKEY              \ Any pre-existing key press is now gone, so we can
\                       \ start scanning the keyboard again, returning the
\                       \ internal key number in A and X (or 0 for no key press)
\
\BEQ t2                 \ Keep looping up to t2 until a key is pressed
\
\TAY                    \ Copy A to Y, so Y contains the internal key number
\                       \ of the key pressed
\
\LDA (TRTB%),Y          \ The address in TRTB% points to the MOS key
\                       \ translation table, which is used to translate
\                       \ internal key numbers to ASCII, so this fetches the
\                       \ key's ASCII code into A
\
\LDY YSAV               \ Restore the original value of Y we stored above
\
\TAX                    \ Copy A into X

.out

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: me1
\       Type: Subroutine
\   Category: Flight
\    Summary: Erase an old in-flight message and display a new one
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\   X                   Must be set to 0
\
\ ******************************************************************************

.me1

 STX DLY                \ Set the message delay in DLY to 0, so any new
                        \ in-flight messages will be shown instantly

 PHA                    \ Store the new message token we want to print

 LDA MCH                \ Set A to the token number of the message that is
 JSR mes9               \ currently on-screen, and call mes9 to print it (which
                        \ will remove it from the screen, as printing is done
                        \ using EOR logic)

 PLA                    \ Restore the new message token

 EQUB &2C               \ Fall through into ou2 to print the new message, but
                        \ skip the first instruction by turning it into
                        \ &2C &A9 &6C, or BIT &6CA9, which does nothing apart
                        \ from affect the flags

\ ******************************************************************************
\
\       Name: ou2
\       Type: Subroutine
\   Category: Flight
\    Summary: Display "E.C.M.SYSTEM DESTROYED" as an in-flight message
\
\ ******************************************************************************

.ou2

 LDA #108               \ Set A to recursive token 108 ("E.C.M.SYSTEM")

 EQUB &2C               \ Fall through into ou3 to print the new message, but
                        \ skip the first instruction by turning it into
                        \ &2C &A9 &6F, or BIT &6FA9, which does nothing apart
                        \ from affect the flags

\ ******************************************************************************
\
\       Name: ou3
\       Type: Subroutine
\   Category: Flight
\    Summary: Display "FUEL SCOOPS DESTROYED" as an in-flight message
\
\ ******************************************************************************

.ou3

 LDA #111               \ Set A to recursive token 111 ("FUEL SCOOPS")

\ ******************************************************************************
\
\       Name: MESS
\       Type: Subroutine
\   Category: Flight
\    Summary: Display an in-flight message
\
\ ------------------------------------------------------------------------------
\
\ Display an in-flight message in capitals at the bottom of the space view,
\ erasing any existing in-flight message first.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.MESS

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

 LDY #9                 \ Move the text cursor to column 9, row 22, at the
 STY XC                 \ bottom middle of the screen, and set Y = 22
 LDY #22
 STY YC

 CPX DLY                \ If the message delay in DLY is not zero, jump up to
 BNE me1                \ me1 to erase the current message first (whose token
                        \ number will be in MCH)

 STY DLY                \ Set the message delay in DLY to 22

 STA MCH                \ Set MCH to the token we are about to display

                        \ Fall through into mes9 to print the token in A

\ ******************************************************************************
\
\       Name: mes9
\       Type: Subroutine
\   Category: Flight
\    Summary: Print a text token, possibly followed by " DESTROYED"
\
\ ------------------------------------------------------------------------------
\
\ Print a text token, followed by " DESTROYED" if the destruction flag is set
\ (for when a piece of equipment is destroyed).
\
\ ******************************************************************************

.mes9

 JSR TT27               \ Call TT27 to print the text token in A

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC out                \ subroutine (as out contains an RTS)

 LDA #253               \ Print recursive token 93 (" DESTROYED") and return
 JMP TT27               \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: OUCH
\       Type: Subroutine
\   Category: Flight
\    Summary: Potentially lose cargo or equipment following damage
\
\ ------------------------------------------------------------------------------
\
\ Our shields are dead and we are taking damage, so there is a small chance of
\ losing cargo or equipment.
\
\ ******************************************************************************

.OUCH

 JSR DORND              \ Set A and X to random numbers

 BMI out                \ If A < 0 (50% chance), return from the subroutine
                        \ (as out contains an RTS)

 CPX #22                \ If X >= 22 (91% chance), return from the subroutine
 BCS out                \ (as out contains an RTS)

 LDA QQ20,X             \ If we do not have any of item QQ20+X, return from the
 BEQ out                \ subroutine (as out contains an RTS). X is in the range
                        \ 0-21, so this not only checks for cargo, but also for
                        \ E.C.M., fuel scoops, energy bomb, energy unit and
                        \ docking computer, all of which can be destroyed

 LDA DLY                \ If there is already an in-flight message on-screen,
 BNE out                \ return from the subroutine (as out contains an RTS)

 LDY #3                 \ Set bit 1 of de, the equipment destruction flag, so
 STY de                 \ that when we call MESS below, " DESTROYED" is appended
                        \ to the in-flight message

 STA QQ20,X             \ A is 0 (as we didn't branch with the BNE above), so
                        \ this sets QQ20+X to 0, which destroys any cargo or
                        \ equipment we have of that type

 CPX #17                \ If X >= 17 then we just lost a piece of equipment, so
 BCS ou1                \ jump to ou1 to print the relevant message

 TXA                    \ Print recursive token 48 + A as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 BNE MESS               \ ITEMS") as the C flag is clear, so this prints the
                        \ destroyed item's name, followed by " DESTROYED" (as we
                        \ set bit 1 of the de flag above), and returns from the
                        \ subroutine using a tail call

.ou1

 BEQ ou2                \ If X = 17, jump to ou2 to print "E.C.M.SYSTEM
                        \ DESTROYED" and return from the subroutine using a tail
                        \ call

 CPX #18                \ If X = 18, jump to ou3 to print "FUEL SCOOPS
 BEQ ou3                \ DESTROYED" and return from the subroutine using a tail
                        \ call

 TXA                    \ Otherwise X is in the range 19 to 21 and the C flag is
 ADC #113-20            \ set (as we got here via a BCS to ou1), so we set A as
                        \ follows:
                        \
                        \   A = 113 - 20 + X + C
                        \     = 113 - 19 + X
                        \     = 113 to 115

 BNE MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: QQ16
\       Type: Variable
\   Category: Text
\    Summary: The two-letter token lookup table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ Two-letter token lookup table for tokens 128-159.
\
\ ******************************************************************************

.QQ16

 EQUS "AL"              \ Token 128
 EQUS "LE"              \ Token 129
 EQUS "XE"              \ Token 130
 EQUS "GE"              \ Token 131
 EQUS "ZA"              \ Token 132
 EQUS "CE"              \ Token 133
 EQUS "BI"              \ Token 134
 EQUS "SO"              \ Token 135
 EQUS "US"              \ Token 136
 EQUS "ES"              \ Token 137
 EQUS "AR"              \ Token 138
 EQUS "MA"              \ Token 139
 EQUS "IN"              \ Token 140
 EQUS "DI"              \ Token 141
 EQUS "RE"              \ Token 142
 EQUS "A?"              \ Token 143
 EQUS "ER"              \ Token 144
 EQUS "AT"              \ Token 145
 EQUS "EN"              \ Token 146
 EQUS "BE"              \ Token 147
 EQUS "RA"              \ Token 148
 EQUS "LA"              \ Token 149
 EQUS "VE"              \ Token 150
 EQUS "TI"              \ Token 151
 EQUS "ED"              \ Token 152
 EQUS "OR"              \ Token 153
 EQUS "QU"              \ Token 154
 EQUS "AN"              \ Token 155
 EQUS "TE"              \ Token 156
 EQUS "IS"              \ Token 157
 EQUS "RI"              \ Token 158
 EQUS "ON"              \ Token 159

\ ******************************************************************************
\
\       Name: ITEM
\       Type: Macro
\   Category: Market
\    Summary: Macro definition for the market prices table
\  Deep dive: Market item prices and availability
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the market prices table:
\
\   ITEM price, factor, units, quantity, mask
\
\ It inserts an item into the market prices table at QQ23.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   price               Base price
\
\   factor              Economic factor
\
\   units               Units: "t", "g" or "k"
\
\   quantity            Base quantity
\
\   mask                Fluctuations mask
\
\ ******************************************************************************

MACRO ITEM price, factor, units, quantity, mask

 IF factor < 0
  s = 1 << 7
 ELSE
  s = 0
 ENDIF

 IF units = 't'
  u = 0
 ELIF units = 'k'
  u = 1 << 5
 ELSE
  u = 1 << 6
 ENDIF

 e = ABS(factor)

 EQUB price
 EQUB s + u + e
 EQUB quantity
 EQUB mask

ENDMACRO

\ ******************************************************************************
\
\       Name: QQ23
\       Type: Variable
\   Category: Market
\    Summary: Market prices table
\  Deep dive: Market item prices and availability
\
\ ------------------------------------------------------------------------------
\
\ Each item has four bytes of data, like this:
\
\   Byte #0 = Base price
\   Byte #1 = Economic factor in bits 0-4, with the sign in bit 7
\             Unit in bits 5-6
\   Byte #2 = Base quantity
\   Byte #3 = Mask to control price fluctuations
\
\ To make it easier for humans to follow, I've defined a macro called ITEM
\ that takes the following arguments and builds the four bytes for us:
\
\   ITEM base price, economic factor, units, base quantity, mask
\
\ So for food, we have the following, for example:
\
\   * Base price = 19
\   * Economic factor = -2
\   * Unit = tonnes
\   * Base quantity = 6
\   * Mask = %00000001
\
\ ******************************************************************************

.QQ23

 ITEM 19,  -2, 't',   6, %00000001  \  0 = Food
 ITEM 20,  -1, 't',  10, %00000011  \  1 = Textiles
 ITEM 65,  -3, 't',   2, %00000111  \  2 = Radioactives
 ITEM 40,  -5, 't', 226, %00011111  \  3 = Slaves
 ITEM 83,  -5, 't', 251, %00001111  \  4 = Liquor/Wines
 ITEM 196,  8, 't',  54, %00000011  \  5 = Luxuries
 ITEM 235, 29, 't',   8, %01111000  \  6 = Narcotics
 ITEM 154, 14, 't',  56, %00000011  \  7 = Computers
 ITEM 117,  6, 't',  40, %00000111  \  8 = Machinery
 ITEM 78,   1, 't',  17, %00011111  \  9 = Alloys
 ITEM 124, 13, 't',  29, %00000111  \ 10 = Firearms
 ITEM 176, -9, 't', 220, %00111111  \ 11 = Furs
 ITEM 32,  -1, 't',  53, %00000011  \ 12 = Minerals
 ITEM 97,  -1, 'k',  66, %00000111  \ 13 = Gold
 ITEM 171, -2, 'k',  55, %00011111  \ 14 = Platinum
 ITEM 45,  -1, 'g', 250, %00001111  \ 15 = Gem-Stones
 ITEM 53,  15, 't', 192, %00000111  \ 16 = Alien items

\ ******************************************************************************
\
\       Name: TIDY
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Orthonormalise the orientation vectors for a ship
\  Deep dive: Tidying orthonormal vectors
\             Orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ This routine orthonormalises the orientation vectors for a ship. This means
\ making the three orientation vectors orthogonal (perpendicular to each other),
\ and normal (so each of the vectors has length 1).
\
\ We do this because we use the small angle approximation to rotate these
\ vectors in space. It is not completely accurate, so the three vectors tend
\ to get stretched over time, so periodically we tidy the vectors with this
\ routine to ensure they remain as orthonormal as possible.
\
\ ******************************************************************************

.TI2

                        \ Called from below with A = 0, X = 0, Y = 4 when
                        \ nosev_x and nosev_y are small, so we assume that
                        \ nosev_z is big

 TYA                    \ A = Y = 4
 LDY #2
 JSR TIS3               \ Call TIS3 with X = 0, Y = 2, A = 4, to set roofv_z =
 STA INWK+20            \ -(nosev_x * roofv_x + nosev_y * roofv_y) / nosev_z

 JMP TI3                \ Jump to TI3 to keep tidying

.TI1

                        \ Called from below with A = 0, Y = 4 when nosev_x is
                        \ small

 TAX                    \ Set X = A = 0

 LDA XX15+1             \ Set A = nosev_y, and if the top two magnitude bits
 AND #%01100000         \ are both clear, jump to TI2 with A = 0, X = 0, Y = 4
 BEQ TI2

 LDA #2                 \ Otherwise nosev_y is big, so set up the index values
                        \ to pass to TIS3

 JSR TIS3               \ Call TIS3 with X = 0, Y = 4, A = 2, to set roofv_y =
 STA INWK+18            \ -(nosev_x * roofv_x + nosev_z * roofv_z) / nosev_y

 JMP TI3                \ Jump to TI3 to keep tidying

.TIDY

 LDA INWK+10            \ Set (XX15, XX15+1, XX15+2) = nosev
 STA XX15
 LDA INWK+12
 STA XX15+1
 LDA INWK+14
 STA XX15+2

 JSR NORM               \ Call NORM to normalise the vector in XX15, i.e. nosev

 LDA XX15               \ Set nosev = (XX15, XX15+1, XX15+2)
 STA INWK+10
 LDA XX15+1
 STA INWK+12
 LDA XX15+2
 STA INWK+14

 LDY #4                 \ Set Y = 4

 LDA XX15               \ Set A = nosev_x, and if the top two magnitude bits
 AND #%01100000         \ are both clear, jump to TI1 with A = 0, Y = 4
 BEQ TI1

 LDX #2                 \ Otherwise nosev_x is big, so set up the index values
 LDA #0                 \ to pass to TIS3

 JSR TIS3               \ Call TIS3 with X = 2, Y = 4, A = 0, to set roofv_x =
 STA INWK+16            \ -(nosev_y * roofv_y + nosev_z * roofv_z) / nosev_x

.TI3

 LDA INWK+16            \ Set (XX15, XX15+1, XX15+2) = roofv
 STA XX15
 LDA INWK+18
 STA XX15+1
 LDA INWK+20
 STA XX15+2

 JSR NORM               \ Call NORM to normalise the vector in XX15, i.e. roofv

 LDA XX15               \ Set roofv = (XX15, XX15+1, XX15+2)
 STA INWK+16
 LDA XX15+1
 STA INWK+18
 LDA XX15+2
 STA INWK+20

 LDA INWK+12            \ Set Q = nosev_y
 STA Q

 LDA INWK+20            \ Set A = roofv_z

 JSR MULT12             \ Set (S R) = Q * A = nosev_y * roofv_z

 LDX INWK+14            \ Set X = nosev_z

 LDA INWK+18            \ Set A = roofv_y

 JSR TIS1               \ Set (A ?) = (-X * A + (S R)) / 96
                        \        = (-nosev_z * roofv_y + nosev_y * roofv_z) / 96
                        \
                        \ This also sets Q = nosev_z

 EOR #%10000000         \ Set sidev_x = -A
 STA INWK+22            \        = (nosev_z * roofv_y - nosev_y * roofv_z) / 96

 LDA INWK+16            \ Set A = roofv_x

 JSR MULT12             \ Set (S R) = Q * A = nosev_z * roofv_x

 LDX INWK+10            \ Set X = nosev_x

 LDA INWK+20            \ Set A = roofv_z

 JSR TIS1               \ Set (A ?) = (-X * A + (S R)) / 96
                        \        = (-nosev_x * roofv_z + nosev_z * roofv_x) / 96
                        \
                        \ This also sets Q = nosev_x

 EOR #%10000000         \ Set sidev_y = -A
 STA INWK+24            \        = (nosev_x * roofv_z - nosev_z * roofv_x) / 96

 LDA INWK+18            \ Set A = roofv_y

 JSR MULT12             \ Set (S R) = Q * A = nosev_x * roofv_y

 LDX INWK+12            \ Set X = nosev_y

 LDA INWK+16            \ Set A = roofv_x

 JSR TIS1               \ Set (A ?) = (-X * A + (S R)) / 96
                        \        = (-nosev_y * roofv_x + nosev_x * roofv_y) / 96

 EOR #%10000000         \ Set sidev_z = -A
 STA INWK+26            \        = (nosev_y * roofv_x - nosev_x * roofv_y) / 96

 LDA #0                 \ Set A = 0 so we can clear the low bytes of the
                        \ orientation vectors

 LDX #14                \ We want to clear the low bytes, so start from sidev_y
                        \ at byte #9+14 (we clear all except sidev_z_lo, though
                        \ I suspect this is in error and that X should be 16)

.TIL1

 STA INWK+9,X           \ Set the low byte in byte #9+X to zero

 DEX                    \ Set X = X - 2 to jump down to the next low byte
 DEX

 BPL TIL1               \ Loop back until we have zeroed all the low bytes

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TIS2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate A = A / Q
\  Deep dive: Shift-and-subtract division
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division, where A is a sign-magnitude number and Q is
\ a positive integer:
\
\   A = A / Q
\
\ The value of A is returned as a sign-magnitude number with 96 representing 1,
\ and the maximum value returned is 1 (i.e. 96). This routine is used when
\ normalising vectors, where we represent fractions using integers, so this
\ gives us an approximation to two decimal places.
\
\ ******************************************************************************

.TIS2

 TAY                    \ Store the argument A in Y

 AND #%01111111         \ Strip the sign bit from the argument, so A = |A|

 CMP Q                  \ If A >= Q then jump to TI4 to return a 1 with the
 BCS TI4                \ correct sign

 LDX #%11111110         \ Set T to have bits 1-7 set, so we can rotate through 7
 STX T                  \ loop iterations, getting a 1 each time, and then
                        \ getting a 0 on the 8th iteration... and we can also
                        \ use T to catch our result bits into bit 0 each time

.TIL2

 ASL A                  \ Shift A to the left

 CMP Q                  \ If A < Q skip the following subtraction
 BCC P%+4

 SBC Q                  \ A >= Q, so set A = A - Q
                        \
                        \ Going into this subtraction we know the C flag is
                        \ set as we passed through the BCC above, and we also
                        \ know that A >= Q, so the C flag will still be set once
                        \ we are done

 ROL T                  \ Rotate the counter in T to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS TIL2               \ If we still have set bits in T, loop back to TIL2 to
                        \ do the next iteration of 7

                        \ We've done the division and now have a result in the
                        \ range 0-255 here, which we need to reduce to the range
                        \ 0-96. We can do that by multiplying the result by 3/8,
                        \ as 256 * 3/8 = 96

 LDA T                  \ Set T = T / 4
 LSR A
 LSR A
 STA T

 LSR A                  \ Set T = T / 8 + T / 4
 ADC T                  \       = 3T / 8
 STA T

 TYA                    \ Fetch the sign bit of the original argument A
 AND #%10000000

 ORA T                  \ Apply the sign bit to T

 RTS                    \ Return from the subroutine

.TI4

 TYA                    \ Fetch the sign bit of the original argument A
 AND #%10000000

 ORA #96                \ Apply the sign bit to 96 (which represents 1)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TIS3
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate -(nosev_1 * roofv_1 + nosev_2 * roofv_2) / nosev_3
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following expression:
\
\   A = -(nosev_1 * roofv_1 + nosev_2 * roofv_2) / nosev_3
\
\ where 1, 2 and 3 are x, y, or z, depending on the values of X, Y and A. This
\ routine is called with the following values:
\
\   X = 0, Y = 2, A = 4 ->
\         A = -(nosev_x * roofv_x + nosev_y * roofv_y) / nosev_z
\
\   X = 0, Y = 4, A = 2 ->
\         A = -(nosev_x * roofv_x + nosev_z * roofv_z) / nosev_y
\
\   X = 2, Y = 4, A = 0 ->
\         A = -(nosev_y * roofv_y + nosev_z * roofv_z) / nosev_x
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Index 1 (0 = x, 2 = y, 4 = z)
\
\   Y                   Index 2 (0 = x, 2 = y, 4 = z)
\
\   A                   Index 3 (0 = x, 2 = y, 4 = z)
\
\ ******************************************************************************

.TIS3

 STA P+2                \ Store P+2 in A for later

 LDA INWK+10,X          \ Set Q = nosev_x_hi (plus X)
 STA Q

 LDA INWK+16,X          \ Set A = roofv_x_hi (plus X)

 JSR MULT12             \ Set (S R) = Q * A
                        \           = nosev_x_hi * roofv_x_hi

 LDX INWK+10,Y          \ Set Q = nosev_x_hi (plus Y)
 STX Q

 LDA INWK+16,Y          \ Set A = roofv_x_hi (plus Y)

 JSR MAD                \ Set (A X) = Q * A + (S R)
                        \           = (nosev_x,X * roofv_x,X) +
                        \             (nosev_x,Y * roofv_x,Y)

 STX P                  \ Store low byte of result in P, so result is now in
                        \ (A P)

 LDY P+2                \ Set Q = roofv_x_hi (plus argument A)
 LDX INWK+10,Y
 STX Q

 EOR #%10000000         \ Flip the sign of A

                        \ Fall through into DIVDT to do:
                        \
                        \   (P+1 A) = (A P) / Q
                        \
                        \     = -((nosev_x,X * roofv_x,X) +
                        \         (nosev_x,Y * roofv_x,Y))
                        \       / nosev_x,A

\ ******************************************************************************
\
\       Name: DVIDT
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P+1 A) = (A P) / Q
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following integer division between sign-magnitude numbers:
\
\   (P+1 A) = (A P) / Q
\
\ This uses the same shift-and-subtract algorithm as TIS2.
\
\ ******************************************************************************

.DVIDT

 STA P+1                \ Set P+1 = A, so P(1 0) = (A P)

 EOR Q                  \ Set T = the sign bit of A EOR Q, so it's 1 if A and Q
 AND #%10000000         \ have different signs, i.e. it's the sign of the result
 STA T                  \ of A / Q

 LDA #0                 \ Set A = 0 for us to build a result

 LDX #16                \ Set a counter in X to count the 16 bits in P(1 0)

 ASL P                  \ Shift P(1 0) left
 ROL P+1

 ASL Q                  \ Clear the sign bit of Q the C flag at the same time
 LSR Q

.DVL2

 ROL A                  \ Shift A to the left

 CMP Q                  \ If A < Q skip the following subtraction
 BCC P%+4

 SBC Q                  \ Set A = A - Q
                        \
                        \ Going into this subtraction we know the C flag is
                        \ set as we passed through the BCC above, and we also
                        \ know that A >= Q, so the C flag will still be set once
                        \ we are done

 ROL P                  \ Rotate P(1 0) to the left, and catch the result bit
 ROL P+1                \ into the C flag (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 DEX                    \ Decrement the loop counter

 BNE DVL2               \ Loop back for the next bit until we have done all 16
                        \ bits of P(1 0)

 LDA P                  \ Set A = P so the low byte is in the result in A

 ORA T                  \ Set A to the correct sign bit that we set in T above

 RTS                    \ Return from the subroutine

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
 SAVE "versions/demo/3-assembled-output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_G% = P%

 LOAD_G% = LOAD% + P% - CODE%

\ ******************************************************************************
\
\       Name: SHPPT
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw a distant ship as a point rather than a full wireframe
\
\ ******************************************************************************

.SHPPT

 JSR EE51               \ Call EE51 to remove the ship's wireframe from the
                        \ screen, if there is one

 JSR PROJ               \ Project the ship onto the screen, returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate
                        \   * A = K4+1

 ORA K3+1               \ If either of the high bytes of the screen coordinates
 BNE nono               \ are non-zero, jump to nono as the ship is off-screen

 LDA K4                 \ Set A = the y-coordinate of the dot

 CMP #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view

 LDY #2                 \ Call Shpt with Y = 2 to set up bytes 1-4 in the ship
 JSR Shpt               \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ first row of the dot (i.e. a four-pixel dash)

 LDY #6                 \ Set Y to 6 for the next call to Shpt

 LDA K4                 \ Set A = y-coordinate of dot + 1 (so this is the second
 ADC #1                 \ row of the two-pixel high dot)
                        \
                        \ The addition works as the Shpt routine clears the C
                        \ flag

 JSR Shpt               \ Call Shpt with Y = 6 to set up bytes 5-8 in the ship
                        \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ second row of the dot (i.e. another four-pixel dash,
                        \ on the row below the first one)

 LDA #%00001000         \ Set bit 3 of the ship's byte #31 to record that we
 ORA XX1+31             \ have now drawn something on-screen for this ship
 STA XX1+31

 LDA #8                 \ Set A = 8 so when we call LL18+2 next, byte #0 of the
                        \ heap gets set to 8, for the 8 bytes we just stuck on
                        \ the heap

 JMP LL81+2             \ Call LL81+2 to draw the ship's dot, returning from the
                        \ subroutine using a tail call

 PLA                    \ Pull the return address from the stack, so the RTS
 PLA                    \ below actually returns from the subroutine that called
                        \ LL9 (as we called SHPPT from LL9 with a JMP)

.nono

 LDA #%11110111         \ Clear bit 3 of the ship's byte #31 to record that
 AND XX1+31             \ nothing is being drawn on-screen for this ship
 STA XX1+31

 RTS                    \ Return from the subroutine

.Shpt

                        \ This routine sets up four bytes in the ship line heap,
                        \ from byte Y-1 to byte Y+2. If the ship's screen point
                        \ turns out to be off-screen, then this routine aborts
                        \ the entire call to LL9, exiting via nono. The four
                        \ bytes define a horizontal four-pixel dash, for either
                        \ the top or the bottom of the ship's dot

 STA (XX19),Y           \ Store A in byte Y of the ship line heap (i.e. Y1)

 INY                    \ Store A in byte Y+2 of the ship line heap (i.e. Y2)
 INY
 STA (XX19),Y

 LDA K3                 \ Set A = screen x-coordinate of the ship dot

 DEY                    \ Store A in byte Y+1 of the ship line heap (i.e. X2)
 STA (XX19),Y

 ADC #3                 \ Set A = screen x-coordinate of the ship dot + 3

 BCS nono-2             \ If the addition pushed the dot off the right side of
                        \ the screen, jump to nono-2 to return from the parent
                        \ subroutine early (i.e. LL9). This works because we
                        \ called Shpt from above with a JSR, so nono-2 removes
                        \ that return address from the stack, leaving the next
                        \ return address exposed. LL9 called SHPPT with a JMP,
                        \ so the next return address is the one that was put on
                        \ the stack by the original call to LL9. So the RTS in
                        \ nono will actually return us from the original call
                        \ to LL9, thus aborting the entire drawing process

 DEY                    \ Store A in byte Y-1 of the ship line heap (i.e. X1)
 DEY
 STA (XX19),Y

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL5
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate Q = SQRT(R Q)
\  Deep dive: Calculating square roots
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following square root:
\
\   Q = SQRT(R Q)
\
\ ******************************************************************************

.LL5

 LDY R                  \ Set (Y S) = (R Q)
 LDA Q
 STA S

                        \ So now to calculate Q = SQRT(Y S)

 LDX #0                 \ Set X = 0, to hold the remainder

 STX Q                  \ Set Q = 0, to hold the result

 LDA #8                 \ Set T = 8, to use as a loop counter
 STA T

.LL6

 CPX Q                  \ If X < Q, jump to LL7
 BCC LL7

 BNE LL8                \ If X > Q, jump to LL8

 CPY #64                \ If Y < 64, jump to LL7 with the C flag clear,
 BCC LL7                \ otherwise fall through into LL8 with the C flag set

.LL8

 TYA                    \ Set Y = Y - 64
 SBC #64                \
 TAY                    \ This subtraction will work as we know C is set from
                        \ the BCC above, and the result will not underflow as we
                        \ already checked that Y >= 64, so the C flag is also
                        \ set for the next subtraction

 TXA                    \ Set X = X - Q
 SBC Q
 TAX

.LL7

 ROL Q                  \ Shift the result in Q to the left, shifting the C flag
                        \ into bit 0 and bit 7 into the C flag

 ASL S                  \ Shift the dividend in (Y S) to the left, inserting
 TYA                    \ bit 7 from above into bit 0
 ROL A
 TAY

 TXA                    \ Shift the remainder in X to the left
 ROL A
 TAX

 ASL S                  \ Shift the dividend in (Y S) to the left
 TYA
 ROL A
 TAY

 TXA                    \ Shift the remainder in X to the left
 ROL A
 TAX

 DEC T                  \ Decrement the loop counter

 BNE LL6                \ Loop back to LL6 until we have done 8 loops

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL28
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate R = 256 * A / Q
\  Deep dive: Shift-and-subtract division
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, where A < Q:
\
\   R = 256 * A / Q
\
\ This is a sister routine to LL61, which does the division when A >= Q.
\
\ If A >= Q then 255 is returned and the C flag is set to indicate an overflow
\ (the C flag is clear if the division was a success).
\
\ The result is returned in one byte as the result of the division multiplied
\ by 256, so we can return fractional results using integers.
\
\ This routine uses the same shift-and-subtract algorithm that's documented in
\ TIS2, but it leaves the fractional result in the integer range 0-255.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if the answer is too big for one byte, clear if the
\                       division was a success
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL28+4              Skips the A >= Q check and always returns with C flag
\                       cleared, so this can be called if we know the division
\                       will work
\
\   LL31                Skips the A >= Q check and does not set the R counter,
\                       so this can be used for jumping straight into the
\                       division loop if R is already set to 254 and we know the
\                       division will work
\
\ ******************************************************************************

.LL28

 CMP Q                  \ If A >= Q, then the answer will not fit in one byte,
 BCS LL2                \ so jump to LL2 to return 255

 LDX #%11111110         \ Set R to have bits 1-7 set, so we can rotate through 7
 STX R                  \ loop iterations, getting a 1 each time, and then
                        \ getting a 0 on the 8th iteration... and we can also
                        \ use R to catch our result bits into bit 0 each time

.LL31

 ASL A                  \ Shift A to the left

 BCS LL29               \ If bit 7 of A was set, then jump straight to the
                        \ subtraction

 CMP Q                  \ If A < Q, skip the following subtraction
 BCC P%+4

 SBC Q                  \ A >= Q, so set A = A - Q

 ROL R                  \ Rotate the counter in R to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS LL31               \ If we still have set bits in R, loop back to LL31 to
                        \ do the next iteration of 7

 RTS                    \ R left with remainder of division

.LL29

 SBC Q                  \ A >= Q, so set A = A - Q

 SEC                    \ Set the C flag to rotate into the result in R

 ROL R                  \ Rotate the counter in R to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS LL31               \ If we still have set bits in R, loop back to LL31 to
                        \ do the next iteration of 7

 RTS                    \ Return from the subroutine with R containing the
                        \ remainder of the division

.LL2

 LDA #255               \ The division is very close to 1, so return the closest
 STA R                  \ possible answer to 256, i.e. R = 255

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL38
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (S A) = (S R) + (A Q)
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following between sign-magnitude numbers:
\
\   (S A) = (S R) + (A Q)
\
\ where the sign bytes only contain the sign bits, not magnitudes.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if the addition overflowed, clear otherwise
\
\ ******************************************************************************

.LL38

 EOR S                  \ If the sign of A * S is negative, skip to LL35, as
 BMI LL39               \ A and S have different signs so we need to subtract

 LDA Q                  \ Otherwise set A = R + Q, which is the result we need,
 CLC                    \ as S already contains the correct sign
 ADC R

 RTS                    \ Return from the subroutine

.LL39

 LDA R                  \ Set A = R - Q
 SEC
 SBC Q

 BCC P%+4               \ If the subtraction underflowed, skip the next two
                        \ instructions so we can negate the result

 CLC                    \ Otherwise the result is correct, and S contains the
                        \ correct sign of the result as R is the dominant side
                        \ of the subtraction, so clear the C flag

 RTS                    \ And return from the subroutine

                        \ If we get here we need to negate both the result and
                        \ the sign in S, as both are the wrong sign

 PHA                    \ Store the result of the subtraction on the stack

 LDA S                  \ Flip the sign of S
 EOR #%10000000
 STA S

 PLA                    \ Restore the subtraction result into A

 EOR #%11111111         \ Negate the result in A using two's complement, i.e.
 ADC #1                 \ set A = ~A + 1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL51
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the dot product of XX15 and XX16
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following dot products:
\
\   XX12(1 0) = XX15(5 0) . XX16(5 0)
\   XX12(3 2) = XX15(5 0) . XX16(11 6)
\   XX12(5 4) = XX15(5 0) . XX16(12 17)
\
\ storing the results as sign-magnitude numbers in XX12 through XX12+5.
\
\ When called from part 5 of LL9, XX12 contains the vector [x y z] to the ship
\ we're drawing, and XX16 contains the orientation vectors, so it returns:
\
\   [ x ]   [ sidev_x ]         [ x ]   [ roofv_x ]         [ x ]   [ nosev_x ]
\   [ y ] . [ sidev_y ]         [ y ] . [ roofv_y ]         [ y ] . [ nosev_y ]
\   [ z ]   [ sidev_z ]         [ z ]   [ roofv_z ]         [ z ]   [ nosev_z ]
\
\ When called from part 6 of LL9, XX12 contains the vector [x y z] of the vertex
\ we're analysing, and XX16 contains the transposed orientation vectors with
\ each of them containing the x, y and z elements of the original vectors, so it
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   [ x ]   [ sidev_x ]         [ x ]   [ sidev_y ]         [ x ]   [ sidev_z ]
\   [ y ] . [ roofv_x ]         [ y ] . [ roofv_y ]         [ y ] . [ roofv_z ]
\   [ z ]   [ nosev_x ]         [ z ]   [ nosev_y ]         [ z ]   [ nosev_z ]
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15(1 0)           The ship (or vertex)'s x-coordinate as (x_sign x_lo)
\
\   XX15(3 2)           The ship (or vertex)'s y-coordinate as (y_sign y_lo)
\
\   XX15(5 4)           The ship (or vertex)'s z-coordinate as (z_sign z_lo)
\
\   XX16 to XX16+5      The scaled sidev (or _x) vector, with:
\
\                         * x, y, z magnitudes in XX16, XX16+2, XX16+4
\
\                         * x, y, z signs in XX16+1, XX16+3, XX16+5
\
\   XX16+6 to XX16+11   The scaled roofv (or _y) vector, with:
\
\                         * x, y, z magnitudes in XX16+6, XX16+8, XX16+10
\
\                         * x, y, z signs in XX16+7, XX16+9, XX16+11
\
\   XX16+12 to XX16+17  The scaled nosev (or _z) vector, with:
\
\                         * x, y, z magnitudes in XX16+12, XX16+14, XX16+16
\
\                         * x, y, z signs in XX16+13, XX16+15, XX16+17
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX12(1 0)           The dot product of [x y z] vector with the sidev (or _x)
\                       vector, with the sign in XX12+1 and magnitude in XX12
\
\   XX12(3 2)           The dot product of [x y z] vector with the roofv (or _y)
\                       vector, with the sign in XX12+3 and magnitude in XX12+2
\
\   XX12(5 4)           The dot product of [x y z] vector with the nosev (or _z)
\                       vector, with the sign in XX12+5 and magnitude in XX12+4
\
\ ******************************************************************************

.LL51

 LDX #0                 \ Set X = 0, which will contain the offset of the vector
                        \ to use in the calculation, increasing by 6 for each
                        \ new vector

 LDY #0                 \ Set Y = 0, which will contain the offset of the
                        \ result bytes in XX12, increasing by 2 for each new
                        \ result

.ll51

 LDA XX15               \ Set Q = x_lo
 STA Q

 LDA XX16,X             \ Set A = |sidev_x|

 JSR FMLTU              \ Set T = A * Q / 256
 STA T                  \       = |sidev_x| * x_lo / 256

 LDA XX15+1             \ Set S to the sign of x_sign * sidev_x
 EOR XX16+1,X
 STA S

 LDA XX15+2             \ Set Q = y_lo
 STA Q

 LDA XX16+2,X           \ Set A = |sidev_y|

 JSR FMLTU              \ Set Q = A * Q / 256
 STA Q                  \       = |sidev_y| * y_lo / 256

 LDA T                  \ Set R = T
 STA R                  \       = |sidev_x| * x_lo / 256

 LDA XX15+3             \ Set A to the sign of y_sign * sidev_y
 EOR XX16+3,X

 JSR LL38               \ Set (S T) = (S R) + (A Q)
 STA T                  \           = |sidev_x| * x_lo + |sidev_y| * y_lo

 LDA XX15+4             \ Set Q = z_lo
 STA Q

 LDA XX16+4,X           \ Set A = |sidev_z|

 JSR FMLTU              \ Set Q = A * Q / 256
 STA Q                  \       = |sidev_z| * z_lo / 256

 LDA T                  \ Set R = T
 STA R                  \       = |sidev_x| * x_lo + |sidev_y| * y_lo

 LDA XX15+5             \ Set A to the sign of z_sign * sidev_z
 EOR XX16+5,X

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           = |sidev_x| * x_lo + |sidev_y| * y_lo
                        \             + |sidev_z| * z_lo

 STA XX12,Y             \ Store the result in XX12+Y(1 0)
 LDA S
 STA XX12+1,Y

 INY                    \ Set Y = Y + 2
 INY

 TXA                    \ Set X = X + 6
 CLC
 ADC #6
 TAX

 CMP #17                \ If X < 17, loop back to ll51 for the next vector
 BCC ll51

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL9 (Part 1 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Check if ship is exploding, check if ship is in front
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This routine draws the current ship on the screen. This part checks to see if
\ the ship is exploding, or if it should start exploding, and if it does it sets
\ things up accordingly.
\
\ It also does some basic checks to see if we can see the ship, and if not it
\ removes it from the screen.
\
\ In this code, XX1 is used to point to the current ship's data block at INWK
\ (the two labels are interchangeable).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX1                 XX1 shares its location with INWK, which contains the
\                       zero-page copy of the data block for this ship from the
\                       K% workspace
\
\   INF                 The address of the data block for this ship in workspace
\                       K%
\
\   XX19(1 0)           XX19(1 0) shares its location with INWK(34 33), which
\                       contains the ship line heap address pointer
\
\   XX0                 The address of the blueprint for this ship
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   EE51                Remove the current ship from the screen, called from
\                       SHPPT before drawing the ship as a point
\
\ ******************************************************************************

.LL25

 JMP PLANET             \ Jump to the PLANET routine, returning from the
                        \ subroutine using a tail call

.LL9

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI LL25               \ planet or sun, so jump to PLANET via LL25 above

 LDA #31                \ Set XX4 = 31 to store the ship's distance for later
 STA XX4                \ comparison with the visibility distance. We will
                        \ update this value below with the actual ship's
                        \ distance if it turns out to be visible on-screen

 LDA #%00100000         \ If bit 5 of the ship's byte #31 is set, then the ship
 BIT XX1+31             \ is currently exploding, so jump down to EE28
 BNE EE28

 BPL EE28               \ If bit 7 of the ship's byte #31 is clear then the ship
                        \ has not just been killed, so jump down to EE28

                        \ Otherwise bit 5 is clear and bit 7 is set, so the ship
                        \ is not yet exploding but it has been killed, so we
                        \ need to start an explosion

 ORA XX1+31             \ Clear bits 6 and 7 of the ship's byte #31, to stop the
 AND #%00111111         \ ship from firing its laser and to mark it as no longer
 STA XX1+31             \ having just been killed

 LDA #0                 \ Set the ship's acceleration in byte #31 to 0, updating
 LDY #28                \ the byte in the workspace K% data block so we don't
 STA (INF),Y            \ have to copy it back from INWK later

 LDY #30                \ Set the ship's pitch counter in byte #30 to 0, to stop
 STA (INF),Y            \ the ship from pitching

 JSR EE51               \ Call EE51 to remove the ship from the screen

                        \ We now need to set up a new explosion cloud. We
                        \ initialise it with a size of 18 (which gets increased
                        \ by 4 every time the cloud gets redrawn), and the
                        \ explosion count (i.e. the number of particles in the
                        \ explosion), which go into bytes 1 and 2 of the ship
                        \ line heap. See DOEXP for more details of explosion
                        \ clouds

 LDY #1                 \ Set byte #1 of the ship line heap to 18, the initial
 LDA #18                \ size of the explosion cloud
 STA (XX19),Y

 LDY #7                 \ Fetch byte #7 from the ship's blueprint, which
 LDA (XX0),Y            \ determines the explosion count (i.e. the number of
 LDY #2                 \ vertices used as origins for explosion clouds), and
 STA (XX19),Y           \ store it in byte #2 of the ship line heap

\LDA XX1+32             \ These instructions are commented out in the original
\AND #&7F               \ source

                        \ The following loop sets bytes 3-6 of the of the ship
                        \ line heap to random numbers

.EE55

 INY                    \ Increment Y (so the loop starts at 3)

 JSR DORND              \ Set A and X to random numbers

 STA (XX19),Y           \ Store A in the Y-th byte of the ship line heap

 CPY #6                 \ Loop back until we have randomised the 6th byte
 BNE EE55

.EE28

 LDA XX1+8              \ Set A = z_sign

.EE49

 BPL LL10               \ If A is positive, i.e. the ship is in front of us,
                        \ jump down to LL10

.LL14

                        \ The following removes the ship from the screen by
                        \ redrawing it (or, if it is exploding, by redrawing the
                        \ explosion cloud). We call it when the ship is no
                        \ longer on-screen, is too far away to be fully drawn,
                        \ and so on

 LDA XX1+31             \ If bit 5 of the ship's byte #31 is clear, then the
 AND #%00100000         \ ship is not currently exploding, so jump down to EE51
 BEQ EE51               \ to redraw its wireframe

 LDA XX1+31             \ The ship is exploding, so clear bit 3 of the ship's
 AND #%11110111         \ byte #31 to denote that the ship is no longer being
 STA XX1+31             \ drawn on-screen

 JMP DOEXP              \ Jump to DOEXP to display the explosion cloud, which
                        \ will remove it from the screen, returning from the
                        \ subroutine using a tail call

.EE51

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is clear, then there
 BIT XX1+31             \ is already nothing being shown for this ship, so
 BEQ LL10-1             \ return from the subroutine (as LL10-1 contains an RTS)

 EOR XX1+31             \ Otherwise flip bit 3 of byte #31 and store it (which
 STA XX1+31             \ clears bit 3 as we know it was set before the EOR), so
                        \ this sets this ship as no longer being drawn on-screen

 JMP LL155              \ Jump to LL155 to draw the ship, which removes it from
                        \ the screen, returning from the subroutine using a
                        \ tail call

\.LL24                  \ This label is commented out in the original source,
                        \ and was presumably used to label the RTS which is
                        \ actually called by LL10-1 above, not LL24

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL9 (Part 2 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Check if ship is in field of view, close enough to draw
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part checks whether the ship is in our field of view, and whether it is
\ close enough to be fully drawn (if not, we jump to SHPPT to draw it as a dot).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL10-1              Contains an RTS
\
\ ******************************************************************************

.LL10

 LDA XX1+7              \ Set A = z_hi

 CMP #192               \ If A >= 192 then the ship is a long way away, so jump
 BCS LL14               \ to LL14 to remove the ship from the screen

 LDA XX1                \ If x_lo >= z_lo, set the C flag, otherwise clear it
 CMP XX1+6

 LDA XX1+1              \ Set A = x_hi - z_hi using the carry from the low
 SBC XX1+7              \ bytes, which sets the C flag as if we had done a full
                        \ two-byte subtraction (x_hi x_lo) - (z_hi z_lo)

 BCS LL14               \ If the C flag is set then x >= z, so the ship is
                        \ further to the side than it is in front of us, so it's
                        \ outside our viewing angle of 45 degrees, and we jump
                        \ to LL14 to remove it from the screen

 LDA XX1+3              \ If y_lo >= z_lo, set the C flag, otherwise clear it
 CMP XX1+6

 LDA XX1+4              \ Set A = y_hi - z_hi using the carry from the low
 SBC XX1+7              \ bytes, which sets the C flag as if we had done a full
                        \ two-byte subtraction (y_hi y_lo) - (z_hi z_lo)

 BCS LL14               \ If the C flag is set then y >= z, so the ship is
                        \ further above us than it is in front of us, so it's
                        \ outside our viewing angle of 45 degrees, and we jump
                        \ to LL14 to remove it from the screen

 LDY #6                 \ Fetch byte #6 from the ship's blueprint into X, which
 LDA (XX0),Y            \ is the number * 4 of the vertex used for the ship's
 TAX                    \ laser

 LDA #255               \ Set bytes X and X+1 of the XX3 heap to 255. We're
 STA XX3,X              \ going to use XX3 to store the screen coordinates of
 STA XX3+1,X            \ all the visible vertices of this ship, so setting the
                        \ laser vertex to 255 means that if we don't update this
                        \ vertex with its screen coordinates in parts 6 and 7,
                        \ this vertex's entry in the XX3 heap will still be 255,
                        \ which we can check in part 9 to see if the laser
                        \ vertex is visible (and therefore whether we should
                        \ draw laser lines if the ship is firing on us)

 LDA XX1+6              \ Set (A T) = (z_hi z_lo)
 STA T
 LDA XX1+7

 LSR A                  \ Set (A T) = (A T) / 8
 ROR T
 LSR A
 ROR T
 LSR A
 ROR T

 LSR A                  \ If A >> 4 is non-zero, i.e. z_hi >= 16, jump to LL13
 BNE LL13               \ as the ship is possibly far away enough to be shown as
                        \ a dot

 LDA T                  \ Otherwise the C flag contains the previous bit 0 of A,
 ROR A                  \ which could have been set, so rotate A right four
 LSR A                  \ times so it's in the form %000xxxxx, i.e. z_hi reduced
 LSR A                  \ to a maximum value of 31
 LSR A

 STA XX4                \ Store A in XX4, which is now the distance of the ship
                        \ we can use for visibility testing

 BPL LL17               \ Jump down to LL17 (this BPL is effectively a JMP as we
                        \ know bit 7 of A is definitely clear)

.LL13

                        \ If we get here then the ship is possibly far enough
                        \ away to be shown as a dot

 LDY #13                \ Fetch byte #13 from the ship's blueprint, which gives
 LDA (XX0),Y            \ the ship's visibility distance, beyond which we show
                        \ the ship as a dot

 CMP XX1+7              \ If z_hi <= the visibility distance, skip to LL17 to
 BCS LL17               \ draw the ship fully, rather than as a dot, as it is
                        \ closer than the visibility distance

 LDA #%00100000         \ If bit 5 of the ship's byte #31 is set, then the
 AND XX1+31             \ ship is currently exploding, so skip to LL17 to draw
 BNE LL17               \ the ship's explosion cloud

 JMP SHPPT              \ Otherwise jump to SHPPT to draw the ship as a dot,
                        \ returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: LL9 (Part 3 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Set up orientation vector, ship coordinate variables
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part sets up the following variable blocks:
\
\   * XX16 contains the orientation vectors, divided to normalise them
\
\   * XX18 contains the ship's x, y and z coordinates in space
\
\ ******************************************************************************

.LL17

 LDX #5                 \ First we copy the three orientation vectors into XX16,
                        \ so set up a counter in X for the 6 bytes in each
                        \ vector

.LL15

 LDA XX1+21,X           \ Copy the X-th byte of sidev to the X-th byte of XX16
 STA XX16,X

 LDA XX1+15,X           \ Copy the X-th byte of roofv to XX16+6 to the X-th byte
 STA XX16+6,X           \ of XX16+6

 LDA XX1+9,X            \ Copy the X-th byte of nosev to XX16+12 to the X-th
 STA XX16+12,X          \ byte of XX16+12

 DEX                    \ Decrement the counter

 BPL LL15               \ Loop back to copy the next byte of each vector, until
                        \ we have the following:
                        \
                        \   * XX16(1 0) = sidev_x
                        \   * XX16(3 2) = sidev_y
                        \   * XX16(5 4) = sidev_z
                        \
                        \   * XX16(7 6) = roofv_x
                        \   * XX16(9 8) = roofv_y
                        \   * XX16(11 10) = roofv_z
                        \
                        \   * XX16(13 12) = nosev_x
                        \   * XX16(15 14) = nosev_y
                        \   * XX16(17 16) = nosev_z

 LDA #197               \ Set Q = 197
 STA Q

 LDY #16                \ Set Y to be a counter that counts down by 2 each time,
                        \ starting with 16, then 14, 12 and so on. We use this
                        \ to work through each of the coordinates in each of the
                        \ orientation vectors

.LL21

 LDA XX16,Y             \ Set A = the low byte of the vector coordinate, e.g.
                        \ nosev_z_lo when Y = 16

 ASL A                  \ Shift bit 7 into the C flag

 LDA XX16+1,Y           \ Set A = the high byte of the vector coordinate, e.g.
                        \ nosev_z_hi when Y = 16

 ROL A                  \ Rotate A left, incorporating the C flag, so A now
                        \ contains the original high byte, doubled, and without
                        \ a sign bit, e.g. A = |nosev_z_hi| * 2

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \
                        \ so, for nosev, this would be:
                        \
                        \   R = 256 * |nosev_z_hi| * 2 / 197
                        \     = 2.6 * |nosev_z_hi|

 LDX R                  \ Store R in the low byte's location, so we can keep the
 STX XX16,Y             \ old, unscaled high byte intact for the sign

 DEY                    \ Decrement the loop counter twice
 DEY

 BPL LL21               \ Loop back for the next vector coordinate until we have
                        \ divided them all

                        \ By this point, the vectors have been turned into
                        \ scaled magnitudes, so we have the following:
                        \
                        \   * XX16   = scaled |sidev_x|
                        \   * XX16+2 = scaled |sidev_y|
                        \   * XX16+4 = scaled |sidev_z|
                        \
                        \   * XX16+6  = scaled |roofv_x|
                        \   * XX16+8  = scaled |roofv_y|
                        \   * XX16+10 = scaled |roofv_z|
                        \
                        \   * XX16+12 = scaled |nosev_x|
                        \   * XX16+14 = scaled |nosev_y|
                        \   * XX16+16 = scaled |nosev_z|

 LDX #8                 \ Next we copy the ship's coordinates into XX18, so set
                        \ up a counter in X for 9 bytes

.ll91

 LDA XX1,X              \ Copy the X-th byte from XX1 to XX18
 STA XX18,X

 DEX                    \ Decrement the loop counter

 BPL ll91               \ Loop back for the next byte until we have copied all
                        \ three coordinates

                        \ So we now have the following:
                        \
                        \   * XX18(2 1 0) = (x_sign x_hi x_lo)
                        \
                        \   * XX18(5 4 3) = (y_sign y_hi y_lo)
                        \
                        \   * XX18(8 7 6) = (z_sign z_hi z_lo)

 LDA #255               \ Set the 15th byte of XX2 to 255, so that face 15 is
 STA XX2+15             \ always visible. No ship definitions actually have this
                        \ number of faces, but this allows us to force a vertex
                        \ to always be visible by associating it with face 15
                        \ (see the ship blueprints for the Cobra Mk III at
                        \ SHIP_COBRA_MK_3 and the asteroid at SHIP_ASTEROID for
                        \ examples of vertices that are associated with face 15)

 LDY #12                \ Set Y = 12 to point to the ship blueprint byte #12,

 LDA XX1+31             \ If bit 5 of the ship's byte #31 is clear, then the
 AND #%00100000         \ ship is not currently exploding, so jump down to EE29
 BEQ EE29               \ to skip the following

                        \ Otherwise we fall through to set up the visibility
                        \ block for an exploding ship

\ ******************************************************************************
\
\       Name: LL9 (Part 4 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Set visibility for exploding ship (all faces visible)
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part sets up the visibility block in XX2 for a ship that is exploding.
\
\ The XX2 block consists of one byte for each face in the ship's blueprint,
\ which holds the visibility of that face. Because the ship is exploding, we
\ want to set all the faces to be visible. A value of 255 in the visibility
\ table means the face is visible, so the following code sets each face to 255
\ and then skips over the face visibility calculations that we would apply to a
\ non-exploding ship.
\
\ ******************************************************************************

 LDA (XX0),Y            \ Fetch byte #12 of the ship's blueprint, which contains
                        \ the number of faces * 4

 LSR A                  \ Set X = A / 4
 LSR A                  \       = the number of faces
 TAX

 LDA #255               \ Set A = 255

.EE30

 STA XX2,X              \ Set the X-th byte of XX2 to 255

 DEX                    \ Decrement the loop counter

 BPL EE30               \ Loop back for the next byte until there is one byte
                        \ set to 255 for each face

 INX                    \ Set XX4 = 0 for the distance value we use to test
 STX XX4                \ for visibility, so we always shows everything

.LL41

 JMP LL42               \ Jump to LL42 to skip the face visibility calculations
                        \ as we don't need to do them now we've set up the XX2
                        \ block for the explosion

\ ******************************************************************************
\
\       Name: LL9 (Part 5 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's faces
\  Deep dive: Drawing ships
\             Back-face culling
\
\ ******************************************************************************

.EE29

 LDA (XX0),Y            \ We set Y to 12 above before jumping down to EE29, so
                        \ this fetches byte #12 of the ship's blueprint, which
                        \ contains the number of faces * 4

 BEQ LL41               \ If there are no faces in this ship, jump to LL42 (via
                        \ LL41) to skip the face visibility calculations

 STA XX20               \ Set A = the number of faces * 4

 LDY #18                \ Fetch byte #18 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the factor by which we scale the face normals, into X
 TAX

 LDA XX18+7             \ Set A = z_hi

.LL90

 TAY                    \ Set Y = z_hi

 BEQ LL91               \ If z_hi = 0 then jump to LL91

                        \ The following is a loop that jumps back to LL90+3,
                        \ i.e. here. LL90 is only used for this loop, so it's a
                        \ bit of a strange use of the label here

 INX                    \ Increment the scale factor in X

 LSR XX18+4             \ Divide (y_hi y_lo) by 2
 ROR XX18+3

 LSR XX18+1             \ Divide (x_hi x_lo) by 2
 ROR XX18

 LSR A                  \ Divide (z_hi z_lo) by 2 (as A contains z_hi)
 ROR XX18+6

 TAY                    \ Set Y = z_hi

 BNE LL90+3             \ If Y is non-zero, loop back to LL90+3 to divide the
                        \ three coordinates until z_hi is 0

.LL91

                        \ By this point z_hi is 0 and X contains the number of
                        \ right shifts we had to do, plus the scale factor from
                        \ the blueprint

 STX XX17               \ Store the updated scale factor in XX17

 LDA XX18+8             \ Set XX15+5 = z_sign
 STA XX15+5

 LDA XX18               \ Set XX15(1 0) = (x_sign x_lo)
 STA XX15
 LDA XX18+2
 STA XX15+1

 LDA XX18+3             \ Set XX15(3 2) = (y_sign y_lo)
 STA XX15+2
 LDA XX18+5
 STA XX15+3

 LDA XX18+6             \ Set XX15+4 = z_lo, so now XX15(5 4) = (z_sign z_lo)
 STA XX15+4

 JSR LL51               \ Call LL51 to set XX12 to the dot products of XX15 and
                        \ XX16, which we'll call dot_sidev, dot_roofv and
                        \ dot_nosev:
                        \
                        \   XX12(1 0) = [x y z] . sidev
                        \             = (dot_sidev_sign dot_sidev_lo)
                        \             = dot_sidev
                        \
                        \   XX12(3 2) = [x y z] . roofv
                        \             = (dot_roofv_sign dot_roofv_lo)
                        \             = dot_roofv
                        \
                        \   XX12(5 4) = [x y z] . nosev
                        \             = (dot_nosev_sign dot_nosev_lo)
                        \             = dot_nosev

 LDA XX12               \ Set XX18(2 0) = dot_sidev
 STA XX18
 LDA XX12+1
 STA XX18+2

 LDA XX12+2             \ Set XX18(5 3) = dot_roofv
 STA XX18+3
 LDA XX12+3
 STA XX18+5

 LDA XX12+4             \ Set XX18(8 6) = dot_nosev
 STA XX18+6
 LDA XX12+5
 STA XX18+8

 LDY #4                 \ Fetch byte #4 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the low byte of the offset to the faces data

 CLC                    \ Set V = low byte faces offset + XX0
 ADC XX0
 STA V

 LDY #17                \ Fetch byte #17 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the high byte of the offset to the faces data

 ADC XX0+1              \ Set V+1 = high byte faces offset + XX0+1
 STA V+1                \
                        \ So V(1 0) now points to the start of the faces data
                        \ for this ship

 LDY #0                 \ We're now going to loop through all the faces for this
                        \ ship, so set a counter in Y, starting from 0, which we
                        \ will increment by 4 each loop to step through the
                        \ four bytes of data for each face

.LL86

 LDA (V),Y              \ Fetch byte #0 for this face into A, so:
                        \
                        \   A = %xyz vvvvv, where:
                        \
                        \     * Bits 0-4 = visibility distance, beyond which the
                        \       face is always shown
                        \
                        \     * Bits 7-5 = the sign bits of normal_x, normal_y
                        \       and normal_z

 STA XX12+1             \ Store byte #0 in XX12+1, so XX12+1 now has the sign of
                        \ normal_x

 AND #%00011111         \ Extract bits 0-4 to give the visibility distance

 CMP XX4                \ If XX4 <= the visibility distance, where XX4 contains
 BCS LL87               \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), skip to LL87 as this face is close enough
                        \ that we have to test its visibility using the face
                        \ normals

                        \ Otherwise this face is within range and is therefore
                        \ always shown

 TYA                    \ Set X = Y / 4
 LSR A                  \       = the number of this face * 4 /4
 LSR A                  \       = the number of this face
 TAX

 LDA #255               \ Set the X-th byte of XX2 to 255 to denote that this
 STA XX2,X              \ face is visible

 TYA                    \ Set Y = Y + 4 to point to the next face
 ADC #4
 TAY

 JMP LL88               \ Jump down to LL88 to skip the following, as we don't
                        \ need to test the face normals

.LL87

 LDA XX12+1             \ Fetch byte #0 for this face into A

 ASL A                  \ Shift A left and store it, so XX12+3 now has the sign
 STA XX12+3             \ of normal_y

 ASL A                  \ Shift A left and store it, so XX12+5 now has the sign
 STA XX12+5             \ of normal_z

 INY                    \ Increment Y to point to byte #1

 LDA (V),Y              \ Fetch byte #1 for this face and store in XX12, so
 STA XX12               \ XX12 = normal_x

 INY                    \ Increment Y to point to byte #2

 LDA (V),Y              \ Fetch byte #2 for this face and store in XX12+2, so
 STA XX12+2             \ XX12+2 = normal_y

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this face and store in XX12+4, so
 STA XX12+4             \ XX12+4 = normal_z

                        \ So we now have:
                        \
                        \   XX12(1 0) = (normal_x_sign normal_x)
                        \
                        \   XX12(3 2) = (normal_y_sign normal_y)
                        \
                        \   XX12(5 4) = (normal_z_sign normal_z)

 LDX XX17               \ If XX17 < 4 then jump to LL92, otherwise we stored a
 CPX #4                 \ larger scale factor above
 BCC LL92

.LL143

 LDA XX18               \ Set XX15(1 0) = XX18(2 0)
 STA XX15               \               = dot_sidev
 LDA XX18+2
 STA XX15+1

 LDA XX18+3             \ Set XX15(3 2) = XX18(5 3)
 STA XX15+2             \               = dot_roofv
 LDA XX18+5
 STA XX15+3

 LDA XX18+6             \ Set XX15(5 4) = XX18(8 6)
 STA XX15+4             \               = dot_nosev
 LDA XX18+8
 STA XX15+5

 JMP LL89               \ Jump down to LL89

.ovflw

                        \ If we get here then the addition below overflowed, so
                        \ we halve the dot products and normal vector

 LSR XX18               \ Divide dot_sidev_lo by 2, so dot_sidev = dot_sidev / 2

 LSR XX18+6             \ Divide dot_nosev_lo by 2, so dot_nosev = dot_nosev / 2

 LSR XX18+3             \ Divide dot_roofv_lo by 2, so dot_roofv = dot_roofv / 2

 LDX #1                 \ Set X = 1 so when we fall through into LL92, we divide
                        \ the normal vector by 2 as well

.LL92

                        \ We jump here from above with the scale factor in X,
                        \ and now we apply it by scaling the normal vector down
                        \ by a factor of 2^X (i.e. divide by 2^X)

 LDA XX12               \ Set XX15 = normal_x
 STA XX15

 LDA XX12+2             \ Set XX15+2 = normal_y
 STA XX15+2

 LDA XX12+4             \ Set A = normal_z

.LL93

 DEX                    \ Decrement the scale factor in X

 BMI LL94               \ If X was 0 before the decrement, there is no scaling
                        \ to do, so jump to LL94 to exit the loop

 LSR XX15               \ Set XX15 = XX15 / 2
                        \          = normal_x / 2

 LSR XX15+2             \ Set XX15+2 = XX15+2 / 2
                        \            = normal_y / 2

 LSR A                  \ Set A = A / 2
                        \       = normal_z / 2

 DEX                    \ Decrement the scale factor in X

 BPL LL93+3             \ If we have more scaling to do, loop back up to the
                        \ first LSR above until the normal vector is scaled down

.LL94

 STA R                  \ Set R = normal_z

 LDA XX12+5             \ Set S = normal_z_sign
 STA S

 LDA XX18+6             \ Set Q = dot_nosev_lo
 STA Q

 LDA XX18+8             \ Set A = dot_nosev_sign

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           = normal_z + dot_nosev
                        \
                        \ setting the sign of the result in S

 BCS ovflw              \ If the addition overflowed, jump up to ovflw to divide
                        \ both the normal vector and dot products by 2 and try
                        \ again

 STA XX15+4             \ Set XX15(5 4) = (S A)
 LDA S                  \               = normal_z + dot_nosev
 STA XX15+5

 LDA XX15               \ Set R = normal_x
 STA R

 LDA XX12+1             \ Set S = normal_x_sign
 STA S

 LDA XX18               \ Set Q = dot_sidev_lo
 STA Q

 LDA XX18+2             \ Set A = dot_sidev_sign

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           = normal_x + dot_sidev
                        \
                        \ setting the sign of the result in S

 BCS ovflw              \ If the addition overflowed, jump up to ovflw to divide
                        \ both the normal vector and dot products by 2 and try
                        \ again

 STA XX15               \ Set XX15(1 0) = (S A)
 LDA S                  \               = normal_x + dot_sidev
 STA XX15+1

 LDA XX15+2             \ Set R = normal_y
 STA R

 LDA XX12+3             \ Set S = normal_y_sign
 STA S

 LDA XX18+3             \ Set Q = dot_roofv_lo
 STA Q

 LDA XX18+5             \ Set A = dot_roofv_sign

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           = normal_y + dot_roofv

 BCS ovflw              \ If the addition overflowed, jump up to ovflw to divide
                        \ both the normal vector and dot products by 2 and try
                        \ again

 STA XX15+2             \ Set XX15(3 2) = (S A)
 LDA S                  \               = normal_y + dot_roofv
 STA XX15+3

.LL89

                        \ When we get here, we have set up the following:
                        \
                        \   XX15(1 0) = normal_x + dot_sidev
                        \             = normal_x + [x y z] . sidev
                        \
                        \   XX15(3 2) = normal_y + dot_roofv
                        \             = normal_y + [x y z] . roofv
                        \
                        \   XX15(5 4) = normal_z + dot_nosev
                        \             = normal_z + [x y z] . nosev
                        \
                        \ and:
                        \
                        \   XX12(1 0) = (normal_x_sign normal_x)
                        \
                        \   XX12(3 2) = (normal_y_sign normal_y)
                        \
                        \   XX12(5 4) = (normal_z_sign normal_z)
                        \
                        \ We now calculate the dot product XX12 . XX15 to tell
                        \ us whether or not this face is visible

 LDA XX12               \ Set Q = XX12
 STA Q

 LDA XX15               \ Set A = XX15

 JSR FMLTU              \ Set T = A * Q / 256
 STA T                  \       = XX15 * XX12 / 256

 LDA XX12+1             \ Set S = sign of XX15(1 0) * XX12(1 0), so:
 EOR XX15+1             \
 STA S                  \   (S T) = XX15(1 0) * XX12(1 0) / 256

 LDA XX12+2             \ Set Q = XX12+2
 STA Q

 LDA XX15+2             \ Set A = XX15+2

 JSR FMLTU              \ Set Q = A * Q
 STA Q                  \       = XX15+2 * XX12+2 / 256

 LDA T                  \ Set T = R, so now:
 STA R                  \
                        \   (S R) = XX15(1 0) * XX12(1 0) / 256

 LDA XX12+3             \ Set A = sign of XX15+3 * XX12+3, so:
 EOR XX15+3             \
                        \   (A Q) = XX15(3 2) * XX12(3 2) / 256

 JSR LL38               \ Set (S T) = (S R) + (A Q)
 STA T                  \           =   XX15(1 0) * XX12(1 0) / 256
                        \             + XX15(3 2) * XX12(3 2) / 256

 LDA XX12+4             \ Set Q = XX12+4
 STA Q

 LDA XX15+4             \ Set A = XX15+4

 JSR FMLTU              \ Set Q = A * Q
 STA Q                  \       = XX15+4 * XX12+4 / 256

 LDA T                  \ Set T = R, so now:
 STA R                  \
                        \   (S R) =   XX15(1 0) * XX12(1 0) / 256
                        \           + XX15(3 2) * XX12(3 2) / 256

 LDA XX15+5             \ Set A = sign of XX15+5 * XX12+5, so:
 EOR XX12+5             \
                        \   (A Q) = XX15(5 4) * XX12(5 4) / 256

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           =   XX15(1 0) * XX12(1 0) / 256
                        \             + XX15(3 2) * XX12(3 2) / 256
                        \             + XX15(5 4) * XX12(5 4) / 256

 PHA                    \ Push the result A onto the stack, so the stack now
                        \ contains the dot product XX12 . XX15

 TYA                    \ Set X = Y / 4
 LSR A                  \       = the number of this face * 4 /4
 LSR A                  \       = the number of this face
 TAX

 PLA                    \ Pull the dot product off the stack into A

 BIT S                  \ If bit 7 of S is set, i.e. the dot product is
 BMI P%+4               \ negative, then this face is visible as its normal is
                        \ pointing towards us, so skip the following instruction

 LDA #0                 \ Otherwise the face is not visible, so set A = 0 so we
                        \ can store this to mean "not visible"

 STA XX2,X              \ Store the face's visibility in the X-th byte of XX2

 INY                    \ Above we incremented Y to point to byte #3, so this
                        \ increments Y to point to byte #4, i.e. byte #0 of the
                        \ next face

.LL88

 CPY XX20               \ If Y >= XX20, the number of faces * 4, jump down to
 BCS LL42               \ LL42 to move on to the

 JMP LL86               \ Otherwise loop back to LL86 to work out the visibility
                        \ of the next face

\ ******************************************************************************
\
\       Name: LL9 (Part 6 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's vertices
\  Deep dive: Drawing ships
\             Calculating vertex coordinates
\
\ ------------------------------------------------------------------------------
\
\ This section calculates the visibility of each of the ship's vertices, and for
\ those that are visible, it starts the process of calculating the screen
\ coordinates of each vertex
\
\ ******************************************************************************

.LL42

                        \ The first task is to set up the inverse matrix, ready
                        \ for us to send to the dot product routine at LL51.
                        \ Back up in part 3, we set up the following variables:
                        \
                        \   * XX16(1 0) = sidev_x
                        \   * XX16(3 2) = sidev_y
                        \   * XX16(5 4) = sidev_z
                        \
                        \   * XX16(7 6) = roofv_x
                        \   * XX16(9 8) = roofv_y
                        \   * XX16(11 10) = roofv_z
                        \
                        \   * XX16(13 12) = nosev_x
                        \   * XX16(15 14) = nosev_y
                        \   * XX16(17 16) = nosev_z
                        \
                        \ and we then scaled the vectors to give the following:
                        \
                        \   * XX16   = scaled |sidev_x|
                        \   * XX16+2 = scaled |sidev_y|
                        \   * XX16+4 = scaled |sidev_z|
                        \
                        \   * XX16+6  = scaled |roofv_x|
                        \   * XX16+8  = scaled |roofv_y|
                        \   * XX16+10 = scaled |roofv_z|
                        \
                        \   * XX16+12 = scaled |nosev_x|
                        \   * XX16+14 = scaled |nosev_y|
                        \   * XX16+16 = scaled |nosev_z|
                        \
                        \ We now need to rearrange these locations so they
                        \ effectively transpose the matrix into its inverse

 LDY XX16+2             \ Set XX16+2 = XX16+6 = scaled |roofv_x|
 LDX XX16+3             \ Set XX16+3 = XX16+7 = roofv_x_hi
 LDA XX16+6             \ Set XX16+6 = XX16+2 = scaled |sidev_y|
 STA XX16+2             \ Set XX16+7 = XX16+3 = sidev_y_hi
 LDA XX16+7
 STA XX16+3
 STY XX16+6
 STX XX16+7

 LDY XX16+4             \ Set XX16+4 = XX16+12 = scaled |nosev_x|
 LDX XX16+5             \ Set XX16+5 = XX16+13 = nosev_x_hi
 LDA XX16+12            \ Set XX16+12 = XX16+4 = scaled |sidev_z|
 STA XX16+4             \ Set XX16+13 = XX16+5 = sidev_z_hi
 LDA XX16+13
 STA XX16+5
 STY XX16+12
 STX XX16+13

 LDY XX16+10            \ Set XX16+10 = XX16+14 = scaled |nosev_y|
 LDX XX16+11            \ Set XX16+11 = XX16+15 = nosev_y_hi
 LDA XX16+14            \ Set XX16+14 = XX16+10 = scaled |roofv_z|
 STA XX16+10            \ Set XX16+15 = XX16+11 = roofv_z
 LDA XX16+15
 STA XX16+11
 STY XX16+14
 STX XX16+15

                        \ So now we have the following sign-magnitude variables
                        \ containing parts of the scaled orientation vectors:
                        \
                        \   XX16(1 0)   = scaled sidev_x
                        \   XX16(3 2)   = scaled roofv_x
                        \   XX16(5 4)   = scaled nosev_x
                        \
                        \   XX16(7 6)   = scaled sidev_y
                        \   XX16(9 8)   = scaled roofv_y
                        \   XX16(11 10) = scaled nosev_y
                        \
                        \   XX16(13 12) = scaled sidev_z
                        \   XX16(15 14) = scaled roofv_z
                        \   XX16(17 16) = scaled nosev_z
                        \
                        \ which is what we want, as the various vectors are now
                        \ arranged so we can use LL51 to multiply by the
                        \ transpose (i.e. the inverse of the matrix)

 LDY #8                 \ Fetch byte #8 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number of vertices * 8, and store it in XX20
 STA XX20

                        \ We now set V(1 0) = XX0(1 0) + 20, so V(1 0) points
                        \ to byte #20 of the ship's blueprint, which is always
                        \ where the vertex data starts (i.e. just after the 20
                        \ byte block that define the ship's characteristics)

 LDA XX0                \ We start with the low bytes
 CLC
 ADC #20
 STA V

 LDA XX0+1              \ And then do the high bytes
 ADC #0
 STA V+1

 LDY #0                 \ We are about to step through all the vertices, using
                        \ Y as a counter. There are six data bytes for each
                        \ vertex, so we will increment Y by 6 for each iteration
                        \ so it can act as an offset from V(1 0) to the current
                        \ vertex's data

 STY CNT                \ Set CNT = 0, which we will use as a pointer to the
                        \ heap at XX3, starting it at zero so the heap starts
                        \ out empty

.LL48

 STY XX17               \ Set XX17 = Y, so XX17 now contains the offset of the
                        \ current vertex's data

 LDA (V),Y              \ Fetch byte #0 for this vertex into XX15, so:
 STA XX15               \
                        \   XX15 = magnitude of the vertex's x-coordinate

 INY                    \ Increment Y to point to byte #1

 LDA (V),Y              \ Fetch byte #1 for this vertex into XX15+2, so:
 STA XX15+2             \
                        \   XX15+2 = magnitude of the vertex's y-coordinate

 INY                    \ Increment Y to point to byte #2

 LDA (V),Y              \ Fetch byte #2 for this vertex into XX15+4, so:
 STA XX15+4             \
                        \   XX15+4 = magnitude of the vertex's z-coordinate

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this vertex into T, so:
 STA T                  \
                        \   T = %xyz vvvvv, where:
                        \
                        \     * Bits 0-4 = visibility distance, beyond which the
                        \                  vertex is not shown
                        \
                        \     * Bits 7-5 = the sign bits of x, y and z

 AND #%00011111         \ Extract bits 0-4 to get the visibility distance

 CMP XX4                \ If XX4 > the visibility distance, where XX4 contains
 BCC LL49-3             \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), then this vertex is too far away to be
                        \ visible, so jump down to LL50 (via the JMP instruction
                        \ in LL49-3) to move on to the next vertex

 INY                    \ Increment Y to point to byte #4

 LDA (V),Y              \ Fetch byte #4 for this vertex into P, so:
 STA P                  \
                        \  P = %ffff ffff, where:
                        \
                        \    * Bits 0-3 = the number of face 1
                        \
                        \    * Bits 4-7 = the number of face 2

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 1 is visible, so jump to LL49

 LDA P                  \ Fetch byte #4 for this vertex into A

 LSR A                  \ Shift right four times to extract the number of face 2
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 2 is visible, so jump to LL49

 INY                    \ Increment Y to point to byte #5

 LDA (V),Y              \ Fetch byte #5 for this vertex into P, so:
 STA P                  \
                        \  P = %ffff ffff, where:
                        \
                        \    * Bits 0-3 = the number of face 3
                        \
                        \    * Bits 4-7 = the number of face 4

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 3 is visible, so jump to LL49

 LDA P                  \ Fetch byte #5 for this vertex into A

 LSR A                  \ Shift right four times to extract the number of face 4
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 4 is visible, so jump to LL49

 JMP LL50               \ If we get here then none of the four faces associated
                        \ with this vertex are visible, so this vertex is also
                        \ not visible, so jump to LL50 to move on to the next
                        \ vertex

.LL49

 LDA T                  \ Fetch byte #5 for this vertex into A and store it, so
 STA XX15+1             \ XX15+1 now has the sign of the vertex's x-coordinate

 ASL A                  \ Shift A left and store it, so XX15+3 now has the sign
 STA XX15+3             \ of the vertex's y-coordinate

 ASL A                  \ Shift A left and store it, so XX15+5 now has the sign
 STA XX15+5             \ of the vertex's z-coordinate

                        \ By this point we have the following:
                        \
                        \   XX15(1 0) = vertex x-coordinate
                        \   XX15(3 2) = vertex y-coordinate
                        \   XX15(5 4) = vertex z-coordinate
                        \
                        \   XX16(1 0)   = scaled sidev_x
                        \   XX16(3 2)   = scaled roofv_x
                        \   XX16(5 4)   = scaled nosev_x
                        \
                        \   XX16(7 6)   = scaled sidev_y
                        \   XX16(9 8)   = scaled roofv_y
                        \   XX16(11 10) = scaled nosev_y
                        \
                        \   XX16(13 12) = scaled sidev_z
                        \   XX16(15 14) = scaled roofv_z
                        \   XX16(17 16) = scaled nosev_z

 JSR LL51               \ Call LL51 to set XX12 to the dot products of XX15 and
                        \ XX16, as follows:
                        \
                        \   XX12(1 0) = [ x y z ] . [ sidev_x roofv_x nosev_x ]
                        \
                        \   XX12(3 2) = [ x y z ] . [ sidev_y roofv_y nosev_y ]
                        \
                        \   XX12(5 4) = [ x y z ] . [ sidev_z roofv_z nosev_z ]
                        \
                        \ XX12 contains the vector from the ship's centre to
                        \ the vertex, transformed from the orientation vector
                        \ space to the universe orientated around our ship. So
                        \ we can refer to this vector below, let's call it
                        \ vertv, so:
                        \
                        \   vertv_x = [ x y z ] . [ sidev_x roofv_x nosev_x ]
                        \
                        \   vertv_y = [ x y z ] . [ sidev_y roofv_y nosev_y ]
                        \
                        \   vertv_z = [ x y z ] . [ sidev_z roofv_z nosev_z ]
                        \
                        \ To finish the calculation, we now want to calculate:
                        \
                        \   vertv + [ x y z ]
                        \
                        \ So let's start with the vertv_x + x

 LDA XX1+2              \ Set A = x_sign of the ship's location

 STA XX15+2             \ Set XX15+2 = x_sign

 EOR XX12+1             \ If the sign of x_sign * the sign of vertv_x is
 BMI LL52               \ negative (i.e. they have different signs), skip to
                        \ LL52

 CLC                    \ Set XX15(2 1 0) = XX1(2 1 0) + XX12(1 0)
 LDA XX12               \                 = (x_sign x_hi x_lo) + vertv_x
 ADC XX1                \
 STA XX15               \ Starting with the low bytes

 LDA XX1+1              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_x is 0)
 STA XX15+1

 JMP LL53               \ We've added the x-coordinates, so jump to LL53 to do
                        \ the y-coordinates

.LL52

                        \ If we get here then x_sign and vertv_x have different
                        \ signs, so we need to subtract them to get the result

 LDA XX1                \ Set XX15(2 1 0) = XX1(2 1 0) - XX12(1 0)
 SEC                    \                 = (x_sign x_hi x_lo) - vertv_x
 SBC XX12               \
 STA XX15               \ Starting with the low bytes

 LDA XX1+1              \ And then doing the high bytes (we can subtract 0 here
 SBC #0                 \ as we know the sign byte of vertv_x is 0)
 STA XX15+1

 BCS LL53               \ If the subtraction didn't underflow, then the sign of
                        \ the result is the same sign as x_sign, and that's what
                        \ we want, so we can jump down to LL53 to do the
                        \ y-coordinates

 EOR #%11111111         \ Otherwise we need to negate the result using two's
 STA XX15+1             \ complement, so first we flip the bits of the high byte

 LDA #1                 \ And then subtract the low byte from 1
 SBC XX15
 STA XX15

 BCC P%+4               \ If the above subtraction underflowed then we need to
 INC XX15+1             \ bump the high byte of the result up by 1

 LDA XX15+2             \ And now we flip the sign of the result to get the
 EOR #%10000000         \ correct result
 STA XX15+2

.LL53

                        \ Now for the y-coordinates, vertv_y + y

 LDA XX1+5              \ Set A = y_sign of the ship's location

 STA XX15+5             \ Set XX15+5 = y_sign

 EOR XX12+3             \ If the sign of y_sign * the sign of vertv_y is
 BMI LL54               \ negative (i.e. they have different signs), skip to
                        \ LL54

 CLC                    \ Set XX15(5 4 3) = XX1(5 4 3) + XX12(3 2)
 LDA XX12+2             \                 = (y_sign y_hi y_lo) + vertv_y
 ADC XX1+3              \
 STA XX15+3             \ Starting with the low bytes

 LDA XX1+4              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_y is 0)
 STA XX15+4

 JMP LL55               \ We've added the y-coordinates, so jump to LL55 to do
                        \ the z-coordinates

.LL54

                        \ If we get here then y_sign and vertv_y have different
                        \ signs, so we need to subtract them to get the result

 LDA XX1+3              \ Set XX15(5 4 3) = XX1(5 4 3) - XX12(3 2)
 SEC                    \                 = (y_sign y_hi y_lo) - vertv_y
 SBC XX12+2             \
 STA XX15+3             \ Starting with the low bytes

 LDA XX1+4              \ And then doing the high bytes (we can subtract 0 here
 SBC #0                 \ as we know the sign byte of vertv_z is 0)
 STA XX15+4

 BCS LL55               \ If the subtraction didn't underflow, then the sign of
                        \ the result is the same sign as y_sign, and that's what
                        \ we want, so we can jump down to LL55 to do the
                        \ z-coordinates

 EOR #%11111111         \ Otherwise we need to negate the result using two's
 STA XX15+4             \ complement, so first we flip the bits of the high byte

 LDA XX15+3             \ And then flip the bits of the low byte and add 1
 EOR #%11111111
 ADC #1
 STA XX15+3

 LDA XX15+5             \ And now we flip the sign of the result to get the
 EOR #%10000000         \ correct result
 STA XX15+5

 BCC LL55               \ If the above subtraction underflowed then we need to
 INC XX15+4             \ bump the high byte of the result up by 1

.LL55

                        \ Now for the z-coordinates, vertv_z + z

 LDA XX12+5             \ If vertv_z_hi is negative, jump down to LL56
 BMI LL56

 LDA XX12+4             \ Set (U T) = XX1(7 6) + XX12(5 4)
 CLC                    \           = (z_hi z_lo) + vertv_z
 ADC XX1+6              \
 STA T                  \ Starting with the low bytes

 LDA XX1+7              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_y is 0)
 STA U

 JMP LL57               \ We've added the z-coordinates, so jump to LL57

                        \ The adding process is continued in part 7, after a
                        \ couple of subroutines that we don't need quite yet

\ ******************************************************************************
\
\       Name: LL61
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (U R) = 256 * A / Q
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, where A >= Q:
\
\   (U R) = 256 * A / Q
\
\ This is a sister routine to LL28, which does the division when A < Q.
\
\ ******************************************************************************

.LL61

 LDX Q                  \ If Q = 0, jump down to LL84 to return a division
 BEQ LL84               \ error

                        \ The LL28 routine returns A / Q, but only if A < Q. In
                        \ our case A >= Q, but we still want to use the LL28
                        \ routine, so we halve A until it's less than Q, call
                        \ the division routine, and then double A by the same
                        \ number of times

 LDX #0                 \ Set X = 0 to count the number of times we halve A

.LL63

 LSR A                  \ Halve A by shifting right

 INX                    \ Increment X

 CMP Q                  \ If A >= Q, loop back to LL63 to halve it again
 BCS LL63

 STX S                  \ Otherwise store the number of times we halved A in S

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \
                        \ which we can do now as A < Q

 LDX S                  \ Otherwise restore the number of times we halved A
                        \ above into X

 LDA R                  \ Set A = our division result

.LL64

 ASL A                  \ Double (U A) by shifting left
 ROL U

 BMI LL84               \ If bit 7 of U is set, the doubling has overflowed, so
                        \ jump to LL84 to return a division error

 DEX                    \ Decrement X

 BNE LL64               \ If X is not yet zero then we haven't done as many
                        \ doublings as we did halvings earlier, so loop back for
                        \ another doubling

 STA R                  \ Store the low byte of the division result in R

 RTS                    \ Return from the subroutine

.LL84

 LDA #50                \ If we get here then either we tried to divide by 0, or
 STA R                  \ the result overflowed, so we set U and R to 50
 STA U

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL62
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate 128 - (U R)
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following for a positive sign-magnitude number (U R):
\
\   128 - (U R)
\
\ and then store the result, low byte then high byte, on the end of the heap at
\ XX3, where X points to the first free byte on the heap. Return by jumping down
\ to LL66.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is incremented by 1
\
\ ******************************************************************************

.LL62

 LDA #128               \ Calculate 128 - (U R), starting with the low bytes
 SEC
 SBC R

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA #0                 \ And then subtract the high bytes
 SBC U

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 JMP LL66               \ Jump down to LL66

\ ******************************************************************************
\
\       Name: LL9 (Part 7 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's vertices
\  Deep dive: Drawing ships
\             Calculating vertex coordinates
\
\ ------------------------------------------------------------------------------
\
\ This section continues the coordinate adding from part 6 by finishing off the
\ calculation that we started above:
\
\                      [ sidev_x roofv_x nosev_x ]   [ x ]   [ x ]
\   vector to vertex = [ sidev_y roofv_y nosev_y ] . [ y ] + [ y ]
\                      [ sidev_z roofv_z nosev_z ]   [ z ]   [ z ]
\
\ The gets stored as follows, in sign-magnitude values with the magnitudes
\ fitting into the low bytes:
\
\   XX15(2 0)           [ x y z ] . [ sidev_x roofv_x nosev_x ] + [ x y z ]
\
\   XX15(5 3)           [ x y z ] . [ sidev_y roofv_y nosev_y ] + [ x y z ]
\
\   (U T)               [ x y z ] . [ sidev_z roofv_z nosev_z ] + [ x y z ]
\
\ Finally, because this vector is from our ship to the vertex, and we are at the
\ origin, this vector is the same as the coordinates of the vertex. In other
\ words, we have just worked out:
\
\   XX15(2 0)           x-coordinate of the current vertex
\
\   XX15(5 3)           y-coordinate of the current vertex
\
\   (U T)               z-coordinate of the current vertex
\
\ ******************************************************************************

.LL56

 LDA XX1+6              \ Set (U T) = XX1(7 6) - XX12(5 4)
 SEC                    \           = (z_hi z_lo) - vertv_z
 SBC XX12+4             \
 STA T                  \ Starting with the low bytes

 LDA XX1+7              \ And then doing the high bytes (we can subtract 0 here
 SBC #0                 \ as we know the sign byte of vertv_z is 0)
 STA U

 BCC LL140              \ If the subtraction just underflowed, skip to LL140 to
                        \ set (U T) to the minimum value of 4

 BNE LL57               \ If U is non-zero, jump down to LL57

 LDA T                  \ If T >= 4, jump down to LL57
 CMP #4
 BCS LL57

.LL140

 LDA #0                 \ If we get here then either (U T) < 4 or the
 STA U                  \ subtraction underflowed, so set (U T) = 4
 LDA #4
 STA T

.LL57

                        \ By this point we have our results, so now to scale
                        \ the 16-bit results down into 8-bit values

 LDA U                  \ If the high bytes of the result are all zero, we are
 ORA XX15+1             \ done, so jump down to LL60 for the next stage
 ORA XX15+4
 BEQ LL60

 LSR XX15+1             \ Shift XX15(1 0) to the right
 ROR XX15

 LSR XX15+4             \ Shift XX15(4 3) to the right
 ROR XX15+3

 LSR U                  \ Shift (U T) to the right
 ROR T

 JMP LL57               \ Jump back to LL57 to see if we can shift the result
                        \ any more

\ ******************************************************************************
\
\       Name: LL9 (Part 8 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the screen coordinates of visible vertices
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This section projects the coordinate of the vertex into screen coordinates and
\ stores them on the XX3 heap. By the end of this part, the XX3 heap contains
\ four bytes containing the 16-bit screen coordinates of the current vertex, in
\ the order: x_lo, x_hi, y_lo, y_hi.
\
\ When we reach here, we are looping through the vertices, and we've just worked
\ out the coordinates of the vertex in our normal coordinate system, as follows
\
\   XX15(2 0)           (x_sign x_lo) = x-coordinate of the current vertex
\
\   XX15(5 3)           (y_sign y_lo) = y-coordinate of the current vertex
\
\   (U T)               (z_sign z_lo) = z-coordinate of the current vertex
\
\ Note that U is always zero when we get to this point, as the vertex is always
\ in front of us (so it has a positive z-coordinate, into the screen).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL70+1              Contains an RTS (as the first byte of an LDA
\                       instruction)
\
\   LL66                A re-entry point into the ship-drawing routine, used by
\                       the LL62 routine to store 128 - (U R) on the XX3 heap
\
\ ******************************************************************************

.LL60

 LDA T                  \ Set Q = z_lo
 STA Q

 LDA XX15               \ Set A = x_lo

 CMP Q                  \ If x_lo < z_lo jump to LL69
 BCC LL69

 JSR LL61               \ Call LL61 to calculate:
                        \
                        \   (U R) = 256 * A / Q
                        \         = 256 * x / z
                        \
                        \ which we can do as x >= z

 JMP LL65               \ Jump to LL65 to skip the division for x_lo < z_lo

.LL69

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * x / z
                        \
                        \ Because x < z, the result fits into one byte, and we
                        \ also know that U = 0, so (U R) also contains the
                        \ result

.LL65

                        \ At this point we have:
                        \
                        \   (U R) = x / z
                        \
                        \ so (U R) contains the vertex's x-coordinate projected
                        \ on screen
                        \
                        \ The next task is to convert (U R) to a pixel screen
                        \ coordinate and stick it on the XX3 heap.
                        \
                        \ We start with the x-coordinate. To convert the
                        \ x-coordinate to a screen pixel we add 128, the
                        \ x-coordinate of the centre of the screen, because the
                        \ projected value is relative to an origin at the centre
                        \ of the screen, but the origin of the screen pixels is
                        \ at the top-left of the screen

 LDX CNT                \ Fetch the pointer to the end of the XX3 heap from CNT
                        \ into X

 LDA XX15+2             \ If x_sign is negative, jump up to LL62, which will
 BMI LL62               \ store 128 - (U R) on the XX3 heap and return by
                        \ jumping down to LL66 below

 LDA R                  \ Calculate 128 + (U R), starting with the low bytes
 CLC
 ADC #128

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA U                  \ And then add the high bytes
 ADC #0

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

.LL66

                        \ We've just stored the screen x-coordinate of the
                        \ vertex on the XX3 heap, so now for the y-coordinate

 TXA                    \ Store the heap pointer in X on the stack (at this
 PHA                    \ it points to the last entry on the heap, not the first
                        \ free byte)

 LDA #0                 \ Set U = 0
 STA U

 LDA T                  \ Set Q = z_lo
 STA Q

 LDA XX15+3             \ Set A = y_lo

 CMP Q                  \ If y_lo < z_lo jump to LL67
 BCC LL67

 JSR LL61               \ Call LL61 to calculate:
                        \
                        \   (U R) = 256 * A / Q
                        \         = 256 * y / z
                        \
                        \ which we can do as y >= z

 JMP LL68               \ Jump to LL68 to skip the division for y_lo < z_lo

.LL70

                        \ This gets called from below when y_sign is negative

 LDA #Y                 \ Calculate #Y + (U R), starting with the low bytes
 CLC
 ADC R

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA #0                 \ And then add the high bytes
 ADC U

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

 JMP LL50               \ Jump to LL50 to move on to the next vertex

.LL67

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * y / z
                        \
                        \ Because y < z, the result fits into one byte, and we
                        \ also know that U = 0, so (U R) also contains the
                        \ result

.LL68

                        \ At this point we have:
                        \
                        \   (U R) = y / z
                        \
                        \ so (U R) contains the vertex's y-coordinate projected
                        \ on screen
                        \
                        \ We now want to convert this to a screen y-coordinate
                        \ and stick it on the XX3 heap, much like we did with
                        \ the x-coordinate above. Again, we convert the
                        \ coordinate by adding or subtracting the y-coordinate
                        \ of the centre of the screen, which is in the constant
                        \ #Y, but this time we do the opposite, as a positive
                        \ projected y-coordinate, i.e. up the space y-axis and
                        \ up the screen, converts to a low y-coordinate, which
                        \ is the opposite way round to the x-coordinates

 PLA                    \ Restore the heap pointer from the stack into X
 TAX

 INX                    \ When we stored the heap pointer, it pointed to the
                        \ last entry on the heap, not the first free byte, so we
                        \ increment it so it does point to the next free byte

 LDA XX15+5             \ If y_sign is negative, jump up to LL70, which will
 BMI LL70               \ store #Y + (U R) on the XX3 heap and return by jumping
                        \ down to LL50 below

 LDA #Y                 \ Calculate #Y - (U R), starting with the low bytes
 SEC
 SBC R

 STA XX3,X              \ Store the low byte of the result in the X-th byte of
                        \ the heap at XX3

 INX                    \ Increment the heap pointer in X to point to the next
                        \ byte

 LDA #0                 \ And then subtract the high bytes
 SBC U

 STA XX3,X              \ Store the high byte of the result in the X-th byte of
                        \ the heap at XX3

.LL50

                        \ By the time we get here, the XX3 heap contains four
                        \ bytes containing the screen coordinates of the current
                        \ vertex, in the order: x_lo, x_hi, y_lo, y_hi

 CLC                    \ Set CNT = CNT + 4, so the heap pointer points to the
 LDA CNT                \ next free byte on the heap
 ADC #4
 STA CNT

 LDA XX17               \ Set A to the offset of the current vertex's data,
                        \ which we set in part 6

 ADC #6                 \ Set Y = A + 6, so Y now points to the data for the
 TAY                    \ next vertex

 BCS LL72               \ If the addition just overflowed, meaning we just tried
                        \ to access vertex #43, jump to LL72, as the maximum
                        \ number of vertices allowed is 42

 CMP XX20               \ If Y >= number of vertices * 6 (which we stored in
 BCS LL72               \ XX20 in part 6), jump to LL72, as we have processed
                        \ all the vertices for this ship

 JMP LL48               \ Loop back to LL48 in part 6 to calculate visibility
                        \ and screen coordinates for the next vertex

\ ******************************************************************************
\
\       Name: LL9 (Part 9 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Draw laser beams if the ship is firing its laser at us
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part sets things up so we can loop through the edges in the next part. It
\ also adds a line to the ship line heap, if the ship is firing at us.
\
\ When we get here, the heap at XX3 contains all the visible vertex screen
\ coordinates.
\
\ ******************************************************************************

.LL72

 LDA XX1+31             \ If bit 5 of the ship's byte #31 is clear, then the
 AND #%00100000         \ ship is not currently exploding, so jump down to EE31
 BEQ EE31

 LDA XX1+31             \ The ship is exploding, so set bit 3 of the ship's byte
 ORA #%00001000         \ #31 to denote that we are drawing something on-screen
 STA XX1+31             \ for this ship

 JMP DOEXP              \ Jump to DOEXP to display the explosion cloud,
                        \ returning from the subroutine using a tail call

.EE31

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is clear, then there
 BIT XX1+31             \ is nothing already being shown for this ship, so skip
 BEQ LL74               \ to LL74 as we don't need to erase anything from the
                        \ screen

 JSR LL155              \ Otherwise call LL155 to draw the existing ship, which
                        \ removes it from the screen

 LDA #%00001000         \ Set bit 3 of A so the next instruction sets bit 3 of
                        \ the ship's byte #31 to denote that we are drawing
                        \ something on-screen for this ship

.LL74

 ORA XX1+31             \ Apply bit 3 of A to the ship's byte #31, so if there
 STA XX1+31             \ was no ship already on screen, the bit is clear,
                        \ otherwise it is set

 LDY #9                 \ Fetch byte #9 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number of edges, and store it in XX20
 STA XX20

 LDY #0                 \ We are about to step through all the edges, using Y
                        \ as a counter

 STY U                  \ Set U = 0 (though we increment it to 1 below)

 STY XX17               \ Set XX17 = 0, which we are going to use as a counter
                        \ for stepping through the ship's edges

 INC U                  \ We are going to start calculating the lines we need to
                        \ draw for this ship, and will store them in the ship
                        \ line heap, using U to point to the end of the heap, so
                        \ we start by setting U = 1

 BIT XX1+31             \ If bit 6 of the ship's byte #31 is clear, then the
 BVC LL170              \ ship is not firing its lasers, so jump to LL170 to
                        \ skip the drawing of laser lines

                        \ The ship is firing its laser at us, so we need to draw
                        \ the laser lines

 LDA XX1+31             \ Clear bit 6 of the ship's byte #31 so the ship doesn't
 AND #%10111111         \ keep firing endlessly
 STA XX1+31

 LDY #6                 \ Fetch byte #6 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number * 4 of the vertex where the ship has its lasers

 TAY                    \ Put the vertex number into Y, where it can act as an
                        \ index into list of vertex screen coordinates we added
                        \ to the XX3 heap

 LDX XX3,Y              \ Fetch the x_lo coordinate of the laser vertex from the
 STX XX15               \ XX3 heap into XX15

 INX                    \ If X = 255 then the laser vertex is not visible, as
 BEQ LL170              \ the value we stored in part 2 wasn't overwritten by
                        \ the vertex calculation in part 6 and 7, so jump to
                        \ LL170 to skip drawing the laser lines

                        \ We now build a laser beam from the ship's laser vertex
                        \ towards our ship, as follows:
                        \
                        \   XX15(1 0) = laser vertex x-coordinate
                        \
                        \   XX15(3 2) = laser vertex y-coordinate
                        \
                        \   XX15(5 4) = x-coordinate of the end of the beam
                        \
                        \   XX12(1 0) = y-coordinate of the end of the beam
                        \
                        \ The end of the laser beam will be positioned to look
                        \ good, rather than being directly aimed at us, as
                        \ otherwise we would only see a flashing point of light
                        \ as they unleashed their attack

 LDX XX3+1,Y            \ Fetch the x_hi coordinate of the laser vertex from the
 STX XX15+1             \ XX3 heap into XX15+1

 INX                    \ If X = 255 then the laser vertex is not visible, as
 BEQ LL170              \ the value we stored in part 2 wasn't overwritten by
                        \ a vertex calculation in part 6 and 7, so jump to LL170
                        \ to skip drawing the laser beam

 LDX XX3+2,Y            \ Fetch the y_lo coordinate of the laser vertex from the
 STX XX15+2             \ XX3 heap into XX15+2

 LDX XX3+3,Y            \ Fetch the y_hi coordinate of the laser vertex from the
 STX XX15+3             \ XX3 heap into XX15+3

 LDA #0                 \ Set XX15(5 4) = 0, so their laser beam fires to the
 STA XX15+4             \ left edge of the screen
 STA XX15+5

 STA XX12+1             \ Set XX12(1 0) = the ship's z_lo coordinate, which will
 LDA XX1+6              \ effectively make the vertical position of the end of
 STA XX12               \ the laser beam move around as the ship moves in space

 LDA XX1+2              \ If the ship's x_sign is positive, skip the next
 BPL P%+4               \ instruction

 DEC XX15+4             \ The ship's x_sign is negative (i.e. it's on the left
                        \ side of the screen), so switch the laser beam so it
                        \ goes to the right edge of the screen by decrementing
                        \ XX15(5 4) to 255

 JSR LL145              \ Call LL145 to see if the laser beam needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

 BCS LL170              \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL170 so we don't store this line
                        \ in the ship line heap

 LDY U                  \ Fetch the ship line heap pointer, which points to the
                        \ next free byte on the heap, into Y

 LDA XX15               \ Add X1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+1             \ Add Y1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+2             \ Add X2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+3             \ Add Y2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 STY U                  \ Store the updated ship line heap pointer in U

\ ******************************************************************************
\
\       Name: LL9 (Part 10 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's edges
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part calculates which edges are visible - in other words, which lines we
\ should draw - and clips them to fit on the screen.
\
\ When we get here, the heap at XX3 contains all the visible vertex screen
\ coordinates.
\
\ ******************************************************************************

.LL170

 LDY #3                 \ Fetch byte #3 of the ship's blueprint, which contains
 CLC                    \ the low byte of the offset to the edges data
 LDA (XX0),Y

 ADC XX0                \ Set V = low byte edges offset + XX0
 STA V

 LDY #16                \ Fetch byte #16 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the high byte of the offset to the edges data

 ADC XX0+1              \ Set V+1 = high byte edges offset + XX0+1
 STA V+1                \
                        \ So V(1 0) now points to the start of the edges data
                        \ for this ship

 LDY #5                 \ Fetch byte #5 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the maximum heap size for plotting the ship (which is
 STA T1                 \ 1 + 4 * the maximum number of visible edges) and store
                        \ it in T1

 LDY XX17               \ Set Y to the edge counter in XX17

.LL75

 LDA (V),Y              \ Fetch byte #0 for this edge, which contains the
                        \ visibility distance for this edge, beyond which the
                        \ edge is not shown

 CMP XX4                \ If XX4 > the visibility distance, where XX4 contains
 BCC LL78               \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), then this edge is too far away to be visible,
                        \ so jump down to LL78 to move on to the next edge

 INY                    \ Increment Y to point to byte #1

 LDA (V),Y              \ Fetch byte #1 for this edge into A, so:
                        \
                        \   A = %ffff ffff, where:
                        \
                        \     * Bits 0-3 = the number of face 1
                        \
                        \     * Bits 4-7 = the number of face 2

 INY                    \ Increment Y to point to byte #2

 STA P                  \ Store byte #1 into P

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL79               \ face 1 is visible, so jump to LL79

 LDA P                  \ Fetch byte #1 for this edge into A

 LSR A                  \ Shift right four times to extract the number of face 2
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

 LDA XX2,X              \ If XX2+X is zero then we decided in part 5 that
 BEQ LL78               \ face 2 is hidden, so jump to LL78

.LL79

                        \ We now build the screen line for this edge, as
                        \ follows:
                        \
                        \   XX15(1 0) = start x-coordinate
                        \
                        \   XX15(3 2) = start y-coordinate
                        \
                        \   XX15(5 4) = end x-coordinate
                        \
                        \   XX12(1 0) = end y-coordinate
                        \
                        \ We can then pass this to the line clipping routine
                        \ before storing the resulting line in the ship line
                        \ heap

 LDA (V),Y              \ Fetch byte #2 for this edge into X, which contains
 TAX                    \ the number of the vertex at the start of the edge
                        \
                        \ Byte #2 contains the vertex number multiplied by 4,
                        \ so we can use it as an index into the heap at XX3 to
                        \ fetch the vertex's screen coordinates, which are
                        \ stored as four bytes containing two 16-bit numbers

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this edge into Q, which contains
 STA Q                  \ the number of the vertex at the end of the edge
                        \
                        \ Byte #3 contains the vertex number multiplied by 4,
                        \ so we can use it as an index into the heap at XX3 to
                        \ fetch the vertex's screen coordinates, which are
                        \ stored as four bytes containing two 16-bit numbers

 LDA XX3+1,X            \ Fetch the x_hi coordinate of the edge's start vertex
 STA XX15+1             \ from the XX3 heap into XX15+1

 LDA XX3,X              \ Fetch the x_lo coordinate of the edge's start vertex
 STA XX15               \ from the XX3 heap into XX15

 LDA XX3+2,X            \ Fetch the y_lo coordinate of the edge's start vertex
 STA XX15+2             \ from the XX3 heap into XX15+2

 LDA XX3+3,X            \ Fetch the y_hi coordinate of the edge's start vertex
 STA XX15+3             \ from the XX3 heap into XX15+3

 LDX Q                  \ Set X to the number of the vertex at the end of the
                        \ edge, which we stored in Q

 LDA XX3,X              \ Fetch the x_lo coordinate of the edge's end vertex
 STA XX15+4             \ from the XX3 heap into XX15+4

 LDA XX3+3,X            \ Fetch the y_hi coordinate of the edge's end vertex
 STA XX12+1             \ from the XX3 heap into XX12+1

 LDA XX3+2,X            \ Fetch the y_lo coordinate of the edge's end vertex
 STA XX12               \ from the XX3 heap into XX12

 LDA XX3+1,X            \ Fetch the x_hi coordinate of the edge's end vertex
 STA XX15+5             \ from the XX3 heap into XX15+5

 JSR LL147              \ Call LL147 to see if the new line segment needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

 BCS LL78               \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL78 so we don't store this line
                        \ in the ship line heap

\ ******************************************************************************
\
\       Name: LL9 (Part 11 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Add all visible edges to the ship line heap
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part adds all the visible edges to the ship line heap, so we can draw
\ them in part 12.
\
\ Other entry points:
\
\   LL81+2              Draw the contents of the ship line heap, used to draw
\                       the ship as a dot from SHPPT
\
\ ******************************************************************************

.LL80

 LDY U                  \ Fetch the ship line heap pointer, which points to the
                        \ next free byte on the heap, into Y

 LDA XX15               \ Add X1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+1             \ Add Y1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+2             \ Add X2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+3             \ Add Y2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 STY U                  \ Store the updated ship line heap pointer in U

 CPY T1                 \ If Y >= T1 then we have reached the maximum number of
 BCS LL81               \ edge lines that we can store in the ship line heap, so
                        \ skip to LL81 so we don't loop back for the next edge

.LL78

 INC XX17               \ Increment the edge counter to point to the next edge

 LDY XX17               \ If Y >= XX20, which contains the number of edges in
 CPY XX20               \ the blueprint, jump to LL81 as we have processed all
 BCS LL81               \ the edges and don't need to loop back for the next one

 LDY #0                 \ Set Y to point to byte #0 again, ready for the next
                        \ edge

 LDA V                  \ Increment V by 4 so V(1 0) points to the data for the
 ADC #4                 \ next edge
 STA V

 BCC ll81               \ If the above addition didn't overflow, jump to ll81 to
                        \ skip the following instruction

 INC V+1                \ Otherwise increment the high byte of V(1 0), as we
                        \ just moved the V(1 0) pointer past a page boundary

.ll81

 JMP LL75               \ Loop back to LL75 to process the next edge

.LL81

                        \ We have finished adding lines to the ship line heap,
                        \ so now we need to set the first byte of the heap to
                        \ the number of bytes stored there

 LDA U                  \ Fetch the ship line heap pointer from U into A, which
                        \ points to the end of the heap, and therefore contains
                        \ the heap size

 LDY #0                 \ Store A as the first byte of the ship line heap, so
 STA (XX19),Y           \ the heap is now correctly set up

\ ******************************************************************************
\
\       Name: LL9 (Part 12 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Draw all the visible edges from the ship line heap
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part draws the lines in the ship line heap, which is used both to draw
\ the ship, and to remove it from the screen.
\
\ ******************************************************************************

.LL155

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

 CMP #4                 \ If the heap size is less than 4, there is nothing to
 BCC LL118-1            \ draw, so return from the subroutine (as LL118-1
                        \ contains an RTS)

 INY                    \ Set Y = 1, which we will use as an index into the ship
                        \ line heap, starting at byte #1 (as byte #0 contains
                        \ the heap size)

.LL27

 LDA (XX19),Y           \ Fetch the X1 line coordinate from the heap and store
 STA XX15               \ it in XX15

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the Y1 line coordinate from the heap and store
 STA XX15+1             \ it in XX15+1

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the X2 line coordinate from the heap and store
 STA XX15+2             \ it in XX15+2

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the Y2 line coordinate from the heap and store
 STA XX15+3             \ it in XX15+3

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2)

 INY                    \ Increment the heap pointer

 CPY XX20               \ If the heap counter is less than the size of the heap,
 BCC LL27               \ loop back to LL27 to draw the next line from the heap

\.LL82                  \ This label is commented out in the original source

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL118
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Move a point along a line until it is on-screen
\  Deep dive: Line-clipping
\
\ ------------------------------------------------------------------------------
\
\ Given a point (x1, y1), a gradient and a direction of slope, move the point
\ along the line until it is on-screen, so this effectively clips the (x1, y1)
\ end of a line to be on the screen.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15(1 0)           x1 as a 16-bit coordinate (x1_hi x1_lo)
\
\   XX15(3 2)           y1 as a 16-bit coordinate (y1_hi y1_lo)
\
\   XX12+2              The line's gradient * 256 (so 1.0 = 256)
\
\   XX12+3              The direction of slope:
\
\                         * Positive (bit 7 clear) = top left to bottom right
\
\                         * Negative (bit 7 set) = top right to bottom left
\
\   T                   The gradient of slope:
\
\                         * 0 if it's a shallow slope
\
\                         * &FF if it's a steep slope
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX15                x1 as an 8-bit coordinate
\
\   XX15+2              y1 as an 8-bit coordinate
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL118-1             Contains an RTS
\
\ ******************************************************************************

.LL118

 LDA XX15+1             \ If x1_hi is positive, jump down to LL119 to skip the
 BPL LL119              \ following

 STA S                  \ Otherwise x1_hi is negative, i.e. off the left of the
                        \ screen, so set S = x1_hi

 JSR LL120              \ Call LL120 to calculate:
                        \
                        \   (Y X) = (S x1_lo) * XX12+2      if T = 0
                        \         = x1 * gradient
                        \
                        \   (Y X) = (S x1_lo) / XX12+2      if T <> 0
                        \         = x1 / gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set y1 = y1 + (Y X)
 CLC                    \
 ADC XX15+2             \ starting with the low bytes
 STA XX15+2

 TYA                    \ And then adding the high bytes
 ADC XX15+3
 STA XX15+3

 LDA #0                 \ Set x1 = 0
 STA XX15
 STA XX15+1

 TAX                    \ Set X = 0 so the next instruction becomes a JMP

.LL119

 BEQ LL134              \ If x1_hi = 0 then jump down to LL134 to skip the
                        \ following, as the x-coordinate is already on-screen
                        \ (as 0 <= (x_hi x_lo) <= 255)

 STA S                  \ Otherwise x1_hi is positive, i.e. x1 >= 256 and off
 DEC S                  \ the right side of the screen, so set S = x1_hi - 1

 JSR LL120              \ Call LL120 to calculate:
                        \
                        \   (Y X) = (S x1_lo) * XX12+2      if T = 0
                        \         = (x1 - 256) * gradient
                        \
                        \   (Y X) = (S x1_lo) / XX12+2      if T <> 0
                        \         = (x1 - 256) / gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set y1 = y1 + (Y X)
 CLC                    \
 ADC XX15+2             \ starting with the low bytes
 STA XX15+2

 TYA                    \ And then adding the high bytes
 ADC XX15+3
 STA XX15+3

 LDX #255               \ Set x1 = 255
 STX XX15
 INX
 STX XX15+1

.LL134

                        \ We have moved the point so the x-coordinate is on
                        \ screen (i.e. in the range 0-255), so now for the
                        \ y-coordinate

 LDA XX15+3             \ If y1_hi is positive, jump down to LL119 to skip
 BPL LL135              \ the following

 STA S                  \ Otherwise y1_hi is negative, i.e. off the top of the
                        \ screen, so set S = y1_hi

 LDA XX15+2             \ Set R = y1_lo
 STA R

 JSR LL123              \ Call LL123 to calculate:
                        \
                        \   (Y X) = (S R) / XX12+2      if T = 0
                        \         = y1 / gradient
                        \
                        \   (Y X) = (S R) * XX12+2      if T <> 0
                        \         = y1 * gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set x1 = x1 + (Y X)
 CLC                    \
 ADC XX15               \ starting with the low bytes
 STA XX15

 TYA                    \ And then adding the high bytes
 ADC XX15+1
 STA XX15+1

 LDA #0                 \ Set y1 = 0
 STA XX15+2
 STA XX15+3

.LL135

\BNE LL139              \ This instruction is commented out in the original
                        \ source

 LDA XX15+2             \ Set (S R) = (y1_hi y1_lo) - screen height
 SEC                    \
 SBC #Y*2               \ starting with the low bytes
 STA R

 LDA XX15+3             \ And then subtracting the high bytes
 SBC #0
 STA S

 BCC LL136              \ If the subtraction underflowed, i.e. if y1 < screen
                        \ height, then y1 is already on-screen, so jump to LL136
                        \ to return from the subroutine, as we are done

.LL139

                        \ If we get here then y1 >= screen height, i.e. off the
                        \ bottom of the screen

 JSR LL123              \ Call LL123 to calculate:
                        \
                        \   (Y X) = (S R) / XX12+2      if T = 0
                        \         = (y1 - screen height) / gradient
                        \
                        \   (Y X) = (S R) * XX12+2      if T <> 0
                        \         = (y1 - screen height) * gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set x1 = x1 + (Y X)
 CLC                    \
 ADC XX15               \ starting with the low bytes
 STA XX15

 TYA                    \ And then adding the high bytes
 ADC XX15+1
 STA XX15+1

 LDA #Y*2-1             \ Set y1 = 2 * #Y - 1. The constant #Y is 96, the
 STA XX15+2             \ y-coordinate of the mid-point of the space view, so
 LDA #0                 \ this sets Y2 to 191, the y-coordinate of the bottom
 STA XX15+3             \ pixel row of the space view

.LL136

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL120
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = (S x1_lo) * XX12+2 or (S x1_lo) / XX12+2
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   * If T = 0, this is a shallow slope, so calculate (Y X) = (S x1_lo) * XX12+2
\
\   * If T <> 0, this is a steep slope, so calculate (Y X) = (S x1_lo) / XX12+2
\
\ giving (Y X) the opposite sign to the slope direction in XX12+3.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   T                   The gradient of slope:
\
\                         * 0 if it's a shallow slope
\
\                         * &FF if it's a steep slope
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL122               Calculate (Y X) = (S R) * Q and set the sign to the
\                       opposite of the top byte on the stack
\
\ ******************************************************************************

.LL120

 LDA XX15               \ Set R = x1_lo
 STA R

\.LL120                 \ This label is commented out in the original source

 JSR LL129              \ Call LL129 to do the following:
                        \
                        \   Q = XX12+2
                        \     = line gradient
                        \
                        \   A = S EOR XX12+3
                        \     = S EOR slope direction
                        \
                        \   (S R) = |S R|
                        \
                        \ So A contains the sign of S * slope direction

 PHA                    \ Store A on the stack so we can use it later

 LDX T                  \ If T is non-zero, then it's a steep slope, so jump
 BNE LL121              \ down to LL121 to calculate this instead:
                        \
                        \   (Y X) = (S R) / Q

.LL122

                        \ The following calculates:
                        \
                        \   (Y X) = (S R) * Q
                        \
                        \ using the same shift-and-add algorithm that's
                        \ documented in MULT1

 LDA #0                 \ Set A = 0

 TAX                    \ Set (Y X) = 0 so we can start building the answer here
 TAY

 LSR S                  \ Shift (S R) to the right, so we extract bit 0 of (S R)
 ROR R                  \ into the C flag

 ASL Q                  \ Shift Q to the left, catching bit 7 in the C flag

 BCC LL126              \ If C (i.e. the next bit from Q) is clear, do not do
                        \ the addition for this bit of Q, and instead skip to
                        \ LL126 to just do the shifts

.LL125

 TXA                    \ Set (Y X) = (Y X) + (S R)
 CLC                    \
 ADC R                  \ starting with the low bytes
 TAX

 TYA                    \ And then doing the high bytes
 ADC S
 TAY

.LL126

 LSR S                  \ Shift (S R) to the right
 ROR R

 ASL Q                  \ Shift Q to the left, catching bit 7 in the C flag

 BCS LL125              \ If C (i.e. the next bit from Q) is set, loop back to
                        \ LL125 to do the addition for this bit of Q

 BNE LL126              \ If Q has not yet run out of set bits, loop back to
                        \ LL126 to do the "shift" part of shift-and-add until
                        \ we have done additions for all the set bits in Q, to
                        \ give us our multiplication result

 PLA                    \ Restore A, which we calculated above, from the stack

 BPL LL133              \ If A is positive jump to LL133 to negate (Y X) and
                        \ return from the subroutine using a tail call

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL123
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = (S R) / XX12+2 or (S R) * XX12+2
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   * If T = 0, this is a shallow slope, so calculate (Y X) = (S R) / XX12+2
\
\   * If T <> 0, this is a steep slope, so calculate (Y X) = (S R) * XX12+2
\
\ giving (Y X) the opposite sign to the slope direction in XX12+3.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX12+2              The line's gradient * 256 (so 1.0 = 256)
\
\   XX12+3              The direction of slope:
\
\                         * Bit 7 clear means top left to bottom right
\
\                         * Bit 7 set means top right to bottom left
\
\   T                   The gradient of slope:
\
\                         * 0 if it's a shallow slope
\
\                         * &FF if it's a steep slope
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL121               Calculate (Y X) = (S R) / Q and set the sign to the
\                       opposite of the top byte on the stack
\
\   LL133               Negate (Y X) and return from the subroutine
\
\   LL128               Contains an RTS
\
\ ******************************************************************************

.LL123

 JSR LL129              \ Call LL129 to do the following:
                        \
                        \   Q = XX12+2
                        \     = line gradient
                        \
                        \   A = S EOR XX12+3
                        \     = S EOR slope direction
                        \
                        \   (S R) = |S R|
                        \
                        \ So A contains the sign of S * slope direction

 PHA                    \ Store A on the stack so we can use it later

 LDX T                  \ If T is non-zero, then it's a steep slope, so jump up
 BNE LL122              \ to LL122 to calculate this instead:
                        \
                        \   (Y X) = (S R) * Q

.LL121

                        \ The following calculates:
                        \
                        \   (Y X) = (S R) / Q
                        \
                        \ using the same shift-and-subtract algorithm that's
                        \ documented in TIS2

 LDA #%11111111         \ Set Y = %11111111
 TAY

 ASL A                  \ Set X = %11111110
 TAX

                        \ This sets (Y X) = %1111111111111110, so we can rotate
                        \ through 15 loop iterations, getting a 1 each time, and
                        \ then getting a 0 on the 16th iteration... and we can
                        \ also use it to catch our result bits into bit 0 each
                        \ time

.LL130

 ASL R                  \ Shift (S R) to the left
 ROL S

 LDA S                  \ Set A = S

 BCS LL131              \ If bit 7 of S was set, then jump straight to the
                        \ subtraction

 CMP Q                  \ If A < Q (i.e. S < Q), skip the following subtractions
 BCC LL132

.LL131

 SBC Q                  \ A >= Q (i.e. S >= Q) so set:
 STA S                  \
                        \   S = (A R) - Q
                        \     = (S R) - Q
                        \
                        \ starting with the low bytes (we know the C flag is
                        \ set so the subtraction will be correct)

 LDA R                  \ And then doing the high bytes
 SBC #0
 STA R

 SEC                    \ Set the C flag to rotate into the result in (Y X)

.LL132

 TXA                    \ Rotate the counter in (Y X) to the left, and catch the
 ROL A                  \ result bit into bit 0 (which will be a 0 if we didn't
 TAX                    \ do the subtraction, or 1 if we did)
 TYA
 ROL A
 TAY

 BCS LL130              \ If we still have set bits in (Y X), loop back to LL130
                        \ to do the next iteration of 15, until we have done the
                        \ whole division

 PLA                    \ Restore A, which we calculated above, from the stack

 BMI LL128              \ If A is negative jump to LL128 to return from the
                        \ subroutine with (Y X) as is

.LL133

 TXA                    \ Otherwise negate (Y X) using two's complement by first
 EOR #%11111111         \ setting the low byte to ~X + 1
\CLC                    \
 ADC #1                 \ The CLC instruction is commented out in the original
 TAX                    \ source. It would have no effect as we know the C flag
                        \ is clear from when we passed through the BCS above

 TYA                    \ Then set the high byte to ~Y + C
 EOR #%11111111
 ADC #0
 TAY

.LL128

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL129
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate Q = XX12+2, A = S EOR XX12+3 and (S R) = |S R|
\
\ ------------------------------------------------------------------------------
\
\ Do the following, in this order:
\
\   Q = XX12+2
\
\   A = S EOR XX12+3
\
\   (S R) = |S R|
\
\ This sets up the variables required above to calculate (S R) / XX12+2 and give
\ the result the opposite sign to XX12+3.
\
\ ******************************************************************************

.LL129

 LDX XX12+2             \ Set Q = XX12+2
 STX Q

 LDA S                  \ If S is positive, jump to LL127
 BPL LL127

 LDA #0                 \ Otherwise set R = -R
 SEC
 SBC R
 STA R

 LDA S                  \ Push S onto the stack
 PHA

 EOR #%11111111         \ Set S = ~S + 1 + C
 ADC #0
 STA S

 PLA                    \ Pull the original, negative S from the stack into A

.LL127

 EOR XX12+3             \ Set A = original argument S EOR'd with XX12+3

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LL145 (Part 1 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Work out which end-points are on-screen, if any
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ------------------------------------------------------------------------------
\
\ This routine clips the line from (x1, y1) to (x2, y2) so it fits on-screen, or
\ returns an error if it can't be clipped to fit. The arguments are 16-bit
\ coordinates, and the clipped line is returned using 8-bit screen coordinates.
\
\ This part sets XX13 to reflect which of the two points are on-screen and
\ off-screen.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15(1 0)           x1 as a 16-bit coordinate (x1_hi x1_lo)
\
\   XX15(3 2)           y1 as a 16-bit coordinate (y1_hi y1_lo)
\
\   XX15(5 4)           x2 as a 16-bit coordinate (x2_hi x2_lo)
\
\   XX12(1 0)           y2 as a 16-bit coordinate (y2_hi y2_lo)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   (X1, Y1)            Screen coordinate of the start of the clipped line
\
\   (X2, Y2)            Screen coordinate of the end of the clipped line
\
\   C flag              Clear if the clipped line fits on-screen, set if it
\                       doesn't
\
\   XX13                The state of the original coordinates on-screen:
\
\                         * 0   = (x2, y2) on-screen
\
\                         * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\                         * 191 = (x1, y1) off-screen, (x2, y2) off-screen
\
\                       So XX13 is non-zero if the end of the line was clipped,
\                       meaning the next line sent to BLINE can't join onto the
\                       end but has to start a new segment
\
\   SWAP                The swap status of the returned coordinates:
\
\                         * &FF if we swapped the values of (x1, y1) and
\                           (x2, y2) as part of the clipping process
\
\                         * 0 if the coordinates are still in the same order
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL147               Don't initialise the values in SWAP or A
\
\ ******************************************************************************

.LL145

 LDA #0                 \ Set SWAP = 0
 STA SWAP

 LDA XX15+5             \ Set A = x2_hi

.LL147

 LDX #Y*2-1             \ Set X = #Y * 2 - 1. The constant #Y is 96, the
                        \ y-coordinate of the mid-point of the space view, so
                        \ this sets Y2 to 191, the y-coordinate of the bottom
                        \ pixel row of the space view

 ORA XX12+1             \ If one or both of x2_hi and y2_hi are non-zero, jump
 BNE LL107              \ to LL107 to skip the following, leaving X at 191

 CPX XX12               \ If y2_lo > the y-coordinate of the bottom of screen
 BCC LL107              \ then (x2, y2) is off the bottom of the screen, so skip
                        \ the following instruction, leaving X at 191

 LDX #0                 \ Set X = 0

.LL107

 STX XX13               \ Set XX13 = X, so we have:
                        \
                        \   * XX13 = 0 if x2_hi = y2_hi = 0, y2_lo is on-screen
                        \
                        \   * XX13 = 191 if x2_hi or y2_hi are non-zero or y2_lo
                        \            is off the bottom of the screen
                        \
                        \ In other words, XX13 is 191 if (x2, y2) is off-screen,
                        \ otherwise it is 0

 LDA XX15+1             \ If one or both of x1_hi and y1_hi are non-zero, jump
 ORA XX15+3             \ to LL83
 BNE LL83

 LDA #Y*2-1             \ If y1_lo > the y-coordinate of the bottom of screen
 CMP XX15+2             \ then (x1, y1) is off the bottom of the screen, so jump
 BCC LL83               \ to LL83

                        \ If we get here, (x1, y1) is on-screen

 LDA XX13               \ If XX13 is non-zero, i.e. (x2, y2) is off-screen, jump
 BNE LL108              \ to LL108 to halve it before continuing at LL83

                        \ If we get here, the high bytes are all zero, which
                        \ means the x-coordinates are < 256 and therefore fit on
                        \ screen, and neither coordinate is off the bottom of
                        \ the screen. That means both coordinates are already on
                        \ screen, so we don't need to do any clipping, all we
                        \ need to do is move the low bytes into (X1, Y1) and
                        \ X2, Y2) and return

.LL146

                        \ If we get here then we have clipped our line to the
                        \ screen edge (if we had to clip it at all), so we move
                        \ the low bytes from (x1, y1) and (x2, y2) into (X1, Y1)
                        \ and (X2, Y2), remembering that they share locations
                        \ with XX15:
                        \
                        \   X1 = XX15
                        \   Y1 = XX15+1
                        \   X2 = XX15+2
                        \   Y2 = XX15+3
                        \
                        \ X1 already contains x1_lo, so now we do the rest

 LDA XX15+2             \ Set Y1 (aka XX15+1) = y1_lo
 STA XX15+1

 LDA XX15+4             \ Set X2 (aka XX15+2) = x2_lo
 STA XX15+2

 LDA XX12               \ Set Y2 (aka XX15+3) = y2_lo
 STA XX15+3

 CLC                    \ Clear the C flag as the clipped line fits on-screen

 RTS                    \ Return from the subroutine

.LL109

 SEC                    \ Set the C flag to indicate the clipped line does not
                        \ fit on-screen

 RTS                    \ Return from the subroutine

.LL108

 LSR XX13               \ If we get here then (x2, y2) is off-screen and XX13 is
                        \ 191, so shift XX13 right to halve it to 95

\ ******************************************************************************
\
\       Name: LL145 (Part 2 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Work out if any part of the line is on-screen
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ------------------------------------------------------------------------------
\
\ This part does a number of tests to see if the line is on or off the screen.
\
\ If we get here then at least one of (x1, y1) and (x2, y2) is off-screen, with
\ XX13 set as follows:
\
\   * 0   = (x1, y1) off-screen, (x2, y2) on-screen
\
\   * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\   * 191 = (x1, y1) off-screen, (x2, y2) off-screen
\
\ where "off-screen" is defined as having a non-zero high byte in one of the
\ coordinates, or in the case of y-coordinates, having a low byte > 191, the
\ y-coordinate of the bottom of the space view.
\
\ ******************************************************************************

.LL83

 LDA XX13               \ If XX13 < 128 then only one of the points is on-screen
 BPL LL115              \ so jump down to LL115 to skip the checks of whether
                        \ both points are in the strips to the right or bottom
                        \ of the screen

                        \ If we get here, both points are off-screen

 LDA XX15+1             \ If both x1_hi and x2_hi have bit 7 set, jump to LL109
 AND XX15+5             \ to return from the subroutine with the C flag set, as
 BMI LL109              \ the entire line is above the top of the screen

 LDA XX15+3             \ If both y1_hi and y2_hi have bit 7 set, jump to LL109
 AND XX12+1             \ to return from the subroutine with the C flag set, as
 BMI LL109              \ the entire line is to the left of the screen

 LDX XX15+1             \ Set A = X = x1_hi - 1
 DEX
 TXA

 LDX XX15+5             \ Set XX12+2 = x2_hi - 1
 DEX
 STX XX12+2

 ORA XX12+2             \ If neither (x1_hi - 1) or (x2_hi - 1) have bit 7 set,
 BPL LL109              \ jump to LL109 to return from the subroutine with the C
                        \ flag set, as the line doesn't fit on-screen

 LDA XX15+2             \ If y1_lo < y-coordinate of screen bottom, clear the C
 CMP #Y*2               \ flag, otherwise set it

 LDA XX15+3             \ Set XX12+2 = y1_hi - (1 - C), so:
 SBC #0                 \
 STA XX12+2             \  * Set XX12+2 = y1_hi - 1 if y1_lo is on-screen
                        \  * Set XX12+2 = y1_hi     otherwise
                        \
                        \ We do this subtraction because we are only interested
                        \ in trying to move the points up by a screen if that
                        \ might move the point into the space view portion of
                        \ the screen, i.e. if y1_lo is on-screen

 LDA XX12               \ If y2_lo < y-coordinate of screen bottom, clear the C
 CMP #Y*2               \ flag, otherwise set it

 LDA XX12+1             \ Set XX12+2 = y2_hi - (1 - C), so:
 SBC #0                 \
                        \  * Set XX12+1 = y2_hi - 1 if y2_lo is on-screen
                        \  * Set XX12+1 = y2_hi     otherwise
                        \
                        \ We do this subtraction because we are only interested
                        \ in trying to move the points up by a screen if that
                        \ might move the point into the space view portion of
                        \ the screen, i.e. if y1_lo is on-screen

 ORA XX12+2             \ If neither XX12+1 or XX12+2 have bit 7 set, jump to
 BPL LL109              \ LL109 to return from the subroutine with the C flag
                        \ set, as the line doesn't fit on-screen

\ ******************************************************************************
\
\       Name: LL145 (Part 3 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Calculate the line's gradient
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ******************************************************************************

.LL115

 TYA                    \ Store Y on the stack so we can preserve it through the
 PHA                    \ call to this subroutine

 LDA XX15+4             \ Set XX12+2 = x2_lo - x1_lo
 SEC
 SBC XX15
 STA XX12+2

 LDA XX15+5             \ Set XX12+3 = x2_hi - x1_hi
 SBC XX15+1
 STA XX12+3

 LDA XX12               \ Set XX12+4 = y2_lo - y1_lo
 SEC
 SBC XX15+2
 STA XX12+4

 LDA XX12+1             \ Set XX12+5 = y2_hi - y1_hi
 SBC XX15+3
 STA XX12+5

                        \ So we now have:
                        \
                        \   delta_x in XX12(3 2)
                        \   delta_y in XX12(5 4)
                        \
                        \ where the delta is (x1, y1) - (x2, y2))

 EOR XX12+3             \ Set S = the sign of delta_x * the sign of delta_y, so
 STA S                  \ if bit 7 of S is set, the deltas have different signs

 LDA XX12+5             \ If delta_y_hi is positive, jump down to LL110 to skip
 BPL LL110              \ the following

 LDA #0                 \ Otherwise flip the sign of delta_y to make it
 SEC                    \ positive, starting with the low bytes
 SBC XX12+4
 STA XX12+4

 LDA #0                 \ And then doing the high bytes, so now:
 SBC XX12+5             \
 STA XX12+5             \   XX12(5 4) = |delta_y|

.LL110

 LDA XX12+3             \ If delta_x_hi is positive, jump down to LL111 to skip
 BPL LL111              \ the following

 SEC                    \ Otherwise flip the sign of delta_x to make it
 LDA #0                 \ positive, starting with the low bytes
 SBC XX12+2
 STA XX12+2

 LDA #0                 \ And then doing the high bytes, so now:
 SBC XX12+3             \
                        \   (A XX12+2) = |delta_x|

.LL111

                        \ We now keep halving |delta_x| and |delta_y| until
                        \ both of them have zero in their high bytes

 TAX                    \ If |delta_x_hi| is non-zero, skip the following
 BNE LL112

 LDX XX12+5             \ If |delta_y_hi| = 0, jump down to LL113 (as both
 BEQ LL113              \ |delta_x_hi| and |delta_y_hi| are 0)

.LL112

 LSR A                  \ Halve the value of delta_x in (A XX12+2)
 ROR XX12+2

 LSR XX12+5             \ Halve the value of delta_y XX12(5 4)
 ROR XX12+4

 JMP LL111              \ Loop back to LL111

.LL113

                        \ By now, the high bytes of both |delta_x| and |delta_y|
                        \ are zero

 STX T                  \ We know that X = 0 as that's what we tested with a BEQ
                        \ above, so this sets T = 0

 LDA XX12+2             \ If delta_x_lo < delta_y_lo, so our line is more
 CMP XX12+4             \ vertical than horizontal, jump to LL114
 BCC LL114

                        \ If we get here then our line is more horizontal than
                        \ vertical, so it is a shallow slope

 STA Q                  \ Set Q = delta_x_lo

 LDA XX12+4             \ Set A = delta_y_lo

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * delta_y_lo / delta_x_lo

 JMP LL116              \ Jump to LL116, as we now have the line's gradient in R

.LL114

                        \ If we get here then our line is more vertical than
                        \ horizontal, so it is a steep slope

 LDA XX12+4             \ Set Q = delta_y_lo
 STA Q
 LDA XX12+2             \ Set A = delta_x_lo

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * delta_x_lo / delta_y_lo

 DEC T                  \ T was set to 0 above, so this sets T = &FF when our
                        \ line is steep

\ ******************************************************************************
\
\       Name: LL145 (Part 4 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Call the routine in LL188 to do the actual clipping
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ------------------------------------------------------------------------------
\
\ This part sets things up to call the routine in LL188, which does the actual
\ clipping.
\
\ If we get here, then R has been set to the gradient of the line (x1, y1) to
\ (x2, y2), with T indicating the gradient of slope:
\
\   * 0   = shallow slope (more horizontal than vertical)
\
\   * &FF = steep slope (more vertical than horizontal)
\
\ and XX13 has been set as follows:
\
\   * 0   = (x1, y1) off-screen, (x2, y2) on-screen
\
\   * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\   * 191 = (x1, y1) off-screen, (x2, y2) off-screen
\
\ ******************************************************************************

.LL116

 LDA R                  \ Store the gradient in XX12+2
 STA XX12+2

 LDA S                  \ Store the type of slope in XX12+3, bit 7 clear means
 STA XX12+3             \ top left to bottom right, bit 7 set means top right to
                        \ bottom left

 LDA XX13               \ If XX13 = 0, skip the following instruction
 BEQ LL138

 BPL LLX117             \ If XX13 is positive, it must be 95. This means
                        \ (x1, y1) is on-screen but (x2, y2) isn't, so we jump
                        \ to LLX117 to swap the (x1, y1) and (x2, y2)
                        \ coordinates around before doing the actual clipping,
                        \ because we need to clip (x2, y2) but the clipping
                        \ routine at LL118 only clips (x1, y1)

.LL138

                        \ If we get here, XX13 = 0 or 191, so (x1, y1) is
                        \ off-screen and needs clipping

 JSR LL118              \ Call LL118 to move (x1, y1) along the line onto the
                        \ screen, i.e. clip the line at the (x1, y1) end

 LDA XX13               \ If XX13 = 0, i.e. (x2, y2) is on-screen, jump down to
 BPL LL124              \ LL124 to return with a successfully clipped line

.LL117

                        \ If we get here, XX13 = 191 (both coordinates are
                        \ off-screen)

 LDA XX15+1             \ If either of x1_hi or y1_hi are non-zero, jump to
 ORA XX15+3             \ LL137 to return from the subroutine with the C flag
 BNE LL137              \ set, as the line doesn't fit on-screen

 LDA XX15+2             \ If y1_lo > y-coordinate of the bottom of the screen
 CMP #Y*2               \ jump to LL137 to return from the subroutine with the
 BCS LL137              \ C flag set, as the line doesn't fit on-screen

.LLX117

                        \ If we get here, XX13 = 95 or 191, and in both cases
                        \ (x2, y2) is off-screen, so we now need to swap the
                        \ (x1, y1) and (x2, y2) coordinates around before doing
                        \ the actual clipping, because we need to clip (x2, y2)
                        \ but the clipping routine at LL118 only clips (x1, y1)

 LDX XX15               \ Swap x1_lo = x2_lo
 LDA XX15+4
 STA XX15
 STX XX15+4

 LDA XX15+5             \ Swap x2_lo = x1_lo
 LDX XX15+1
 STX XX15+5
 STA XX15+1

 LDX XX15+2             \ Swap y1_lo = y2_lo
 LDA XX12
 STA XX15+2
 STX XX12

 LDA XX12+1             \ Swap y2_lo = y1_lo
 LDX XX15+3
 STX XX12+1
 STA XX15+3

 JSR LL118              \ Call LL118 to move (x1, y1) along the line onto the
                        \ screen, i.e. clip the line at the (x1, y1) end

 DEC SWAP               \ Set SWAP = &FF to indicate that we just clipped the
                        \ line at the (x2, y2) end by swapping the coordinates
                        \ (the DEC does this as we set SWAP to 0 at the start of
                        \ this subroutine)

.LL124

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 JMP LL146              \ Jump up to LL146 to move the low bytes of (x1, y1) and
                        \ (x2, y2) into (X1, Y1) and (X2, Y2), and return from
                        \ the subroutine with a successfully clipped line

.LL137

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 SEC                    \ Set the C flag to indicate the clipped line does not
                        \ fit on-screen

 RTS                    \ Return from the subroutine

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
 SAVE "versions/demo/3-assembled-output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\       Name: checksum0
\       Type: Variable
\   Category: Copy protection
\    Summary: Checksum for the entire main game code
\
\ ------------------------------------------------------------------------------
\
\ This byte contains a checksum for the entire main game code. It is populated
\ by elite-checksum.py and is used by the encryption checks in elite-loader.asm
\ (see the CHK routine in the loader for more details).
\
\ ******************************************************************************

.checksum0

 SKIP 1                 \ This value is checked against the calculated checksum
                        \ in part 6 of the loader in elite-loader.asm

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_SHIPS% = P%

 LOAD_SHIPS% = LOAD% + P% - CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

\MOD
EQUB &60, &60, &60, &66, &3C, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &00, &00, &18, &18, &00, &18, &18, &00, &60, &60, &60, &60, &60, &60, &7E, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &3C, &66, &0C, &18, &18, &00, &18, &00, &66, &66, &76, &7E, &6E, &66, &66, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &00, &00, &7E, &00, &7E, &00, &00, &00, &0C, &18, &30, &30, &30, &18, &0C, &00, &60, &60, &60, &60, &60, &60, &7E, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &3C, &66, &0C, &18, &18, &00, &18, &00, &66, &66, &76, &7E, &6E, &66, &66, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &30, &18, &0C, &0C, &0C, &18, &30, &00, &7E, &60, &60, &7C, &60, &60, &7E, &00, &3C, &66, &66, &66, &66, &66, &3C, &00, &7C, &66, &66, &7C, &6C, &66, &66, &00, &0C, &18, &30, &30, &30, &18, &0C, &00, &66, &66, &76, &7E, &6E, &66, &66, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &63, &77, &7F, &6B, &6B, &63, &63, &00, &3C, &66, &66, &66, &66, &66, &3C, &00, &78, &6C, &66, &66, &66, &6C, &78, &00, &3C, &66, &06, &0C, &18, &30, &7E, &00, &7E, &60, &7C, &06, &06, &66, &3C, &00, &1C, &30, &60, &7C, &66, &66, &3C, &00, &30, &18, &0C, &0C, &0C, &18, &30, &00, &00, &00, &18, &18, &00, &18, &18, &00, &66, &66, &76, &7E, &6E, &66, &66, &00, &7E, &60, &60, &7C, &60, &60, &7E, &00, &66, &66, &3C, &18, &3C, &66, &66, &00, &7E, &18, &18, &18, &18, &18, &18, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &3C, &66, &06, &1C, &06, &66, &3C, &00, &3C, &66, &66, &3E, &06, &0C, &38, &00, &7E, &06, &0C, &18, &30, &30, &30, &00, &3C, &66, &66, &7E, &66, &66, &66, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &00, &00, &7E, &00, &7E, &00, &00, &00, &3C, &66, &6E, &7E, &76, &66, &3C, &00, &00, &00, &18, &18, &00, &18, &18, &00, &7E, &60, &60, &7C, &60, &60, &60, &00, &3C, &66, &66, &66, &66, &66, &3C, &00, &7C, &66, &66, &7C, &6C, &66, &66, &00, &66, &66, &76, &7E, &6E, &66, &66, &00, &60, &66, &0C, &18, &30, &66, &06, &00, &00, &00, &7E, &00, &7E, &00, &00, &00, &38, &6C, &6C, &38, &6D, &66, &3B, &00, &18, &38, &18, &18, &18, &18, &7E, &00, &18, &38, &18, &18, &18, &18, &7E, &00, &3C, &66, &6E, &7E, &76, &66, &3C, &00
EQUB &3C, &A8

.XX21

 EQUW SHIP_SIDEWINDER   \         1 = Sidewinder
 EQUW SHIP_VIPER        \ COPS =  2 = Viper
 EQUW SHIP_MAMBA        \         3 = Mamba
 EQUW SHIP_PYTHON       \         4 = Python
 EQUW SHIP_COBRA_MK_3   \         5 = Cobra Mk III (bounty hunter)
 EQUW SHIP_THARGOID     \ THG  =  6 = Thargoid
 EQUW SHIP_COBRA_MK_3   \ CYL  =  7 = Cobra Mk III (trader)
 EQUW SHIP_CORIOLIS     \ SST  =  8 = Coriolis space station
 EQUW SHIP_MISSILE      \ MSL  =  9 = Missile
 EQUW SHIP_ASTEROID     \ AST  = 10 = Asteroid
 EQUW SHIP_CANISTER     \ OIL  = 11 = Cargo canister
 EQUW SHIP_THARGON      \ TGL  = 12 = Thargon
 EQUW SHIP_ESCAPE_POD   \ ESC  = 13 = Escape pod

\ ******************************************************************************
\
\       Name: VERTEX
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding vertices to ship blueprints
\  Deep dive: Ship blueprints
\             Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   VERTEX x, y, z, face1, face2, face3, face4, visibility
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   x                   The vertex's x-coordinate
\
\   y                   The vertex's y-coordinate
\
\   z                   The vertex's z-coordinate
\
\   face1               The number of face 1 associated with this vertex
\
\   face2               The number of face 2 associated with this vertex
\
\   face3               The number of face 3 associated with this vertex
\
\   face4               The number of face 4 associated with this vertex
\
\   visibility          The visibility distance, beyond which the vertex is not
\                       shown
\
\ ******************************************************************************

MACRO VERTEX x, y, z, face1, face2, face3, face4, visibility

 IF x < 0
  s_x = 1 << 7
 ELSE
  s_x = 0
 ENDIF

 IF y < 0
  s_y = 1 << 6
 ELSE
  s_y = 0
 ENDIF

 IF z < 0
  s_z = 1 << 5
 ELSE
  s_z = 0
 ENDIF

 s = s_x + s_y + s_z + visibility
 f1 = face1 + (face2 << 4)
 f2 = face3 + (face4 << 4)
 ax = ABS(x)
 ay = ABS(y)
 az = ABS(z)

 EQUB ax, ay, az, s, f1, f2

ENDMACRO

\ ******************************************************************************
\
\       Name: EDGE
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding edges to ship blueprints
\  Deep dive: Ship blueprints
\             Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   EDGE vertex1, vertex2, face1, face2, visibility
\
\ When stored in memory, bytes #2 and #3 contain the vertex numbers multiplied
\ by 4, so we can use them as indices into the heap at XX3 to fetch the screen
\ coordinates for each vertex, as they are stored as four bytes containing two
\ 16-bit numbers (see part 10 of the LL9 routine for details).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   vertex1             The number of the vertex at the start of the edge
\
\   vertex1             The number of the vertex at the end of the edge
\
\   face1               The number of face 1 associated with this edge
\
\   face2               The number of face 2 associated with this edge
\
\   visibility          The visibility distance, beyond which the edge is not
\                       shown
\
\ ******************************************************************************

MACRO EDGE vertex1, vertex2, face1, face2, visibility

 f = face1 + (face2 << 4)
 EQUB visibility, f, vertex1 << 2, vertex2 << 2

ENDMACRO

\ ******************************************************************************
\
\       Name: FACE
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding faces to ship blueprints
\  Deep dive: Ship blueprints
\             Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   FACE normal_x, normal_y, normal_z, visibility
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   normal_x            The face normal's x-coordinate
\
\   normal_y            The face normal's y-coordinate
\
\   normal_z            The face normal's z-coordinate
\
\   visibility          The visibility distance, beyond which the edge is always
\                       shown
\
\ ******************************************************************************

MACRO FACE normal_x, normal_y, normal_z, visibility

 IF normal_x < 0
  s_x = 1 << 7
 ELSE
  s_x = 0
 ENDIF

 IF normal_y < 0
  s_y = 1 << 6
 ELSE
  s_y = 0
 ENDIF

 IF normal_z < 0
  s_z = 1 << 5
 ELSE
  s_z = 0
 ENDIF

 s = s_x + s_y + s_z + visibility
 ax = ABS(normal_x)
 ay = ABS(normal_y)
 az = ABS(normal_z)

 EQUB s, ax, ay, az

ENDMACRO

\ ******************************************************************************
\
\       Name: SHIP_SIDEWINDER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Sidewinder
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_SIDEWINDER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 65 * 65           \ Targetable area          = 65 * 65

 EQUB LO(SHIP_SIDEWINDER_EDGES - SHIP_SIDEWINDER)  \ Edges data offset (low)
 EQUB LO(SHIP_SIDEWINDER_FACES - SHIP_SIDEWINDER)  \ Faces data offset (low)

 EQUB 61                \ Max. edge count          = (61 - 1) / 4 = 15
 EQUB 0                 \ Gun vertex               = 0
 EQUB 30                \ Explosion count          = 6, as (4 * n) + 6 = 30
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 15                \ Number of edges          = 15
 EQUW 50                \ Bounty                   = 50
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 20                \ Visibility distance      = 20
 EQUB 70                \ Max. energy              = 70
 EQUB 37                \ Max. speed               = 37

 EQUB HI(SHIP_SIDEWINDER_EDGES - SHIP_SIDEWINDER)  \ Edges data offset (high)
 EQUB HI(SHIP_SIDEWINDER_FACES - SHIP_SIDEWINDER)  \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

.SHIP_SIDEWINDER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  -32,    0,   36,     0,      1,    4,     5,         31    \ Vertex 0
 VERTEX   32,    0,   36,     0,      2,    5,     6,         31    \ Vertex 1
 VERTEX   64,    0,  -28,     2,      3,    6,     6,         31    \ Vertex 2
 VERTEX  -64,    0,  -28,     1,      3,    4,     4,         31    \ Vertex 3
 VERTEX    0,   16,  -28,     0,      1,    2,     3,         31    \ Vertex 4
 VERTEX    0,  -16,  -28,     3,      4,    5,     6,         31    \ Vertex 5
 VERTEX  -12,    6,  -28,     3,      3,    3,     3,         15    \ Vertex 6
 VERTEX   12,    6,  -28,     3,      3,    3,     3,         15    \ Vertex 7
 VERTEX   12,   -6,  -28,     3,      3,    3,     3,         12    \ Vertex 8
 VERTEX  -12,   -6,  -28,     3,      3,    3,     3,         12    \ Vertex 9

.SHIP_SIDEWINDER_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     5,         31    \ Edge 0
 EDGE       1,       2,     2,     6,         31    \ Edge 1
 EDGE       1,       4,     0,     2,         31    \ Edge 2
 EDGE       0,       4,     0,     1,         31    \ Edge 3
 EDGE       0,       3,     1,     4,         31    \ Edge 4
 EDGE       3,       4,     1,     3,         31    \ Edge 5
 EDGE       2,       4,     2,     3,         31    \ Edge 6
 EDGE       3,       5,     3,     4,         31    \ Edge 7
 EDGE       2,       5,     3,     6,         31    \ Edge 8
 EDGE       1,       5,     5,     6,         31    \ Edge 9
 EDGE       0,       5,     4,     5,         31    \ Edge 10
 EDGE       6,       7,     3,     3,         15    \ Edge 11
 EDGE       7,       8,     3,     3,         12    \ Edge 12
 EDGE       6,       9,     3,     3,         12    \ Edge 13
 EDGE       8,       9,     3,     3,         12    \ Edge 14

.SHIP_SIDEWINDER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       32,        8,         31      \ Face 0
 FACE      -12,       47,        6,         31      \ Face 1
 FACE       12,       47,        6,         31      \ Face 2
 FACE        0,        0,     -112,         31      \ Face 3
 FACE      -12,      -47,        6,         31      \ Face 4
 FACE        0,      -32,        8,         31      \ Face 5
 FACE       12,      -47,        6,         31      \ Face 6

\ ******************************************************************************
\
\       Name: SHIP_VIPER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Viper
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_VIPER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 75 * 75           \ Targetable area          = 75 * 75

 EQUB LO(SHIP_VIPER_EDGES - SHIP_VIPER)            \ Edges data offset (low)
 EQUB LO(SHIP_VIPER_FACES - SHIP_VIPER)            \ Faces data offset (low)

 EQUB 77                \ Max. edge count          = (77 - 1) / 4 = 19
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 90                \ Number of vertices       = 90 / 6 = 15
 EQUB 20                \ Number of edges          = 20
 EQUW 0                 \ Bounty                   = 0
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 23                \ Visibility distance      = 23
 EQUB 120               \ Max. energy              = 120
 EQUB 32                \ Max. speed               = 32

 EQUB HI(SHIP_VIPER_EDGES - SHIP_VIPER)            \ Edges data offset (high)
 EQUB HI(SHIP_VIPER_FACES - SHIP_VIPER)            \ Faces data offset (high)

 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00010001         \ Laser power              = 2
                        \ Missiles                 = 1

.SHIP_VIPER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   72,     1,      2,    3,     4,         31    \ Vertex 0
 VERTEX    0,   16,   24,     0,      1,    2,     2,         30    \ Vertex 1
 VERTEX    0,  -16,   24,     3,      4,    5,     5,         30    \ Vertex 2
 VERTEX   48,    0,  -24,     2,      4,    6,     6,         31    \ Vertex 3
 VERTEX  -48,    0,  -24,     1,      3,    6,     6,         31    \ Vertex 4
 VERTEX   24,  -16,  -24,     4,      5,    6,     6,         30    \ Vertex 5
 VERTEX  -24,  -16,  -24,     5,      3,    6,     6,         30    \ Vertex 6
 VERTEX   24,   16,  -24,     0,      2,    6,     6,         31    \ Vertex 7
 VERTEX  -24,   16,  -24,     0,      1,    6,     6,         31    \ Vertex 8
 VERTEX  -32,    0,  -24,     6,      6,    6,     6,         19    \ Vertex 9
 VERTEX   32,    0,  -24,     6,      6,    6,     6,         19    \ Vertex 10
 VERTEX    8,    8,  -24,     6,      6,    6,     6,         19    \ Vertex 11
 VERTEX   -8,    8,  -24,     6,      6,    6,     6,         19    \ Vertex 12
 VERTEX   -8,   -8,  -24,     6,      6,    6,     6,         18    \ Vertex 13
 VERTEX    8,   -8,  -24,     6,      6,    6,     6,         18    \ Vertex 14

.SHIP_VIPER_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       3,     2,     4,         31    \ Edge 0
 EDGE       0,       1,     1,     2,         30    \ Edge 1
 EDGE       0,       2,     3,     4,         30    \ Edge 2
 EDGE       0,       4,     1,     3,         31    \ Edge 3
 EDGE       1,       7,     0,     2,         30    \ Edge 4
 EDGE       1,       8,     0,     1,         30    \ Edge 5
 EDGE       2,       5,     4,     5,         30    \ Edge 6
 EDGE       2,       6,     3,     5,         30    \ Edge 7
 EDGE       7,       8,     0,     6,         31    \ Edge 8
 EDGE       5,       6,     5,     6,         30    \ Edge 9
 EDGE       4,       8,     1,     6,         31    \ Edge 10
 EDGE       4,       6,     3,     6,         30    \ Edge 11
 EDGE       3,       7,     2,     6,         31    \ Edge 12
 EDGE       3,       5,     6,     4,         30    \ Edge 13
 EDGE       9,      12,     6,     6,         19    \ Edge 14
 EDGE       9,      13,     6,     6,         18    \ Edge 15
 EDGE      10,      11,     6,     6,         19    \ Edge 16
 EDGE      10,      14,     6,     6,         18    \ Edge 17
 EDGE      11,      14,     6,     6,         16    \ Edge 18
 EDGE      12,      13,     6,     6,         16    \ Edge 19

.SHIP_VIPER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       32,        0,         31      \ Face 0
 FACE      -22,       33,       11,         31      \ Face 1
 FACE       22,       33,       11,         31      \ Face 2
 FACE      -22,      -33,       11,         31      \ Face 3
 FACE       22,      -33,       11,         31      \ Face 4
 FACE        0,      -32,        0,         31      \ Face 5
 FACE        0,        0,      -48,         31      \ Face 6

\ ******************************************************************************
\
\       Name: SHIP_MAMBA
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Mamba
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_MAMBA

 EQUB 1                 \ Max. canisters on demise = 1
 EQUW 70 * 70           \ Targetable area          = 70 * 70

 EQUB LO(SHIP_MAMBA_EDGES - SHIP_MAMBA)            \ Edges data offset (low)
 EQUB LO(SHIP_MAMBA_FACES - SHIP_MAMBA)            \ Faces data offset (low)

 EQUB 93                \ Max. edge count          = (93 - 1) / 4 = 23
 EQUB 0                 \ Gun vertex               = 0
 EQUB 34                \ Explosion count          = 7, as (4 * n) + 6 = 34
 EQUB 150               \ Number of vertices       = 150 / 6 = 25
 EQUB 28                \ Number of edges          = 28
 EQUW 150               \ Bounty                   = 150
 EQUB 20                \ Number of faces          = 20 / 4 = 5
 EQUB 25                \ Visibility distance      = 25
 EQUB 90                \ Max. energy              = 90
 EQUB 30                \ Max. speed               = 30

 EQUB HI(SHIP_MAMBA_EDGES - SHIP_MAMBA)            \ Edges data offset (high)
 EQUB HI(SHIP_MAMBA_FACES - SHIP_MAMBA)            \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010010         \ Laser power              = 2
                        \ Missiles                 = 2

.SHIP_MAMBA_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   64,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX  -64,   -8,  -32,     0,      2,    4,     4,         31    \ Vertex 1
 VERTEX  -32,    8,  -32,     1,      2,    4,     4,         30    \ Vertex 2
 VERTEX   32,    8,  -32,     1,      3,    4,     4,         30    \ Vertex 3
 VERTEX   64,   -8,  -32,     0,      3,    4,     4,         31    \ Vertex 4
 VERTEX   -4,    4,   16,     1,      1,    1,     1,         14    \ Vertex 5
 VERTEX    4,    4,   16,     1,      1,    1,     1,         14    \ Vertex 6
 VERTEX    8,    3,   28,     1,      1,    1,     1,         13    \ Vertex 7
 VERTEX   -8,    3,   28,     1,      1,    1,     1,         13    \ Vertex 8
 VERTEX  -20,   -4,   16,     0,      0,    0,     0,         20    \ Vertex 9
 VERTEX   20,   -4,   16,     0,      0,    0,     0,         20    \ Vertex 10
 VERTEX  -24,   -7,  -20,     0,      0,    0,     0,         20    \ Vertex 11
 VERTEX  -16,   -7,  -20,     0,      0,    0,     0,         16    \ Vertex 12
 VERTEX   16,   -7,  -20,     0,      0,    0,     0,         16    \ Vertex 13
 VERTEX   24,   -7,  -20,     0,      0,    0,     0,         20    \ Vertex 14
 VERTEX   -8,    4,  -32,     4,      4,    4,     4,         13    \ Vertex 15
 VERTEX    8,    4,  -32,     4,      4,    4,     4,         13    \ Vertex 16
 VERTEX    8,   -4,  -32,     4,      4,    4,     4,         14    \ Vertex 17
 VERTEX   -8,   -4,  -32,     4,      4,    4,     4,         14    \ Vertex 18
 VERTEX  -32,    4,  -32,     4,      4,    4,     4,          7    \ Vertex 19
 VERTEX   32,    4,  -32,     4,      4,    4,     4,          7    \ Vertex 20
 VERTEX   36,   -4,  -32,     4,      4,    4,     4,          7    \ Vertex 21
 VERTEX  -36,   -4,  -32,     4,      4,    4,     4,          7    \ Vertex 22
 VERTEX  -38,    0,  -32,     4,      4,    4,     4,          5    \ Vertex 23
 VERTEX   38,    0,  -32,     4,      4,    4,     4,          5    \ Vertex 24

.SHIP_MAMBA_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     2,         31    \ Edge 0
 EDGE       0,       4,     0,     3,         31    \ Edge 1
 EDGE       1,       4,     0,     4,         31    \ Edge 2
 EDGE       1,       2,     2,     4,         30    \ Edge 3
 EDGE       2,       3,     1,     4,         30    \ Edge 4
 EDGE       3,       4,     3,     4,         30    \ Edge 5
 EDGE       5,       6,     1,     1,         14    \ Edge 6
 EDGE       6,       7,     1,     1,         12    \ Edge 7
 EDGE       7,       8,     1,     1,         13    \ Edge 8
 EDGE       5,       8,     1,     1,         12    \ Edge 9
 EDGE       9,      11,     0,     0,         20    \ Edge 10
 EDGE       9,      12,     0,     0,         16    \ Edge 11
 EDGE      10,      13,     0,     0,         16    \ Edge 12
 EDGE      10,      14,     0,     0,         20    \ Edge 13
 EDGE      13,      14,     0,     0,         14    \ Edge 14
 EDGE      11,      12,     0,     0,         14    \ Edge 15
 EDGE      15,      16,     4,     4,         13    \ Edge 16
 EDGE      17,      18,     4,     4,         14    \ Edge 17
 EDGE      15,      18,     4,     4,         12    \ Edge 18
 EDGE      16,      17,     4,     4,         12    \ Edge 19
 EDGE      20,      21,     4,     4,          7    \ Edge 20
 EDGE      20,      24,     4,     4,          5    \ Edge 21
 EDGE      21,      24,     4,     4,          5    \ Edge 22
 EDGE      19,      22,     4,     4,          7    \ Edge 23
 EDGE      19,      23,     4,     4,          5    \ Edge 24
 EDGE      22,      23,     4,     4,          5    \ Edge 25
 EDGE       0,       2,     1,     2,         30    \ Edge 26
 EDGE       0,       3,     1,     3,         30    \ Edge 27

.SHIP_MAMBA_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,      -24,        2,         30      \ Face 0
 FACE        0,       24,        2,         30      \ Face 1
 FACE      -32,       64,       16,         30      \ Face 2
 FACE       32,       64,       16,         30      \ Face 3
 FACE        0,        0,     -127,         30      \ Face 4

\ ******************************************************************************
\
\       Name: SHIP_COBRA_MK_3
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Cobra Mk III
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_COBRA_MK_3

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 95 * 95           \ Targetable area          = 95 * 95

 EQUB LO(SHIP_COBRA_MK_3_EDGES - SHIP_COBRA_MK_3)  \ Edges data offset (low)
 EQUB LO(SHIP_COBRA_MK_3_FACES - SHIP_COBRA_MK_3)  \ Faces data offset (low)

 EQUB 153               \ Max. edge count          = (153 - 1) / 4 = 38
 EQUB 84                \ Gun vertex               = 84 / 4 = 21
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 168               \ Number of vertices       = 168 / 6 = 28
 EQUB 38                \ Number of edges          = 38
 EQUW 0                 \ Bounty                   = 0
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 50                \ Visibility distance      = 50
 EQUB 150               \ Max. energy              = 150
 EQUB 28                \ Max. speed               = 28

 EQUB HI(SHIP_COBRA_MK_3_EDGES - SHIP_COBRA_MK_3)  \ Edges data offset (low)
 EQUB HI(SHIP_COBRA_MK_3_FACES - SHIP_COBRA_MK_3)  \ Faces data offset (low)

 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00010011         \ Laser power              = 2
                        \ Missiles                 = 3

.SHIP_COBRA_MK_3_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   32,    0,   76,    15,     15,   15,    15,         31    \ Vertex 0
 VERTEX  -32,    0,   76,    15,     15,   15,    15,         31    \ Vertex 1
 VERTEX    0,   26,   24,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX -120,   -3,   -8,     3,      7,   10,    10,         31    \ Vertex 3
 VERTEX  120,   -3,   -8,     4,      8,   12,    12,         31    \ Vertex 4
 VERTEX  -88,   16,  -40,    15,     15,   15,    15,         31    \ Vertex 5
 VERTEX   88,   16,  -40,    15,     15,   15,    15,         31    \ Vertex 6
 VERTEX  128,   -8,  -40,     8,      9,   12,    12,         31    \ Vertex 7
 VERTEX -128,   -8,  -40,     7,      9,   10,    10,         31    \ Vertex 8
 VERTEX    0,   26,  -40,     5,      6,    9,     9,         31    \ Vertex 9
 VERTEX  -32,  -24,  -40,     9,     10,   11,    11,         31    \ Vertex 10
 VERTEX   32,  -24,  -40,     9,     11,   12,    12,         31    \ Vertex 11
 VERTEX  -36,    8,  -40,     9,      9,    9,     9,         20    \ Vertex 12
 VERTEX   -8,   12,  -40,     9,      9,    9,     9,         20    \ Vertex 13
 VERTEX    8,   12,  -40,     9,      9,    9,     9,         20    \ Vertex 14
 VERTEX   36,    8,  -40,     9,      9,    9,     9,         20    \ Vertex 15
 VERTEX   36,  -12,  -40,     9,      9,    9,     9,         20    \ Vertex 16
 VERTEX    8,  -16,  -40,     9,      9,    9,     9,         20    \ Vertex 17
 VERTEX   -8,  -16,  -40,     9,      9,    9,     9,         20    \ Vertex 18
 VERTEX  -36,  -12,  -40,     9,      9,    9,     9,         20    \ Vertex 19
 VERTEX    0,    0,   76,     0,     11,   11,    11,          6    \ Vertex 20
 VERTEX    0,    0,   90,     0,     11,   11,    11,         31    \ Vertex 21
 VERTEX  -80,   -6,  -40,     9,      9,    9,     9,          8    \ Vertex 22
 VERTEX  -80,    6,  -40,     9,      9,    9,     9,          8    \ Vertex 23
 VERTEX  -88,    0,  -40,     9,      9,    9,     9,          6    \ Vertex 24
 VERTEX   80,    6,  -40,     9,      9,    9,     9,          8    \ Vertex 25
 VERTEX   88,    0,  -40,     9,      9,    9,     9,          6    \ Vertex 26
 VERTEX   80,   -6,  -40,     9,      9,    9,     9,          8    \ Vertex 27

.SHIP_COBRA_MK_3_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,    11,         31    \ Edge 0
 EDGE       0,       4,     4,    12,         31    \ Edge 1
 EDGE       1,       3,     3,    10,         31    \ Edge 2
 EDGE       3,       8,     7,    10,         31    \ Edge 3
 EDGE       4,       7,     8,    12,         31    \ Edge 4
 EDGE       6,       7,     8,     9,         31    \ Edge 5
 EDGE       6,       9,     6,     9,         31    \ Edge 6
 EDGE       5,       9,     5,     9,         31    \ Edge 7
 EDGE       5,       8,     7,     9,         31    \ Edge 8
 EDGE       2,       5,     1,     5,         31    \ Edge 9
 EDGE       2,       6,     2,     6,         31    \ Edge 10
 EDGE       3,       5,     3,     7,         31    \ Edge 11
 EDGE       4,       6,     4,     8,         31    \ Edge 12
 EDGE       1,       2,     0,     1,         31    \ Edge 13
 EDGE       0,       2,     0,     2,         31    \ Edge 14
 EDGE       8,      10,     9,    10,         31    \ Edge 15
 EDGE      10,      11,     9,    11,         31    \ Edge 16
 EDGE       7,      11,     9,    12,         31    \ Edge 17
 EDGE       1,      10,    10,    11,         31    \ Edge 18
 EDGE       0,      11,    11,    12,         31    \ Edge 19
 EDGE       1,       5,     1,     3,         29    \ Edge 20
 EDGE       0,       6,     2,     4,         29    \ Edge 21
 EDGE      20,      21,     0,    11,          6    \ Edge 22
 EDGE      12,      13,     9,     9,         20    \ Edge 23
 EDGE      18,      19,     9,     9,         20    \ Edge 24
 EDGE      14,      15,     9,     9,         20    \ Edge 25
 EDGE      16,      17,     9,     9,         20    \ Edge 26
 EDGE      15,      16,     9,     9,         19    \ Edge 27
 EDGE      14,      17,     9,     9,         17    \ Edge 28
 EDGE      13,      18,     9,     9,         19    \ Edge 29
 EDGE      12,      19,     9,     9,         19    \ Edge 30
 EDGE       2,       9,     5,     6,         30    \ Edge 31
 EDGE      22,      24,     9,     9,          6    \ Edge 32
 EDGE      23,      24,     9,     9,          6    \ Edge 33
 EDGE      22,      23,     9,     9,          8    \ Edge 34
 EDGE      25,      26,     9,     9,          6    \ Edge 35
 EDGE      26,      27,     9,     9,          6    \ Edge 36
 EDGE      25,      27,     9,     9,          8    \ Edge 37

.SHIP_COBRA_MK_3_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       62,       31,         31      \ Face 0
 FACE      -18,       55,       16,         31      \ Face 1
 FACE       18,       55,       16,         31      \ Face 2
 FACE      -16,       52,       14,         31      \ Face 3
 FACE       16,       52,       14,         31      \ Face 4
 FACE      -14,       47,        0,         31      \ Face 5
 FACE       14,       47,        0,         31      \ Face 6
 FACE      -61,      102,        0,         31      \ Face 7
 FACE       61,      102,        0,         31      \ Face 8
 FACE        0,        0,      -80,         31      \ Face 9
 FACE       -7,      -42,        9,         31      \ Face 10
 FACE        0,      -30,        6,         31      \ Face 11
 FACE        7,      -42,        9,         31      \ Face 12

\ ******************************************************************************
\
\       Name: SHIP_THARGOID
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Thargoid mothership
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_THARGOID

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99

 EQUB LO(SHIP_THARGOID_EDGES - SHIP_THARGOID)      \ Edges data offset (low)
 EQUB LO(SHIP_THARGOID_FACES - SHIP_THARGOID)      \ Faces data offset (low)

 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
 EQUB 60                \ Gun vertex               = 60 / 4 = 15
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 120               \ Number of vertices       = 120 / 6 = 20
 EQUB 26                \ Number of edges          = 26
 EQUW 500               \ Bounty                   = 500
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 55                \ Visibility distance      = 55
 EQUB 240               \ Max. energy              = 240
 EQUB 39                \ Max. speed               = 39

 EQUB HI(SHIP_THARGOID_EDGES - SHIP_THARGOID)      \ Edges data offset (high)
 EQUB HI(SHIP_THARGOID_FACES - SHIP_THARGOID)      \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010110         \ Laser power              = 2
                        \ Missiles                 = 6

.SHIP_THARGOID_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   32,  -48,   48,     0,      4,    8,     8,         31    \ Vertex 0
 VERTEX   32,  -68,    0,     0,      1,    4,     4,         31    \ Vertex 1
 VERTEX   32,  -48,  -48,     1,      2,    4,     4,         31    \ Vertex 2
 VERTEX   32,    0,  -68,     2,      3,    4,     4,         31    \ Vertex 3
 VERTEX   32,   48,  -48,     3,      4,    5,     5,         31    \ Vertex 4
 VERTEX   32,   68,    0,     4,      5,    6,     6,         31    \ Vertex 5
 VERTEX   32,   48,   48,     4,      6,    7,     7,         31    \ Vertex 6
 VERTEX   32,    0,   68,     4,      7,    8,     8,         31    \ Vertex 7
 VERTEX  -24, -116,  116,     0,      8,    9,     9,         31    \ Vertex 8
 VERTEX  -24, -164,    0,     0,      1,    9,     9,         31    \ Vertex 9
 VERTEX  -24, -116, -116,     1,      2,    9,     9,         31    \ Vertex 10
 VERTEX  -24,    0, -164,     2,      3,    9,     9,         31    \ Vertex 11
 VERTEX  -24,  116, -116,     3,      5,    9,     9,         31    \ Vertex 12
 VERTEX  -24,  164,    0,     5,      6,    9,     9,         31    \ Vertex 13
 VERTEX  -24,  116,  116,     6,      7,    9,     9,         31    \ Vertex 14
 VERTEX  -24,    0,  164,     7,      8,    9,     9,         31    \ Vertex 15
 VERTEX  -24,   64,   80,     9,      9,    9,     9,         30    \ Vertex 16
 VERTEX  -24,   64,  -80,     9,      9,    9,     9,         30    \ Vertex 17
 VERTEX  -24,  -64,  -80,     9,      9,    9,     9,         30    \ Vertex 18
 VERTEX  -24,  -64,   80,     9,      9,    9,     9,         30    \ Vertex 19

.SHIP_THARGOID_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       7,     4,     8,         31    \ Edge 0
 EDGE       0,       1,     0,     4,         31    \ Edge 1
 EDGE       1,       2,     1,     4,         31    \ Edge 2
 EDGE       2,       3,     2,     4,         31    \ Edge 3
 EDGE       3,       4,     3,     4,         31    \ Edge 4
 EDGE       4,       5,     4,     5,         31    \ Edge 5
 EDGE       5,       6,     4,     6,         31    \ Edge 6
 EDGE       6,       7,     4,     7,         31    \ Edge 7
 EDGE       0,       8,     0,     8,         31    \ Edge 8
 EDGE       1,       9,     0,     1,         31    \ Edge 9
 EDGE       2,      10,     1,     2,         31    \ Edge 10
 EDGE       3,      11,     2,     3,         31    \ Edge 11
 EDGE       4,      12,     3,     5,         31    \ Edge 12
 EDGE       5,      13,     5,     6,         31    \ Edge 13
 EDGE       6,      14,     6,     7,         31    \ Edge 14
 EDGE       7,      15,     7,     8,         31    \ Edge 15
 EDGE       8,      15,     8,     9,         31    \ Edge 16
 EDGE       8,       9,     0,     9,         31    \ Edge 17
 EDGE       9,      10,     1,     9,         31    \ Edge 18
 EDGE      10,      11,     2,     9,         31    \ Edge 19
 EDGE      11,      12,     3,     9,         31    \ Edge 20
 EDGE      12,      13,     5,     9,         31    \ Edge 21
 EDGE      13,      14,     6,     9,         31    \ Edge 22
 EDGE      14,      15,     7,     9,         31    \ Edge 23
 EDGE      16,      17,     9,     9,         30    \ Edge 24
 EDGE      18,      19,     9,     9,         30    \ Edge 25

.SHIP_THARGOID_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      103,      -60,       25,         31      \ Face 0
 FACE      103,      -60,      -25,         31      \ Face 1
 FACE      103,      -25,      -60,         31      \ Face 2
 FACE      103,       25,      -60,         31      \ Face 3
 FACE       64,        0,        0,         31      \ Face 4
 FACE      103,       60,      -25,         31      \ Face 5
 FACE      103,       60,       25,         31      \ Face 6
 FACE      103,       25,       60,         31      \ Face 7
 FACE      103,      -25,       60,         31      \ Face 8
 FACE      -48,        0,        0,         31      \ Face 9

\ ******************************************************************************
\
\       Name: SHIP_CORIOLIS
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Coriolis space station
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_CORIOLIS

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 160 * 160         \ Targetable area          = 160 * 160

 EQUB LO(SHIP_CORIOLIS_EDGES - SHIP_CORIOLIS)      \ Edges data offset (low)
 EQUB LO(SHIP_CORIOLIS_FACES - SHIP_CORIOLIS)      \ Faces data offset (low)

 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
 EQUB 0                 \ Gun vertex               = 0
 EQUB 54                \ Explosion count          = 12, as (4 * n) + 6 = 54
 EQUB 96                \ Number of vertices       = 96 / 6 = 16
 EQUB 28                \ Number of edges          = 28
 EQUW 0                 \ Bounty                   = 0
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 120               \ Visibility distance      = 120
 EQUB 240               \ Max. energy              = 240
 EQUB 0                 \ Max. speed               = 0

 EQUB HI(SHIP_CORIOLIS_EDGES - SHIP_CORIOLIS)      \ Edges data offset (high)
 EQUB HI(SHIP_CORIOLIS_FACES - SHIP_CORIOLIS)      \ Faces data offset (high)

 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00000110         \ Laser power              = 0
                        \ Missiles                 = 6

.SHIP_CORIOLIS_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  160,    0,  160,     0,      1,    2,     6,         31    \ Vertex 0
 VERTEX    0,  160,  160,     0,      2,    3,     8,         31    \ Vertex 1
 VERTEX -160,    0,  160,     0,      3,    4,     7,         31    \ Vertex 2
 VERTEX    0, -160,  160,     0,      1,    4,     5,         31    \ Vertex 3
 VERTEX  160, -160,    0,     1,      5,    6,    10,         31    \ Vertex 4
 VERTEX  160,  160,    0,     2,      6,    8,    11,         31    \ Vertex 5
 VERTEX -160,  160,    0,     3,      7,    8,    12,         31    \ Vertex 6
 VERTEX -160, -160,    0,     4,      5,    7,     9,         31    \ Vertex 7
 VERTEX  160,    0, -160,     6,     10,   11,    13,         31    \ Vertex 8
 VERTEX    0,  160, -160,     8,     11,   12,    13,         31    \ Vertex 9
 VERTEX -160,    0, -160,     7,      9,   12,    13,         31    \ Vertex 10
 VERTEX    0, -160, -160,     5,      9,   10,    13,         31    \ Vertex 11
 VERTEX   10,  -30,  160,     0,      0,    0,     0,         30    \ Vertex 12
 VERTEX   10,   30,  160,     0,      0,    0,     0,         30    \ Vertex 13
 VERTEX  -10,   30,  160,     0,      0,    0,     0,         30    \ Vertex 14
 VERTEX  -10,  -30,  160,     0,      0,    0,     0,         30    \ Vertex 15

.SHIP_CORIOLIS_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       3,     0,     1,         31    \ Edge 0
 EDGE       0,       1,     0,     2,         31    \ Edge 1
 EDGE       1,       2,     0,     3,         31    \ Edge 2
 EDGE       2,       3,     0,     4,         31    \ Edge 3
 EDGE       3,       4,     1,     5,         31    \ Edge 4
 EDGE       0,       4,     1,     6,         31    \ Edge 5
 EDGE       0,       5,     2,     6,         31    \ Edge 6
 EDGE       5,       1,     2,     8,         31    \ Edge 7
 EDGE       1,       6,     3,     8,         31    \ Edge 8
 EDGE       2,       6,     3,     7,         31    \ Edge 9
 EDGE       2,       7,     4,     7,         31    \ Edge 10
 EDGE       3,       7,     4,     5,         31    \ Edge 11
 EDGE       8,      11,    10,    13,         31    \ Edge 12
 EDGE       8,       9,    11,    13,         31    \ Edge 13
 EDGE       9,      10,    12,    13,         31    \ Edge 14
 EDGE      10,      11,     9,    13,         31    \ Edge 15
 EDGE       4,      11,     5,    10,         31    \ Edge 16
 EDGE       4,       8,     6,    10,         31    \ Edge 17
 EDGE       5,       8,     6,    11,         31    \ Edge 18
 EDGE       5,       9,     8,    11,         31    \ Edge 19
 EDGE       6,       9,     8,    12,         31    \ Edge 20
 EDGE       6,      10,     7,    12,         31    \ Edge 21
 EDGE       7,      10,     7,     9,         31    \ Edge 22
 EDGE       7,      11,     5,     9,         31    \ Edge 23
 EDGE      12,      13,     0,     0,         30    \ Edge 24
 EDGE      13,      14,     0,     0,         30    \ Edge 25
 EDGE      14,      15,     0,     0,         30    \ Edge 26
 EDGE      15,      12,     0,     0,         30    \ Edge 27

.SHIP_CORIOLIS_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,        0,      160,         31      \ Face 0
 FACE      107,     -107,      107,         31      \ Face 1
 FACE      107,      107,      107,         31      \ Face 2
 FACE     -107,      107,      107,         31      \ Face 3
 FACE     -107,     -107,      107,         31      \ Face 4
 FACE        0,     -160,        0,         31      \ Face 5
 FACE      160,        0,        0,         31      \ Face 6
 FACE     -160,        0,        0,         31      \ Face 7
 FACE        0,      160,        0,         31      \ Face 8
 FACE     -107,     -107,     -107,         31      \ Face 9
 FACE      107,     -107,     -107,         31      \ Face 10
 FACE      107,      107,     -107,         31      \ Face 11
 FACE     -107,      107,     -107,         31      \ Face 12
 FACE        0,        0,     -160,         31      \ Face 13

\ ******************************************************************************
\
\       Name: SHIP_MISSILE
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a missile
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_MISSILE

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 40 * 40           \ Targetable area          = 40 * 40

 EQUB LO(SHIP_MISSILE_EDGES - SHIP_MISSILE)        \ Edges data offset (low)
 EQUB LO(SHIP_MISSILE_FACES - SHIP_MISSILE)        \ Faces data offset (low)

 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
 EQUB 0                 \ Gun vertex               = 0
 EQUB 10                \ Explosion count          = 1, as (4 * n) + 6 = 10
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 24                \ Number of edges          = 24
 EQUW 0                 \ Bounty                   = 0
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 14                \ Visibility distance      = 14
 EQUB 2                 \ Max. energy              = 2
 EQUB 44                \ Max. speed               = 44

 EQUB HI(SHIP_MISSILE_EDGES - SHIP_MISSILE)        \ Edges data offset (high)
 EQUB HI(SHIP_MISSILE_FACES - SHIP_MISSILE)        \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_MISSILE_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   68,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX    8,   -8,   36,     1,      2,    4,     5,         31    \ Vertex 1
 VERTEX    8,    8,   36,     2,      3,    4,     7,         31    \ Vertex 2
 VERTEX   -8,    8,   36,     0,      3,    6,     7,         31    \ Vertex 3
 VERTEX   -8,   -8,   36,     0,      1,    5,     6,         31    \ Vertex 4
 VERTEX    8,    8,  -44,     4,      7,    8,     8,         31    \ Vertex 5
 VERTEX    8,   -8,  -44,     4,      5,    8,     8,         31    \ Vertex 6
 VERTEX   -8,   -8,  -44,     5,      6,    8,     8,         31    \ Vertex 7
 VERTEX   -8,    8,  -44,     6,      7,    8,     8,         31    \ Vertex 8
 VERTEX   12,   12,  -44,     4,      7,    8,     8,          8    \ Vertex 9
 VERTEX   12,  -12,  -44,     4,      5,    8,     8,          8    \ Vertex 10
 VERTEX  -12,  -12,  -44,     5,      6,    8,     8,          8    \ Vertex 11
 VERTEX  -12,   12,  -44,     6,      7,    8,     8,          8    \ Vertex 12
 VERTEX   -8,    8,  -12,     6,      7,    7,     7,          8    \ Vertex 13
 VERTEX   -8,   -8,  -12,     5,      6,    6,     6,          8    \ Vertex 14
 VERTEX    8,    8,  -12,     4,      7,    7,     7,          8    \ Vertex 15
 VERTEX    8,   -8,  -12,     4,      5,    5,     5,          8    \ Vertex 16

.SHIP_MISSILE_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     2,         31    \ Edge 0
 EDGE       0,       2,     2,     3,         31    \ Edge 1
 EDGE       0,       3,     0,     3,         31    \ Edge 2
 EDGE       0,       4,     0,     1,         31    \ Edge 3
 EDGE       1,       2,     4,     2,         31    \ Edge 4
 EDGE       1,       4,     1,     5,         31    \ Edge 5
 EDGE       3,       4,     0,     6,         31    \ Edge 6
 EDGE       2,       3,     3,     7,         31    \ Edge 7
 EDGE       2,       5,     4,     7,         31    \ Edge 8
 EDGE       1,       6,     4,     5,         31    \ Edge 9
 EDGE       4,       7,     5,     6,         31    \ Edge 10
 EDGE       3,       8,     6,     7,         31    \ Edge 11
 EDGE       7,       8,     6,     8,         31    \ Edge 12
 EDGE       5,       8,     7,     8,         31    \ Edge 13
 EDGE       5,       6,     4,     8,         31    \ Edge 14
 EDGE       6,       7,     5,     8,         31    \ Edge 15
 EDGE       6,      10,     5,     8,          8    \ Edge 16
 EDGE       5,       9,     7,     8,          8    \ Edge 17
 EDGE       8,      12,     7,     8,          8    \ Edge 18
 EDGE       7,      11,     5,     8,          8    \ Edge 19
 EDGE       9,      15,     4,     7,          8    \ Edge 20
 EDGE      10,      16,     4,     5,          8    \ Edge 21
 EDGE      12,      13,     6,     7,          8    \ Edge 22
 EDGE      11,      14,     5,     6,          8    \ Edge 23

.SHIP_MISSILE_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      -64,        0,       16,         31      \ Face 0
 FACE        0,      -64,       16,         31      \ Face 1
 FACE       64,        0,       16,         31      \ Face 2
 FACE        0,       64,       16,         31      \ Face 3
 FACE       32,        0,        0,         31      \ Face 4
 FACE        0,      -32,        0,         31      \ Face 5
 FACE      -32,        0,        0,         31      \ Face 6
 FACE        0,       32,        0,         31      \ Face 7
 FACE        0,        0,     -176,         31      \ Face 8

\ ******************************************************************************
\
\       Name: SHIP_ASTEROID
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an asteroid
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_ASTEROID

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 80 * 80           \ Targetable area          = 80 * 80

 EQUB LO(SHIP_ASTEROID_EDGES - SHIP_ASTEROID)      \ Edges data offset (low)
 EQUB LO(SHIP_ASTEROID_FACES - SHIP_ASTEROID)      \ Faces data offset (low)

 EQUB 65                \ Max. edge count          = (65 - 1) / 4 = 16
 EQUB 0                 \ Gun vertex               = 0
 EQUB 34                \ Explosion count          = 7, as (4 * n) + 6 = 34
 EQUB 54                \ Number of vertices       = 54 / 6 = 9
 EQUB 21                \ Number of edges          = 21
 EQUW 5                 \ Bounty                   = 5
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 50                \ Visibility distance      = 50
 EQUB 60                \ Max. energy              = 60
 EQUB 30                \ Max. speed               = 30

 EQUB HI(SHIP_ASTEROID_EDGES - SHIP_ASTEROID)      \ Edges data offset (high)
 EQUB HI(SHIP_ASTEROID_FACES - SHIP_ASTEROID)      \ Faces data offset (high)

 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_ASTEROID_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   80,    0,    15,     15,   15,    15,         31    \ Vertex 0
 VERTEX  -80,  -10,    0,    15,     15,   15,    15,         31    \ Vertex 1
 VERTEX    0,  -80,    0,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX   70,  -40,    0,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX   60,   50,    0,     5,      6,   12,    13,         31    \ Vertex 4
 VERTEX   50,    0,   60,    15,     15,   15,    15,         31    \ Vertex 5
 VERTEX  -40,    0,   70,     0,      1,    2,     3,         31    \ Vertex 6
 VERTEX    0,   30,  -75,    15,     15,   15,    15,         31    \ Vertex 7
 VERTEX    0,  -50,  -60,     8,      9,   10,    11,         31    \ Vertex 8

.SHIP_ASTEROID_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     7,         31    \ Edge 0
 EDGE       0,       4,     6,    13,         31    \ Edge 1
 EDGE       3,       4,     5,    12,         31    \ Edge 2
 EDGE       2,       3,     4,    11,         31    \ Edge 3
 EDGE       1,       2,     3,    10,         31    \ Edge 4
 EDGE       1,       6,     2,     3,         31    \ Edge 5
 EDGE       2,       6,     1,     3,         31    \ Edge 6
 EDGE       2,       5,     1,     4,         31    \ Edge 7
 EDGE       5,       6,     0,     1,         31    \ Edge 8
 EDGE       0,       5,     0,     6,         31    \ Edge 9
 EDGE       3,       5,     4,     5,         31    \ Edge 10
 EDGE       0,       6,     0,     2,         31    \ Edge 11
 EDGE       4,       5,     5,     6,         31    \ Edge 12
 EDGE       1,       8,     8,    10,         31    \ Edge 13
 EDGE       1,       7,     7,     8,         31    \ Edge 14
 EDGE       0,       7,     7,    13,         31    \ Edge 15
 EDGE       4,       7,    12,    13,         31    \ Edge 16
 EDGE       3,       7,     9,    12,         31    \ Edge 17
 EDGE       3,       8,     9,    11,         31    \ Edge 18
 EDGE       2,       8,    10,    11,         31    \ Edge 19
 EDGE       7,       8,     8,     9,         31    \ Edge 20

.SHIP_ASTEROID_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        9,       66,       81,         31      \ Face 0
 FACE        9,      -66,       81,         31      \ Face 1
 FACE      -72,       64,       31,         31      \ Face 2
 FACE      -64,      -73,       47,         31      \ Face 3
 FACE       45,      -79,       65,         31      \ Face 4
 FACE      135,       15,       35,         31      \ Face 5
 FACE       38,       76,       70,         31      \ Face 6
 FACE      -66,       59,      -39,         31      \ Face 7
 FACE      -67,      -15,      -80,         31      \ Face 8
 FACE       66,      -14,      -75,         31      \ Face 9
 FACE      -70,      -80,      -40,         31      \ Face 10
 FACE       58,     -102,      -51,         31      \ Face 11
 FACE       81,        9,      -67,         31      \ Face 12
 FACE       47,       94,      -63,         31      \ Face 13

\ ******************************************************************************
\
\       Name: SHIP_CANISTER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a cargo canister
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_CANISTER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 20 * 20           \ Targetable area          = 20 * 20

 EQUB LO(SHIP_CANISTER_EDGES - SHIP_CANISTER)      \ Edges data offset (low)
 EQUB LO(SHIP_CANISTER_FACES - SHIP_CANISTER)      \ Faces data offset (low)

 EQUB 49                \ Max. edge count          = (49 - 1) / 4 = 12
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 15                \ Number of edges          = 15
 EQUW 0                 \ Bounty                   = 0
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 12                \ Visibility distance      = 12
 EQUB 17                \ Max. energy              = 17
 EQUB 15                \ Max. speed               = 15

 EQUB HI(SHIP_CANISTER_EDGES - SHIP_CANISTER)      \ Edges data offset (high)
 EQUB HI(SHIP_CANISTER_FACES - SHIP_CANISTER)      \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_CANISTER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   24,   16,    0,     0,      1,    5,     5,         31    \ Vertex 0
 VERTEX   24,    5,   15,     0,      1,    2,     2,         31    \ Vertex 1
 VERTEX   24,  -13,    9,     0,      2,    3,     3,         31    \ Vertex 2
 VERTEX   24,  -13,   -9,     0,      3,    4,     4,         31    \ Vertex 3
 VERTEX   24,    5,  -15,     0,      4,    5,     5,         31    \ Vertex 4
 VERTEX  -24,   16,    0,     1,      5,    6,     6,         31    \ Vertex 5
 VERTEX  -24,    5,   15,     1,      2,    6,     6,         31    \ Vertex 6
 VERTEX  -24,  -13,    9,     2,      3,    6,     6,         31    \ Vertex 7
 VERTEX  -24,  -13,   -9,     3,      4,    6,     6,         31    \ Vertex 8
 VERTEX  -24,    5,  -15,     4,      5,    6,     6,         31    \ Vertex 9

.SHIP_CANISTER_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     1,         31    \ Edge 0
 EDGE       1,       2,     0,     2,         31    \ Edge 1
 EDGE       2,       3,     0,     3,         31    \ Edge 2
 EDGE       3,       4,     0,     4,         31    \ Edge 3
 EDGE       0,       4,     0,     5,         31    \ Edge 4
 EDGE       0,       5,     1,     5,         31    \ Edge 5
 EDGE       1,       6,     1,     2,         31    \ Edge 6
 EDGE       2,       7,     2,     3,         31    \ Edge 7
 EDGE       3,       8,     3,     4,         31    \ Edge 8
 EDGE       4,       9,     4,     5,         31    \ Edge 9
 EDGE       5,       6,     1,     6,         31    \ Edge 10
 EDGE       6,       7,     2,     6,         31    \ Edge 11
 EDGE       7,       8,     3,     6,         31    \ Edge 12
 EDGE       8,       9,     4,     6,         31    \ Edge 13
 EDGE       9,       5,     5,     6,         31    \ Edge 14

.SHIP_CANISTER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE       96,        0,        0,         31      \ Face 0
 FACE        0,       41,       30,         31      \ Face 1
 FACE        0,      -18,       48,         31      \ Face 2
 FACE        0,      -51,        0,         31      \ Face 3
 FACE        0,      -18,      -48,         31      \ Face 4
 FACE        0,       41,      -30,         31      \ Face 5
 FACE      -96,        0,        0,         31      \ Face 6

\ ******************************************************************************
\
\       Name: SHIP_THARGON
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Thargon
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ------------------------------------------------------------------------------
\
\ The ship blueprint for the Thargon reuses the edges data from the cargo
\ canister, so the edges data offset is negative.
\
\ ******************************************************************************

.SHIP_THARGON

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 40 * 40           \ Targetable area          = 40 * 40

 EQUB LO(SHIP_CANISTER_EDGES - SHIP_THARGON)       \ Edges from canister
 EQUB LO(SHIP_THARGON_FACES - SHIP_THARGON)        \ Faces data offset (low)

 EQUB 65                \ Max. edge count          = (65 - 1) / 4 = 16
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 15                \ Number of edges          = 15
 EQUW 50                \ Bounty                   = 50
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 20                \ Visibility distance      = 20
 EQUB 20                \ Max. energy              = 20
 EQUB 30                \ Max. speed               = 30

 EQUB HI(SHIP_CANISTER_EDGES - SHIP_THARGON)       \ Edges from canister
 EQUB HI(SHIP_THARGON_FACES - SHIP_THARGON)        \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

.SHIP_THARGON_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   -9,    0,   40,     1,      0,    5,     5,         31    \ Vertex 0
 VERTEX   -9,  -38,   12,     1,      0,    2,     2,         31    \ Vertex 1
 VERTEX   -9,  -24,  -32,     2,      0,    3,     3,         31    \ Vertex 2
 VERTEX   -9,   24,  -32,     3,      0,    4,     4,         31    \ Vertex 3
 VERTEX   -9,   38,   12,     4,      0,    5,     5,         31    \ Vertex 4
 VERTEX    9,    0,   -8,     5,      1,    6,     6,         31    \ Vertex 5
 VERTEX    9,  -10,  -15,     2,      1,    6,     6,         31    \ Vertex 6
 VERTEX    9,   -6,  -26,     3,      2,    6,     6,         31    \ Vertex 7
 VERTEX    9,    6,  -26,     4,      3,    6,     6,         31    \ Vertex 8
 VERTEX    9,   10,  -15,     5,      4,    6,     6,         31    \ Vertex 9

.SHIP_THARGON_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      -36,        0,        0,         31      \ Face 0
 FACE       20,       -5,        7,         31      \ Face 1
 FACE       46,      -42,      -14,         31      \ Face 2
 FACE       36,        0,     -104,         31      \ Face 3
 FACE       46,       42,      -14,         31      \ Face 4
 FACE       20,        5,        7,         31      \ Face 5
 FACE       36,        0,        0,         31      \ Face 6

\ ******************************************************************************
\
\       Name: SHIP_ESCAPE_POD
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an escape pod
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_ESCAPE_POD

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 16 * 16           \ Targetable area          = 16 * 16

 EQUB LO(SHIP_ESCAPE_POD_EDGES - SHIP_ESCAPE_POD)  \ Edges data offset (low)
 EQUB LO(SHIP_ESCAPE_POD_FACES - SHIP_ESCAPE_POD)  \ Faces data offset (low)

 EQUB 25                \ Max. edge count          = (25 - 1) / 4 = 6
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 6                 \ Number of edges          = 6
 EQUW 0                 \ Bounty                   = 0
 EQUB 16                \ Number of faces          = 16 / 4 = 4
 EQUB 8                 \ Visibility distance      = 8
 EQUB 17                \ Max. energy              = 17
 EQUB 8                 \ Max. speed               = 8

 EQUB HI(SHIP_ESCAPE_POD_EDGES - SHIP_ESCAPE_POD)  \ Edges data offset (high)
 EQUB HI(SHIP_ESCAPE_POD_FACES - SHIP_ESCAPE_POD)  \ Faces data offset (high)

 EQUB 3                 \ Normals are scaled by    =  2^3 = 8
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_ESCAPE_POD_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   -7,    0,   36,     2,      1,    3,     3,         31    \ Vertex 0
 VERTEX   -7,  -14,  -12,     2,      0,    3,     3,         31    \ Vertex 1
 VERTEX   -7,   14,  -12,     1,      0,    3,     3,         31    \ Vertex 2
 VERTEX   21,    0,    0,     1,      0,    2,     2,         31    \ Vertex 3

.SHIP_ESCAPE_POD_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     2,         31    \ Edge 0
 EDGE       1,       2,     3,     0,         31    \ Edge 1
 EDGE       2,       3,     1,     0,         31    \ Edge 2
 EDGE       3,       0,     2,     1,         31    \ Edge 3
 EDGE       0,       2,     3,     1,         31    \ Edge 4
 EDGE       3,       1,     2,     0,         31    \ Edge 5

.SHIP_ESCAPE_POD_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE       26,        0,      -61,         31      \ Face 0
 FACE       19,       51,       15,         31      \ Face 1
 FACE       19,      -51,       15,         31      \ Face 2
 FACE      -56,        0,        0,         31      \ Face 3

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
 SAVE "versions/demo/3-assembled-output/SHIPS.bin", CODE_SHIPS%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE PYTHON SHIP BLUEPRINT FILE
\
\ Produces the binary file PYTHON.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CLEAR 0, &7F00

 CODE_PYTHON% = &7F00
 LOAD_PYTHON% = &1B00

 ORG CODE_PYTHON%       \ Set the assembly address to CODE_PYTHON%

\ ******************************************************************************
\
\       Name: SHIP_PYTHON
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Python
\  Deep dive: Ship blueprints
\             Comparing ship specifications
\
\ ******************************************************************************

.SHIP_PYTHON

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 120 * 120         \ Targetable area          = 120 * 120

 EQUB LO(SHIP_PYTHON_EDGES - SHIP_PYTHON)          \ Edges data offset (low)
 EQUB LO(SHIP_PYTHON_FACES - SHIP_PYTHON)          \ Faces data offset (low)

 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
 EQUB 0                 \ Gun vertex               = 0
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 26                \ Number of edges          = 26
 EQUW 200               \ Bounty                   = 200
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 40                \ Visibility distance      = 40
 EQUB 250               \ Max. energy              = 250
 EQUB 20                \ Max. speed               = 20

 EQUB HI(SHIP_PYTHON_EDGES - SHIP_PYTHON)          \ Edges data offset (high)
 EQUB HI(SHIP_PYTHON_FACES - SHIP_PYTHON)          \ Faces data offset (high)

 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00011011         \ Laser power              = 3
                        \ Missiles                 = 3

.SHIP_PYTHON_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,  224,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX    0,   48,   48,     0,      1,    4,     5,         30    \ Vertex 1
 VERTEX   96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX  -96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX    0,   48,  -32,     4,      5,    8,     9,         30    \ Vertex 4
 VERTEX    0,   24, -112,     9,      8,   12,    12,         31    \ Vertex 5
 VERTEX  -48,    0, -112,     8,     11,   12,    12,         31    \ Vertex 6
 VERTEX   48,    0, -112,     9,     10,   12,    12,         31    \ Vertex 7
 VERTEX    0,  -48,   48,     2,      3,    6,     7,         30    \ Vertex 8
 VERTEX    0,  -48,  -32,     6,      7,   10,    11,         30    \ Vertex 9
 VERTEX    0,  -24, -112,    10,     11,   12,    12,         30    \ Vertex 10

.SHIP_PYTHON_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       8,     2,     3,         30    \ Edge 0
 EDGE       0,       3,     0,     2,         31    \ Edge 1
 EDGE       0,       2,     1,     3,         31    \ Edge 2
 EDGE       0,       1,     0,     1,         30    \ Edge 3
 EDGE       2,       4,     9,     5,         29    \ Edge 4
 EDGE       1,       2,     1,     5,         29    \ Edge 5
 EDGE       2,       8,     7,     3,         29    \ Edge 6
 EDGE       1,       3,     0,     4,         29    \ Edge 7
 EDGE       3,       8,     2,     6,         29    \ Edge 8
 EDGE       2,       9,     7,    10,         29    \ Edge 9
 EDGE       3,       4,     4,     8,         29    \ Edge 10
 EDGE       3,       9,     6,    11,         29    \ Edge 11
 EDGE       3,       5,     8,     8,          5    \ Edge 12
 EDGE       3,      10,    11,    11,          5    \ Edge 13
 EDGE       2,       5,     9,     9,          5    \ Edge 14
 EDGE       2,      10,    10,    10,          5    \ Edge 15
 EDGE       2,       7,     9,    10,         31    \ Edge 16
 EDGE       3,       6,     8,    11,         31    \ Edge 17
 EDGE       5,       6,     8,    12,         31    \ Edge 18
 EDGE       5,       7,     9,    12,         31    \ Edge 19
 EDGE       7,      10,    12,    10,         29    \ Edge 20
 EDGE       6,      10,    11,    12,         29    \ Edge 21
 EDGE       4,       5,     8,     9,         29    \ Edge 22
 EDGE       9,      10,    10,    11,         29    \ Edge 23
 EDGE       1,       4,     4,     5,         29    \ Edge 24
 EDGE       8,       9,     6,     7,         29    \ Edge 25

.SHIP_PYTHON_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      -27,       40,       11,         30      \ Face 0
 FACE       27,       40,       11,         30      \ Face 1
 FACE      -27,      -40,       11,         30      \ Face 2
 FACE       27,      -40,       11,         30      \ Face 3
 FACE      -19,       38,        0,         30      \ Face 4
 FACE       19,       38,        0,         30      \ Face 5
 FACE      -19,      -38,        0,         30      \ Face 6
 FACE       19,      -38,        0,         30      \ Face 7
 FACE      -25,       37,      -11,         30      \ Face 8
 FACE       25,       37,      -11,         30      \ Face 9
 FACE       25,      -37,      -11,         30      \ Face 10
 FACE      -25,      -37,      -11,         30      \ Face 11
 FACE        0,        0,     -112,         30      \ Face 12

 SKIP 11                \ This space appears to be unused

\ ******************************************************************************
\
\       Name: SVN
\       Type: Variable
\   Category: Save and load
\    Summary: The "saving in progress" flag
\
\ ******************************************************************************

.SVN

 SKIP 1                 \ "Saving in progress" flag
                        \
                        \   * Non-zero while we are saving a commander
                        \
                        \   * 0 otherwise

\ ******************************************************************************
\
\       Name: VEC
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The original value of the IRQ1 vector
\
\ ******************************************************************************

.VEC

 SKIP 2                 \ VEC = &7FFE
                        \
                        \ This gets set to the value of the original IRQ1 vector
                        \ by the loading process

\ ******************************************************************************
\
\ Save PYTHON.bin
\
\ ******************************************************************************

 PRINT "PYTHON"
 PRINT "Assembled at ", ~CODE_PYTHON%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_PYTHON%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_PYTHON%

 PRINT "S.PYTHON ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_PYTHON%
 SAVE "versions/demo/3-assembled-output/PYTHON.bin", CODE_PYTHON%, P%, LOAD%

\ ******************************************************************************
\
\ Show free space
\
\ ******************************************************************************

 PRINT "ELITE game code ", ~(&6000-P%), " bytes free"
 PRINT "Ends at ", ~P%
