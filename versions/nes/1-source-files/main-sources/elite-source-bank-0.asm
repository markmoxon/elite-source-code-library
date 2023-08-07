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

 DEC DLY
 BMI C835B
 BEQ C8341
 JSR PrintMessage
 JMP C8344

.C8341

 JSR CLYNS

.C8344

 JSR SendMessageToPPU
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
 DEC DLY
 BMI C835B
 BEQ C835B
 JSR PrintMessage
 JMP MA16

.C835B

 LDA #0
 STA DLY

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
\   Category: Drawing the screen
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
\   Category: Utility routines
\    Summary: An unused routine that sets A and X to 15
\
\ ******************************************************************************

.SetAXTo15

 LDA #15                \ Set A = 15

 TAX                    \ Set X = 15

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintCombatRank
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current combat rank
\
\ ------------------------------------------------------------------------------
\
\ This routine is based on part of the STATUS routine from the original source,
\ so I have kept the original st3 and st4 labels.
\
\ ******************************************************************************

.PrintCombatRank

 LDA #16                \ Print recursive token 130 ("RATING:") followed by
 JSR TT68               \ a colon

 LDA L04A9              \ ???
 AND #1
 BEQ P%+5

 JSR TT162              \ Print a newline

 LDA TALLY+1            \ Fetch the high byte of the kill tally, and if it is
 BNE st4                \ not zero, then we have more than 256 kills, so jump
                        \ to st4 to work out whether we are Competent,
                        \ Dangerous, Deadly or Elite

                        \ Otherwise we have fewer than 256 kills, so we are one
                        \ of Harmless, Mostly Harmless, Poor, Average or Above
                        \ Average

 TAX                    \ Set X to 0 (as A is 0)

 LDX TALLY              \ Set X to the low byte of the kill tally

 CPX #0                 \ Increment A if X >= 0
 ADC #0

 CPX #2                 \ Increment A if X >= 2
 ADC #0

 CPX #8                 \ Increment A if X >= 8
 ADC #0

 CPX #24                \ Increment A if X >= 24
 ADC #0

 CPX #44                \ Increment A if X >= 44
 ADC #0

 CPX #130               \ Increment A if X >= 130
 ADC #0

 TAX                    \ Set X to A, which will be as follows:
                        \
                        \   * 1 (Harmless)        when TALLY = 0 or 1
                        \
                        \   * 2 (Mostly Harmless) when TALLY = 2 to 7
                        \
                        \   * 3 (Poor)            when TALLY = 8 to 23
                        \
                        \   * 4 (Average)         when TALLY = 24 to 43
                        \
                        \   * 5 (Above Average)   when TALLY = 44 to 129
                        \
                        \   * 6 (Competent)       when TALLY = 130 to 255
                        \
                        \ Note that the Competent range also covers kill counts
                        \ from 256 to 511, but those are covered by st4 below

.st3

 TXA                    \ Store the combat rank in X on the stack
 PHA

 LDA L04A9              \ ???
 AND #5
 BEQ P%+8

 JSR TT162              \ Print two newlines
 JSR TT162

 PLA                    \ Set A to the combat rank we stored on the stack above

 CLC                    \ Print recursive token 135 + A, which will be in the
 ADC #21                \ range 136 ("HARMLESS") to 144 ("---- E L I T E ----")
 JMP plf                \ followed by a newline, returning from the subroutine
                        \ using a tail call

.st4

                        \ We call this from above with the high byte of the
                        \ kill tally in A, which is non-zero, and want to return
                        \ with the following in X, depending on our rating:
                        \
                        \   Competent = 6
                        \   Dangerous = 7
                        \   Deadly    = 8
                        \   Elite     = 9
                        \
                        \ The high bytes of the top tier ratings are as follows,
                        \ so this a relatively simple calculation:
                        \
                        \   Competent       = 1 to 2
                        \   Dangerous       = 2 to 9
                        \   Deadly          = 10 to 24
                        \   Elite           = 25 and up

 LDX #9                 \ Set X to 9 for an Elite rating

 CMP #25                \ If A >= 25, jump to st3 to print out our rating, as we
 BCS st3                \ are Elite

 DEX                    \ Decrement X to 8 for a Deadly rating

 CMP #10                \ If A >= 10, jump to st3 to print out our rating, as we
 BCS st3                \ are Deadly

 DEX                    \ Decrement X to 7 for a Dangerous rating

 CMP #2                 \ If A >= 2, jump to st3 to print out our rating, as we
 BCS st3                \ are Dangerous

 DEX                    \ Decrement X to 6 for a Competent rating

 BNE st3                \ Jump to st3 to print out our rating, as we are
                        \ Competent (this BNE is effectively a JMP as A will
                        \ never be zero)

