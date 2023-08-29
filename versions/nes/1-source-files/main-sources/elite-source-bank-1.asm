\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 1)
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
\   * bank1.bin
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

 _BANK = 1

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 1
\
\ Produces the binary file bank1.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/nes/main/variable/unused_copy_of_xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/kwl_per_cent.asm"
INCLUDE "library/master/data/variable/kwh_per_cent.asm"
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

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/common/main/subroutine/shppt.asm"
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
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/planet.asm"
INCLUDE "library/common/main/subroutine/pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine/pls1.asm"
INCLUDE "library/common/main/subroutine/pls2.asm"
INCLUDE "library/common/main/subroutine/pls22.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"

\ ******************************************************************************
\
\       Name: SUN (Part 2 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Start from bottom of screen and erase the old sun
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases the old sun, starting at the bottom of the screen and working
\ upwards until we reach the bottom of the new sun.
\
\ ******************************************************************************

 LDA XX2                \ ???
 STA YY
 LDA XX2+1
 STA YY+1
 LDY TGT
 LDA #0
 STA L05EB
 STA L05EC
 STA L05ED
 STA L05EE
 STA L05EF
 STA L05F0
 STA L05F1
 TYA
 TAX
 AND #&F8
 TAY
 LDA V+1
 BNE CAD1D
 TXA
 AND #7
 BEQ CAD04
 CMP #2
 BCC CACFA
 BEQ CACF0
 CMP #4
 BCC CACE6
 BEQ CACDC
 CMP #6
 BCC CACD2
 BEQ CACC8

.CACBE

 JSR CAF35
 STA L05F1
 DEC V
 BEQ CAD2C

.CACC8

 JSR CAF35
 STA L05F0
 DEC V
 BEQ CAD3B

.CACD2

 JSR CAF35
 STA L05EF
 DEC V
 BEQ CAD4A

.CACDC

 JSR CAF35
 STA L05EE
 DEC V
 BEQ CAD59

.CACE6

 JSR CAF35
 STA L05ED
 DEC V
 BEQ CAD68

.CACF0

 JSR CAF35
 STA L05EC
 DEC V
 BEQ CAD77

.CACFA

 JSR CAF35
 STA L05EB
 DEC V
 BEQ CAD1B

.CAD04

 JSR CAF35
 STA L05EA
 DEC V
 BEQ CAD19
 JSR CADC6
 TYA
 SEC
 SBC #8
 TAY
 BCS CACBE
 RTS

.CAD19

 BEQ CAD95

.CAD1B

 BEQ CAD86

.CAD1D

 JSR CAF35
 STA L05F1
 LDX V
 INX
 STX V
 CPX K
 BCS CADA3

.CAD2C

 JSR CAF35
 STA L05F0
 LDX V
 INX
 STX V
 CPX K
 BCS CADA8

.CAD3B

 JSR CAF35
 STA L05EF
 LDX V
 INX
 STX V
 CPX K
 BCS CADAD

.CAD4A

 JSR CAF35
 STA L05EE
 LDX V
 INX
 STX V
 CPX K
 BCS CADB2

.CAD59

 JSR CAF35
 STA L05ED
 LDX V
 INX
 STX V
 CPX K
 BCS CADB7

.CAD68

 JSR CAF35
 STA L05EC
 LDX V
 INX
 STX V
 CPX K
 BCS CADBC

.CAD77

 JSR CAF35
 STA L05EB
 LDX V
 INX
 STX V
 CPX K
 BCS CADC1

.CAD86

 JSR CAF35
 STA L05EA
 LDX V
 INX
 STX V
 CPX K
 BCS CADC6

.CAD95

 JSR CADC6
 TYA
 SEC
 SBC #8
 TAY
 BCC CADA2
 JMP CAD1D

.CADA2

 RTS

.CADA3

 LDA #0
 STA L05F0

.CADA8

 LDA #0
 STA L05EF

.CADAD

 LDA #0
 STA L05EE

.CADB2

 LDA #0
 STA L05ED

.CADB7

 LDA #0
 STA L05EC

.CADBC

 LDA #0
 STA L05EB

.CADC1

 LDA #0
 STA L05EA

.CADC6

 LDA L05EA
 CMP L05EB
 BCC CADD1
 LDA L05EB

.CADD1

 CMP L05EC
 BCC CADD9
 LDA L05EC

.CADD9

 CMP L05ED
 BCC CADE1
 LDA L05EC

.CADE1

 CMP L05EE
 BCC CADE9
 LDA L05EE

.CADE9

 CMP L05EF
 BCC CADF1
 LDA L05EF

.CADF1

 CMP L05F0
 BCC CADF9
 LDA L05F0

.CADF9

 CMP L05F1
 BCC CAE03
 LDA L05F1
 BEQ CAE29

.CAE03

 JSR EDGES
 BCS CAE29
 LDA X2
 AND #&F8
 STA P+1
 LDA XX15
 ADC #7
 BCS CAE29
 AND #&F8
 CMP P+1
 BCS CAE29
 STA P
 CMP #&F8
 BCS CAE26
 JSR CAEE8

 JSR DrawSunRowOfBlocks \ Draw the character blocks containing the horizontal
                        \ line (P, Y) to (P+1, Y) with sunlight, silhouetting
                        \ any existing content against the sun

.CAE26

 JMP CAE9B

.CAE29

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR EDGES-2
 BCS CAE46
 JSR HLOIN

.CAE46

 DEY
 LDA L05F0
 JSR EDGES-2
 BCS CAE52
 JSR HLOIN

.CAE52

 DEY
 LDA L05EF
 JSR EDGES-2
 BCS CAE5E
 JSR HLOIN

.CAE5E

 DEY
 LDA L05EE
 JSR EDGES-2
 BCS CAE6A
 JSR HLOIN

.CAE6A

 DEY
 LDA L05ED
 JSR EDGES-2
 BCS CAE76
 JSR HLOIN

.CAE76

 DEY
 LDA L05EC
 JSR EDGES-2
 BCS CAE82
 JSR HLOIN

.CAE82

 DEY
 LDA L05EB
 JSR EDGES-2
 BCS CAE8E
 JSR HLOIN

.CAE8E

 DEY
 LDA L05EA
 JSR EDGES-2
 BCS CAE9A
 JMP HLOIN

.CAE9A

 RTS

.CAE9B

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P
 BEQ CAE9A
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR DrawSunEdgeLeft
 DEY
 LDA L05F0
 JSR DrawSunEdgeLeft
 DEY
 LDA L05EF
 JSR DrawSunEdgeLeft
 DEY
 LDA L05EE
 JSR DrawSunEdgeLeft
 DEY
 LDA L05ED
 JSR DrawSunEdgeLeft
 DEY
 LDA L05EC
 JSR DrawSunEdgeLeft
 DEY
 LDA L05EB
 JSR DrawSunEdgeLeft
 DEY
 LDA L05EA
 JMP DrawSunEdgeLeft

.CAEE8

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P+1
 STX XX15
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR DrawSunEdgeRight
 DEY
 LDA L05F0
 JSR DrawSunEdgeRight
 DEY
 LDA L05EF
 JSR DrawSunEdgeRight
 DEY
 LDA L05EE
 JSR DrawSunEdgeRight
 DEY
 LDA L05ED
 JSR DrawSunEdgeRight
 DEY
 LDA L05EB
 JSR DrawSunEdgeRight
 DEY
 LDA L05EB
 JSR DrawSunEdgeRight
 DEY
 LDA L05EA
 JMP DrawSunEdgeRight

.CAF35

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY Y1


INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/edges.asm"

\ ******************************************************************************
\
\       Name: DrawSunEdgeLeft
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw part of the left edge of the sun
\
\ ******************************************************************************

.DrawSunEdgeLeft

 LDX P                  \ ???
 STX X2
 EOR #&FF
 SEC
 ADC YY
 STA XX15
 LDA YY+1
 ADC #&FF
 BEQ CB04D
 BMI CB056

.CB04C

 RTS

.CB04D

 LDA XX15
 CMP X2
 BCS CB04C
 JMP HLOIN

.CB056

 LDA #0
 STA XX15
 JMP HLOIN

\ ******************************************************************************
\
\       Name: DrawSunEdgeRight
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw part of the right edge of the sun
\
\ ******************************************************************************

.DrawSunEdgeRight

 CLC                    \ ???
 ADC YY
 STA X2
 LDA YY+1
 ADC #0
 BEQ CB04D
 BMI CB04C
 LDA #&FD
 STA X2
 CMP XX15
 BEQ CB04C
 BCC CB04C
 JMP HLOIN

INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/nes/main/subroutine/pl44.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/stars2.asm"

\ ******************************************************************************
\
\       Name: yHangarFloor
\       Type: Variable
\   Category: Ship hangar
\    Summary: Pixel y-coordinates for the four horizontal lines that make up the
\             floor of the ship hangar
\
\ ******************************************************************************

.yHangarFloor

 EQUB 80
 EQUB 88
 EQUB 98
 EQUB 120

\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Display the ship hangar
\
\ ------------------------------------------------------------------------------
\
\ This routine is called after the ships in the hangar have been drawn, so all
\ it has to do is draw the hangar's background.
\
\ The hangar background is made up of two parts:
\
\   * The hangar floor consists of four screen-wide horizontal lines at the
\     y-coordinates given in the yHangarFloor table, which are close together at
\     the horizon and further apart as the eye moves down and towards us, giving
\     the hangar a simple sense of perspective
\
\   * The back wall of the hangar consists of equally spaced vertical lines
\     that join the horizon to the top of the screen
\
\ The ships in the hangar have already been drawn by this point, so the lines
\ are drawn so they don't overlap anything that's already there, which makes
\ them look like they are behind and below the ships. This is achieved by
\ drawing the lines in from the screen edges until they bump into something
\ already on-screen. For the horizontal lines, when there are multiple ships in
\ the hangar, this also means drawing lines between the ships, as well as in
\ from each side.
\
\ ******************************************************************************

.HANGER

                        \ We start by drawing the floor

 LDX #0                 \ We are going to work our way through the four lines in
                        \ the hangar floor, so 

.hang1

 STX TGT                \ Store the line number in TGT so we can retrieve it
                        \ later

 LDA yHangarFloor,X     \ Set Y to the pixel y-coordinate of the line, from the
 TAY                    \ yHangarFloor table

 LDA #8                 \ Set A = 8 so the call to HAL3 draws a horizontal line
                        \ that starts at pixel x-coordinate 8 (i.e. just inside
                        \ the left box edge surrounding the view)

 LDX #28                \ Set X = 28 so the call to HAL3 draws a horizontal line
                        \ of up to 28 blocks (i.e. almost the full screen width)

 JSR HAL3               \ Call HAL3 to draw a line from the left edge of the
                        \ screen, going right until we bump into something
                        \ already on-screen, at which point it stops drawing

 LDA #240               \ Set A = 240 so the call to HAS3 draws a horizontal
                        \ line that starts at pixel x-coordinate 240 (i.e. just
                        \ inside the right box edge surrounding the view)

 LDX #28                \ Set X = 28 so the call to HAS3 draws a horizontal line
                        \ of up to 28 blocks (i.e. almost the full screen width)

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

 LDA HANGFLAG           \ Fetch the value of HANGFLAG, which gets set to 0 in
                        \ the HALL routine above if there is only one ship

 BEQ hang2              \ If HANGFLAG is zero, jump to hang2 to skip the
                        \ following as there is only one ship in the hangar

                        \ If we get here then there are multiple ships in the
                        \ hangar, so we also need to draw the horizontal line in
                        \ the gap between the ships

 LDA #128               \ Set A = 128 so the call to HAL3 draws a horizontal
                        \ line that starts at pixel x-coordinate 128 (i.e.
                        \ from halfway across the screen)

 LDX #12                \ Set X = 12 so the call to HAL3 draws a horizontal line
                        \ of up to 12 blocks, which will be enough to draw
                        \ between the ships

 JSR HAL3               \ Call HAL3 to draw a line from the halfway point across
                        \ the right half of the screen, going right until we
                        \ bump into something already on-screen, at which point
                        \ it stops drawing

 LDA #127               \ Set A = 127 so the call to HAS3 draws a horizontal
                        \ line that starts at pixel x-coordinate 127 (i.e.
                        \ just before the halfway point)

 LDX #12                \ Set X = 12 so the call to HAL3 draws a horizontal line
                        \ of up to 12 blocks, which will be enough to draw
                        \ between the ships

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

.hang2

                        \ We have finished threading our horizontal line behind
                        \ the ships already on-screen, so now for the next line

 LDX TGT                \ Set X to the number of the floor line we are drawing

 INX                    \ Increment X to move on to the next floor line

 CPX #4                 \ Loop back to hang1 to draw the next floor line until
 BNE hang1              \ we have drawn all four

                        \ The floor is done, so now we move on to the back wall

 JSR DORND              \ Set A to a random number between 0 and 7, with bit 2
 AND #7                 \ set, to give a random number in the range 4 to 7,
 ORA #4                 \ which we use as the x-coordinate of the first vertical
                        \ line in the hangar wall

 LDY #0                 \ Set Y = 0 so the call to DrawHangarWallLine starts
                        \ drawing the wall lines in the first tile of the screen
                        \ row, at the left edge of the screen

.hang3

 JSR DrawHangarWallLine \ Draw a vertical wall line at x-coordinate A

 CLC                    \ Add 10 to A 
 ADC #10

 BCS hang4              \ If adding 10 made the addition overflow then we have
                        \ fallen off the right edge of the screen, so jump to
                        \ hang4 to return from the subroutine

 CMP #248               \ Loop back until we have drawn lines all the way to the
 BCC hang3              \ right edge of the screen, not going further than an
                        \ x-coordinate of 247


.hang4

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawHangarWallLine
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Draw a vertical hangar wall line from top to bottom, stopping when
\             it bumps into existing on-screen content
\
\ ******************************************************************************

.DrawHangarWallLine

 STA S                  \ Store A in S so we can retrieve it when returning
                        \ from the subroutine

 STY YSAV               \ Store Y in YSAV so we can retrieve it when returning
                        \ from the subroutine

 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 LDA S
 AND #7
 STA T

.CB5D9

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX #0
 LDA (SC2,X)
 BEQ CB615
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDY #0
 LDX T

.loop_CB5FF

 LDA (SC),Y
 AND TWOS,X
 BNE CB62A
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 CPY #8
 BNE loop_CB5FF
 JMP CB61C

.CB615

 LDA T
 CLC
 ADC #&34
 STA (SC2,X)

.CB61C

 LDA SC2
 CLC
 ADC #&20
 STA SC2
 BCC CB5D9
 INC SC2+1
 JMP CB5D9

.CB62A

 LDA S                  \ Retrieve the value of A we stored above, so A is
                        \ preserved

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HAL3
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Draw a hangar background line from left to right, stopping when it
\             bumps into existing on-screen content
\
\ ******************************************************************************

.HAL3

 STX R                  \ Set R to the line width in X

 STY YSAV               \ Store Y in YSAV so we can retrieve it below

 LSR A                  \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + A / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 CLC                    \ to convert the pixel y-coordinate in Y into the number
 ADC yLookupLo,Y        \ of the first tile on the row containing the pixel
 STA SC2                \
 LDA nameBufferHi       \ Adding nameBufferHi and A / 8 therefore sets SC2(1 0)
 ADC yLookupHi,Y        \ to the address of the entry in the nametable buffer
 STA SC2+1              \ that contains the tile number for the tile containing
                        \ the pixel at (A, Y), i.e. the start of the line we are
                        \ drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)
                        \
                        \ As we are drawing a horizontal line, we do not need to
                        \ vary the value of Y, as we will always want to draw on
                        \ the same pixel row within each character block

