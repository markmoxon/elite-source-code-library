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
\       Name: SUN (Part 2 of 2)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Starting from the bottom of the sun, draw the new
\             sun line by line
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases the old sun, starting at the bottom of the screen and working
\ upwards until we reach the bottom of the new sun.
\
\ ******************************************************************************

 LDA K3                 \ Set YY(1 0) to the pixel x-coordinate of the centre
 STA YY                 \ of the new sun, from K3(1 0)
 LDA K3+1
 STA YY+1

 LDY TGT                \ Set Y to the maximum y-coordinate of the sun on the
                        \ screen (i.e. the bottom of the sun), which we set up
                        \ in part 1

 LDA #0                 \ Set the sub width variables to zero, so we can use
 STA sunWidth1          \ them below to store the widths of the sun on each
 STA sunWidth2          \ pixel row within each tile row
 STA sunWidth3
 STA sunWidth4
 STA sunWidth5
 STA sunWidth6
 STA sunWidth7

 TYA                    \ Set A to the maximum y-coordinate of the sun, so we
                        \ can apply the first AND below

 TAX                    \ Set X to the maximum y-coordinate of the sun, so we
                        \ can apply the second AND below

 AND #%11111000         \ Each tile row contains 8 pixel rows, so to get the
 TAY                    \ y-coordinate of the first row of pixels in the tile
                        \ row, we clear bits 0-2, so Y now contains the pixel
                        \ y-coordinate of the top pixel row in the tile row
                        \ containing the bottom of the sun

 LDA V+1                \ If V+1 is non-zero then we are doing the top half of
 BNE dsun11             \ the new sun, so jump down to dsun11 to work our way
                        \ upwards from the centre towards the top of the sun

                        \ If we get here then we are drawing the bottom half of
                        \ of the sun, so we work our way up from the bottom by
                        \ decrementing V for each pixel line, as V contains the
                        \ vertical distance between the line we're drawing and
                        \ the centre of the new sun, and it starts out pointing
                        \ to the bottom of the sun

 TXA                    \ Set A = X mod 8, which is the pixel row within the
 AND #7                 \ tile row of the bottom of the sun

 BEQ dsun8              \ If A = 0 then the bottom of the sun is only in the top
                        \ pixel row of the tile row, so jump to dsun8 to
                        \ calculate the sun's width on one pixel row

 CMP #2                 \ If A = 1, jump to dsun7 to calculate the sun's width
 BCC dsun7              \ on two pixel rows

 BEQ dsun6              \ If A = 2, jump tp dsun6 to calculate the sun's width
                        \ on three pixel rows

 CMP #4                 \ If A = 3, jump tp dsun5 to calculate the sun's width
 BCC dsun5              \ on four pixel rows

 BEQ dsun4              \ If A = 4, jump tp dsun4 to calculate the sun's width
                        \ on five pixel rows

 CMP #6                 \ If A = 5, jump tp dsun3 to calculate the sun's width
 BCC dsun3              \ on six pixel rows

 BEQ dsun2              \ If A = 6, jump tp dsun2 to calculate the sun's width
                        \ on seven pixel rows

                        \ If we get here then A = 7, so keep going to calculate
                        \ the sun's width on all eight pixel rows, starting from
                        \ row 7 at the bottom of the tile row, all the way up to
                        \ pixel row 0 at the top of the tile row

.dsun1

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth7          \ Store the half-width of pixel row 7 in sunWidth7

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun12             \ If V is zero then we have reached the centre, so jump
                        \ to dsun12 to start working our way up from the centre,
                        \ incrementing V instead