\ ******************************************************************************
\
\       Name: PrintLegalStatus
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current legal status (clean, offender or fugitive)
\
\ ******************************************************************************

.PrintLegalStatus

 LDA #125               \ Print recursive token 125 ("LEGAL STATUS:) followed
 JSR spc                \ by a space

 LDA #19                \ Set A to token 133 ("CLEAN")

 LDY FIST               \ Fetch our legal status, and if it is 0, we are clean,
 BEQ st5                \ so jump to st5 to print "Clean"

 CPY #40                \ Set the C flag if Y >= 40, so C is set if we have
                        \ a legal status of 40+ (i.e. we are a fugitive)

 ADC #1                 \ Add 1 + C to A, so if C is not set (i.e. we have a
                        \ legal status between 1 and 49) then A is set to token
                        \ 134 ("OFFENDER"), and if C is set (i.e. we have a
                        \ legal status of 50+) then A is set to token 135
                        \ ("FUGITIVE")

.st5

 JMP plf                \ Print the text token in A (which contains our legal
                        \ status) followed by a newline, returning from the
                        \ subroutine using a tail call

INCLUDE "library/common/main/subroutine/status.asm"

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
 STA firstNametableTile
 LDA #108
 STA maxTileNumber
 STA lastTileNumber
 STA lastTileNumber+1
 LDX #&25
 LDA QQ11
 AND #&40
 BEQ C8944
 LDX #4

.C8944

 STX firstPatternTile

 JSR DrawBoxEdges       \ Draw the left and right edges of the box along the
                        \ sides of the screen, drawing into the nametable buffer
                        \ for the drawing bitplane

 JSR CopyNameBuffer0To1
 LDA QQ11
 CMP QQ11a
 BEQ C8976
 JSR SetupView_b3

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
 STA firstPatternTile
 RTS

.C8976

 JSR subm_F126
 JMP C8955

\ ******************************************************************************
\
\       Name: L897C
\       Type: Variable
\   Category: Text
\    Summary: ???
\
\ ******************************************************************************

.L897C

 EQUB 8, 8, 10, 8

\ ******************************************************************************
\
\       Name: SendScreenToPPU
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.SendScreenToPPU

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA #0
 STA firstNametableTile

 LDA #100
 STA maxTileNumber

 LDA #37
 STA firstPatternTile

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DrawBoxEdges       \ Draw the left and right edges of the box along the
                        \ sides of the screen, drawing into the nametable buffer
                        \ for the drawing bitplane

 JSR CopyNameBuffer0To1

 LDA #%11000100         \ Set both bitplane flags as follows:
 STA bitplaneFlags      \
 STA bitplaneFlags+1    \   * Bit 2 set   = send tiles until the end of buffer
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear

 LDA tileNumber
 STA firstPatternTile

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintTokenCrTab
\       Type: Subroutine
\   Category: Text
\    Summary: Print a token, a newline and the correct indent for Status Mode
\             entries in the chosen language
\
\ ******************************************************************************

.PrintTokenCrTab

 JSR TT27_b2            \ Print the token in A

                        \ Fall through into PrintCrTab to print a newline and
                        \ the correct indent for the chosen language

\ ******************************************************************************
\
\       Name: PrintCrTab
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline and the correct indent for Status Mode entries in
\             the chosen language
\
\ ******************************************************************************

.PrintCrTab

 JSR TT67               \ Print a newline

 LDX chosenLanguage     \ Move the text cursor to the correct column for the
 LDA tabStatusMode,X    \ Status Mode entry in the chosen language
 STA XC

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: tabStatusMode
\       Type: Variable
\   Category: Text
\    Summary: The tab stop for Status Mode entries for each language
\
\ ******************************************************************************