.hanl1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hanl7              \ tile has not yet been allocated to this entry, so jump
                        \ to hanl7 to allocate a new dynamic tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDA (SC),Y             \ If the pattern data where we want to draw the line is
 BEQ hanl4              \ zero, then there is nothing currently on-screen at
                        \ this point, so jump to hanl4 to draw a full 8-pixel
                        \ line into the pattern data for this tile

                        \ There is something on-screen where we want to draw our
                        \ line, so we now draw the line until it bumps into
                        \ what's already on-screen, so the floor line goes right
                        \ up to the edge of the ship in the hangar

 LDA #%10000000         \ Set A to a pixel byte containing one set pixel at the
                        \ left end of the 8-pixel row, which we can extend to
                        \ the right by one pixel each time until it meets the
                        \ edge of the on-screen ship

.hanl2

 STA T                  \ Store the current pixel pattern in T

 AND (SC),Y             \ We now work out whether the pixel pattern in A would
                        \ overlap with the edge of the on-screen ship, which we
                        \ do by AND'ing the pixel pattern with the on-screen
                        \ pixel pattern in SC+Y, so if there are any pixels in
                        \ both the pixel pattern and on-screen, they will be set
                        \ in the result

 BNE hanl3              \ If the result is non-zero then our pixel pattern in A
                        \ does indeed overlap with the on-screen ship, so this
                        \ is the pattern we want, so jump to hanl3 to draw it

                        \ If we get here then our pixel pattern in A does not
                        \ overlap with the on-screen ship, so we need to extend
                        \ our pattern to the right by one pixel and try again

 LDA T                  \ Shift the whole pixel pattern to the right by one
 SEC                    \ pixel, shifting a set pixel into the left end (bit 7)
 ROR A

 JMP hanl2              \ Jump back to hanl2 to check whether our extended pixel
                        \ pattern has reached the edge of the ship yet

