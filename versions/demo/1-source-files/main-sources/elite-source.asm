\ ******************************************************************************
\
\ BBC MICRO ELITE DEMONSTRATION DISC MAIN GAME SOURCE
\
\ The BBC Micro Elite demonstration disc was written by Ian Bell and David
\ Braben and is copyright Acornsoft 1984
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
\INCLUDE "library/common/main/subroutine/main_flight_loop_part_5_of_16.asm"
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
\INCLUDE "library/common/main/subroutine/flip.asm"
\INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
\INCLUDE "library/common/main/subroutine/stars6.asm"
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

.L2049
 TAX                    \ ???
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

\INCLUDE "library/common/main/subroutine/escape.asm"

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
\INCLUDE "library/common/main/subroutine/stars2.asm"
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
\INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
\INCLUDE "library/common/main/subroutine/plut-pu1.asm"
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
\INCLUDE "library/common/main/subroutine/mjp.asm"
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

INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"
INCLUDE "library/common/main/subroutine/killshp.asm"
INCLUDE "library/common/main/variable/sfx.asm"
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
INCLUDE "library/common/main/subroutine/death.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
INCLUDE "library/common/main/subroutine/br1_part_1_of_2.asm"
INCLUDE "library/common/main/subroutine/dfault-qu5.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/common/main/subroutine/title.asm"
\INCLUDE "library/common/main/subroutine/check.asm"
\INCLUDE "library/common/main/subroutine/trnme.asm"
\INCLUDE "library/common/main/subroutine/tr1.asm"
\INCLUDE "library/common/main/subroutine/gtnme-gtnmew.asm"
\INCLUDE "library/common/main/variable/rline.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
\INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/demo/main/subroutine/sve.asm"
\INCLUDE "library/common/main/subroutine/qus1.asm"
\INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/common/main/subroutine/fx200.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/common/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/variable/kytb-ikns.asm"

.L4737
 ORA #$80               \ ???
 STA $41
 RTS

INCLUDE "library/original/main/subroutine/dks1.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/common/main/subroutine/dks4-dks5.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
\INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dkj1.asm"
INCLUDE "library/common/main/subroutine/u_per_cent.asm"

.L47A2

 PHA                    \ ???

 JSR U%                 \ Call U% to clear the key logger

 PLA                    \ ???
 AND #$7F
 STA $41
 JMP $4849

\INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/demo/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"

.L4861
 LDX #$10               \ ???
 JSR $474B
 BPL L486D
 LDA #$FF
 STA $0F49
.L486D
 LDX #$51
 JSR $474B
 BPL L4879
 LDA #$00
 STA $0F49
.L4879
 LDX #$70
 JSR $474B
 BPL L4883
 JMP $4526
.L4883
 LDX #$69
 JSR $474B
 BPL L4891
.L488A
 LDX #$59
 JSR $474B
 BPL L488A
.L4891
 RTS

\INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/demo/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/ou2.asm"
INCLUDE "library/common/main/subroutine/ou3.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/subroutine/ouch.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"

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

INCLUDE "library/original/main/variable/checksum0.asm"

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_SHIPS% = P%

 LOAD_SHIPS% = LOAD% + P% - CODE%

 EQUB &60, &60, &60, &66, &3C, &00, &60, &66    \ These bytes appear to be
 EQUB &0C, &18, &30, &66, &06, &00, &00, &00    \ unused and just contain random
 EQUB &18, &18, &00, &18, &18, &00, &60, &60    \ workspace noise left over from
 EQUB &60, &60, &60, &60, &7E, &00, &60, &66    \ the BBC Micro assembly process
 EQUB &0C, &18, &30, &66, &06, &00, &3C, &66
 EQUB &0C, &18, &18, &00, &18, &00, &66, &66
 EQUB &76, &7E, &6E, &66, &66, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &00, &00
 EQUB &7E, &00, &7E, &00, &00, &00, &0C, &18
 EQUB &30, &30, &30, &18, &0C, &00, &60, &60
 EQUB &60, &60, &60, &60, &7E, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &3C, &66
 EQUB &0C, &18, &18, &00, &18, &00, &66, &66
 EQUB &76, &7E, &6E, &66, &66, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &30, &18
 EQUB &0C, &0C, &0C, &18, &30, &00, &7E, &60
 EQUB &60, &7C, &60, &60, &7E, &00, &3C, &66
 EQUB &66, &66, &66, &66, &3C, &00, &7C, &66
 EQUB &66, &7C, &6C, &66, &66, &00, &0C, &18
 EQUB &30, &30, &30, &18, &0C, &00, &66, &66
 EQUB &76, &7E, &6E, &66, &66, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &63, &77
 EQUB &7F, &6B, &6B, &63, &63, &00, &3C, &66
 EQUB &66, &66, &66, &66, &3C, &00, &78, &6C
 EQUB &66, &66, &66, &6C, &78, &00, &3C, &66
 EQUB &06, &0C, &18, &30, &7E, &00, &7E, &60
 EQUB &7C, &06, &06, &66, &3C, &00, &1C, &30
 EQUB &60, &7C, &66, &66, &3C, &00, &30, &18
 EQUB &0C, &0C, &0C, &18, &30, &00, &00, &00
 EQUB &18, &18, &00, &18, &18, &00, &66, &66
 EQUB &76, &7E, &6E, &66, &66, &00, &7E, &60
 EQUB &60, &7C, &60, &60, &7E, &00, &66, &66
 EQUB &3C, &18, &3C, &66, &66, &00, &7E, &18
 EQUB &18, &18, &18, &18, &18, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &3C, &66
 EQUB &06, &1C, &06, &66, &3C, &00, &3C, &66
 EQUB &66, &3E, &06, &0C, &38, &00, &7E, &06
 EQUB &0C, &18, &30, &30, &30, &00, &3C, &66
 EQUB &66, &7E, &66, &66, &66, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &00, &00
 EQUB &7E, &00, &7E, &00, &00, &00, &3C, &66
 EQUB &6E, &7E, &76, &66, &3C, &00, &00, &00
 EQUB &18, &18, &00, &18, &18, &00, &7E, &60
 EQUB &60, &7C, &60, &60, &60, &00, &3C, &66
 EQUB &66, &66, &66, &66, &3C, &00, &7C, &66
 EQUB &66, &7C, &6C, &66, &66, &00, &66, &66
 EQUB &76, &7E, &6E, &66, &66, &00, &60, &66
 EQUB &0C, &18, &30, &66, &06, &00, &00, &00
 EQUB &7E, &00, &7E, &00, &00, &00, &38, &6C
 EQUB &6C, &38, &6D, &66, &3B, &00, &18, &38
 EQUB &18, &18, &18, &18, &7E, &00, &18, &38
 EQUB &18, &18, &18, &18, &7E, &00, &3C, &66
 EQUB &6E, &7E, &76, &66, &3C, &00, &3C, &A8

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"

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

INCLUDE "library/common/main/variable/ship_python.asm"

 SKIP 11                \ This space appears to be unused

INCLUDE "library/common/main/variable/svn.asm"
INCLUDE "library/common/main/variable/vec.asm"

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