.tabStatusMode

 EQUB 3                 \ English

 EQUB 3                 \ German

 EQUB 1                 \ French

 EQUB 3                 \ There is no fourth language, so this byte is ignored

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

 ADC #170+YPAL

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
 JSR FlipDrawingPlane
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

 JSR SendDrawPlaneToPPU
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
INCLUDE "library/nes/main/subroutine/bris_b0.asm"
INCLUDE "library/common/main/subroutine/ping.asm"

\ ******************************************************************************
\
\       Name: PlayDemo
\       Type: Subroutine
\   Category: Demo
\    Summary: ???
\
\ ******************************************************************************

.PlayDemo

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

 LDA #&FF               \ Set demoInProgress = &FF to indicate that we are
 STA demoInProgress     \ playing the demo

 JSR SOLAR
 LDA #0
 STA DELTA
 STA ALPHA
 STA ALP1
 STA QQ12
 STA VIEW
 JSR TT66

 LSR demoInProgress     \ Clear bit 7 of demoInProgress

 JSR CopyNameBuffer0To1
 JSR subm_F139
 JSR SetupDemoView
 JSR SeedRandomNumbers
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

 JSR SIGHT_b3           \ Draw the laser crosshairs

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

 JSR FlipDrawingPlane
 JSR subm_MA23
 JSR SendDrawPlaneToPPU
 LDA pointerButton
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
\    Summary: Print a character followed by a colon, drawing in both bitplanes
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

 LDA #3                 \ Set the font bitplane to print in both planes 1 and 2
 STA fontBitplane

 LDA #':'               \ Print a colon
 JSR TT27_b2

 LDA #1                 \ Set the font bitplane to plane 1
 STA fontBitplane

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
\   Category: Charts
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

 ADC #10+YPAL

 STA ySprite0,X

 RTS

\ ******************************************************************************
\
\       Name: HideCrosshairs
\       Type: Subroutine
\   Category: Charts
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
\    Summary: The tab stop for the Short-range Chart title for each language
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
\   Category: Charts
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

 ADC #10+YPAL

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
 JSR SendMessageToPPU

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
\    Summary: The row for the Market Prices title for each language
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
 LDA controller1Leftx8
 CMP #&F0
 BEQ CA025
 LDA controller1Rightx8
 CMP #&F0
 BEQ CA0B3

.CA06E

 LDA pointerButton
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
 JSR SendScreenToPPU

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

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
\   Category: Market
\    Summary: ???
\
\ ******************************************************************************

.subm_A130

 TAY
 LDX #2
 STX fontBitplane
 CLC
 LDX chosenLanguage
 ADC rowMarketPrice,X
 STA YC
 TYA
 JSR TT151
 LDX #1
 STX fontBitplane
 RTS

\ ******************************************************************************
\
\       Name: subm_A147
\       Type: Subroutine
\   Category: Market
\    Summary: ???
\
\ ******************************************************************************

.subm_A147

 TAY
 CLC
 LDX chosenLanguage
 ADC rowMarketPrice,X
 STA YC
 TYA
 JMP TT151

\ ******************************************************************************
\
\       Name: subm_A155
\       Type: Subroutine
\   Category: Market
\    Summary: ???
\
\ ******************************************************************************

.subm_A155

 LDA #&80
 STA QQ17
 LDX chosenLanguage
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

\ ******************************************************************************
\
\       Name: StartAfterLoad
\       Type: Subroutine
\   Category: Start and end
\    Summary: Start the game following a commander file load
\
\ ------------------------------------------------------------------------------
\
\ This routine is very similar to the BR1 routine.
\
\ ******************************************************************************

.StartAfterLoad

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)

.stal1

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ2
 STA QQ2,X

 DEX                    \ Decrement the counter

 BPL stal1              \ Loop back to stal1 if we still have more bytes to copy

 INX                    \ Set X = 0 (as we ended the above loop with X = &FF)

 STX EV                 \ Set EV, the extra vessels spawning counter, to 0, as
                        \ we are entering a new system with no extra vessels
                        \ spawned

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawCobraMkIII
\       Type: Subroutine
\   Category: Equipment
\    Summary: Draw the Cobra Mk III on the Equip Ship screen
\
\ ******************************************************************************