.dsun2

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth6          \ Store the half-width of pixel row 6 in sunWidth6

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun13             \ If V is zero then we have reached the centre, so jump
                        \ to dsun13 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun3

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth5          \ Store the half-width of pixel row 5 in sunWidth5

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun14             \ If V is zero then we have reached the centre, so jump
                        \ to dsun14 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun4

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth4          \ Store the half-width of pixel row 4 in sunWidth4

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun15             \ If V is zero then we have reached the centre, so jump
                        \ to dsun15 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun5

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth3          \ Store the half-width of pixel row 3 in sunWidth3

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun16             \ If V is zero then we have reached the centre, so jump
                        \ to dsun16 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun6

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth2          \ Store the half-width of pixel row 2 in sunWidth2

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun17             \ If V is zero then we have reached the centre, so jump
                        \ to dsun17 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun7

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth1          \ Store the half-width of pixel row 1 in sunWidth1

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun10             \ If V is zero then we have reached the centre, so jump
                        \ to dsun18 via dsun10 to start working our way up from
                        \ the centre, incrementing V for the rest of this tile
                        \ row

.dsun8

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth0          \ Store the half-width of pixel row 0 in sunWidth0

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun9              \ If V is zero then we have reached the centre, so jump
                        \ to dsun19 via dsun9 to start working our way up from
                        \ the centre, incrementing V for the rest of this tile
                        \ row

 JSR dsun28             \ Call dsun28 to draw all eight lines for this tile row

 TYA                    \ Set Y = Y - 8 to move up a tile row
 SEC
 SBC #8
 TAY

 BCS dsun1              \ If the subtraction didn't underflow, then Y is still
                        \ positive and is therefore still on-screen, so loop
                        \ back to dsun1 to keep drawing pixel rows

 RTS                    \ Otherwise we have reached the top of the screen, so
                        \ return from the subroutine as we are done drawing

.dsun9

 BEQ dsun19             \ Jump down to dsun19 (this is only used to enable us to
                        \ use a BEQ dsun9 above)

.dsun10

 BEQ dsun18             \ Jump down to dsun18 (this is only used to enable us to
                        \ use a BEQ dsun10 above)

.dsun11

                        \ If we get here then we are drawing the top half of the
                        \ sun, so we increment V for each pixel line as we move
                        \ up the screen

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth7          \ Store the half-width of pixel row 7 in sunWidth7

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun21             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun21 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun12

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth6          \ Store the half-width of pixel row 6 in sunWidth6

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun22             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun22 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun13

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth5          \ Store the half-width of pixel row 5 in sunWidth5

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun23             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun23 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun14

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth4          \ Store the half-width of pixel row 4 in sunWidth4

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun24             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun24 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun15

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth3          \ Store the half-width of pixel row 3 in sunWidth3

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun25             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun25 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun16

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth2          \ Store the half-width of pixel row 2 in sunWidth2

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun26             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun26 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun17

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth1          \ Store the half-width of pixel row 1 in sunWidth1

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun27             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun27 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun18

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth0          \ Store the half-width of pixel row 0 in sunWidth0

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun28             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun28 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun19

 JSR dsun28             \ Call dsun28 to draw all eight lines for this tile row

 TYA                    \ Set Y = Y - 8 to move up a tile row
 SEC
 SBC #8
 TAY

 BCC dsun20             \ If the subtraction underflowed, then Y is negative
                        \ and is therefore off the top of the screen, so jump to
                        \ dsun20 to return from the subroutine

 JMP dsun11             \ Otherwise we still have work to do, so jump up to
                        \ dsun11 to keep working our way up the top half of the
                        \ sun

.dsun20

 RTS                    \ Return from the subroutine

.dsun21

                        \ If we jump here then we have reached the top of the
                        \ sun and only need to draw pixel row 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth6

 LDA #0
 STA sunWidth6

.dsun22

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 6 and 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth5

 LDA #0
 STA sunWidth5

.dsun23

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 5 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth4

 LDA #0
 STA sunWidth4

.dsun24

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 4 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth3

 LDA #0
 STA sunWidth3

.dsun25

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 3 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth2

 LDA #0
 STA sunWidth2

.dsun26

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 2 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth1

 LDA #0
 STA sunWidth1

