\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 0)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank0.bin
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
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

 _BANK = 0

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 0
\
\ Produces the binary file bank0.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"

\ ******************************************************************************
\
\       Name: ResetShipStatus
\       Type: Subroutine
\   Category: Flight
\    Summary: Reset the ship's speed, hyperspace counter, laser temperature,
\             shields and energy banks
\
\ ******************************************************************************

.ResetShipStatus

 LDA #0                 \ Reduce the speed to 0
 STA DELTA

 STA QQ22+1             \ Reset the on-screen hyperspace counter

 LDA #0                 \ Cool down the lasers completely
 STA GNTMP

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

 RTS                    \ Return from the subroutine

INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_4_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_5_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_6_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_7_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_8_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_9_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_10_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_11_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_12_of_16.asm"

\ ******************************************************************************
\
\       Name: subm_8334
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_8334

 DEC L0393
 BMI C835B
 BEQ C8341
 JSR LASLI2
 JMP C8344

.C8341

 JSR CLYNS

.C8344

 JSR subm_D951
 JMP MA16

\ ******************************************************************************
\
\       Name: subm_MA23
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_MA23

 LDA QQ11
 BNE subm_8334
 DEC L0393
 BMI C835B
 BEQ C835B
 JSR LASLI2
 JMP MA16

.C835B

 LDA #0
 STA L0393

.MA16

 LDA ECMP               \ If our E.C.M is not on, skip to MA69, otherwise keep
 BEQ MA69               \ going to drain some energy

 JSR DENGY              \ Call DENGY to deplete our energy banks by 1

 BEQ MA70               \ If we have no energy left, jump to MA70 to turn our
                        \ E.C.M. off