.DrawCobraMkIII

 LDA #20                \ Set XC and YC so the call to DrawImageNames draws the
 STA YC                 \ Cobra Mk III at text column 2 on row 20
 LDA #2
 STA XC

 LDA #26                \ Set K = 26 so the call to DrawImageNames draws 26
 STA K                  \ tiles in each row

 LDA #5                 \ Set K+1 = 5 so the call to DrawImageNames draws 5 rows
 STA K+1                \ of tiles

 LDA #HI(cobraNames)    \ Set V(1 0) = cobraNames, so the call to DrawImageNames
 STA V+1                \ draws the Cobra Mk III
 LDA #LO(cobraNames)
 STA V

 LDA #0                 \ Set K+2 = 0, so the call to DrawImageNames copies the
 STA K+2                \ entries directly from cobraNames to the nametable
                        \ buffer without adding an offset

 JSR DrawImageNames_b4  \ Draw the Cobra Mk III at text column 2 on row 20

 JMP DrawEquipment_b6   \ Draw the currently fitted equipment onto the Cobra Mk
                        \ III image, returning from the subroutine using a tail
                        \ call

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
 STX fontBitplane

 LDX XX13
 JSR PrintEquipment+2

 LDX #1
 STX fontBitplane

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

 JSR WaitForIconBarPPU  \ Wait until the PPU starts drawing the icon bar

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

 JSR DrawEquipment_b6   \ Draw the currently fitted equipment onto the Cobra Mk
                        \ III image

 JSR SendScreenToPPU

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

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
\    Summary: The tab stop for the Equip Ship title for each language
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
 LDX chosenLanguage
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
 STA fontBitplane
 JSR subm_A6A8
 LDA #1
 STA fontBitplane
 TYA
 PHA
 JSR SendScreenToPPU

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

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

 LDA controller1Leftx8
 ORA controller1Rightx8
 ORA controller1A
 BMI qv
 LDY #3

.loop_CA706

 JSR subm_A6A8
 DEY
 BNE loop_CA706
 LDA #2
 STA fontBitplane
 JSR subm_A6A8
 LDA #1
 STA fontBitplane
 LDA #&0B
 STA XC
 STA K+2
 LDA #7
 STA YC
 STA K+3
 LDX chosenLanguage
 LDA LA6F2,X
 STA K
 LDA #6
 STA K+1
 JSR subm_B2BC_b3
 JSR SendScreenToPPU
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
 LDA pointerButton
 BEQ CA737
 CMP #&50
 BNE CA775
 LDA #0
 STA pointerButton
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
\       Name: SetCurrentSeeds
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the seeds for the selected system in QQ15 to the seeds in the
\             safehouse
\
\ ******************************************************************************

.SetCurrentSeeds

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ from safehouse into QQ15, where we store the seeds for
                        \ the selected system, so set up a counter in X for
                        \ copying six bytes (for three 16-bit seeds)

.safe1

 LDA safehouse,X        \ Copy the X-th byte in safehouse to the X-th byte in
 STA QQ15,X             \ QQ15

 DEX                    \ Decrement the counter

 BPL safe1              \ Loop back until we have copied all six bytes

INCLUDE "library/common/main/subroutine/cpl.asm"
INCLUDE "library/common/main/subroutine/cmn.asm"
INCLUDE "library/common/main/subroutine/ypl.asm"
INCLUDE "library/common/main/subroutine/tal.asm"
INCLUDE "library/common/main/subroutine/fwl.asm"

\ ******************************************************************************
\
\       Name: Print4Newlines
\       Type: Subroutine
\   Category: Text
\    Summary: Print four newlines
\
\ ******************************************************************************

.Print4Newlines

 JSR Print2Newlines     \ Print two newlines

                        \ Fall through into Print2Newlines to print another two
                        \ newlines

\ ******************************************************************************
\
\       Name: Print2Newlines
\       Type: Subroutine
\   Category: Text
\    Summary: Print two newlines
\
\ ******************************************************************************

.Print2Newlines

 JSR TT162              \ Print two newlines
 JMP TT162

\ ******************************************************************************
\
\       Name: ypls
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current system name
\
\ ******************************************************************************

.ypls

 JMP ypl                \ Jump to ypl to print the current system name and
                        \ return from the subroutine using a tail call

INCLUDE "library/common/main/subroutine/csh.asm"
INCLUDE "library/common/main/subroutine/plf.asm"
INCLUDE "library/common/main/subroutine/tt68.asm"
INCLUDE "library/common/main/subroutine/tt73.asm"