.dsun27

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 1 to 7 in the current
                        \ tile row, so we zero sunWidth0

 LDA #0
 STA sunWidth0

                        \ So by this point sunWidth0 through sunWidth7 are set
                        \ up with the correct widths that we need to draw on
                        \ each pixel row of the current tile row, with some of
                        \ them possibly set to zero

                        \ We now fall through into dsun28 to draw these eight
                        \ pixel rows and return from the subroutine

.dsun28

                        \ If we jump here with a branch instruction or fall
                        \ through from above, then we have reached the top of
                        \ the sun and need to draw pixel rows 0 to 7 in the
                        \ current tile row, and then we are done drawing
                        \
                        \ If we call this code as a subroutine using JSR dsun28
                        \ then we need to draw pixel rows 0 to 7 in the current
                        \ tile row, and when we return from the call we keep
                        \ drawing rows
                        \
                        \ In either case, we now need to draw all eight rows
                        \ before returning from the subroutine
                        \
                        \ We start by finding the smallest width out of
                        \ sunWidth0 through sunWidth7

 LDA sunWidth0          \ Set A to sunWidth0 as our starting point

 CMP sunWidth1          \ If A >= sunWidth1 then set A = sunWidth1, so this sets
 BCC dsun29             \ A = min(A, sunWidth1)
 LDA sunWidth1

.dsun29

 CMP sunWidth2          \ If A >= sunWidth2 then set A = sunWidth2, so this sets
 BCC dsun30             \ A = min(A, sunWidth2)
 LDA sunWidth2

.dsun30

 CMP sunWidth3          \ If A >= sunWidth3 then set A = sunWidth3, so this sets
 BCC dsun31             \ A = min(A, sunWidth3)
 LDA sunWidth2

.dsun31

 CMP sunWidth4          \ If A >= sunWidth4 then set A = sunWidth4, so this sets
 BCC dsun32             \ A = min(A, sunWidth4)
 LDA sunWidth4

.dsun32

 CMP sunWidth5          \ If A >= sunWidth5 then set A = sunWidth5, so this sets
 BCC dsun33             \ A = min(A, sunWidth5)
 LDA sunWidth5

.dsun33

 CMP sunWidth6          \ If A >= sunWidth6 then set A = sunWidth6, so this sets
 BCC dsun34             \ A = min(A, sunWidth6)
 LDA sunWidth6

.dsun34

 CMP sunWidth7          \ If A >= sunWidth7 then set A = sunWidth7, so this sets
 BCC dsun35             \ A = min(A, sunWidth7)
 LDA sunWidth7

                        \ So by this point A = min(sunWidth0 to sunWidth7), and
                        \ we can now check to see if we can save time by drawing
                        \ a portion of this tile row out of filled blocks

 BEQ dsun37             \ If A = 0 then at least one of the pixel rows needs to
                        \ be left blank, so we can't draw the row using filled
                        \ blocks, so jump to dsun37 to draw the tile row one
                        \ pixel row at a time