.hanl3

 LDA T                  \ Draw our pixel pattern into the pattern buffer, using
 ORA (SC),Y             \ OR logic so it overwrites what's already there and
 STA (SC),Y             \ merges into the existing ship edge

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

.hanl4

                        \ If we get here then we can draw a full 8-pixel wide
                        \ horizontal line into the pattern data for the current
                        \ tile, as there is nothing there already

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 STA (SC),Y             \ Store the 8-pixel line in the Y-th entry in the
                        \ pattern buffer

.hanl5

 DEC R                  \ Decrement the line width in R

 BEQ hanl6              \ If we have drawn all R blocks, jump to hanl6 to return
                        \ from the subroutine

 INC SC2                \ Increment SC2(1 0) to point to the next nametable
 BNE hanl1              \ entry and jump back to hanl1 to draw the next block of
 INC SC2+1              \ the horizontal line
 JMP hanl1

.hanl6

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

.hanl7

                        \ If we get here then there is no dynamic tile allocated
                        \ to the part of the line we want to draw, so we can use
                        \ one of the pre-rendered tiles that contains an 8-pixel
                        \ horizontal line on the correct pixel row
                        \
                        \ We jump here with X = 0

 TYA                    \ Set A = Y + 37
 CLC                    \
 ADC #37                \ Tiles 37 to 44 contain pre-rendered patterns as
                        \ follows:
                        \
                        \   * Tile 37 has a horizontal line on pixel row 0
                        \   * Tile 38 has a horizontal line on pixel row 1
                        \     ...
                        \   * Tile 43 has a horizontal line on pixel row 6
                        \   * Tile 44 has a horizontal line on pixel row 7
                        \
                        \ So A contains the pre-rendered tile number that
                        \ contains an 8-pixel line on pixel row Y, and as Y
                        \ contains the offset of the pixel row for the line we
                        \ are drawing, this means A contains the correct tile
                        \ number for this part of the line

 STA (SC2,X)            \ Display the pre-rendered tile on-screen by setting
                        \ the nametable entry to A

 JMP hanl5              \ Jump up to hanl5 to move on to the next character
                        \ block to the right