\ ******************************************************************************
\
\       Name: tals
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current galaxy number
\
\ ******************************************************************************

.tals

 JMP tal                \ Jump to tal to print the current galaxy number and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PrintCtrlCode
\       Type: Subroutine
\   Category: Text
\    Summary: Print a control code (in the range 0 to 9)
\
\ ******************************************************************************

.PrintCtrlCode

 TXA                    \ Copy the token number from X to A. We can then keep
                        \ decrementing X and testing it against zero, while
                        \ keeping the original token number intact in A; this
                        \ effectively implements a switch statement on the
                        \ value of the token

 BEQ csh                \ If token = 0, this is control code 0 (current amount
                        \ of cash and newline), so jump to csh to print the
                        \ amount of cash and return from the subroutine using
                        \ a tail call

 DEX                    \ If token = 1, this is control code 1 (current galaxy
 BEQ tals               \ number), so jump to tal via tals to print the galaxy
                        \ number and return from the subroutine using a tail
                        \ call

 DEX                    \ If token = 2, this is control code 2 (current system
 BEQ ypls               \ name), so jump to ypl via ypls to print the current
                        \ system name  and return from the subroutine using a
                        \ tail call

 DEX                    \ If token > 3, skip the following instruction
 BNE P%+5

 JMP cpl                \ This token is control code 3 (selected system name)
                        \ so jump to cpl to print the selected system name
                        \ and return from the subroutine using a tail call

 DEX                    \ If token <> 4, skip the following instruction
 BNE P%+5

 JMP cmn                \ This token is control code 4 (commander name) so jump
                        \ to cmn to print the commander name and return from the
                        \ subroutine using a tail call

 DEX                    \ If token = 5, this is control code 5 (fuel, newline,
 BEQ fwls               \ cash, newline), so jump to fwl via fwls to print the
                        \ fuel level and return from the subroutine using a tail
                        \ call

 DEX                    \ If token > 6, skip the following three instructions
 BNE ptok2

 LDA #%10000000         \ This token is control code 6 (switch to Sentence
 STA QQ17               \ Case), so set bit 7 of QQ17 to switch to Sentence Case

.ptok1

 RTS                    \ Return from the subroutine

.ptok2

 DEX                    \ If token = 7, this is control code 7 (beep), so jump
 BEQ ptok1              \ to ptok1 to return from the subroutine

 DEX                    \ If token > 8, jump to ptok3
 BNE ptok3

 STX QQ17               \ This is control code 8, so set QQ17 = 0 to switch to
                        \ ALL CAPS (we know X is zero as we just passed through
                        \ a BNE)

 RTS                    \ Return from the subroutine

.ptok3

                        \ If we get here then token > 8, so this is control code
                        \ 9 (print a colon then tab to column 22 or 23)

 JSR TT73               \ Print a colon

 LDA L04A9              \ If bit 1 of L04A9 is set, jump to ptok4 to move the
 AND #%00000010         \ text cursor to column 23
 BNE ptok4

 LDA #22                \ Bit 1 of L04A9 is clear, so move the text cursor to
 STA XC                 \ column 22

 RTS                    \ Return from the subroutine

.ptok4

 LDA #23                \ Move the text cursor to column 23
 STA XC

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: fwls
\       Type: Subroutine
\   Category: Text
\    Summary: Print fuel and cash levels
\
\ ******************************************************************************

.fwls

 JMP fwl                \ Jump to fwl to print the fuel and cash levels, and
                        \ return from the subroutine using a tail call

INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sp1.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/common/main/subroutine/sps4.asm"
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"

\ ******************************************************************************
\
\       Name: CopyShipDataToINWK
\       Type: Subroutine
\   Category: Universe
\    Summary: Copy the ship's data block from INF to INWK
\
\ ******************************************************************************

.CopyShipDataToINWK

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #NI%-1             \ There are NI% bytes in each ship data block (and in
                        \ the INWK workspace, so we set a counter in Y so we can
                        \ loop through them

.cink1

 LDA (INF),Y            \ Load the Y-th byte of INF and store it in the Y-th
 STA INWK,Y             \ byte of INWK

 DEY                    \ Decrement the loop counter

 BPL cink1              \ Loop back for the next byte until we have copied the
                        \ last byte from INF to INWK

INCLUDE "library/common/main/subroutine/killshp.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"