.dsun35

 JSR EDGES              \ Call EDGES to calculate X1 and X2 for the horizontal
                        \ line centred on YY(1 0) and with half-width A, clipped
                        \ to fit on-screen if necessary, so this gives us the
                        \ coordinates of the smallest pixel row in the tile row
                        \ that we want to draw

 BCS dsun37             \ If the C flag is set, then the smallest pixel row
                        \ is off-screen, so jump to dsun37 to draw the tile row
                        \ one pixel row at a time, as there is at least one
                        \ pixel row in the tile row that doesn't need drawing

                        \ If we get here then every pixel row in the tile row
                        \ fits on-screen and contains some sun pixels, so we
                        \ can now work out how to draw this row using filled
                        \ tiles where possible
                        \
                        \ We do this by breaking the line up into a tile at the
                        \ left end of the row, a tile at the right end of the
                        \ row, and a set of filled tiles in the middle
                        \
                        \ We set P and P+1 to the pixel coordinates of the block
                        \ of filled tiles in the middle

 LDA X2                 \ Set P+1 to the x-coordinate of the right end of the
 AND #%11111000         \ smallest sun line by clearing bits 0-2 of X2, giving
 STA P+1                \ P+1 = (X2 div 8) * 8
                        \
                        \ This gives us what we want as each tile is 8 pixels
                        \ wide

 LDA X1                 \ Now to calculate the x-coordinate of the left end of
 ADC #7                 \ the filled tiles, so set A = X1 + 7 (we know the C
                        \ flag is clear for the addition as we just passed
                        \ through a BCS)

 BCS dsun37             \ If the addition overflowed, then this addition pushes
                        \ us past the right edge of the screen, so jump to
                        \ dsun37 to draw the tile row one pixel row at a time as
                        \ there isn't any room for filled tiles

 AND #%11111000         \ Clear bits 0-2 of A to give us the x-coordinate of the
                        \ left end of the set of filled tiles

 CMP P+1                \ If A >= P+1 then there is no room for any filled as
 BCS dsun37             \ the entire line fits into one tile, so jump to dsun37
                        \ to draw the tile row one pixel row at a time

 STA P                  \ Otherwise we now have valid values for the
                        \ x-coordinate range of the filled blocks in the
                        \ middle of the row, so store A in P so the coordinate
                        \ range is from P to P+1

 CMP #248               \ If A >= 248 then we only have room for one block on
 BCS dsun36             \ this row, and it's at the right edge of the screen,
                        \ so jump to dsun36 to skip the right and middle tiles
                        \ and just draw the tile at the left end of the row

 JSR dsun47             \ Call dsun47 to draw the tile at the right end of this
                        \ tile row

 JSR DrawSunRowOfBlocks \ Draw the tiles containing the horizontal line (P, Y)
                        \ to (P+1, Y) with filled blocks, silhouetting any
                        \ existing content against the sun

.dsun36

 JMP dsun46             \ Jump to dsun46 to draw the tile at the left end of this
                        \ tile row, returning from the subroutine using a tail
                        \ call as we have now drawn the middle of the row, plus
                        \ both ends

.dsun37

                        \ If we get here then we draw the current tile row one
                        \ pixel row at a time

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth7,
                        \ which is the pixel line for row 7 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES

 BCS dsun38             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 7 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun38

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth6,
                        \ which is the pixel line for row 6 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES

 BCS dsun39             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 6 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun39

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth5,
                        \ which is the pixel line for row 5 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun40             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 5 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun40

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth4,
                        \ which is the pixel line for row 4 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun41             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 4 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun41

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth3,
                        \ which is the pixel line for row 3 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun42             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 3 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun42

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth2          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth2,
                        \ which is the pixel line for row 2 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun43             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 2 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun43

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth1,
                        \ which is the pixel line for row 1 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun44             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 1 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun44

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth0,
                        \ which is the pixel line for row 0 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun45             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and return from the subroutine
                        \ as we are done

 JMP HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 0 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun, and return from the
                        \ subroutine using a tail call as we have now drawn all
                        \ the lines in this row

.dsun45

 RTS                    \ Return from the subroutine

.dsun46

                        \ If we get here then we need to draw the tile at the
                        \ left end of the current tile row

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P                  \ Set X to P, the x-coordinate of the left end of the
                        \ middle part of the sun row (which is the same as the
                        \ x-coordinate just to the right of the leftmost tile)

 BEQ dsun45             \ If X = 0 then the leftmost tile is off the left of the
                        \ screen, so jump to dsun45 to return from the
                        \ subroutine

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 7

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 6

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 5

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 4

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 3

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth2          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 2

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 1

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Draw a pixel byte for the left edge of the sun at the
 JMP DrawSunEdgeLeft    \ left end of pixel row 0 and return from the subroutine
                        \ using a tail call