\ ******************************************************************************
\
\       Name: HAS3
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Draw a hangar background line from right to left
\
\ ******************************************************************************

.HAS3

 STX R
 STY YSAV
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 TYA
 AND #7
 TAY

.CB6BA

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0
 LDA (SC2,X)
 BEQ CB70B
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDA (SC),Y
 BEQ CB6F8
 LDA #1

.loop_CB6E2

 STA T
 AND (SC),Y
 BNE CB6EF
 LDA T
 SEC
 ROL A
 JMP loop_CB6E2

.CB6EF

 LDA T
 ORA (SC),Y
 STA (SC),Y

.loop_CB6F5

 LDY YSAV
 RTS

.CB6F8

 LDA #&FF
 STA (SC),Y

.loop_CB6FC

 DEC R
 BEQ loop_CB6F5
 LDA SC2
 BNE CB706
 DEC SC2+1

.CB706

 DEC SC2
 JMP CB6BA

.CB70B

 TYA
 CLC
 ADC #&25
 STA (SC2,X)
 JMP loop_CB6FC

INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/nes/main/subroutine/zinf_b1.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"

\ ******************************************************************************
\
\       Name: SCAN
\   Category: Dashboard
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.CB969

 LDA #240
 STA ySprite0,Y
 STA ySprite1,Y
 STA ySprite2,Y