\ ******************************************************************************
\
\       Name: YESNO
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Display "YES" or "NO" and wait until one is chosen
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The result:
\
\                         * 1 if "YES" was chosen
\
\                         * 2 if "NO" was chosen
\
\ ******************************************************************************

.YESNO

 LDA fontBitplane       \ Store the current font bitplane value on the stack,
 PHA                    \ so we can restore it when we return from the
                        \ subroutine

 LDA #2                 \ Set the font bitplane to %10 ???
 STA fontBitplane

 LDA #1                 \ Push a value of 1 onto the stack, so the following
 PHA                    \ prints extended token 1 ("YES")

.yeno1

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #15                \ Move the text cursor to column 15
 STA XC

 PLA                    \ Print the extended token whose number is on the stack,
 PHA                    \ so this will be "YES" (token 1) or "NO" (token 2)
 JSR DETOK_b2

 JSR SendMessageToPPU   \ ???

 LDA controller1A       \ If "A" is being pressed on the controller, jump to
 BMI yeno3              \ to record the choice

 LDA controller1Up      \ If neither the up nor down arrow is being pressed on
 ORA controller1Down    \ the controller, jump to yeno2 to pause and loop back
 BPL yeno2              \ to keep waiting for a choice to be made

                        \ If we get here then either the up or down arrow is
                        \ being pressed, so we toggle the on-screen choice
                        \ between "YES" and "NO"

 PLA                    \ Flip the value on the top of the stack between 1 and 2
 EOR #3                 \ by EOR'ing with 3, which toggles the token between
 PHA                    \ "YES" and "NO"

.yeno2

 LDY #8                 \ Wait for 8 vertical syncs (8/50 = 0.16 seconds)
 JSR DELAY

 JMP yeno1              \ Loop back to print "YES" or NO" and wait for a choice

.yeno3

 LDA #0                 \ ???
 STA L0081

 STA controller1A       \ Reset the key logger for the controller "A" button as
                        \ we have consumed the key press

 PLA                    \ Set X to the value from the top of the stack, which
 TAX                    \ will be 1 for "YES" or 2 for "NO", giving us our
                        \ result to return

 PLA                    \ Restore the font bitplane value that we stored on the
 STA fontBitplane       \ stack so it's unchanged by the routine

 TXA                    \ Copy X to A, so we return the result in both A and X

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ReadDirectionalPad
\       Type: Subroutine
\   Category: Keyboard
\    Summary: ???
\
\ ******************************************************************************

.ReadDirectionalPad

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
 LDA controller1Leftx8
 BPL CAD40
 DEX

.CAD40

 LDA controller1Rightx8
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

INCLUDE "library/enhanced/main/subroutine/there.asm"
INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"

\ ******************************************************************************
\
\       Name: SetScreenHeight
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the screen height variables to the specified height
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The y-coordinate of the centre of the screen (i.e. half
\                       the screen height)
\
\ ******************************************************************************

.SetScreenHeight

 STA Yx1M2              \ Store the half-screen height in Yx1M2

 ASL A                  \ Double the half-screen height in A to get the full
                        \ screen height, while setting the C flag to bit 7 of
                        \ the original argument
                        \
                        \ This routine is only ever called with A set to either
                        \ 72 or 77, so the C flag is never set

 STA Yx2M2              \ Store the full screen height in Yx2M2

 SBC #0                 \ Set the value of Yx2M1 as follows:
 STA Yx2M1              \
                        \   * If the C flag is set: Yx2M1 = Yx2M2
                        \
                        \   * If the C flag is clear: Yx2M1 = Yx2M2 - 1
                        \
                        \ This routine is only ever called with A set to either
                        \ 72 or 77, so the C flag is never set, so we always set
                        \ Yx2M1 = Yx2M2 - 1

 RTS                    \ Return from the subroutine

INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_1_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_3_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_4_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"

\ ******************************************************************************
\
\       Name: LB079
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.LB079

 EQUB 5, 5, 5, 6                              ; B079: 05 05 05... ...

INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/common/main/subroutine/bad.asm"
INCLUDE "library/common/main/subroutine/farof.asm"
INCLUDE "library/common/main/subroutine/mas4.asm"

\ ******************************************************************************
\
\       Name: subm_B1D1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_B1D1

 LDA pointerButton

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
 STA pointerButton
 JSR subm_A166_b6
 SEC
 RTS