.dsun47

                        \ If we get here then we need to draw the tile at the
                        \ right end of the current tile row

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P+1                \ Set X1 to P+1, the x-coordinate of the right end of
 STX X1                 \ the middle part of the sun row (which is the same as
                        \ x-coordinate of the left end of the rightmost tile)

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 7

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 6

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 5

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 4

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 3

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 2
                        \
                        \ This appears to be a bug (though one you would be
                        \ hard-pressed to detect from looking at the screen), as
                        \ we should probably be loading sunWidth2 here, not
                        \ sunWidth1
                        \
                        \ As it stands, on each tile row of the sun, the right
                        \ edge always has matching lines on pixel rows 1 and 2

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 1

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Draw a pixel byte for the right edge of the sun at the
 JMP DrawSunEdgeRight   \ right end of pixel row 0 and return from the subroutine
                        \ using a tail call

INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/edges.asm"

\ ******************************************************************************
\
\       Name: DrawSunEdgeLeft
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw a sun line in the tile on the left end of a sun row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The half-width of the sun line
\
\   Y                   The number of the pixel row of the sun line within the
\                       tile row (0-7)
\
\   P                   The pixel x-coordinate of the start of the middle
\                       section of the sun line (i.e. the x-coordinate just to
\                       the right of the leftmost tile)
\
\   YY(1 0)             The centre x-coordinate of the sun
\
\ Other entry points:
\
\   RTS7                Contains an RTS
\
\   DrawSunEdge         Draw a sun line from (X1, Y) to (X2, Y) 
\
\ ******************************************************************************

.DrawSunEdgeLeft

 LDX P                  \ Set X2 to P, which contains the x-coordinate just to
 STX X2                 \ the right of the leftmost tile
                        \
                        \ We can use this as the x-coordinate of the right end
                        \ of the line that we want to draw in the leftmost tile

 EOR #&FF               \ Use two's complement to set X1 = YY(1 0) - A
 SEC                    \
 ADC YY                 \ So X1 contains the x-coordinate of the left end of the
 STA X1                 \ sun line
 LDA YY+1
 ADC #&FF

 BEQ DrawSunEdge        \ If the high byte of the result is zero, then the left
                        \ end of the line is on-screen, so jump to DrawSunEdge
                        \ to draw the sun line from (X1, Y) to (X2, Y)

 BMI sunl1              \ If the high byte of the result is negative, then the
                        \ left end of the line is off the left edge of the
                        \ screen, so jump to sunl1 to draw a clipped sun line
                        \ from (0, Y) to (X2, Y)

                        \ Otherwise the line is off-screen, so return from the
                        \ subroutine without drawing anything

.RTS7

 RTS                    \ Return from the subroutine

.DrawSunEdge

 LDA X1                 \ If X1 >= X2 then the left end of the line is to the
 CMP X2                 \ right of the right end of the line, so these are not
 BCS RTS7               \ valid line coordinates and we jump to RTS7 to return
                        \ from the subroutine without drawing anything

 JMP HLOIN              \ Otherwise draw the sun line from (X1, Y) to (X2, Y)
                        \ and return from the subroutine using a tail call

.sunl1

                        \ If we get here then we need to clip the left end of
                        \ the line to fit on-screen

 LDA #0                 \ Draw a clipped the sun line from (0, Y) to (X2, Y)
 STA X1                 \ and return from the subroutine using a tail call
 JMP HLOIN

\ ******************************************************************************
\
\       Name: DrawSunEdgeRight
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw a sun line in the tile on the right end of a sun row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The half-width of the sun line
\
\   Y                   The number of the pixel row of the sun line within the
\                       tile row (0-7)
\
\   X1                  The pixel x-coordinate of the rightmost tile on the sun
\                       line
\
\   YY(1 0)             The centre x-coordinate of the sun
\
\ ******************************************************************************