.CB974

 RTS

.SCAN

 LDA QQ11               \ If this is not the space view (i.e. QQ11 is non-zero)
 BNE CB974              \ then jump to CB974???

 LDX TYPE               \ ???
 BMI CB974
 LDA INWK+33
 BEQ CB974
 TAX
 ASL A
 ADC INWK+33
 ASL A
 ASL A
 ADC #&2C
 TAY
 LDA scannerAttrs,X
 STA attrSprite0,Y
 LDA INWK+1
 CMP INWK+4
 BCS CB998
 LDA INWK+4

.CB998

 CMP INWK+7
 BCS CB99E
 LDA INWK+7

.CB99E

 CMP #&40
 BCS CB969
 STA SC2
 LDA INWK+1
 ADC INWK+4
 ADC INWK+7
 BCS CB969
 SEC
 SBC SC2
 LSR A
 LSR A
 STA SC2+1
 LSR A
 LSR A
 ADC SC2+1
 ADC SC2
 CMP #&40
 BCS CB969
 LDA INWK+1
 CLC
 LDX INWK+2
 BPL CB9C8
 EOR #&FF
 ADC #1

.CB9C8

 ADC #124
 STA SC2
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDX INWK+8
 BMI CB9D8
 EOR #&FF
 SEC

.CB9D8

 ADC #199+YPAL

 STA SC2+1
 LDA INWK+4
 CMP #&30
 BCC CB9E4
 LDA #&2F