.CB1E2

 CLC
 RTS

INCLUDE "library/common/main/subroutine/death.asm"

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
 JSR JAMESON_b6
 JSR ResetOptions
 LDA #1
 STA fontBitplane
 LDX #&FF
 STX QQ11a

 TXS                    \ Set the stack pointer to &01FF, which is the standard
                        \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR RESET
 JSR ChooseLanguage_b6

INCLUDE "library/common/main/subroutine/death2.asm"

\ ******************************************************************************
\
\       Name: subm_B358
\       Type: Subroutine
\   Category: Start and end
\    Summary: ???
\
\ ******************************************************************************

.subm_B358

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR BR1                \ Reset a number of variables, ready to start a new game

                        \ Fall through into the BAY routine to go to the docking
                        \ bay (i.e. show the Status Mode screen)

INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"

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
 STA firstPatternTile
 LDA #80
 STA maxTileNumber
 LDX #8
 STX firstNametableTile
 RTS

INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/common/main/subroutine/u_per_cent-zektran.asm"
INCLUDE "library/common/main/subroutine/mas1.asm"
INCLUDE "library/common/main/subroutine/mas2.asm"
INCLUDE "library/common/main/subroutine/mas3.asm"

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

INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"

\ ******************************************************************************
\
\       Name: WARP
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.WARP

 LDA demoInProgress     \ Fast-forward in demo starts game
 BEQ CB5BF
 JSR ResetShipStatus
 JMP subm_B358

.CB5BF

 LDA auto               \ Fast-forward on docking computer insta-docks
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

 JSR CopyShipDataToINWK \ Copy the ship's data block from INF to INWK

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

INCLUDE "library/common/main/subroutine/dokey.asm"

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
 STY DLY
 LDA #&C0
 STA DTW4
 LDA #0
 STA DTW5
 PLA
 JSR ex_b2
 JMP CB7F2

INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"

\ ******************************************************************************
\
\       Name: DisableJustifyText
\       Type: Subroutine
\   Category: Text
\    Summary: Turn off justified text
\
\ ******************************************************************************

.DisableJustifyText

 LDA #0                 \ Set DTW4 = %00000000  (do not justify text, print
 STA DTW4               \ buffer on carriage return)

 STA DTW5               \ Set DTW5 = 0 (reset line buffer size)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintMessage
\       Type: Subroutine
\   Category: Text
\    Summary: Print an in-flight message
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PrintMessage-1      Contains an RTS
\
\ ******************************************************************************

.PrintMessage

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

 LDA messageBuffer,Y
 JSR CHPR_b2
 INY
 CPY L0584
 BNE loop_CB862
 LDA QQ11
 BEQ PrintMessage-1
 JMP SendMessageToPPU

INCLUDE "library/common/main/subroutine/ouch.asm"
INCLUDE "library/common/main/subroutine/ou2.asm"
INCLUDE "library/common/main/subroutine/ou3.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/enhanced/main/subroutine/pas1.asm"
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
INCLUDE "library/common/main/subroutine/flip.asm"

\ ******************************************************************************
\
\       Name: SetNewSpaceView
\       Type: Subroutine
\   Category: Flight
\    Summary: ???
\
\ ******************************************************************************

.SetNewSpaceView

 LDA #&48
 JSR SetScreenHeight
 STX VIEW
 LDA #0
 JSR TT66
 JSR CopyNameBuffer0To1
 JSR SetupView_b3
 JMP ResetStardust

\ ******************************************************************************
\
\       Name: ChangeSpaceView
\       Type: Subroutine
\   Category: Flight
\    Summary: ???
\
\ ******************************************************************************

.ChangeSpaceView

 STX VIEW
 LDA #0
 JSR TT66
 JSR CopyNameBuffer0To1
 LDA #80
 STA lastTileNumber
 STA lastTileNumber+1
 JSR SetupSpaceView_b3

\ ******************************************************************************
\
\       Name: ResetStardust
\       Type: Subroutine
\   Category: Stardust
\    Summary: Hide the sprites for the stardust
\
\ ******************************************************************************

.ResetStardust

 LDX #NOST              \ Set X to the maximum number of stardust particles, so
                        \ we hide them all

 LDY #152               \ Set Y so we start hiding from sprite 152 / 4 = 38