.DrawSunEdgeRight

 CLC                    \ Set X1 = YY(1 0) + A
 ADC YY                 \
 STA X2                 \ So X2 contains the x-coordinate of the right end of
 LDA YY+1               \ the sun line
 ADC #0

                        \ X1 is already set to the x-coordinate of the rightmost
                        \ tile, so the line we need to draw is from (X1, Y) to
                        \ (X2, Y)

 BEQ DrawSunEdge        \ If the high byte of the result is zero, then the right
                        \ end of the line is on-screen, so jump to DrawSunEdge
                        \ to draw the sun line from (X1, Y) to (X2, Y)

 BMI RTS7               \ If the high byte of the result is negative, then the
                        \ right end of the line is off the left edge of the
                        \ screen, so the line is not on-screen and we jump to
                        \ RTS7 to return from the subroutine (as RTS7 contains
                        \ an RTS)

                        \ If we get here then the right end of the line is past
                        \ the right edge of the screen, so we need to clip the
                        \ right end of the line to fit on-screen

 LDA #253               \ Set X2 = 253 so the line is clipped to the right edge
 STA X2                 \ of the screen

 CMP X1                 \ If X2 <= X1 then the right end of the line is to the
 BEQ RTS7               \ left of the left end of the line, so these are not
 BCC RTS7               \ valid line coordinates and we jump to RTS7 to return
                        \ from the subroutine without drawing anything

 JMP HLOIN              \ Otherwise draw the sun line from (X1, Y) to (X2, Y)
                        \ and return from the subroutine using a tail call

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

 LDA S                  \ Set T = S mod 8, which is the pixel column within the
 AND #7                 \ character block at which we want to draw the start of
 STA T                  \ our line (as each character block has 8 columns)
                        \
                        \ As we are drawing a vertical line, we do not need to
                        \ vary the value of T, as we will always want to draw on
                        \ the same pixel column within each character block

.hanw1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hanw3              \ tile has not yet been allocated to this entry, so jump
                        \ to hanw3 to allocate a new dynamic tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDY #0                 \ We want to start drawing the line from the top pixel
                        \ line in the next character row, so set Y = 0 to use as
                        \ the pixel row number

 LDX T                  \ Set X to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ T above

.hanw2

 LDA (SC),Y             \ We now work out whether the pixel in column X would
 AND TWOS,X             \ overlap with the top edge of the on-screen ship, which
                        \ we do by AND'ing the pixel pattern with the on-screen
                        \ pixel pattern in SC+Y, so if there are any pixels in
                        \ both the pixel pattern and on-screen, they will be set
                        \ in the result

 BNE hanw5              \ If the result is non-zero then our pixel in column X
                        \ does indeed overlap with the on-screen ship, so we
                        \ need to stop drawing our well line, so jump to hanw5
                        \ to return from the subroutine

                        \ If we get here then our pixel in column X does not
                        \ overlap with the on-screen ship, so we can draw it

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the y-coordinate in Y so we move down the
                        \ line by one pixel

 CPY #8                 \ If Y <> 8, loop back to hanw2 draw the next pixel as
 BNE hanw2              \ we haven't yet reached the bottom of the character
                        \ block containing the line's top end

 JMP hanw4              \ Otherwise we have finished drawing the vertical line
                        \ in this character row, so jump to hanw4 to move down
                        \ to the next row

.hanw3

 LDA T                  \ Set A to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ T above

 CLC                    \ Patterns 52 to 59 contain pre-rendered tiles, each
 ADC #52                \ containing a single-pixel vertical line, with a line
 STA (SC2,X)            \ at column 0 in pattern 52, a line at column 1 in
                        \ pattern 53, and so on up to column 7 in pattern 58,
                        \ so this sets the nametable entry for the character
                        \ block we are drawing to the correct pre-rendered tile
                        \ for drawing a vertical line in pixel column A