.CB9E4

 LSR A
 STA Y1
 CLC
 BEQ CB9F1
 LDX INWK+5
 BPL CB9F1
 JMP CBA6C

.CB9F1

 LDA SC2+1
 SEC
 SBC #8
 STA SC2+1
 LDA Y1
 CMP #&10
 BCC CBA24
 LDA SC2
 STA xSprite0,Y
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite0,Y
 SEC
 SBC #8
 STA ySprite1,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite0,Y
 STA attrSprite1,Y
 LDA SC2+1
 SBC #&10
 STA SC2+1
 BNE CBA4F

.CBA24

 CMP #8
 BCC CBA47
 LDA #&F0
 STA ySprite0,Y
 LDA SC2
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite1,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite1,Y
 LDA SC2+1
 SBC #8
 STA SC2+1
 BNE CBA4F

.CBA47

 LDA #&F0
 STA ySprite0,Y
 STA ySprite1,Y

.CBA4F

 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA tileSprite2,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite2,Y
 LDA SC2
 STA xSprite2,Y
 LDA SC2+1
 STA ySprite2,Y
 RTS

.CBA6C

 CLC
 ADC SC2+1

 CMP #220+YPAL
 BCC CBA75
 LDA #220+YPAL

.CBA75

 SEC
 SBC SC2+1
 STA Y1
 CMP #&10
 BCC CBAA5
 LDA SC2
 STA xSprite0,Y
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite0,Y
 CLC
 ADC #8
 STA ySprite1,Y
 LDA attrSprite0,Y
 ORA #&20
 STA attrSprite0,Y
 STA attrSprite1,Y
 LDA SC2+1
 CLC
 ADC #&10
 STA SC2+1
 BNE CBAD0