.rest1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

 STA ySprite0,Y         \ Set the y-coordinate for sprite Y / 4 to 240 to hide
                        \ it (the division by four is because each sprite in the
                        \ sprite buffer has four bytes of data)

 LDA #210               \ Set the sprite to use pattern number 210 ???
 STA tileSprite0,Y

 TXA                    \ ???
 LSR A
 ROR A
 ROR A
 AND #%11100001
 STA attrSprite0,Y

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BNE rest1              \ Loop back until we have hidden X sprites

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync

 JSR SIGHT_b3           \ Draw the laser crosshairs

\ ******************************************************************************
\
\       Name: SetupDemoView
\       Type: Subroutine
\   Category: Demo
\    Summary: ???
\
\ ******************************************************************************

.SetupDemoView

 LDA #&FF
 STA L045F

 LDA #&2C
 STA visibleColour

 LDA tileNumber
 STA firstPatternTile

 LDA #80
 STA maxTileNumber

 LDX #8
 STX firstNametableTile

 LDA #116
 STA lastTileNumber

 RTS

INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"

\ ******************************************************************************
\
\       Name: LBEAB
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.LBEAB

 EQUB &1B, &17, &0E, &0D, &0D                 ; BEAB: 1B 17 0E... ...

INCLUDE "library/common/main/subroutine/exno.asm"

\ ******************************************************************************
\
\       Name: TT66
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen and set the current view type
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the new current view (see QQ11 for a list of
\                       view types)
\
\ ******************************************************************************

.TT66

 STA QQ11               \ Set the current view type in QQ11 to A

 LDA QQ11a              \ ???
 ORA QQ11
 BMI CBEC4
 LDA QQ11
 BPL CBEC4

 JSR ClearScanner       \ Remove all ships from the scanner and hide the scanner
                        \ sprites

.CBEC4

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JSR ClearScreen_b3     \ ???

 LDA #&10
 STA L00B5
 LDX #0
 STX L046D
 JSR SetDrawingBitplane

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

 STA DTW2               \ Set bit 7 of DTW2 to indicate we are not currently
                        \ printing a word

 STA DTW1               \ ???

 LDA #0
 STA DTW6

 STA LAS2               \ Set LAS2 = 0 to stop any laser pulsing

 STA DLY                \ Set the delay in DLY to 0, to indicate that we are
                        \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STA de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't


 LDA #1                 \ ???
 STA XC
 STA YC
 JSR SetViewPatterns_b3
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
 JSR SetupIconBar_b3
 LDA QQ11a
 BPL CBF2B
 JSR subm_EB86
 JSR ResetScanner_b3

.CBF2B

 JSR DrawDashNames_b3
 JSR msblob
 JMP CBF91

.loop_CBF34

 JMP SetViewAttrs_b3

.CBF37

 TXA
 JSR SetupIconBar_b3
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

 JSR SetViewAttrs_b3

 LDA demoInProgress     \ If bit 7 of demoInProgress is set then we are
 BMI CBFA1              \ initialising the demo

 LDA QQ11
 BPL CBFA1
 CMP QQ11a
 BEQ CBFA1

.CBFA1

 JSR DrawBoxTop
 LDX chosenLanguage
 LDA QQ11
 BEQ CBFBF
 CMP #1
 BNE CBFD8
 LDA #0
 STA YC
 LDX chosenLanguage
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
 JSR PrintSpaceViewName
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
 JSR PrintSpaceViewName
 JMP CBFD8

\ ******************************************************************************
\
\       Name: PrintSpaceViewName
\       Type: Subroutine
\   Category: Text
\    Summary: Print the name of the current space view
\
\ ******************************************************************************

.PrintSpaceViewName

 LDA VIEW               \ Load the current view into A:
                        \
                        \   0 = front
                        \   1 = rear
                        \   2 = left
                        \   3 = right

 ORA #&60               \ OR with &60 so we get a value of &60 to &63 (96 to 99)

 JMP TT27_b2            \ Print recursive token 96 to 99, which will be in the
                        \ range "FRONT" to "RIGHT", returning from the
                        \ subroutine using a tail call

INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank0.bin
\
\ ******************************************************************************

 PRINT "S.bank0.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank0.bin", CODE%, P%, LOAD%