.hanw4

                        \ Next, we update SC2(1 0) to the address of the next
                        \ row down in the nametable buffer, which we can do by
                        \ adding 32 as there are 32 tiles in each row

 LDA SC2                \ Set SC2(1 0) = SC2(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC2

 BCC hanw1              \ And then the high bytes, jumping to hanw1 when we are
 INC SC2+1              \ done to draw the vertical line on the next row
 JMP hanw1

.hanw5

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

 STX R                  \ Set R to the line length in X

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

 DEC R                  \ Decrement the line length in R

 BEQ hanl6              \ If we have drawn all R blocks, jump to hanl6 to return
                        \ from the subroutine

 INC SC2                \ Increment SC2(1 0) to point to the next nametable
 BNE hanl1              \ entry to the right, starting with the low byte, and
                        \ if the increment didn't wrap the low byte round to
                        \ zero, jump back to hanl1 to draw the next block of the
                        \ horizontal line

 INC SC2+1              \ The low byte of SC2(1 0) incremented round to zero, so
 JMP hanl1              \ we also need to increment the high byte before jumping
                        \ back to hanl1 to draw the next block of the horizontal
                        \ line

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

 STX R                  \ Set R to the line length in X

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

.hanr1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hanr8              \ tile has not yet been allocated to this entry, so jump
                        \ to hanr8 to allocate a new dynamic tile

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
 BEQ hanr5              \ zero, then there is nothing currently on-screen at
                        \ this point, so jump to hanr5 to draw a full 8-pixel
                        \ line into the pattern data for this tile

                        \ There is something on-screen where we want to draw our
                        \ line, so we now draw the line until it bumps into
                        \ what's already on-screen, so the floor line goes right
                        \ up to the edge of the ship in the hangar

 LDA #%00000001         \ Set A to a pixel byte containing one set pixel at the
                        \ right end of the 8-pixel row, which we can extend to
                        \ the left by one pixel each time until it meets the
                        \ edge of the on-screen ship

.hanr2

 STA T                  \ Store the current pixel pattern in T

 AND (SC),Y             \ We now work out whether the pixel pattern in A would
                        \ overlap with the edge of the on-screen ship, which we
                        \ do by AND'ing the pixel pattern with the on-screen
                        \ pixel pattern in SC+Y, so if there are any pixels in
                        \ both the pixel pattern and on-screen, they will be set
                        \ in the result

 BNE hanr3              \ If the result is non-zero then our pixel pattern in A
                        \ does indeed overlap with the on-screen ship, so this
                        \ is the pattern we want, so jump to hanr3 to draw it

                        \ If we get here then our pixel pattern in A does not
                        \ overlap with the on-screen ship, so we need to extend
                        \ our pattern to the left by one pixel and try again

 LDA T                  \ Shift the whole pixel pattern to the left by one
 SEC                    \ pixel, shifting a set pixel into the right end (bit 0)
 ROL A

 JMP hanr2              \ Jump back to hanr2 to check whether our extended pixel
                        \ pattern has reached the edge of the ship yet

.hanr3

 LDA T                  \ Draw our pixel pattern into the pattern buffer, using
 ORA (SC),Y             \ OR logic so it overwrites what's already there and
 STA (SC),Y             \ merges into the existing ship edge

.hanr4

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

.hanr5

                        \ If we get here then we can draw a full 8-pixel wide
                        \ horizontal line into the pattern data for the current
                        \ tile, as there is nothing there already

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 STA (SC),Y             \ Store the 8-pixel line in the Y-th entry in the
                        \ pattern buffer

.hanr6

 DEC R                  \ Decrement the line length in R

 BEQ hanr4              \ If we have drawn all R blocks, jump to hanr4 to return
                        \ from the subroutine

 LDA SC2                \ We now decrement SC2(1 0) to point to the next
 BNE hanr7              \ nametable entry to the left, so check whether the low
                        \ byte of SC2(1 0) is non-zero, and if so jump to hanr7
                        \ to decrement it

 DEC SC2+1              \ Otherwise we also need to decrement the high byte
                        \ before decrementing the low byte round to &FF

.hanr7

 DEC SC2                \ Decerement the low byte of SC2(1 0)

 JMP hanr1              \ Jump back to hanr1 to draw the next block of the
                        \ horizontal line

.hanr8

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

 JMP hanr6              \ Jump up to hanr6 to move on to the next character
                        \ block to the left

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