.CBAA5

 CMP #8
 BCC CBAC8
 LDA #&F0
 STA ySprite0,Y
 LDA SC2
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite1,Y
 LDA attrSprite0,Y
 ORA #&20
 STA attrSprite1,Y
 LDA SC2+1
 ADC #7
 STA SC2+1
 BNE CBAD0

.CBAC8

 LDA #&F0
 STA ySprite0,Y
 STA ySprite1,Y

.CBAD0

 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA tileSprite2,Y
 LDA attrSprite0,Y
 ORA #&E0
 STA attrSprite2,Y
 LDA SC2
 STA xSprite2,Y
 LDA SC2+1
 STA ySprite2,Y
 RTS

\ ******************************************************************************
\
\       Name: RemoveFromScanner
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Remove a ship from the scanner
\
\ ******************************************************************************

.RemoveFromScanner

 LDA #0                 \ Zero byte #33 in the current ship's data block at K%,
 LDY #33                \ so it is not shown on the scanner (a non-zero byte #33
 STA (INF),Y            \ represents the ship's number on the scanner, with a
                        \ ship number of zero indicating that the ship is not
                        \ shown on the scanner)

                        \ Fall through into HideFromScanner to hide the scanner
                        \ sprites for this ship and reset byte #33 in the INWK
                        \ workspace

\ ******************************************************************************
\
\       Name: HideFromScanner
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Hide the current ship from the scanner
\
\ ******************************************************************************

.HideFromScanner

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX INWK+33            \ Set X to the number of the current ship on the
                        \ scanner, which is in ship data byte #33

 BEQ hide2              \ If byte #33 for the current ship is zero, then the
                        \ ship doesn't appear on the scanner, so jump to hide2
                        \ to return from the subroutine as there is nothing to
                        \ hide
                        
 LDA #0                 \ Otherwise we need to hide this ship, so we start by
 STA scannerFlags,X     \ zeroing the scanner flags for the ship number X on
                        \ the scanner

                        \ We now hide the three sprites used to show this ship
                        \ on the scanner
                        \
                        \ There are four data bytes for each sprite in the
                        \ sprite buffer, and there are three sprites used to
                        \ display each ship on the scanner, so we start by
                        \ calculating the offset of the sprite data for this
                        \ ship's scanner sprites

 TXA                    \ Set X = (X * 2 + X) * 4
 ASL A                  \       = (3 * X) * 4
 ADC INWK+33            \
 ASL A                  \ So X is the index of the sprite buffer data for the
 ASL A                  \ three sprites for ship number X on the scanner
 TAX

 LDA QQ11               \ If this is not the space view, jump to hide1 as the
 BNE hide1              \ dashoard is only shown in the space view

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

 STA ySprite11,X        \ Hide the three scanner sprites for ship number X, so
 STA ySprite12,X        \ the current ship is no longer shown on the scanner
 STA ySprite13,X        \ (the first ship on the scanner, ship number 1, uses
                        \ the three sprites at 14, 15 and 16 in the buffer, and
                        \ each sprite has four bytes in the buffer, so we can
                        \ get the sprite numbers by adding X, which contains the
                        \ offset within the sprite buffer, to the addresses of
                        \ sprites 11, 12 and 13)

.hide1

 LDA #0                 \ Zero the current ship's byte #33 in INWK, so that it
 STA INWK+33            \ no longer has a ship number on the scanner (a non-zero
                        \ byte #33 represents the ship's number on the scanner,
                        \ but a ship number of zero indicates that the ship is
                        \ not shown on the scanner)

.hide2

 RTS                    \ Return from the subroutine

INCLUDE "library/nes/main/subroutine/ptcls2.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank1.bin
\
\ ******************************************************************************

 PRINT "S.bank1.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank1.bin", CODE%, P%, LOAD%