.MA69

 LDA ECMA               \ If an E.C.M is going off (ours or an opponent's) then
 BEQ MA66               \ keep going, otherwise skip to MA66

 LDA #&80
 STA K+2
 LDA #&7F
 STA K
 LDA Yx1M2
 STA K+3
 STA K+1
 JSR subm_B919_b6

 DEC ECMA               \ Decrement the E.C.M. countdown timer, and if it has
 BNE MA66               \ reached zero, keep going, otherwise skip to MA66

.MA70

 JSR ECMOF              \ If we get here then either we have either run out of
                        \ energy, or the E.C.M. timer has run down, so switch
                        \ off the E.C.M.

.MA66

 LDX #0

 LDA FRIN
 BEQ C8390

 JSR MAL1

.C8390

 LDX #2

.loop_C8392

 LDA FRIN,X
 BEQ C839D

 JSR MAL1

 JMP loop_C8392

.C839D

 LDX #1

 LDA FRIN+1
 BEQ MA18

 BPL C83AB

 LDY #0
 STY SSPR

.C83AB

 JSR MAL1

INCLUDE "library/common/main/subroutine/main_flight_loop_part_13_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_14_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_15_of_16.asm"

\ ******************************************************************************
\
\       Name: Main flight loop (Part 16 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Call stardust routine
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Jump to the stardust routine if we are in a space view
\
\   * Return from the main flight loop
\
\ ******************************************************************************

.MA23

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE MA232              \ then jump to MA232 to return from the main flight loop
                        \ (as MA232 is an RTS)

 JMP STARS_b1           \ This is a space view, so jump to the STARS routine to
                        \ process the stardust, and return from the main flight
                        \ loop using a tail call

\ ******************************************************************************
\
\       Name: ChargeShields
\       Type: Subroutine
\   Category: Flight
\    Summary: Charge the shields and energy banks
\
\ ******************************************************************************

.ChargeShields

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX ENERGY             \ Fetch our ship's energy levels and skip to b if bit 7
 BPL b                  \ is not set, i.e. only charge the shields from the
                        \ energy banks if they are at more than 50% charge

 LDX ASH                \ Call SHD to recharge our aft shield and update the
 JSR SHD                \ shield status in ASH
 STX ASH

 LDX FSH                \ Call SHD to recharge our forward shield and update
 JSR SHD                \ the shield status in FSH
 STX FSH

.b

 SEC                    \ Set A = ENERGY + ENGY + 1, so our ship's energy
 LDA ENGY               \ level goes up by 2 if we have an energy unit fitted,
 ADC ENERGY             \ otherwise it goes up by 1

 BCS paen1              \ If the value of A did not overflow (the maximum
 STA ENERGY             \ energy level is &FF), then store A in ENERGY

.paen1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CheckAltitude
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform an altitude check with the planet, ending the game if we
\             hit the ground
\
\ ******************************************************************************

.CheckAltitude

 LDY #&FF               \ Set our altitude in ALTIT to &FF, the maximum
 STY ALTIT

 INY                    \ Set Y = 0

 JSR m                  \ Call m to calculate the maximum distance to the
                        \ planet in any of the three axes, returned in A

 BNE MA232              \ If A > 0 then we are a fair distance away from the
                        \ planet in at least one axis, so jump to MA232 to skip
                        \ the rest of the altitude check

 JSR MAS3               \ Set A = x_hi^2 + y_hi^2 + z_hi^2, so using Pythagoras
                        \ we now know that A now contains the square of the
                        \ distance between our ship (at the origin) and the
                        \ centre of the planet at (x_hi, y_hi, z_hi)

 BCS MA232              \ If the C flag was set by MAS3, then the result
                        \ overflowed (was greater than &FF) and we are still a
                        \ fair distance from the planet, so jump to MA232 as we
                        \ haven't crashed into the planet

 SBC #36                \ Subtract 36 from x_hi^2 + y_hi^2 + z_hi^2. The radius
                        \ of the planet is defined as 6 units and 6^2 = 36, so
                        \ A now contains the high byte of our altitude above
                        \ the planet surface, squared

 BCC MA282              \ If A < 0 then jump to MA282 as we have crashed into
                        \ the planet

 STA R                  \ Set (R Q) = (A Q)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR LL5                \ We are getting close to the planet, so we need to
                        \ work out how close. We know from the above that A
                        \ contains our altitude squared, so we store A in R
                        \ and call LL5 to calculate:
                        \
                        \   Q = SQRT(R Q) = SQRT(A Q)
                        \
                        \ Interestingly, Q doesn't appear to be set to 0 for
                        \ this calculation, so presumably this doesn't make a
                        \ difference

 LDA Q                  \ Store the result in ALTIT, our altitude
 STA ALTIT

 BNE MA232              \ If our altitude is non-zero then we haven't crashed,
                        \ so jump to MA232 to skip to the next section

.MA282

 JMP DEATH              \ If we get here then we just crashed into the planet
                        \ or got too close to the sun, so jump to DEATH to start
                        \ the funeral preparations and return from the main
                        \ flight loop using a tail call

.MA232

 RTS                    \ Return from the subroutine

INCLUDE "library/common/main/subroutine/main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_3_of_16.asm"
INCLUDE "library/enhanced/main/subroutine/spin.asm"

\ ******************************************************************************
\
\       Name: HideHiddenColour
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Set the hidden colour to black, so that pixels in this colour in
\             palette 0 are invisible
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   oh                  Contains an RTS
\
\ ******************************************************************************

.HideHiddenColour

 LDA #&0F               \ Set hiddenColour to &0F, which is black, so this hides
 STA hiddenColour       \ any pixels that use the hidden colour in palette 0

.oh

 RTS                    \ Return from the subroutine

INCLUDE "library/advanced/main/variable/scacol.asm"

\ ******************************************************************************
\
\       Name: SetAXTo15 (Unused)
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SetAXTo15

 LDA #&0F
 TAX
 RTS

\ ******************************************************************************
\
\       Name: PrintCombatRank
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PrintCombatRank

 LDA #&10
 JSR TT68
 LDA L04A9
 AND #1
 BEQ C87CE
 JSR TT162

.C87CE

 LDA TALLY+1
 BNE C8806
 TAX
 LDX TALLY
 CPX #0
 ADC #0
 CPX #2
 ADC #0
 CPX #8
 ADC #0
 CPX #&18
 ADC #0
 CPX #&2C
 ADC #0
 CPX #&82
 ADC #0
 TAX

.C87F0

 TXA
 PHA
 LDA L04A9
 AND #5
 BEQ C87FF
 JSR TT162
 JSR TT162

.C87FF

 PLA
 CLC
 ADC #&15
 JMP plf

.C8806

 LDX #9
 CMP #&19
 BCS C87F0
 DEX
 CMP #&0A
 BCS C87F0
 DEX
 CMP #2
 BCS C87F0
 DEX
 BNE C87F0

\ ******************************************************************************
\
\       Name: subm_8819
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_8819

 LDA #&7D
 JSR spc
 LDA #&13
 LDY FIST
 BEQ C8829
 CPY #&28
 ADC #1

.C8829

 JMP plf

\ ******************************************************************************
\
\       Name: STATUS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.wearedocked

 LDA #&CD
 JSR DETOK_b2
 JSR TT67
 JMP C885F

.STATUS

 LDA #&98
 JSR ChangeViewRow0
 JSR subm_9D09
 LDA #7
 STA XC
 LDA #&7E
 JSR NLIN3
 JSR GetStatusCondition
 STX L0471
 LDA #&E6
 DEX
 BMI wearedocked
 BEQ C885C
 LDY ENERGY
 CPY #&80
 ADC #1

.C885C

 JSR plf

.C885F

 LDA L04A9
 AND #4
 BEQ C8874
 JSR subm_8819
 JSR PrintCombatRank
 LDA #5
 JSR plf
 JMP C887F

.C8874

 JSR PrintCombatRank
 LDA #5
 JSR plf
 JSR subm_8819

.C887F

 LDA #&12
 JSR PrintTokenCrTab
 INC YC
 LDA ESCP
 BEQ C8890
 LDA #&70
 JSR PrintTokenCrTab

.C8890

 LDA BST
 BEQ C889A
 LDA #&6F
 JSR PrintTokenCrTab

.C889A

 LDA ECM
 BEQ C88A4
 LDA #&6C
 JSR PrintTokenCrTab

.C88A4

 LDA #&71
 STA XX4

.loop_C88A8

 TAY
 LDX L034F,Y
 BEQ C88B1
 JSR PrintTokenCrTab

.C88B1

 INC XX4
 LDA XX4
 CMP #&75
 BCC loop_C88A8
 LDX #0

.C88BB

 STX CNT
 LDY LASER,X
 BEQ C88FE
 LDA L04A9
 AND #4
 BNE C88D0
 TXA
 CLC
 ADC #&60
 JSR spc

.C88D0

 LDA #&67
 LDX CNT
 LDY LASER,X
 CPY #&8F
 BNE C88DD
 LDA #&68

.C88DD

 CPY #&97
 BNE C88E3
 LDA #&75

.C88E3

 CPY #&32
 BNE C88E9
 LDA #&76

.C88E9

 JSR TT27_b2
 LDA L04A9
 AND #4
 BEQ C88FB
 LDA CNT
 CLC
 ADC #&60
 JSR PrintSpaceAndToken

.C88FB

 JSR PrintCrTab

.C88FE

 LDX CNT
 INX
 CPX #4
 BCC C88BB
 LDA #&18
 STA XC
 LDX language
 LDA C897C,X
 STA YC
 JSR subm_B882_b4
 LDA S
 ORA #&80
 CMP systemFlag
 STA systemFlag
 BEQ C8923
 JSR subm_EB8C

.C8923

 JSR subm_A082_b6

\ ******************************************************************************
\
\       Name: subm_8926
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_8926

 LDA tileNumber
 BNE C892E
 LDA #&FF
 STA tileNumber

.C892E

 LDA #0
 STA L00CC
 LDA #&6C
 STA L00D8
 STA phaseL00CD
 STA phaseL00CD+1
 LDX #&25
 LDA QQ11
 AND #&40
 BEQ C8944
 LDX #4

.C8944

 STX L00D2
 JSR DrawBoxEdges
 JSR CopyNameBuffer0To1
 LDA QQ11
 CMP QQ11a
 BEQ C8976
 JSR subm_A7B7_b3

.C8955

 LDX #&FF
 LDA QQ11
 CMP #&95
 BEQ C896C
 CMP #&DF
 BEQ C896C
 CMP #&92
 BEQ C896C
 CMP #&93
 BEQ C896C
 ASL A
 BPL C896E

.C896C

 LDX #0

.C896E

 STX L045F
 LDA tileNumber
 STA L00D2
 RTS

.C8976

 JSR subm_F126
 JMP C8955

.C897C

 PHP
 PHP
 ASL A
 PHP

\ ******************************************************************************
\
\       Name: subm_8980
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_8980

 JSR subm_D8C5
 LDA #0
 STA L00CC
 LDA #&64
 STA L00D8
 LDA #&25
 STA L00D2

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DrawBoxEdges
 JSR CopyNameBuffer0To1
 LDA #&C4
 STA phaseFlags
 STA phaseFlags+1
 LDA tileNumber
 STA L00D2
 RTS

\ ******************************************************************************
\
\       Name: PrintTokenCrTab
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PrintTokenCrTab

 JSR TT27_b2

\ ******************************************************************************
\
\       Name: PrintCrTab
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PrintCrTab

 JSR TT67
 LDX language
 LDA L89B4,X
 STA XC
 RTS

\ ******************************************************************************
\
\       Name: L89B4
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.L89B4

 EQUB 3, 3, 1, 3                              ; 89B4: 03 03 01... ...

INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"

\ ******************************************************************************
\
\       Name: DrawPitchRollBars
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Moves sprite 11 to coord (JSTX, 29)
\              12 to coord (JSTY, 37)
\
\ ******************************************************************************

.DrawPitchRollBars

 LDA JSTX
 EOR #&FF
 LSR A
 LSR A
 LSR A
 CLC
 ADC #&D8
 STA SC2
 LDY #&1D
 LDA #&0B
 JSR C8BB4
 LDA JSTY
 LSR A
 LSR A
 LSR A
 CLC
 ADC #&D8
 STA SC2
 LDY #&25
 LDA #&0C

.C8BB4

 ASL A
 ASL A
 TAX
 LDA SC2
 SEC
 SBC #4
 STA xSprite0,X
 TYA
 CLC

IF _NTSC

 ADC #&AA

ELIF _PAL

 ADC #&B0

ENDIF

 STA ySprite0,X
 RTS

INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/enhanced/main/subroutine/hme2.asm"
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

\ ******************************************************************************
\
\       Name: LAUN
\       Type: Subroutine
\   Category: Flight
\    Summary: Make the launch sound and draw the launch tunnel
\
\ ------------------------------------------------------------------------------
\
\ This is shown when launching from or docking with the space station.
\
\ ******************************************************************************

.LAUN

 LDA #0
 JSR subm_B39D
 JSR HideSprites5To63
 LDY #&0C
 JSR NOISE
 LDA #&80
 STA K+2
 LDA Yx1M2
 STA K+3
 LDA #&50
 STA XP
 LDA #&70
 STA YP
 LDY #4
 JSR DELAY
 LDY #&18
 JSR NOISE

.C9345

 JSR subm_B1D1
 JSR ChangeDrawingPhase
 LDA XP
 AND #&0F
 ORA #&60
 STA STP
 LDA #&80
 STA L03FC

.C9359

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA STP
 SEC
 SBC #&10
 BMI C93AC
 STA STP
 CMP YP
 BCS C9359
 STA Q
 LDA #8
 JSR LL28
 LDA R
 SEC
 SBC #&14
 CMP #&54
 BCS C93AC
 STA K+1
 LSR A
 ADC K+1
 STA K
 ASL L03FC
 BCC C93A6
 LDA YP
 CMP #&64
 BCS C93A6
 LDA K+1
 CMP #&48
 BCS C93BC
 LDA STP
 PHA
 JSR subm_B919_b6
 PLA
 STA STP

.C93A6

 JSR subm_BA17_b6
 JMP C9359

.C93AC

 JSR subm_D975
 DEC YP
 DEC XP
 BNE C9345
 LDY #&17
 JMP NOISE

.C93BC

 LDA #&48
 STA K+1
 LDA STP
 PHA
 JSR subm_B919_b6
 PLA
 STA STP
 JMP C9359

.C93CC

 RTS

INCLUDE "library/common/main/subroutine/lasli.asm"
INCLUDE "library/enhanced/main/subroutine/brief2.asm"
INCLUDE "library/enhanced/main/subroutine/brp.asm"
INCLUDE "library/enhanced/main/subroutine/brief3.asm"
INCLUDE "library/enhanced/main/subroutine/debrief2.asm"
INCLUDE "library/enhanced/main/subroutine/debrief.asm"
INCLUDE "library/advanced/main/subroutine/tbrief.asm"
INCLUDE "library/enhanced/main/subroutine/brief.asm"
INCLUDE "library/nes/main/subroutine/bris_0.asm"
INCLUDE "library/common/main/subroutine/ping.asm"

\ ******************************************************************************
\
\       Name: DemoShips
\       Type: Subroutine
\   Category: Demo
\    Summary: ???
\
\ ******************************************************************************

.DemoShips

 JSR RES2
 JSR subm_B8FE_b6
 LDA #0
 STA QQ14
 STA CASH
 STA CASH+1
 LDA #&FF
 STA ECM
 LDA #1
 STA ENGY
 LDA #&8F
 STA LASER
 LDA #&FF
 STA DLY
 JSR SOLAR
 LDA #0
 STA DELTA
 STA ALPHA
 STA ALP1
 STA QQ12
 STA VIEW
 JSR TT66
 LSR DLY
 JSR CopyNameBuffer0To1
 JSR subm_F139
 JSR subm_BE48
 JSR subm_F39A
 JSR subm_95FC
 LDA #6
 STA INWK+30
 LDA #&18
 STA INWK+29
 LDA #&12
 JSR NWSHP
 LDA #&0A
 JSR subm_95E4
 LDA #&92
 STA K%+114
 LDA #1
 STA K%+112
 JSR subm_95FC
 LDA #6
 STA INWK+30
 ASL INWK+2
 LDA #&C0
 STA INWK+29
 LDA #&13
 JSR NWSHP
 LDA #6
 JSR subm_95E4
 JSR subm_95FC
 LDA #6
 STA INWK+30
 ASL INWK+2
 LDA #0
 STA XX1
 LDA #&46
 STA INWK+6
 LDA #&11
 JSR NWSHP
 LDA #5
 JSR subm_95E4
 LDA #&C0
 STA K%+198
 LDA #&0B
 JSR subm_95E4
 LDA #&32
 STA nmiTimer
 LDA #0
 STA nmiTimerLo
 STA nmiTimerHi
 JSR subm_BA23_b3
 LSR L0300
 JSR subm_AC5C_b3
 LDA L0306
 STA L0305
 LDA #&10
 STA DELTA
 JMP MLOOP

\ ******************************************************************************
\
\       Name: subm_95E4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_95E4

 STA LASCT

.loop_C95E7

 JSR ChangeDrawingPhase
 JSR subm_MA23
 JSR subm_D975
 LDA L0465
 JSR subm_B1D4
 DEC LASCT
 BNE loop_C95E7
 RTS

\ ******************************************************************************
\
\       Name: subm_95FC
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_95FC

 JSR ZINF
 LDA #&60
 STA INWK+14
 ORA #&80
 STA INWK+22
 LDA #&FE
 STA INWK+32
 LDA #&20
 STA INWK+27
 LDA #&80
 STA INWK+2
 LDA #&28
 STA XX1
 LDA #&28
 STA INWK+3
 LDA #&3C
 STA INWK+6
 RTS

INCLUDE "library/enhanced/main/subroutine/tnpr1.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/nes/main/subroutine/changeviewrow0.asm"
INCLUDE "library/common/main/subroutine/tt20.asm"
INCLUDE "library/common/main/subroutine/tt54.asm"
INCLUDE "library/common/main/subroutine/tt146.asm"
INCLUDE "library/common/main/subroutine/tt60.asm"
INCLUDE "library/common/main/subroutine/ttx69.asm"
INCLUDE "library/common/main/subroutine/tt69.asm"
INCLUDE "library/common/main/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt70.asm"
INCLUDE "library/common/main/subroutine/spc.asm"
INCLUDE "library/nes/main/subroutine/printspaceandtoken.asm"
INCLUDE "library/nes/main/variable/tabdataonsystem.asm"

\ ******************************************************************************
\
\       Name: PrintTokenAndColon
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character followed by a colon, drawing in both bit planes
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed
\
\ ******************************************************************************

.PrintTokenAndColon

 JSR TT27_b2            \ Print the character in A

 LDA #3                 \ Set the font bit plane to print in both planes 1 and 2
 STA fontBitPlane

 LDA #':'               \ Print a colon
 JSR TT27_b2

 LDA #1                 \ Set the font bit plane to plane 1
 STA fontBitPlane

 RTS                    \ Return from the subroutine

INCLUDE "library/nes/main/variable/radiustext.asm"
INCLUDE "library/common/main/subroutine/tt25.asm"
INCLUDE "library/common/main/subroutine/tt22.asm"
INCLUDE "library/common/main/subroutine/tt15.asm"
INCLUDE "library/common/main/subroutine/tt14.asm"
INCLUDE "library/common/main/subroutine/tt128.asm"
INCLUDE "library/common/main/subroutine/tt210.asm"
INCLUDE "library/common/main/subroutine/tt213.asm"

\ ******************************************************************************
\
\       Name: PrintCharacterSetC
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character and set the C flag
\
\ ******************************************************************************

.PrintCharacterSetC

 JSR DASC_b2
 SEC
 RTS

INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"

\ ******************************************************************************
\
\       Name: DrawCrosshairs
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Draw a set of moveable crosshairs as a square reticle
\
\ ******************************************************************************

.DrawCrosshairs

 LDA #&F8
 STA tileSprite15

 LDA #1
 STA attrSprite15

 LDA QQ19
 STA SC2

 LDY QQ19+1
 LDA #&0F
 ASL A
 ASL A
 TAX

 LDA SC2
 SEC
 SBC #4
 STA xSprite0,X
 TYA
 CLC

IF _NTSC

 ADC #&0A

ELIF _PAL

 ADC #&10

ENDIF

 STA ySprite0,X

 RTS

\ ******************************************************************************
\
\       Name: HideCrosshairs
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide the moveable crosshairs (i.e. the square reticle)
\
\ ******************************************************************************

.HideCrosshairs

 LDA #240               \ Set the y-coordinate of sprite 15 to 240, so it is
 STA ySprite15          \ below the bottom of the screen and is therefore hidden

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: tabShortRange
\       Type: Variable
\   Category: Text
\    Summary: The column for the Short-range Chart title for each language
\
\ ******************************************************************************

.tabShortRange

 EQUB 7                 \ English

 EQUB 8                 \ German

 EQUB 10                \ French

 EQUB 8                 \ There is no fourth language, so this byte is ignored

INCLUDE "library/common/main/subroutine/tt23.asm"

\ ******************************************************************************
\
\       Name: DrawChartSystem
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Draw system blobs on short-range chart
\
\ ------------------------------------------------------------------------------
\
\ Increments L04A1
\ Sets sprite L04A1 to tile 213+K at (K3-4, K4+10)
\ K = 2 or 3 or 4 -> 215-217
\
\ ******************************************************************************

.DrawChartSystem

 LDY L04A1
 CPY #&18
 BCS C9CF7
 INY
 STY L04A1
 TYA
 ASL A
 ASL A
 TAY
 LDA K3
 SBC #3
 STA xSprite38,Y
 LDA K4
 CLC

IF _NTSC

 ADC #&0A

ELIF _PAL

 ADC #&10

ENDIF

 STA ySprite38,Y
 LDA #&D5
 CLC
 ADC K
 STA tileSprite38,Y
 LDA #2
 STA attrSprite38,Y

.C9CF7

 RTS

INCLUDE "library/common/main/subroutine/tt81.asm"

\ ******************************************************************************
\
\       Name: subm_9D03
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_9D03

 JSR TT111
 JMP subm_9D35

\ ******************************************************************************
\
\       Name: subm_9D09
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_9D09

 LDA L0395
 BMI C9D60
 JSR TT111
 LDA QQ11
 AND #&0E
 CMP #&0C
 BNE subm_9D35
 JSR TT103
 LDA #0
 STA QQ17
 JSR CLYNS
 JSR cpl
 LDA #&80
 STA QQ17
 LDA #&0C
 JSR DASC_b2
 JSR TT146
 JSR subm_D951

.subm_9D35

 LDA QQ8+1
 BNE C9D51
 LDA QQ8
 BNE C9D46
 LDA MJ
 BEQ C9D51
 BNE C9D4D

.C9D46

 CMP QQ14
 BEQ C9D4D
 BCS C9D51

.C9D4D

 LDA #&C0
 BNE C9D53

.C9D51

 LDA #&80

.C9D53

 TAX
 EOR L0395
 STX L0395
 ASL A
 BPL C9D6A
 JMP subm_AC5C_b3

.C9D60

 LDX #5

.loop_C9D62

 LDA L0453,X
 STA QQ15,X
 DEX
 BPL loop_C9D62

.C9D6A

 RTS

INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/hy6-docked.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/jmp.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"
INCLUDE "library/common/main/subroutine/prq.asm"
INCLUDE "library/common/main/subroutine/tt151.asm"

\ ******************************************************************************
\
\       Name: PrintSpacedHyphen
\       Type: Subroutine
\   Category: Text
\    Summary: Print two spaces, then a "-", and then another two spaces
\
\ ******************************************************************************

.PrintSpacedHyphen

 JSR TT162              \ Print two spaces
 JSR TT162

 LDA #'-'               \ Print a "-" character
 JSR TT27_b2

 JSR TT162              \ Print two spaces, returning from the subroutine using
 JMP TT162              \ a tail call

INCLUDE "library/common/main/subroutine/tt152.asm"
INCLUDE "library/common/main/subroutine/tt162.asm"
INCLUDE "library/common/main/subroutine/tt160.asm"
INCLUDE "library/common/main/subroutine/tt161.asm"
INCLUDE "library/common/main/subroutine/tt16a.asm"
INCLUDE "library/common/main/subroutine/tt163.asm"

\ ******************************************************************************
\
\       Name: PrintNumberInHold
\       Type: Subroutine
\   Category: Market
\    Summary: Print the number of units of a specified item that we have in the
\             hold
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   QQ29                The item number
\
\ ******************************************************************************

.PrintNumberInHold

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY QQ29               \ Set Y to the current item number

 LDA #3                 \ Set A = 3 to use as the number of digits below

 LDX QQ20,Y             \ Set X to the number of units of this item that we
                        \ already have in the hold

 BEQ PrintSpacedHyphen  \ If we don't have any units of this item in the hold,
                        \ jump to PrintSpacedHyphen to print two spaces, a "-",
                        \ and two spaces

 CLC                    \ Otherwise print the 8-bit number in X to 3 digits, as
 JSR pr2+2              \ we set A to 3 above

 JMP TT152              \ Print the unit ("t", "kg" or "g") for the market item,
                        \ with a following space if required to make it two
                        \ characters long, and return from the subroutine using
                        \ a tail call

\ ******************************************************************************
\
\       Name: rowMarketPrice
\       Type: Variable
\   Category: Text
\    Summary: The column for the Market Prices title for each language
\
\ ******************************************************************************

.rowMarketPrice

 EQUB 4                 \ English

 EQUB 5                 \ German

 EQUB 4                 \ French

 EQUB 4                 \ There is no fourth language, so this byte is ignored

INCLUDE "library/common/main/subroutine/tt167.asm"

\ ******************************************************************************
\
\       Name: BuyAndSellCargo
\       Type: Subroutine
\   Category: Market
\    Summary: Process the buying and selling of cargo on the Market Prices
\             screen
\
\ ******************************************************************************

 LDA QQ12
 BNE CA028

.CA01C

 JSR subm_EB86
 JSR Set_K_K3_XC_YC
 JMP subm_8926

.CA025

 JMP CA0F4

.CA028

 LDA #0
 STA QQ29
 JSR subm_A130
 JSR subm_A155
 JSR CA01C

.CA036

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1B
 BMI CA06E
 LDA controller1Up
 ORA controller1Down
 BEQ CA04E
 LDA controller1Left
 ORA controller1Right
 BNE CA06E

.CA04E

 LDA controller1Up
 AND #&F0
 CMP #&F0
 BEQ CA079
 LDA controller1Down
 AND #&F0
 CMP #&F0
 BEQ CA09B
 LDA L04BA
 CMP #&F0
 BEQ CA025
 LDA L04BB
 CMP #&F0
 BEQ CA0B3

.CA06E

 LDA L0465
 BEQ CA036
 JSR subm_B1D1
 BCS CA036
 RTS

.CA079

 LDA QQ29
 JSR subm_A147
 LDA QQ29
 SEC
 SBC #1

 BPL CA089
 LDA #0

.CA089

 STA QQ29

.CA08C

 LDA QQ29

 JSR subm_A130
 JSR subm_8980
 JSR subm_D8C5
 JMP CA036

.CA09B

 LDA QQ29
 JSR subm_A147

 LDA QQ29
 CLC
 ADC #1

 CMP #&11
 BNE CA0AD
 LDA #&10

.CA0AD

 STA QQ29
 JMP CA08C

.CA0B3

 LDA #1
 JSR tnpr
 BCS CA12D
 LDY QQ29
 LDA AVL,Y
 BEQ CA12D
 LDA QQ24
 STA P
 LDA #0
 JSR GC2
 JSR LCASH
 BCC CA12D
 JSR subm_F454
 LDY #&1C
 JSR NOISE
 LDY QQ29
 LDA AVL,Y
 SEC
 SBC #1
 STA AVL,Y
 LDA QQ20,Y
 CLC
 ADC #1
 STA QQ20,Y
 JSR subm_A155
 JMP CA08C

.CA0F4

 LDY QQ29
 LDA AVL,Y
 CMP #&63
 BCS CA12D
 LDA QQ20,Y
 BEQ CA12D
 JSR subm_F454
 SEC
 SBC #1
 STA QQ20,Y
 LDA AVL,Y
 CLC
 ADC #1
 STA AVL,Y
 LDA QQ24
 STA P
 LDA #0
 JSR GC2
 JSR MCASH
 JSR subm_A155

 LDY #3
 JSR NOISE

 JMP CA08C

.CA12D

 JMP CA036

\ ******************************************************************************
\
\       Name: subm_A130
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A130

 TAY
 LDX #2
 STX fontBitPlane
 CLC
 LDX language
 ADC rowMarketPrice,X
 STA YC
 TYA
 JSR TT151
 LDX #1
 STX fontBitPlane
 RTS

\ ******************************************************************************
\
\       Name: subm_A147
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A147

 TAY
 CLC
 LDX language
 ADC rowMarketPrice,X
 STA YC
 TYA
 JMP TT151

\ ******************************************************************************
\
\       Name: subm_A155
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A155

 LDA #&80
 STA QQ17
 LDX language
 LDA LA16D,X
 STA YC
 LDA LA169,X
 STA XC
 JMP PCASH

\ ******************************************************************************
\
\       Name: LA169
\       Type: Variable
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.LA169

 EQUB 5, 5, 3, 5

\ ******************************************************************************
\
\       Name: LA16D
\       Type: Variable
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.LA16D

 EQUB &16, &17, &16, &16

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
INCLUDE "library/common/main/subroutine/gc2.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"

\ ******************************************************************************
\
\       Name: subm_EQSHP1
\       Type: Subroutine
\   Category: Equipment
\    Summary: ???
\
\ ******************************************************************************

.subm_EQSHP1

 LDA #20                \ Move the text cursor to column 2 on row 20
 STA YC
 LDA #2
 STA XC

 LDA #&1A
 STA K
 LDA #5
 STA K+1

 LDA #&B7
 STA V+1
 LDA #&EC
 STA V

 LDA #0
 STA K+2

 JSR subm_B9C1_b4

 JMP subm_A4A5_b6

\ ******************************************************************************
\
\       Name: subm_EQSHP2
\       Type: Subroutine
\   Category: Equipment
\    Summary: ???
\
\ ******************************************************************************

.subm_EQSHP2

 LDX #2
 STX fontBitPlane

 LDX XX13
 JSR PrintEquipment+2

 LDX #1
 STX fontBitPlane

 RTS

\ ******************************************************************************
\
\       Name: PrintEquipment
\       Type: Subroutine
\   Category: Equipment
\    Summary: Print an inventory listing for a specified item
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX13                The item number + 1 (i.e. 1 for fuel)
\
\   Q                   The highest item number on sale + 1
\
\ Other entry points:
\
\   PrintEquipment+2    Print the item number in X
\
\ ******************************************************************************

.PrintEquipment

 LDX XX13               \ Set X to the item number to print

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STX XX13               \ Store the item number in XX13, in case we entered the
                        \ routine at PrintEquipment+2

 TXA                    \ Set A = X + 2
 CLC                    \
 ADC #2                 \ So the first item (item 1) will be on row 3, and so on

 LDX Q                  \ If Q >= 12, set A = A - 1 so we move everything up the
 CPX #12                \ screen by one line when the highest item number on
 BCC preq1              \ sale is at least 11
 SEC
 SBC #1

.preq1

 STA YC                 \ Move the text cursor to row A

 LDA #1                 \ Move the text cursor to column 1
 STA XC

 LDA L04A9              \ If bit 1 of L04A9 is clear, print a space
 AND #%00000010
 BNE preq2
 JSR TT162

.preq2

 JSR TT162              \ Print a space

 LDA XX13               \ Print recursive token 104 + XX13, which will be in the
 CLC                    \ range 105 ("FUEL") to 116 ("GALACTIC HYPERSPACE ")
 ADC #104               \ so this prints the current item's name
 JSR TT27_b2

 JSR subm_D17F          \ ???

 LDA XX13               \ If the current item number in XX13 is not 1, then it
 CMP #1                 \ is not the fuel level, so jump to preq3 to skip the
 BNE preq3              \ following (which prints the fuel level)

 LDA #' '               \ Print a space
 JSR TT27_b2

 LDA #'('               \ Print an open bracket
 JSR TT27_b2

 LDX QQ14               \ Set X to the current fuel level * 10

 SEC                    \ Set the C flag so the call to pr2+2 prints a decimal
                        \ point

 LDA #0                 \ Set the number of digits to 0 for the call to pr2+2,
                        \ so the number is not padded with spaces

 JSR pr2+2              \ Print the fuel level with a decimal point and no
                        \ padding

 LDA #195               \ Print recursive token 35 ("LIGHT YEARS")
 JSR TT27_b2

 LDA #')'               \ Print a closing bracket
 JSR TT27_b2

 LDA L04A9              \ If bit 2 of L04A9 is set, jump to preq3 to skip the
 AND #%00000100         \ following (which prints the price)
 BNE preq3

                        \ Bit 2 of L04A9 is clear, so now we print the price

 LDA XX13               \ Call prx-3 to set (Y X) to the price of the item with
 JSR prx-3              \ number XX13 - 1 (as XX13 contains the item number + 1)

 SEC                    \ Set the C flag so we will print a decimal point when
                        \ we print the price

 LDA #5                 \ Print the number in (Y X) to 5 digits, left-padding
 JSR TT11               \ with spaces and including a decimal point, which will
                        \ be the correct price for this item as (Y X) contains
                        \ the price * 10, so the trailing zero will go after the
                        \ decimal point (i.e. 5250 will be printed as 525.0)

 LDA #' '               \ Print a space
 JMP TT27_b2

.preq3

 LDA #' '               \ Print a space
 JSR TT27_b2

 LDA XC                 \ Loop back to print another space until XC = 24, so
 CMP #24                \ so this tabs the text cursor to column 24
 BNE preq3

 LDA XX13               \ Call prx-3 to set (Y X) to the price of the item with
 JSR prx-3              \ number XX13 - 1 (as XX13 contains the item number + 1)

 SEC                    \ Set the C flag so we will print a decimal point when
                        \ we print the price

 LDA #6                 \ Print the number in (Y X) to 6 digits, left-padding
 JSR TT11               \ with spaces and including a decimal point, which will
                        \ be the correct price for this item as (Y X) contains
                        \ the price * 10, so the trailing zero will go after the
                        \ decimal point (i.e. 5250 will be printed as 525.0)

 JMP TT162              \ Print a space and return from the subroutine using a
                        \ tail call

\ ******************************************************************************
\
\       Name: subm_EQSHP4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EQSHP4

 JSR PrintEquipment

 LDA XX13
 SEC
 SBC #1

 BNE CA464
 LDA #1

.CA464

 STA XX13

.CA466

 JSR subm_EQSHP2

 JSR subm_A4A5_b6

 JSR subm_8980

 JSR subm_D8C5

 JMP CA4DB

\ ******************************************************************************
\
\       Name: subm_EQSHP5
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EQSHP5

 JSR PrintEquipment

 LDA XX13
 CLC
 ADC #1

 CMP Q
 BNE CA485

 LDA Q
 SBC #1

.CA485

 STA XX13

 JMP CA466

\ ******************************************************************************
\
\       Name: tabEquipShip
\       Type: Variable
\   Category: Text
\    Summary: The column for the Equip Ship title for each language
\
\ ******************************************************************************

.tabEquipShip

 EQUB 12                \ English

 EQUB 8                 \ German

 EQUB 10                \ French

INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"

\ ******************************************************************************
\
\       Name: subm_A6A1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A6A1

 LDX L03E9
 LDA #0
 TAY
 RTS

\ ******************************************************************************
\
\       Name: subm_A6A8
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A6A8

 LDA #&0C
 STA XC
 TYA
 PHA
 CLC
 ADC #8
 STA YC
 JSR TT162
 LDA L04A9
 AND #6
 BNE CA6C0
 JSR TT162

.CA6C0

 PLA
 PHA
 CLC
 ADC #&60
 JSR TT27_b2

.loop_CA6C8

 JSR TT162
 LDA XC
 LDX language
 CMP LA6D8,X
 BNE loop_CA6C8
 PLA
 TAY
 RTS

\ ******************************************************************************
\
\       Name: LA6D8
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LA6D8

 EQUB &15, &15, &16, &15                      ; A6D8: 15 15 16... ...

\ ******************************************************************************
\
\       Name: subm_A6DC
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A6DC

 LDA #2
 STA fontBitPlane
 JSR subm_A6A8
 LDA #1
 STA fontBitPlane
 TYA
 PHA
 JSR subm_8980
 JSR subm_D8C5
 PLA
 TAY
 RTS

\ ******************************************************************************
\
\       Name: LA6F2
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LA6F2

 EQUB &0A, &0A, &0B, &0A                      ; A6F2: 0A 0A 0B... ...

\ ******************************************************************************
\
\       Name: qv
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.qv

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA L04BA
 ORA L04BB
 ORA controller1A
 BMI qv
 LDY #3

.loop_CA706

 JSR subm_A6A8
 DEY
 BNE loop_CA706
 LDA #2
 STA fontBitPlane
 JSR subm_A6A8
 LDA #1
 STA fontBitPlane
 LDA #&0B
 STA XC
 STA K+2
 LDA #7
 STA YC
 STA K+3
 LDX language
 LDA LA6F2,X
 STA K
 LDA #6
 STA K+1
 JSR subm_B2BC_b3
 JSR subm_8980
 LDY #0

.CA737

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1Up
 BPL CA74A
 JSR subm_A6A8
 DEY
 BPL CA747
 LDY #3

.CA747

 JSR subm_A6DC

.CA74A

 LDA controller1Down
 BPL CA75C
 JSR subm_A6A8
 INY
 CPY #4
 BNE CA759
 LDY #0

.CA759

 JSR subm_A6DC

.CA75C

 LDA controller1A
 BMI CA775
 LDA L0465
 BEQ CA737
 CMP #&50
 BNE CA775
 LDA #0
 STA L0465
 JSR subm_A166_b6
 JMP CA737

.CA775

 TYA
 TAX
 RTS

INCLUDE "library/enhanced/main/subroutine/refund.asm"
INCLUDE "library/common/main/variable/prxs.asm"

\ ******************************************************************************
\
\       Name: hyp1_cpl
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.hyp1_cpl

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ from safehouse into QQ15, where we store the seeds for
                        \ the selected system, so set up a counter in X for
                        \ copying six bytes (for three 16-bit seeds)

.loop_CA7C8

 LDA safehouse,X        \ Copy the X-th byte in safehouse to the X-th byte in
 STA QQ15,X             \ QQ15

 DEX                    \ Decrement the counter

 BPL loop_CA7C8         \ Loop back until we have copied all six bytes

INCLUDE "library/common/main/subroutine/cpl.asm"
INCLUDE "library/common/main/subroutine/cmn.asm"
INCLUDE "library/common/main/subroutine/ypl.asm"
INCLUDE "library/common/main/subroutine/tal.asm"
INCLUDE "library/common/main/subroutine/fwl.asm"

\ ******************************************************************************
\
\       Name: subm_A89F
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A89F

 JSR subm_A8A2

\ ******************************************************************************
\
\       Name: subm_A8A2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_A8A2

 JSR TT162
 JMP TT162

\ ******************************************************************************
\
\       Name: ypls
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ypls

 JMP ypl

INCLUDE "library/common/main/subroutine/csh.asm"

\ ******************************************************************************
\
\       Name: plf
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.plf

 JSR TT27_b2
 JMP TT67

\ ******************************************************************************
\
\       Name: TT68
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT68

 JSR TT27_b2

\ ******************************************************************************
\
\       Name: TT73
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT73

 LDA #':'
 JMP TT27_b2

\ ******************************************************************************
\
\       Name: tals
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.tals

 JMP tal

\ ******************************************************************************
\
\       Name: TT27_0
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT27_0

 TXA
 BEQ csh
 DEX
 BEQ tals
 DEX
 BEQ ypls
 DEX
 BNE CA8E8
 JMP cpl

.CA8E8

 DEX
 BNE CA8EE
 JMP cmn

.CA8EE

 DEX
 BEQ fwls
 DEX
 BNE CA8F9
 LDA #&80
 STA QQ17

.loop_CA8F8

 RTS

.CA8F9

 DEX
 BEQ loop_CA8F8
 DEX
 BNE CA902
 STX QQ17
 RTS

.CA902

 JSR TT73
 LDA L04A9
 AND #2
 BNE CA911
 LDA #&16
 STA XC
 RTS

.CA911

 LDA #&17
 STA XC
 RTS

\ ******************************************************************************
\
\       Name: fwls
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.fwls

 JMP fwl

\ ******************************************************************************
\
\       Name: SOS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SOS1

 JSR msblob
 LDA #&7F
 STA INWK+29
 STA INWK+30
 LDA tek
 AND #2
 ORA #&80
 JMP NWSHP

\ ******************************************************************************
\
\       Name: SOLAR
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SOLAR

 LDA TRIBBLE
 BEQ CA94C
 LDA #0
 STA QQ20
 JSR DORND
 AND #&0F
 ADC TRIBBLE
 ORA #4
 ROL A
 STA TRIBBLE
 ROL TRIBBLE+1
 BPL CA94C
 ROR TRIBBLE+1

.CA94C

 LSR FIST
 JSR ZINF
 LDA QQ15+1
 AND #3
 ADC #3
 STA INWK+8
 LDX QQ15+2
 CPX #&80
 ROR A
 STA INWK+2
 ROL A
 LDX QQ15+3
 CPX #&80
 ROR A
 STA INWK+5
 JSR SOS1
 LDA QQ15+3
 AND #7
 ORA #&81
 STA INWK+8
 LDA QQ15+5
 AND #3
 STA INWK+2
 STA INWK+1
 LDA #0
 STA INWK+29
 STA INWK+30
 STA FRIN+1
 STA SSPR
 LDA #&81
 JSR NWSHP

\ ******************************************************************************
\
\       Name: NWSTARS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.NWSTARS

 LDA QQ11
 ORA DLY
 BNE WPSHPS

\ ******************************************************************************
\
\       Name: nWq
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.nWq

 LDA frameCounter
 CLC
 ADC RAND
 STA RAND
 LDA frameCounter
 STA RAND+1
 LDY NOSTM

.CA9A4

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DORND
 ORA #8
 STA SZ,Y
 STA ZZ
 JSR DORND
 ORA #&10
 AND #&F8
 STA SX,Y
 JSR DORND
 STA SY,Y
 STA SXL,Y
 STA SYL,Y
 STA SZL,Y
 DEY
 BNE CA9A4

\ ******************************************************************************
\
\       Name: WPSHPS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.WPSHPS

 LDX #0

.CA9D9

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA FRIN,X
 BEQ CA9FD
 BMI CA9FA
 STA TYPE
 JSR GINF
 LDY #&1F
 LDA (XX19),Y
 AND #&B7
 STA (XX19),Y

.CA9FA

 INX
 BNE CA9D9

.CA9FD

 LDX #0
 RTS

.loop_CAA00

 DEX
 RTS

\ ******************************************************************************
\
\       Name: SHD
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SHD

 INX
 BEQ loop_CAA00

\ ******************************************************************************
\
\       Name: DENGY
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DENGY

 DEC ENERGY
 PHP
 BNE CAA0E
 INC ENERGY

.CAA0E

 PLP
 RTS

.loop_CAA10

 LDA #&F0
 STA ySprite13
 RTS

\ ******************************************************************************
\
\       Name: COMPAS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.COMPAS

 LDA MJ
 BNE loop_CAA10
 LDA SSPR
 BNE SP1
 JSR SPS1
 JMP SP2

\ ******************************************************************************
\
\       Name: SP1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SP1

 JSR SPS4

\ ******************************************************************************
\
\       Name: SP2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SP2

 LDA XX15
 JSR SPS2
 TXA
 CLC
 ADC #&DC
 STA xSprite13
 LDA Y1
 JSR SPS2
 STX T

IF _NTSC

 LDA #&BA

ELIF _PAL

 LDA #&C0

ENDIF

 SEC
 SBC T
 STA ySprite13
 LDA #&F7
 LDX X2
 BPL CAA4C
 LDA #&F6

.CAA4C

 STA tileSprite13
 RTS

\ ******************************************************************************
\
\       Name: SPS4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SPS4

 LDX #8

.loop_CAA52

 LDA K%+42,X
 STA K3,X
 DEX
 BPL loop_CAA52
 JMP TAS2

\ ******************************************************************************
\
\       Name: OOPS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.OOPS

 STA T
 LDX #0
 LDY #8
 LDA (XX19),Y
 BMI CAA79
 LDA FSH
 SBC T
 BCC CAA72
 STA FSH
 RTS

.CAA72

 LDX #0
 STX FSH
 BCC CAA89

.CAA79

 LDA ASH
 SBC T
 BCC CAA84
 STA ASH
 RTS

.CAA84

 LDX #0
 STX ASH

.CAA89

 ADC ENERGY
 STA ENERGY
 BEQ CAA93
 BCS CAA96

.CAA93

 JMP DEATH

.CAA96

 JSR EXNO3
 JMP OUCH

\ ******************************************************************************
\
\       Name: NWSPS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.NWSPS

 LDX #&81
 STX INWK+32
 LDX #0
 STX INWK+30
 STX NEWB
 STX FRIN+1
 DEX
 STX INWK+29
 LDX #&0A
 JSR NwS1
 JSR NwS1
 JSR NwS1
 LDA #2
 JSR NWSHP
 LDX XX21+2
 LDY XX21+3
 LDA tek
 CMP #&0A
 BCC CAACF
 LDX XX21+64
 LDY XX21+65

.CAACF

 STX L04A2
 STY L04A3
 JMP subm_AC5C_b3

\ ******************************************************************************
\
\       Name: NW2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.NW2

 STA FRIN,X
 TAX
 LDA #0
 STA INWK+33
 JMP CAB86

\ ******************************************************************************
\
\       Name: NWSHP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.NWSHP

 STA T

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0

.loop_CAAF4

 LDA FRIN,X
 BEQ CAB00
 INX
 CPX #8
 BCC loop_CAAF4

.loop_CAAFE

 CLC
 RTS

.CAB00

 JSR GINF
 LDA T
 BMI NW2
 ASL A
 TAY
 LDA XX21-1,Y
 BEQ loop_CAAFE
 STA XX0+1
 LDA XX21-2,Y
 STA XX0
 STX SC2
 LDX T
 LDA #0
 STA INWK+33
 LDA scacol,X
 BMI CAB43
 TAX
 LDY #8

.loop_CAB25

 LDA L0374,Y
 BEQ CAB2F
 DEY
 BNE loop_CAB25
 BEQ CAB43

.CAB2F

 LDA #&FF
 STA L0374,Y
 STY INWK+33
 TYA
 ASL A
 ADC INWK+33
 ASL A
 ASL A
 TAY
 TXA
 LDX INWK+33
 STA L037E,X

.CAB43

 LDX SC2

.NW6

 LDY #&0E
 JSR GetShipBlueprint   \ Set A to the Y-th byte from the current ship blueprint
 STA INWK+35
 LDY #&13
 JSR GetShipBlueprint   \ Set A to the Y-th byte from the current ship blueprint
 AND #7
 STA INWK+31
 LDA T
 STA FRIN,X
 TAX
 BMI CAB86
 CPX #&0F
 BEQ gangbang
 CPX #3
 BCC NW7
 CPX #&0B
 BCS NW7

.gangbang

 INC JUNK

.NW7

 INC MANY,X
 LDY T
 JSR GetDefaultNEWB     \ Set A to the default NEWB flags for ship type Y
 AND #&6F
 ORA NEWB
 STA NEWB
 AND #4
 BEQ CAB86
 LDA L0300
 ORA #&80
 STA L0300

.CAB86

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #&25

.loop_CAB95

 LDA XX1,Y
 STA (XX19),Y
 DEY
 BPL loop_CAB95

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 SEC
 RTS

\ ******************************************************************************
\
\       Name: NwS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.NwS1

 LDA XX1,X
 EOR #&80
 STA XX1,X
 INX
 INX
 RTS

\ ******************************************************************************
\
\       Name: KS3
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.KS3

 RTS

\ ******************************************************************************
\
\       Name: KS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.KS1

 LDX XSAV
 JSR KILLSHP
 LDX XSAV
 RTS

\ ******************************************************************************
\
\       Name: KS4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.KS4

 JSR ZINF
 LDA #0
 STA FRIN+1
 STA SSPR
 LDA #6
 STA INWK+5
 LDA #&81
 JSR NWSHP
 JMP subm_AC5C_b3

\ ******************************************************************************
\
\       Name: KS2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.KS2

 LDX #&FF

.CABD7

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 INX
 LDA FRIN,X
 BEQ KS3
 CMP #1
 BNE CABD7
 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1
 LDY #&20
 LDA (SC),Y
 BPL CABD7
 AND #&7F
 LSR A
 CMP XX4
 BCC CABD7
 BEQ CAC13
 SBC #1
 ASL A
 ORA #&80
 STA (SC),Y
 BNE CABD7

.CAC13

 LDA #0
 STA (SC),Y
 BEQ CABD7

\ ******************************************************************************
\
\       Name: subm_AC19
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_AC19

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #&25

.loop_CAC1E

 LDA (XX19),Y
 STA XX1,Y
 DEY
 BPL loop_CAC1E

\ ******************************************************************************
\
\       Name: KILLSHP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.KILLSHP

 STX XX4
 JSR subm_BAF3_b1
 LDX XX4
 LDA MSTG
 CMP XX4
 BNE CAC3E
 LDY #&6C
 JSR ABORT
 LDA #&C8
 JSR MESS

.CAC3E

 LDY XX4
 LDX FRIN,Y
 CPX #2
 BNE CAC4A
 JMP KS4

.CAC4A

 CPX #&1F
 BNE CAC59
 LDA TP
 ORA #2
 STA TP
 INC TALLY+1

.CAC59

 CPX #&0F
 BEQ blacksuspenders
 CPX #3
 BCC CAC68
 CPX #&0B
 BCS CAC68

.blacksuspenders

 DEC JUNK

.CAC68

 DEC MANY,X
 LDX XX4

.KSL1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 INX
 LDA FRIN,X
 STA L0369,X
 BNE CAC86
 JMP KS2

.CAC86

 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #&29

.loop_CACA2

 LDA (SC),Y
 STA (XX19),Y
 DEY
 BPL loop_CACA2
 LDA SC
 STA XX19
 LDA SC+1
 STA INF+1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JMP KSL1

\ ******************************************************************************
\
\       Name: ABORT
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ABORT

 LDX #0
 STX MSAR
 DEX

\ ******************************************************************************
\
\       Name: ABORT2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ABORT2

 STX MSTG

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX NOMSL
 JSR MSBAR
 JMP subm_AC5C_b3

\ ******************************************************************************
\
\       Name: msbpars
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.msbpars

 EQUB 4, 0, 0, 0, 0                           ; ACE0: 04 00 00... ...

\ ******************************************************************************
\
\       Name: YESNO
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.YESNO

 LDA fontBitPlane
 PHA
 LDA #2
 STA fontBitPlane
 LDA #1
 PHA

.CACEF

 JSR CLYNS
 LDA #&0F
 STA XC
 PLA
 PHA
 JSR DETOK_b2
 JSR subm_D951
 LDA controller1A
 BMI CAD17
 LDA controller1Up
 ORA controller1Down
 BPL CAD0F
 PLA
 EOR #3
 PHA

.CAD0F

 LDY #8
 JSR DELAY
 JMP CACEF

.CAD17

 LDA #0
 STA L0081
 STA controller1A
 PLA
 TAX
 PLA
 STA fontBitPlane
 TXA
 RTS

\ ******************************************************************************
\
\       Name: subm_AD25
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_AD25

 LDA QQ11
 BNE CAD2E
 JSR DOKEY
 TXA
 RTS

.CAD2E

 JSR DOKEY
 LDX #0
 LDY #0
 LDA controller1B
 BMI CAD52
 LDA L04BA
 BPL CAD40
 DEX

.CAD40

 LDA L04BB
 BPL CAD46
 INX

.CAD46

 LDA controller1Up
 BPL CAD4C
 INY

.CAD4C

 LDA controller1Down
 BPL CAD52
 DEY

.CAD52

 LDA L0081
 RTS

\ ******************************************************************************
\
\       Name: THERE
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.THERE

 LDX GCNT
 DEX
 BNE CAD69
 LDA QQ0
 CMP #&90
 BNE CAD69
 LDA QQ1
 CMP #&21
 BEQ CAD6A

.CAD69

 CLC

.CAD6A

 RTS

\ ******************************************************************************
\
\       Name: RESET
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.RESET

 JSR subm_B46B
 LDA #0
 STA L0395
 LDX #6

.loop_CAD75

 STA BETA,X
 DEX
 BPL loop_CAD75
 TXA
 STA QQ12
 LDX #2

.loop_CAD7F

 STA FSH,X
 DEX
 BPL loop_CAD7F
 LDA #&FF
 STA L0464

\ ******************************************************************************
\
\       Name: RES2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.RES2

 SEI
 LDA #1
 STA L00F6
 LDA #1
 STA boxEdge1
 LDA #2
 STA boxEdge2
 LDA #&50
 STA phaseL00CD
 STA phaseL00CD+1
 LDA BOMB
 BPL CADAA
 JSR HideHiddenColour
 STA BOMB

.CADAA

 LDA #&14
 STA NOSTM
 LDX #&FF
 STX MSTG
 LDA L0300
 ORA #&80
 STA L0300
 LDA #&80
 STA JSTX
 STA JSTY
 STA ALP2
 STA BET2
 ASL A
 STA DLY
 STA BETA
 STA BET1
 STA ALP2+1
 STA BET2+1
 STA MCNT
 STA LAS
 STA L03E7
 STA L03E8
 LDA #3
 STA DELTA
 STA ALPHA
 STA ALP1
 LDA #&48
 JSR SetScreenHeight
 LDA ECMA
 BEQ CADF3
 JSR ECMOF

.CADF3

 JSR WPSHPS
 LDA QQ11a
 BMI CAE00
 JSR HideSprites59To62
 JSR HideScannerSprites

.CAE00

 JSR subm_B46B

\ ******************************************************************************
\
\       Name: ZINF
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ZINF

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #&25
 LDA #0

.loop_CAE14

 STA XX1,Y
 DEY
 BPL loop_CAE14

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #&60
 STA INWK+18
 STA INWK+22
 ORA #&80
 STA INWK+14
 RTS

\ ******************************************************************************
\
\       Name: SetScreenHeight
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SetScreenHeight

 STA Yx1M2
 ASL A
 STA Yx2M2
 SBC #0
 STA Yx2M1
 RTS

\ ******************************************************************************
\
\       Name: msblob
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.msblob

 LDX #4

.loop_CAE3E

 CPX NOMSL
 BEQ CAE4C
 LDY #&85
 JSR MSBAR
 DEX
 BNE loop_CAE3E
 RTS

.CAE4C

 LDY #&6C
 JSR MSBAR
 DEX
 BNE CAE4C
 RTS

\ ******************************************************************************
\
\       Name: MTT4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MTT4

 JSR DORND
 LSR A
 STA INWK+32
 STA INWK+29
 ROL INWK+31
 AND #&0F
 ADC #&0A
 STA INWK+27
 JSR DORND
 BMI CAE74
 LDA INWK+32
 ORA #&C0
 STA INWK+32
 LDX #&10
 STX NEWB

.CAE74

 AND #2
 ADC #&0B
 CMP #&0F
 BNE CAE7E
 LDA #&0B

.CAE7E

 JSR NWSHP
 JMP MLOOP

\ ******************************************************************************
\
\       Name: subm_AE84
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_AE84

 LDA nmiTimerLo
 STA RAND
 LDA K%+6
 STA RAND+1
 LDA L0307
 STA RAND+3
 LDA QQ12
 BEQ TT100
 JMP MLOOP

\ ******************************************************************************
\
\       Name: TT100
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT100

 JSR M%
 DEC MCNT
 BEQ CAEA3

.loop_CAEA0

 JMP MLOOP

.CAEA3

 LDA MJ
 ORA DLY
 BNE loop_CAEA0
 JSR DORND
 CMP #&28
 BCS MTT1
 LDA JUNK
 CMP #3
 BCS MTT1
 JSR ZINF
 LDA #&26
 STA INWK+7
 JSR DORND
 STA XX1
 STX INWK+3
 AND #&80
 STA INWK+2
 TXA
 AND #&80
 STA INWK+5
 ROL INWK+1
 ROL INWK+1
 JSR DORND
 AND #&30
 BNE CAEDE
 JMP MTT4

.CAEDE

 ORA #&6F
 STA INWK+29
 LDA SSPR
 BNE MLOOPS
 TXA
 BCS CAEF2
 AND #&1F
 ORA #&10
 STA INWK+27
 BCC CAEF6

.CAEF2

 ORA #&7F
 STA INWK+30

.CAEF6

 JSR DORND
 CMP #&FC
 BCC CAF03
 LDA #&0F
 STA INWK+32
 BNE CAF09

.CAF03

 CMP #&0A
 AND #1
 ADC #5

.CAF09

 JSR NWSHP

.MLOOPS

 JMP MLOOP

\ ******************************************************************************
\
\       Name: MTT1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MTT1

 LDA SSPR
 BNE MLOOPS
 JSR BAD
 ASL A
 LDX MANY+16
 BEQ CAF20
 ORA FIST

.CAF20

 STA T
 JSR Ze
 CMP #&88
 BNE CAF2C
 JMP fothg

.CAF2C

 CMP T
 BCS CAF3B
 LDA NEWB
 ORA #4
 STA NEWB
 LDA #&10
 JSR NWSHP

.CAF3B

 LDA MANY+16
 BNE MLOOPS

\ ******************************************************************************
\
\       Name: MainLoop4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MainLoop4

 DEC EV
 BPL MLOOPS
 INC EV
 LDA TP
 AND #&0C
 CMP #8
 BNE nopl
 JSR DORND
 CMP #&C8
 BCC nopl

.CAF58

 JSR GTHG+15            \ Spawn a Thargoid (but not a Thargon)

 JMP MLOOP

.nopl

 JSR DORND
 LDY gov
 BEQ LABEL_2
 LDY JUNK
 LDX FRIN+2,Y
 BEQ CAF72
 CMP #&32
 BCS MLOOPS

.CAF72

 CMP #&64
 BCS MLOOPS
 AND #7
 CMP gov
 BCC MLOOPS

.LABEL_2

 JSR Ze
 CMP #&64
 AND #&0F
 ORA #&10
 STA INWK+27
 BCS CAFCF
 INC EV
 AND #3
 ADC #&18
 TAY
 JSR THERE
 BCC CAFA8
 LDA #&F9
 STA INWK+32
 LDA TP
 AND #3
 LSR A
 BCC CAFA8
 ORA MANY+31
 BEQ LAFB4

.CAFA8

 JSR DORND
 CMP #&C8
 ROL A
 ORA #&C0
 STA INWK+32
 TYA

 EQUB &2C

.LAFB4

 LDA #&1F

.loop_CAFB6

 JSR NWSHP
 JMP MLOOP

.fothg

 LDA K%+6
 AND #&3E
 BNE CAF58
 LDA #&12
 STA INWK+27
 LDA #&79
 STA INWK+32
 LDA #&20
 BNE loop_CAFB6

.CAFCF

 AND #3
 STA EV
 STA XX13

.loop_CAFD6

 LDA #4
 STA NEWB
 JSR DORND
 STA T
 JSR DORND
 AND T
 AND #7
 ADC #&11
 JSR NWSHP
 DEC XX13
 BPL loop_CAFD6

\ ******************************************************************************
\
\       Name: MLOOP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MLOOP

 LDX #&FF
 TXS
 LDX GNTMP
 BEQ CAFFA
 DEC GNTMP

.CAFFA

 LDX LASCT
 BEQ CB006
 DEX
 BEQ CB003
 DEX

.CB003

 STX LASCT

.CB006

 LDA QQ11
 BEQ CB00F
 LDY #4
 JSR DELAY

.CB00F

 LDA TRIBBLE+1
 BEQ CB02B
 JSR DORND
 CMP #&DC
 LDA TRIBBLE
 ADC #0
 STA TRIBBLE
 BCC CB02B
 INC TRIBBLE+1
 BPL CB02B
 DEC TRIBBLE+1

.CB02B

 LDA TRIBBLE+1
 BEQ CB04C
 LDY CABTMP
 CPY #&E0
 BCS subm_B039
 LSR A
 LSR A

.subm_B039

 STA T
 JSR DORND
 CMP T
 BCS CB04C
 AND #3
 TAY
 LDA LB079,Y
 TAY
 JSR NOISE

.CB04C

 LDA L0300
 LDX QQ22+1
 BEQ CB055
 ORA #&80

.CB055

 LDX DLY
 BEQ CB05C
 AND #&7F

.CB05C

 STA L0300
 AND #&C0
 BEQ CB070
 CMP #&C0
 BEQ CB070
 CMP #&80
 ROR A
 STA L0300
 JSR subm_AC5C_b3

.CB070

 JSR subm_AD25

.CB073

 JSR TT102
 JMP subm_AE84

\ ******************************************************************************
\
\       Name: LB079
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LB079

 EQUB 5, 5, 5, 6                              ; B079: 05 05 05... ...

\ ******************************************************************************
\
\       Name: TT102
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT102

 CMP #0
 BNE CB084
 JMP CB16A

.CB084

 CMP #3
 BNE CB08B
 JMP STATUS

.CB08B

 CMP #4
 BEQ CB09B
 CMP #&24
 BNE CB0A6
 LDA L0470
 EOR #&80
 STA L0470

.CB09B

 LDA L0470
 BPL CB0A3
 JMP TT22

.CB0A3

 JMP TT23

.CB0A6

 CMP #&23
 BNE CB0B0
 JSR subm_9D09
 JMP TT25

.CB0B0

 CMP #8
 BNE CB0B7
 JMP TT213

.CB0B7

 CMP #2
 BNE CB0BE
 JMP TT167

.CB0BE

 CMP #1
 BNE CB0CC
 LDX QQ12
 BEQ CB0CC
 JSR subm_9D03
 JMP TT110

.CB0CC

 CMP #&11
 BNE CB119
 LDX QQ12
 BNE CB119
 LDA auto
 BNE CB106
 LDA SSPR
 BEQ CB119
 LDA DKCMP
 ORA L03E8
 BNE CB0FA
 LDY #0
 LDX #&32
 JSR LCASH
 BCS CB0F2
 JMP BOOP

.CB0F2

 DEC L03E8
 LDA #0
 JSR MESS

.CB0FA

 LDA #1
 JSR WSCAN
 JSR subm_8021_b6
 LDA #&FF
 BNE CB10B

.CB106

 JSR WaitResetSound
 LDA #0

.CB10B

 STA auto
 LDA QQ11
 BEQ CB118
 JSR CLYNS
 JSR subm_8980

.CB118

 RTS

.CB119

 JSR subm_B1D4
 CMP #&15
 BNE CB137
 LDA QQ12
 BPL CB125
 RTS

.CB125

 LDA #0
 LDX QQ11
 BNE CB133
 LDA VIEW
 CLC
 ADC #1
 AND #3

.CB133

 TAX
 JMP LOOK1

.CB137

 BIT QQ12
 BPL CB149
 CMP #5
 BNE CB142
 JMP EQSHP

.CB142

 CMP #6
 BNE CB149
 JMP subm_B459_b6

.CB149

 CMP #&16
 BNE CB150
 JMP subm_9E51

.CB150

 CMP #&29
 BNE CB157
 JMP hyp

.CB157

 CMP #&27
 BNE CB16A
 LDA QQ22+1
 BNE CB1A5
 LDA QQ11
 AND #&0E
 CMP #&0C
 BNE CB1A5
 JMP HME2

.CB16A

 STA T1
 LDA QQ11
 AND #&0E
 CMP #&0C
 BNE CB18D
 LDA QQ22+1
 BNE CB18D
 LDA T1
 CMP #&26
 BNE CB18A
 JSR ping

.CB181

 ASL L0395
 LSR L0395
 JMP subm_9D09

.CB18A

 JSR TT16

.CB18D

 LDA QQ22+1
 BEQ CB1A5
 DEC QQ22
 BNE CB1A5
 LDA #5
 STA QQ22
 DEC QQ22+1
 BEQ CB1A2
 LDA #&FA
 JMP MESS

.CB1A2

 JMP TT18

.CB1A5

 RTS

\ ******************************************************************************
\
\       Name: BAD
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.BAD

 LDA QQ20+3
 CLC
 ADC QQ20+6
 ASL A
 ADC QQ20+10
 RTS

\ ******************************************************************************
\
\       Name: FAROF
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.FAROF

 LDA INWK+2
 ORA INWK+5
 ORA INWK+8
 ASL A
 BNE CB1C8
 LDA #&E0
 CMP INWK+1
 BCC CB1C7
 CMP INWK+4
 BCC CB1C7
 CMP INWK+7

.CB1C7

 RTS

.CB1C8

 CLC
 RTS

\ ******************************************************************************
\
\       Name: MAS4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MAS4

 ORA INWK+1
 ORA INWK+4
 ORA INWK+7
 RTS

\ ******************************************************************************
\
\       Name: subm_B1D1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B1D1

 LDA L0465

\ ******************************************************************************
\
\       Name: subm_B1D4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B1D4

 CMP #&50
 BNE CB1E2
 LDA #0
 STA L0465
 JSR subm_A166_b6
 SEC
 RTS

.CB1E2

 CLC
 RTS

\ ******************************************************************************
\
\       Name: DEATH
\       Type: Subroutine
\   Category: Start and end
\    Summary: ???
\
\ ******************************************************************************

.DEATH

 JSR WaitResetSound
 JSR EXNO3
 JSR RES2
 ASL DELTA
 ASL DELTA
 LDA #0
 STA boxEdge1
 STA boxEdge2
 STA L03EE
 LDA #&C4
 JSR TT66
 JSR subm_BED2_b6
 JSR CopyNameBuffer0To1
 JSR subm_EB86
 LDA #0
 STA L045F
 LDA #&C4
 JSR subm_A7B7_b3
 LDA #0
 STA QQ11
 STA QQ11a
 LDA tileNumber
 STA L00D2
 LDA #&74
 STA L00D8
 LDX #8
 STX L00CC
 LDA #&68
 JSR SetScreenHeight
 LDY #8
 LDA #1

.loop_CB22F

 STA L0374,Y
 DEY
 BNE loop_CB22F
 JSR nWq
 JSR DORND
 AND #&87
 STA ALPHA
 AND #7
 STA ALP1
 LDA ALPHA
 AND #&80
 STA ALP2
 EOR #&80
 STA ALP2+1

.CB24D

 JSR Ze
 LSR A
 LSR A
 STA XX1
 LDY #0
 STY QQ11
 STY INWK+1
 STY INWK+4
 STY INWK+7
 STY INWK+32
 DEY
 STY MCNT
 EOR #&2A
 STA INWK+3
 ORA #&50
 STA INWK+6
 TXA
 AND #&8F
 STA INWK+29
 LDY #&40
 STY LASCT
 SEC
 ROR A
 AND #&87
 STA INWK+30
 LDX #5
 LDA XX21+7
 BEQ CB285
 BCC CB285
 DEX

.CB285

 JSR fq1
 JSR DORND
 AND #&80
 LDY #&1F
 STA (XX19),Y
 LDA FRIN+6
 BEQ CB24D
 LDA #8
 STA DELTA
 LDA #&0C
 STA L00B5
 LDA #&92
 LDY #&78
 JSR subm_B77A
 JSR HideSprites5To63
 LDA #&1E
 STA LASCT

.loop_CB2AD

 JSR ChangeDrawingPhase
 JSR subm_MA23
 JSR subm_BED2_b6
 LDA #&CC
 JSR subm_D977
 DEC LASCT
 BNE loop_CB2AD
 JMP DEATH2

\ ******************************************************************************
\
\       Name: ShowStartScreen
\       Type: Subroutine
\   Category: Start and end
\    Summary: ???
\
\ ******************************************************************************

.ShowStartScreen

 LDA #&FF
 STA L0307
 LDA #&80
 STA L0308
 LDA #&1B
 STA L0309
 LDA #&34
 STA L030A
 JSR ResetSoundL045E
 JSR subm_B906_b6
 JSR subm_F3AB
 LDA #1
 STA fontBitPlane
 LDX #&FF
 STX QQ11a
 TXS
 JSR RESET
 JSR StartScreen_b6

\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DEATH2

 LDX #&FF
 TXS
 INX
 STX L0470
 JSR RES2
 LDA #5
 JSR subm_E909
 JSR ResetKeyLogger
 JSR subm_F3BC
 LDA controller1Select
 AND controller1Start
 AND controller1A
 AND controller1B
 BNE CB341
 LDA controller1Select
 ORA controller2Select
 BNE CB355
 LDA #0
 PHA
 JSR BR1_Part2
 LDA #&FF
 STA QQ11
 LDA L03EE
 BEQ CB32C
 JSR subm_F362

.CB32C

 JSR WSCAN
 LDA #4
 JSR subm_8021_b6
 LDA L0305
 CLC
 ADC #6
 STA L0305
 PLA
 JMP subm_A5AB_b6

.CB341

 JSR BR1_Part2
 LDA #&FF
 STA QQ11
 JSR WSCAN
 LDA #4
 JSR subm_8021_b6
 LDA #2
 JMP subm_A5AB_b6

.CB355

 JSR subm_B63D_b3

\ ******************************************************************************
\
\       Name: subm_B358
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B358

 LDX #&FF
 TXS
 JSR BR1_Part2

\ ******************************************************************************
\
\       Name: BAY
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.BAY

 JSR ClearTiles_b3
 LDA #&FF
 STA QQ12
 LDA #3
 JMP CB073

\ ******************************************************************************
\
\       Name: BR1_Part2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.BR1_Part2

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR subm_B8FE_b6
 JSR WaitResetSound
 JSR ping
 JSR TT111
 JSR jmp
 LDX #5

.loop_CB37E

 LDA QQ15,X
 STA QQ2,X
 DEX
 BPL loop_CB37E
 INX
 STX EV
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov
 RTS

\ ******************************************************************************
\
\       Name: subm_B39D
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B39D

 JSR TT66
 JSR CopyNameBuffer0To1
 JSR subm_F126
 LDA #0
 STA QQ11
 STA QQ11a
 STA L045F
 LDA tileNumber
 STA L00D2
 LDA #&50
 STA L00D8
 LDX #8
 STX L00CC
 RTS

\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TITLE

 STY L0480
 STX TYPE
 JSR RESET
 JSR ResetKeyLogger

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #&60
 STA INWK+14
 LDA #&37
 STA INWK+7
 LDX #&7F
 STX INWK+29
 STX INWK+30
 INX
 STX QQ17
 LDA TYPE
 JSR NWSHP
 JSR subm_BAF3_b1
 LDA #&0C
 STA CNT2
 LDA #5
 STA MCNT
 LDY #0
 STY DELTA
 LDA #1
 JSR subm_B39D
 LDA #7
 STA YP

.loop_CB3F9

 LDA #&19
 STA XP

.loop_CB3FE

 LDA INWK+7
 CMP #1
 BEQ CB406
 DEC INWK+7

.CB406

 JSR subm_B426
 BCS CB422
 DEC XP
 BNE loop_CB3FE
 DEC YP
 BNE loop_CB3F9

.loop_CB415

 LDA INWK+7
 CMP #&37
 BCS CB424
 INC INWK+7
 JSR subm_B426
 BCC loop_CB415

.CB422

 SEC
 RTS

.CB424

 CLC
 RTS

\ ******************************************************************************
\
\       Name: subm_B426
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B426

 JSR MVEIT3
 LDX L0480
 STX INWK+6
 LDA MCNT
 AND #3
 LDA #0
 STA XX1
 STA INWK+3

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR subm_D96F
 INC MCNT
 LDA controller1A
 ORA controller1Start
 ORA controller1Select
 BMI CB457
 BNE CB466

.CB457

 LDA controller2A
 ORA controller2Start
 ORA controller2Select
 BMI CB464
 BNE CB469

.CB464

 CLC
 RTS

.CB466

 LSR scanController2

.CB469

 SEC
 RTS

\ ******************************************************************************
\
\       Name: subm_B46B
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B46B

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #&2B
 LDA #0

.loop_CB472

 STA L0369,X
 DEX
 BNE loop_CB472
 LDX #&21

.loop_CB47A

 STA MANY,X
 DEX
 BPL loop_CB47A

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS

\ ******************************************************************************
\
\       Name: ResetKeyLogger
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ResetKeyLogger

 LDX #6
 LDA #0
 STA L0081

.loop_CB48A

 STA KL,X
 DEX
 BPL loop_CB48A
 RTS

\ ******************************************************************************
\
\       Name: MAS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MAS1

 LDA XX1,Y
 ASL A
 STA K+1
 LDA INWK+1,Y
 ROL A
 STA K+2
 LDA #0
 ROR A
 STA K+3
 JSR MVT3
 STA INWK+2,X
 LDY K+1
 STY XX1,X
 LDY K+2
 STY INWK+1,X
 AND #&7F
 RTS

\ ******************************************************************************
\
\       Name: m
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.m

 LDA #0

\ ******************************************************************************
\
\       Name: MAS2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MAS2

 ORA K%+2,Y
 ORA K%+5,Y
 ORA K%+8,Y
 AND #&7F
 RTS

\ ******************************************************************************
\
\       Name: MAS3
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MAS3

 LDA K%+1,Y
 JSR SQUA2
 STA R
 LDA K%+4,Y
 JSR SQUA2
 ADC R
 BCS CB4EB
 STA R

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K%+7,Y
 JSR SQUA2
 ADC R
 BCC CB4ED

.CB4EB

 LDA #&FF

.CB4ED

 RTS

\ ******************************************************************************
\
\       Name: SpawnSpaceStation
\       Type: Subroutine
\   Category: Universe
\    Summary: Add a space station to the local bubble of universe if we are
\             close enough to the station's orbit
\
\ ******************************************************************************

.SpawnSpaceStation

                        \ We now check the distance from our ship (at the
                        \ origin) towards the point where we will spawn the
                        \ space station if we are close enough
                        \
                        \ This point is calculated by starting at the planet's
                        \ centre and adding 2 * nosev, which takes us to a point
                        \ above the planet's surface, at an altitude that
                        \ matches the planet's radius
                        \
                        \ This point pitches and rolls around the planet as the
                        \ nosev vector rotates with the planet, and if our ship
                        \ is within a distance of (100 0) from this point in all
                        \ three axes, then we spawn the space station at this
                        \ point, with the station's slot facing towards the
                        \ planet, along the nosev vector
                        \
                        \ This works because in the following, we calculate the
                        \ station's coordinates one axis at a time, and store
                        \ the results in the INWK block, so by the time we have
                        \ calculated and checked all three, the ship data block
                        \ is set up with the correct spawning coordinates

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ Call MAS1 with X = 0, Y = 9 to do the following:
 LDY #9                 \
 JSR MAS1               \   (x_sign x_hi x_lo) += (nosev_x_hi nosev_x_lo) * 2
                        \
                        \   A = |x_sign|

 BNE MA23S2             \ If A > 0, jump to MA23S2 to skip the following, as we
                        \ are too far from the planet in the x-direction to
                        \ bump into a space station

 LDX #3                 \ Call MAS1 with X = 3, Y = 11 to do the following:
 LDY #11                \
 JSR MAS1               \   (y_sign y_hi y_lo) += (nosev_y_hi nosev_y_lo) * 2
                        \
                        \   A = |y_sign|

 BNE MA23S2             \ If A > 0, jump to MA23S2 to skip the following, as we
                        \ are too far from the planet in the y-direction to
                        \ bump into a space station

 LDX #6                 \ Call MAS1 with X = 6, Y = 13 to do the following:
 LDY #13                \
 JSR MAS1               \   (z_sign z_hi z_lo) += (nosev_z_hi nosev_z_lo) * 2
                        \
                        \   A = |z_sign|

 BNE MA23S2             \ If A > 0, jump to MA23S2 to skip the following, as we
                        \ are too far from the planet in the z-direction to
                        \ bump into a space station

 LDA #100               \ Call FAROF2 to compare x_hi, y_hi and z_hi with 100,
 JSR FAROF2             \ which will set the C flag if all three are < 100, or
                        \ clear the C flag if any of them are >= 100 ???

 BCS MA23S2             \ Jump to MA23S2 if any one of x_hi, y_hi or z_hi are
                        \ >= 100 (i.e. they must all be < 100 for us to be near
                        \ enough to the planet to bump into a space station)
                        \ ??? (this is a BCS not a BCC)

 JSR NWSPS              \ Add a new space station to our local bubble of
                        \ universe

 SEC                    \ Set the C flag to indicate that we have added the
                        \ space station

 RTS                    \ Return from the subroutine

.MA23S2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CLC                    \ Clear the C flag to indicate that we have not added
                        \ the space station

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SPS2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SPS2

 TAY
 AND #&7F
 LSR A
 LSR A
 LSR A
 LSR A
 ADC #0
 CPY #&80
 BCC CB542
 EOR #&FF
 ADC #0

.CB542

 TAX
 RTS

\ ******************************************************************************
\
\       Name: subm_B544
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B544

 LDA K%+1,X
 STA K3,X
 LDA K%+2,X
 TAY
 AND #&7F
 STA XX2+1,X
 TYA
 AND #&80
 STA XX2+2,X
 RTS

\ ******************************************************************************
\
\       Name: SPS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SPS1

 LDX #0
 JSR subm_B544
 LDX #3
 JSR subm_B544
 LDX #6
 JSR subm_B544

\ ******************************************************************************
\
\       Name: TAS2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TAS2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3
 ORA XX2+3
 ORA XX2+6
 ORA #1
 STA XX2+9
 LDA XX2+1
 ORA XX2+4
 ORA XX2+7

.loop_CB583

 ASL XX2+9
 ROL A
 BCS CB596
 ASL K3
 ROL XX2+1
 ASL XX2+3
 ROL XX2+4
 ASL XX2+6
 ROL XX2+7
 BCC loop_CB583

.CB596

 LSR XX2+1
 LSR XX2+4
 LSR XX2+7

.TA2

 LDA XX2+1
 LSR A
 ORA XX2+2
 STA XX15
 LDA XX2+4
 LSR A
 ORA XX2+5
 STA Y1
 LDA XX2+7
 LSR A
 ORA XX2+8
 STA X2
 JMP NORM

\ ******************************************************************************
\
\       Name: WARP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.WARP

 LDA DLY
 BEQ CB5BF
 JSR ResetShipStatus
 JMP subm_B358

.CB5BF

 LDA auto
 AND SSPR
 BEQ CB5CA
 JMP GOIN

.CB5CA

 JSR subm_B5F8
 BCS CB5DF
 JSR subm_B5F8
 BCS CB5DF
 JSR subm_B5F8
 BCS CB5DF
 JSR WSCAN
 JSR subm_B665

.CB5DF

 LDA #1
 STA MCNT
 LSR A
 STA EV

 JSR CheckAltitude      \ Perform an altitude check with the planet, ending the
                        \ game if we hit the ground

 LDA QQ11
 BNE CB5F7
 LDX VIEW
 DEC VIEW
 JMP LOOK1

.CB5F7

 RTS

\ ******************************************************************************
\
\       Name: subm_B5F8
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B5F8

 JSR WSCAN
 JSR subm_B665

\ ******************************************************************************
\
\       Name: subm_B5FE
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B5FE

 LDA #&80

 LSR A
 STA T
 LDY #0
 JSR CB611
 BCS CB664
 LDA SSPR
 BNE CB664
 LDY #&2A

.CB611

 LDA K%+2,Y
 ORA K%+5,Y
 ASL A
 BNE CB661
 LDA K%+8,Y
 LSR A
 BNE CB661
 LDA K%+7,Y
 ROR A
 SEC
 SBC #&20
 BCS CB62D
 EOR #&FF
 ADC #1

.CB62D

 STA K+2
 LDA K%+1,Y
 LSR A
 STA K
 LDA K%+4,Y
 LSR A
 STA K+1
 CMP K
 BCS CB641
 LDA K

.CB641

 CMP K+2
 BCS CB647
 LDA K+2

.CB647

 STA SC
 LDA K
 CLC
 ADC K+1
 ADC K+2
 SEC
 SBC SC
 LSR A
 LSR A
 STA SC+1
 LSR A
 LSR A
 ADC SC+1
 ADC SC
 CMP T
 BCC CB663

.CB661

 CLC
 RTS

.CB663

 SEC

.CB664

 RTS

\ ******************************************************************************
\
\       Name: subm_B665
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B665

 LDY #&20

.loop_CB667

 JSR ChargeShields
 DEY
 BNE loop_CB667
 LDX #0
 STX GNTMP

.CB672

 STX XSAV
 LDA FRIN,X
 BEQ CB6A7
 BMI CB686
 JSR GINF
 JSR subm_AC19
 LDX XSAV
 JMP CB672

.CB686

 JSR GINF
 LDA #&80
 STA S
 LSR A
 STA R
 LDY #7
 LDA (XX19),Y
 STA P
 INY
 LDA (XX19),Y
 JSR ADD
 STA (XX19),Y
 DEY
 TXA
 STA (XX19),Y
 LDX XSAV
 INX
 BNE CB672

.CB6A7

 RTS

\ ******************************************************************************
\
\       Name: DOKEY
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DOKEY

 JSR SetKeyLogger_b6
 LDA auto
 BNE CB6BA

.CB6B0

 LDX L0081
 CPX #&40
 BNE CB6B9
 JMP subm_A166_b6

.CB6B9

 RTS

.CB6BA

 LDA SSPR
 BNE CB6C8
 STA auto
 JSR WaitResetSound
 JMP CB6B0

.CB6C8

 JSR ZINF
 LDA #&60
 STA INWK+14
 ORA #&80
 STA INWK+22
 STA TYPE
 LDA DELTA
 STA INWK+27
 JSR DOCKIT
 LDA INWK+27
 CMP #&16
 BCC CB6E4
 LDA #&16

.CB6E4

 STA DELTA
 LDA #&FF
 LDX #0
 LDY INWK+28
 BEQ CB6F5
 BMI CB6F2
 LDX #1

.CB6F2

 STA KL,X

.CB6F5

 LDA #&80
 LDX #2
 ASL INWK+29
 BEQ CB712
 BCC CB701
 LDX #3

.CB701

 BIT INWK+29
 BPL CB70C
 LDA #&40
 STA JSTX
 LDA #0

.CB70C

 STA KL,X
 LDA JSTX

.CB712

 STA JSTX
 LDA #&80
 LDX #4
 ASL INWK+30
 BEQ CB727
 BCS CB721
 LDX #5

.CB721

 STA KL,X
 LDA JSTY

.CB727

 STA JSTY
 LDX JSTX
 LDA #&0E
 LDY KY3
 BEQ CB737
 JSR BUMP2

.CB737

 LDY KY4
 BEQ CB73F
 JSR REDU2

.CB73F

 STX JSTX
 LDA #&0E
 LDX JSTY
 LDY KY5
 BEQ CB74F
 JSR REDU2

.CB74F

 LDY KY6
 BEQ CB757
 JSR BUMP2

.CB757

 STX JSTY
 LDA auto
 BNE CB777
 LDX #&80
 LDA KY3
 ORA KY4
 BNE CB76C
 STX JSTX

.CB76C

 LDA KY5
 ORA KY6
 BNE CB777
 STX JSTY

.CB777

 JMP CB6B0

\ ******************************************************************************
\
\       Name: subm_B77A
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B77A

 PHA
 STY L0393
 LDA #&C0
 STA DTW4
 LDA #0
 STA DTW5
 PLA
 JSR ex_b2
 JMP CB7F2

\ ******************************************************************************
\
\       Name: MESS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MESS

 PHA

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #&0A
 STY L0393
 LDA #&C0
 STA DTW4
 LDA #0
 STA DTW5
 PLA
 CMP #&FA
 BNE CB7DF
 LDA #0
 STA QQ17
 LDA #&BD
 JSR TT27_b2
 LDA #&2D
 JSR TT27_b2
 JSR TT162

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR hyp1_cpl
 LDA #3
 CLC
 LDX QQ22+1
 LDY #0
 JSR TT11
 JMP CB7E8

.CB7DF

 PHA
 LDA #0
 STA QQ17
 PLA
 JSR TT27_b2

.CB7E8

 LDA L0394
 BEQ CB7F2
 LDA #&FD
 JSR TT27_b2

.CB7F2

 LDA #&20
 SEC
 SBC DTW5
 BCS CB801
 LDA #&1F
 STA DTW5
 LDA #2

.CB801

 LSR A
 STA messXC

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX DTW5
 STX L0584
 INX

.loop_CB818

 LDA BUF-1,X
 STA L0584,X
 DEX
 BNE loop_CB818
 STX L0394

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

\ ******************************************************************************
\
\       Name: subm_B831
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B831

 LDA #0
 STA DTW4
 STA DTW5

.CB839

 RTS

\ ******************************************************************************
\
\       Name: LASLI2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LASLI2

 LDA L00B5
 LDX QQ11
 BEQ CB845
 JSR CLYNS+8
 LDA #&17

.CB845

 STA YC
 LDX #0
 STX QQ17

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA messXC
 STA XC
 LDA messXC
 STA XC
 LDY #0

.loop_CB862

 LDA L0585,Y
 JSR CHPR_b2
 INY
 CPY L0584
 BNE loop_CB862
 LDA QQ11
 BEQ CB839
 JMP subm_D951

\ ******************************************************************************
\
\       Name: OUCH
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.OUCH

 JSR DORND
 BMI CB8A9
 CPX #&16
 BCS CB8A9
 LDA QQ20,X
 BEQ CB8A9
 LDA L0393
 BNE CB8A9
 LDY #3
 STY L0394
 STA QQ20,X
 CPX #&11
 BCS CB89A
 TXA
 ADC #&D0
 JMP MESS

.CB89A

 BEQ CB8AA
 CPX #&12
 BEQ CB8AE
 TXA
 ADC #&5D

.loop_CB8A3

 JSR MESS
 JMP subm_AC5C_b3

.CB8A9

 RTS

.CB8AA

 LDA #&6C
 BNE loop_CB8A3

.CB8AE

 LDA #&6F
 JMP MESS

\ ******************************************************************************
\
\       Name: QQ23
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.QQ23

 EQUB &13                                     ; B8B3: 13          .
 EQUB &82                                     ; B8B4: 82          .
 EQUB 6                                       ; B8B5: 06          .
 EQUB   1, &14, &81, &0A,   3, &41, &83,   2  ; B8B6: 01 14 81... ...
 EQUB   7, &28, &85, &E2, &1F, &53, &85, &FB  ; B8BE: 07 28 85... .(.
 EQUB &0F, &C4,   8, &36,   3, &EB, &1D,   8  ; B8C6: 0F C4 08... ...
 EQUB &78, &9A, &0E, &38,   3, &75,   6, &28  ; B8CE: 78 9A 0E... x..
 EQUB   7, &4E,   1, &11, &1F, &7C, &0D, &1D  ; B8D6: 07 4E 01... .N.
 EQUB   7, &B0, &89, &DC, &3F, &20, &81, &35  ; B8DE: 07 B0 89... ...
 EQUB   3, &61, &A1, &42,   7, &AB, &A2, &37  ; B8E6: 03 61 A1... .a.
 EQUB &1F, &2D, &C1, &FA, &0F, &35, &0F, &C0  ; B8EE: 1F 2D C1... .-.
 EQUB   7                                     ; B8F6: 07          .

\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PAS1

 LDA #&64
 STA INWK+3
 LDA #0
 STA XX1
 STA INWK+6
 LDA #2
 STA INWK+7
 JSR subm_D96F
 INC MCNT
 JMP MVEIT

\ ******************************************************************************
\
\       Name: subm_B90D
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B90D

 JMP SetKeyLogger_b6

\ ******************************************************************************
\
\       Name: MVEIT
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVEIT

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+31
 AND #&A0
 BNE MVEIT3
 LDA MCNT
 EOR XSAV
 AND #&0F
 BNE MV3
 JSR TIDY_b1

\ ******************************************************************************
\
\       Name: MV3
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MV3

 LDX TYPE
 BPL CB935
 JMP MV40

.CB935

 LDA INWK+32
 BPL MVEIT3
 CPX #1
 BEQ CB945
 LDA MCNT
 EOR XSAV
 AND #7
 BNE MVEIT3

.CB945

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR TACTICS

\ ******************************************************************************
\
\       Name: MVEIT3
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVEIT3

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+27
 ASL A
 ASL A
 STA Q
 LDA INWK+10
 AND #&7F
 JSR FMLTU
 STA R
 LDA INWK+10
 LDX #0
 JSR MVT1m2
 LDA INWK+12
 AND #&7F
 JSR FMLTU
 STA R
 LDA INWK+12
 LDX #3
 JSR MVT1m2
 LDA INWK+14
 AND #&7F
 JSR FMLTU
 STA R

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+14
 LDX #6
 JSR MVT1m2

\ ******************************************************************************
\
\       Name: MVEIT4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVEIT4

 LDA INWK+27
 CLC
 ADC INWK+28
 BPL CB9AE
 LDA #0

.CB9AE

 STA INWK+27
 LDY #&0F
 JSR GetShipBlueprint   \ Set A to the Y-th byte from the current ship blueprint
 CMP INWK+27
 BCS CB9BB
 STA INWK+27

.CB9BB

 LDA #0
 STA INWK+28

\ ******************************************************************************
\
\       Name: MVEIT5
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVEIT5

 LDX ALP1
 LDA XX1
 EOR #&FF
 STA P
 LDA INWK+1
 JSR MLTU2-2
 STA P+2
 LDA ALP2+1
 EOR INWK+2
 LDX #3
 JSR MVT6
 STA K2+3

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA P+1
 STA K2+1
 EOR #&FF
 STA P
 LDA P+2
 STA K2+2
 LDX BET1
 JSR MLTU2-2
 STA P+2
 LDA K2+3
 EOR BET2
 LDX #6
 JSR MVT6
 STA INWK+8

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA P+1
 STA INWK+6
 EOR #&FF
 STA P
 LDA P+2
 STA INWK+7
 JSR MLTU2
 STA P+2
 LDA K2+3
 STA INWK+5
 EOR BET2
 EOR INWK+8
 BPL CBA42
 LDA P+1
 ADC K2+1
 STA INWK+3
 LDA P+2
 ADC K2+2
 STA INWK+4
 JMP CBA71

.CBA42

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K2+1
 SBC P+1
 STA INWK+3
 LDA K2+2
 SBC P+2
 STA INWK+4
 BCS CBA71
 LDA #1
 SBC INWK+3
 STA INWK+3
 LDA #0
 SBC INWK+4
 STA INWK+4
 LDA INWK+5
 EOR #&80
 STA INWK+5

.CBA71

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX ALP1
 LDA INWK+3
 EOR #&FF
 STA P
 LDA INWK+4
 JSR MLTU2-2
 STA P+2
 LDA ALP2
 EOR INWK+5
 LDX #0
 JSR MVT6
 STA INWK+2
 LDA P+2
 STA INWK+1
 LDA P+1
 STA XX1

\ ******************************************************************************
\
\       Name: MV45
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MV45

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA DELTA
 STA R
 LDA #&80
 LDX #6
 JSR MVT1
 LDA TYPE
 AND #&81
 CMP #&81
 BNE CBAC1
 RTS

.CBAC1

 LDY #9
 JSR MVS4
 LDY #&0F
 JSR MVS4
 LDY #&15
 JSR MVS4
 LDA INWK+30
 AND #&80
 STA RAT2
 LDA INWK+30
 AND #&7F
 BEQ CBAF9
 CMP #&7F
 SBC #0
 ORA RAT2
 STA INWK+30
 LDX #&0F
 LDY #9
 JSR MVS5
 LDX #&11
 LDY #&0B
 JSR MVS5
 LDX #&13
 LDY #&0D
 JSR MVS5

.CBAF9

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+29
 AND #&80
 STA RAT2
 LDA INWK+29
 AND #&7F
 BEQ MV5
 CMP #&7F
 SBC #0
 ORA RAT2
 STA INWK+29
 LDX #&0F
 LDY #&15
 JSR MVS5
 LDX #&11
 LDY #&17
 JSR MVS5
 LDX #&13
 LDY #&19
 JSR MVS5

\ ******************************************************************************
\
\       Name: MV5
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MV5

 LDA INWK+31
 ORA #&10
 STA INWK+31
 JMP SCAN_b1

\ ******************************************************************************
\
\       Name: MVT1m2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVT1m2

 AND #&80

\ ******************************************************************************
\
\       Name: MVT1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVT1

 ASL A
 STA S
 LDA #0
 ROR A
 STA T
 LSR S
 EOR INWK+2,X
 BMI CBB5D
 LDA R
 ADC XX1,X
 STA XX1,X
 LDA S
 ADC INWK+1,X
 STA INWK+1,X
 LDA INWK+2,X
 ADC #0
 ORA T
 STA INWK+2,X
 RTS

.CBB5D

 LDA XX1,X
 SEC
 SBC R
 STA XX1,X
 LDA INWK+1,X
 SBC S
 STA INWK+1,X
 LDA INWK+2,X
 AND #&7F
 SBC #0
 ORA #&80
 EOR T
 STA INWK+2,X
 BCS CBB8E
 LDA #1
 SBC XX1,X
 STA XX1,X
 LDA #0
 SBC INWK+1,X
 STA INWK+1,X
 LDA #0
 SBC INWK+2,X
 AND #&7F
 ORA T
 STA INWK+2,X

.CBB8E

 RTS

\ ******************************************************************************
\
\       Name: MVS4
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVS4

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA ALPHA
 STA Q
 LDX INWK+2,Y
 STX R
 LDX INWK+3,Y
 STX S
 LDX XX1,Y
 STX P
 LDA INWK+1,Y
 EOR #&80
 JSR MAD
 STA INWK+3,Y
 STX INWK+2,Y
 STX P
 LDX XX1,Y
 STX R
 LDX INWK+1,Y
 STX S
 LDA INWK+3,Y
 JSR MAD
 STA INWK+1,Y
 STX XX1,Y
 STX P

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA BETA
 STA Q
 LDX INWK+2,Y
 STX R
 LDX INWK+3,Y
 STX S
 LDX INWK+4,Y
 STX P
 LDA INWK+5,Y
 EOR #&80
 JSR MAD
 STA INWK+3,Y
 STX INWK+2,Y
 STX P
 LDX INWK+4,Y
 STX R
 LDX INWK+5,Y
 STX S
 LDA INWK+3,Y
 JSR MAD
 STA INWK+5,Y
 STX INWK+4,Y

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS

\ ******************************************************************************
\
\       Name: MVT6
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MVT6

 TAY
 EOR INWK+2,X
 BMI CBC31
 LDA P+1
 CLC
 ADC XX1,X
 STA P+1
 LDA P+2
 ADC INWK+1,X
 STA P+2
 TYA
 RTS

.CBC31

 LDA XX1,X
 SEC
 SBC P+1
 STA P+1
 LDA INWK+1,X
 SBC P+2
 STA P+2
 BCC CBC44
 TYA
 EOR #&80
 RTS

.CBC44

 LDA #1
 SBC P+1
 STA P+1
 LDA #0
 SBC P+2
 STA P+2
 TYA
 RTS

\ ******************************************************************************
\
\       Name: MV40
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MV40

 LDA ALPHA
 EOR #&80
 STA Q
 LDA XX1
 STA P
 LDA INWK+1
 STA P+1
 LDA INWK+2
 JSR MULT3
 LDX #3
 JSR MVT3
 LDA K+1
 STA K2+1
 STA P
 LDA K+2
 STA K2+2
 STA P+1
 LDA BETA
 STA Q
 LDA K+3
 STA K2+3
 JSR MULT3
 LDX #6
 JSR MVT3
 LDA K+1
 STA P
 STA INWK+6
 LDA K+2
 STA P+1
 STA INWK+7
 LDA K+3
 STA INWK+8
 EOR #&80
 JSR MULT3
 LDA K+3
 AND #&80
 STA T
 EOR K2+3
 BMI CBCC5
 LDA K
 CLC
 ADC K2
 LDA K+1
 ADC K2+1
 STA INWK+3
 LDA K+2
 ADC K2+2
 STA INWK+4
 LDA K+3
 ADC K2+3
 JMP CBCFC

.CBCC5

 LDA K
 SEC
 SBC K2
 LDA K+1
 SBC K2+1
 STA INWK+3
 LDA K+2
 SBC K2+2
 STA INWK+4
 LDA K2+3
 AND #&7F
 STA P
 LDA K+3
 AND #&7F
 SBC P
 STA P
 BCS CBCFC
 LDA #1
 SBC INWK+3
 STA INWK+3
 LDA #0
 SBC INWK+4
 STA INWK+4
 LDA #0
 SBC P
 ORA #&80

.CBCFC

 EOR T
 STA INWK+5
 LDA ALPHA
 STA Q
 LDA INWK+3
 STA P
 LDA INWK+4
 STA P+1
 LDA INWK+5
 JSR MULT3
 LDX #0
 JSR MVT3
 LDA K+1
 STA XX1
 LDA K+2
 STA INWK+1
 LDA K+3
 STA INWK+2
 JMP MV45

\ ******************************************************************************
\
\       Name: PLUT
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PLUT

 LDX VIEW
 BEQ CBD5D
 DEX
 BNE CBD5E
 LDA INWK+2
 EOR #&80
 STA INWK+2
 LDA INWK+8
 EOR #&80
 STA INWK+8
 LDA INWK+10
 EOR #&80
 STA INWK+10
 LDA INWK+14
 EOR #&80
 STA INWK+14
 LDA INWK+16
 EOR #&80
 STA INWK+16
 LDA INWK+20
 EOR #&80
 STA INWK+20
 LDA INWK+22
 EOR #&80
 STA INWK+22
 LDA INWK+26
 EOR #&80
 STA INWK+26

.CBD5D

 RTS

.CBD5E

 LDA #0
 CPX #2
 ROR A
 STA RAT2
 EOR #&80
 STA RAT
 LDA XX1
 LDX INWK+6
 STA INWK+6
 STX XX1
 LDA INWK+1
 LDX INWK+7
 STA INWK+7
 STX INWK+1
 LDA INWK+2
 EOR RAT
 TAX
 LDA INWK+8
 EOR RAT2
 STA INWK+2
 STX INWK+8
 LDY #9
 JSR CBD92
 LDY #&0F
 JSR CBD92
 LDY #&15

.CBD92

 LDA XX1,Y
 LDX INWK+4,Y
 STA INWK+4,Y
 STX XX1,Y
 LDA INWK+1,Y
 EOR RAT
 TAX
 LDA INWK+5,Y
 EOR RAT2
 STA INWK+1,Y
 STX INWK+5,Y

.LO2

 RTS

.LQ

 JSR subm_BDED
 JMP NWSTARS

\ ******************************************************************************
\
\       Name: LOOK1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LOOK1

 LDA #0
 LDY QQ11
 BNE LQ
 CPX VIEW
 BEQ LO2
 JSR ResetStardust
 JSR FLIP
 JMP WSCAN

\ ******************************************************************************
\
\       Name: FLIP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.FLIP

 LDY NOSTM

.CBDCA

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX SY,Y
 LDA SX,Y
 STA SY,Y
 TXA
 STA SX,Y
 LDA SZ,Y
 STA ZZ
 DEY
 BNE CBDCA
 RTS

\ ******************************************************************************
\
\       Name: subm_BDED
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_BDED

 LDA #&48
 JSR SetScreenHeight
 STX VIEW
 LDA #0
 JSR TT66
 JSR CopyNameBuffer0To1
 JSR subm_A7B7_b3
 JMP CBE17

\ ******************************************************************************
\
\       Name: ResetStardust
\       Type: Subroutine
\   Category: ???
\    Summary: Draws sprites for stardust
\
\ ------------------------------------------------------------------------------
\
\ writes to the 20 sprites from 38 onwards, tile = 210, y = &F0
\ attr is based on sprite number
\
\ ******************************************************************************

.ResetStardust

 STX VIEW
 LDA #0
 JSR TT66
 JSR CopyNameBuffer0To1
 LDA #&50
 STA phaseL00CD
 STA phaseL00CD+1
 JSR subm_A9D1_b3

.CBE17

 LDX #&14
 LDY #&98

.CBE1B

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #&F0
 STA ySprite0,Y
 LDA #&D2
 STA tileSprite0,Y
 TXA
 LSR A
 ROR A
 ROR A
 AND #&E1
 STA attrSprite0,Y
 INY
 INY
 INY
 INY
 DEX
 BNE CBE1B
 JSR WSCAN
 JSR subm_BA23_b3

\ ******************************************************************************
\
\       Name: subm_BE48
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_BE48

 LDA #&FF
 STA L045F
 LDA #&2C
 STA visibleColour
 LDA tileNumber
 STA L00D2
 LDA #&50
 STA L00D8
 LDX #8
 STX L00CC
 LDA #&74
 STA phaseL00CD
 RTS

\ ******************************************************************************
\
\       Name: ECMOF
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ECMOF

 LDA #0
 STA ECMA
 STA ECMP
 LDY #2
 JMP ECBLB

\ ******************************************************************************
\
\       Name: SFRMIS
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SFRMIS

 LDX #1
 JSR SFS1-2
 BCC CBE7F
 LDA #&78
 JSR MESS
 LDY #9
 JMP NOISE

.CBE7F

 RTS

\ ******************************************************************************
\
\       Name: EXNO2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.EXNO2

 JSR IncreaseTally
 BCC CBE8D
 INC TALLY+1
 LDA #&65
 JSR MESS

.CBE8D

 LDA INWK+7
 LDX #0
 CMP #&10
 BCS CBEA5
 INX
 CMP #8
 BCS CBEA5
 INX
 CMP #6
 BCS CBEA5
 INX
 CMP #3
 BCS CBEA5
 INX

.CBEA5

 LDY LBEAB,X
 JMP NOISE

\ ******************************************************************************
\
\       Name: LBEAB
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LBEAB

 EQUB &1B, &17, &0E, &0D, &0D                 ; BEAB: 1B 17 0E... ...

\ ******************************************************************************
\
\       Name: EXNO
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.EXNO

 LDY #&0A
 JMP NOISE

\ ******************************************************************************
\
\       Name: TT66
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.TT66

 STA QQ11
 LDA QQ11a
 ORA QQ11
 BMI CBEC4
 LDA QQ11
 BPL CBEC4
 JSR HideScannerSprites

.CBEC4

 JSR subm_D8C5
 JSR ClearTiles_b3
 LDA #&10
 STA L00B5
 LDX #0
 STX L046D
 JSR SetDrawingPhase
 LDA #&80
 STA QQ17
 STA DTW2
 STA DTW1
 LDA #0
 STA DTW6
 STA LAS2
 STA L0393
 STA L0394
 LDA #1
 STA XC
 STA YC
 JSR subm_AFCD_b3
 LDA QQ11
 LDX #&FF
 AND #&40
 BNE CBF19
 LDX #4
 LDA QQ11
 CMP #1
 BEQ CBF19
 LDX #2
 LDA QQ11
 AND #&0E
 CMP #&0C
 BEQ CBF19
 LDX #1
 LDA QQ12
 BEQ CBF19
 LDX #0

.CBF19

 LDA QQ11
 BMI CBF37
 TXA
 JSR subm_AE18_b3
 LDA QQ11a
 BPL CBF2B
 JSR subm_EB86
 JSR subm_A775_b3

.CBF2B

 JSR subm_A730_b3
 JSR msblob
 JMP CBF91

.loop_CBF34

 JMP subm_B9E2_b3

.CBF37

 TXA
 JSR subm_AE18_b3
 LDA QQ11
 CMP #&C4
 BEQ loop_CBF34
 LDA QQ11
 CMP #&8D
 BEQ CBF54
 CMP #&CF
 BEQ CBF54
 AND #&10
 BEQ CBF54
 LDA #&42
 JSR subm_B0E1_b3

.CBF54

 LDA QQ11
 AND #&20
 BEQ CBF5D
 JSR subm_B18E_b3

.CBF5D

 LDA #1

 STA nameBuffer0+20*32+1
 STA nameBuffer0+21*32+1
 STA nameBuffer0+22*32+1
 STA nameBuffer0+23*32+1
 STA nameBuffer0+24*32+1
 STA nameBuffer0+25*32+1
 STA nameBuffer0+26*32+1

 LDA #2

 STA nameBuffer0+20*32
 STA nameBuffer0+21*32
 STA nameBuffer0+22*32
 STA nameBuffer0+23*32
 STA nameBuffer0+24*32
 STA nameBuffer0+25*32
 STA nameBuffer0+26*32

 LDA QQ11
 AND #&40
 BNE CBF91

.CBF91

 JSR subm_B9E2_b3
 LDA DLY
 BMI CBFA1
 LDA QQ11
 BPL CBFA1
 CMP QQ11a
 BEQ CBFA1

.CBFA1

 JSR DrawBoxTop
 LDX language
 LDA QQ11
 BEQ CBFBF
 CMP #1
 BNE CBFD8
 LDA #0
 STA YC
 LDX language
 LDA LC0DF,X
 STA XC
 LDA #&1E
 BNE CBFD5

.CBFBF

 STA YC
 LDA LC0E3,X
 STA XC
 LDA L04A9
 AND #2
 BNE CBFE2
 JSR subm_BFED
 JSR TT162
 LDA #&AF

.CBFD5

 JSR TT27_b2

.CBFD8

 LDX #1
 STX XC
 STX YC
 DEX
 STX QQ17
 RTS

.CBFE2

 LDA #&AF
 JSR spc
 JSR subm_BFED
 JMP CBFD8

\ ******************************************************************************
\
\       Name: subm_BFED
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_BFED

 LDA VIEW
 ORA #&60
 JMP TT27_b2

INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank0.bin
\
\ ******************************************************************************

 PRINT "S.bank0.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank0.bin", CODE%, P%, LOAD%
