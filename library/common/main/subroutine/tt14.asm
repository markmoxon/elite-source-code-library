\ ******************************************************************************
\
\       Name: TT14
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw a circle with crosshairs on a chart
\
\ ------------------------------------------------------------------------------
\
\ Draw a circle with crosshairs at the current system's galactic coordinates.
\
\ ******************************************************************************

.TT126

IF NOT(_APPLE_VERSION)

 LDA #104               \ Set QQ19 = 104, for the x-coordinate of the centre of
 STA QQ19               \ the fixed circle on the Short-range Chart

 LDA #90                \ Set QQ19+1 = 90, for the y-coordinate of the centre of
 STA QQ19+1             \ the fixed circle on the Short-range Chart

ELIF _APPLE_VERSION

 LDA #105               \ Set QQ19 = 105, for the x-coordinate of the centre of
 STA QQ19               \ the fixed circle on the Short-range Chart

 LDA #75                \ Set QQ19+1 = 75, for the y-coordinate of the centre of
 STA QQ19+1             \ the fixed circle on the Short-range Chart

ENDIF

 LDA #16                \ Set QQ19+2 = 16, the size of the crosshairs on the
 STA QQ19+2             \ Short-range Chart

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: Group A: The static chart crosshairs in the Master version are drawn with white/yellow vertical stripes (with the exception of the static crosshairs on the Long-range Chart, which are white). All crosshairs are white in the other versions

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

 JSR TT15               \ Draw the set of crosshairs defined in QQ19, at the
                        \ exact coordinates as this is the Short-range Chart

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: Group B: The Master version contains code to scale the chart views, though it has no effect in this version. The code is left over from the Apple II version, which uses a different scale

 LDA QQ14               \ Set K to the fuel level from QQ14, so this can act as
 STA K                  \ the circle's radius (70 being a full tank)

ELIF _MASTER_VERSION

 LDA QQ14               \ Set K to the fuel level from QQ14, so this can act as
 JSR SCALEY2            \ the circle's radius (70 being a full tank)
 STA K                  \
                        \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 LDA QQ14               \ Set K to the scaled fuel level from QQ14, so this can
 JSR SCALEY2            \ act as the circle's radius (70 being a full tank)
 STA K

ELIF _NES_VERSION

 LDA QQ14               \ Set K = QQ14 + (QQ14 / 32)
 LSR A                  \
 LSR A                  \ So K is the circle's radius, based on the fuel level
 LSR A                  \ in QQ14 (so K is in the range 0 to 73, as the latter
 LSR A                  \ division gets rounded up by the ADC adding in the C
 LSR A                  \ flag, and QQ14 is in the range 0 to 70)
 ADC QQ14
 STA K

ENDIF

 JMP TT128              \ Jump to TT128 to draw a circle with the centre at the
                        \ same coordinates as the crosshairs, (QQ19, QQ19+1),
                        \ and radius K that reflects the current fuel levels,
                        \ returning from the subroutine using a tail call

.TT14

IF _6502SP_VERSION \ Master: See group A

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source (they are left over from the 6502 Second
                        \ Processor version of Elite and would change the text
                        \ colour to white)

ENDIF

IF NOT(_NES_VERSION)

 LDA QQ11               \ If the current view is the Short-range Chart, which
 BMI TT126              \ is the only view with bit 7 set, then jump up to TT126
                        \ to draw the crosshairs and circle for that view

ELIF _NES_VERSION

 LDA QQ11               \ If the view type in QQ11 is &9C (Short-range Chart),
 CMP #&9C               \ jump up to TT126 to draw the crosshairs and circle for
 BEQ TT126              \ that view

ENDIF

                        \ Otherwise this is the Long-range Chart, so we draw the
                        \ crosshairs and circle for that view instead

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: See group B

 LDA QQ14               \ Set K to the fuel level from QQ14 divided by 4, so
 LSR A                  \ this can act as the circle's radius (70 being a full
 LSR A                  \ tank, which divides down to a radius of 17)
 STA K

 LDA QQ0                \ Set QQ19 to the x-coordinate of the current system,
 STA QQ19               \ which will be the centre of the circle and crosshairs
                        \ we draw

 LDA QQ1                \ Set QQ19+1 to the y-coordinate of the current system,
 LSR A                  \ halved because the galactic chart is half as high as
 STA QQ19+1             \ it is wide, which will again be the centre of the
                        \ circle and crosshairs we draw

ELIF _MASTER_VERSION

 LDA QQ14               \ Set K to the fuel level from QQ14 divided by 4, so
 LSR A                  \ this can act as the circle's radius (70 being a full
 JSR SCALEY             \ tank, which divides down to a radius of 17)
 STA K                  \
                        \ The call to SCALEY simply does an LSR A, but having
                        \ this call instruction here would enable different
                        \ scaling to be applied by altering the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 LDA QQ0                \ Set QQ19 to the x-coordinate of the current system,
 JSR SCALEX             \ which will be the centre of the circle and crosshairs
 STA QQ19               \ we draw
                        \
                        \ The call to SCALEX has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 LDA QQ1                \ Set QQ19+1 to the y-coordinate of the current system,
 JSR SCALEY             \ halved because the galactic chart is half as high as
 STA QQ19+1             \ it is wide, which will again be the centre of the
                        \ circle and crosshairs we draw
                        \
                        \ Again, the call to SCALEY simply does an LSR A (see
                        \ the comment above)

ELIF _APPLE_VERSION

 LDA QQ14               \ Set K to the scaled fuel level from QQ14 divided by 4,
 LSR A                  \ so this can act as the circle's radius (70 being a
 JSR SCALEY             \ full tank, which divides down to a radius of 17)
 STA K

 LDA QQ0                \ Set QQ19 to the scaled x-coordinate of the current
 JSR SCALEX             \ system, which will be the centre of the circle and
 STA QQ19               \ crosshairs we draw

 LDA QQ1                \ Set QQ19+1 to the scled y-coordinate of the current
 JSR SCALEY             \ system, which will again be the centre of the circle
 STA QQ19+1             \ and crosshairs we draw

ELIF _NES_VERSION

 LDA QQ14               \ Set K = QQ14/4 - QQ14/16
 LSR A                  \       = 0.1875 * QQ14
 LSR A                  \
 STA K                  \ So K scales the fuel level in QQ14 to act as the
 LSR A                  \ circle's radius, scaling the fuel level from a range
 LSR A                  \ of 0 to 70 down to a range of 0 to 13, so the fuel
 STA T1                 \ circle has a maximum radius of 13 pixels on the
 LDA K                  \ Long-range Chart
 SEC
 SBC T1
 STA K

                        \ We now set the pixel coordinates of the crosshairs in
                        \ QQ9 and QQ9+1 so they fit into the chart, with a
                        \ 31-pixel margin on the left and an 8-pixel margin at
                        \ the top (to which we will add another 24 pixels below)
                        \
                        \ The Long-range Chart is twice as wide as it is high,
                        \ so we need to scale the y-coordinate in QQ19+1 by an
                        \ extra division by 2 when compared to the x-coordinate

 LDA QQ0                \ Set QQ19 = 31 + QQ9 - (QQ9 / 4)
 LSR A                  \          = 31 + 0.75 * QQ9
 LSR A                  \
 STA T1                 \ So this scales the x-coordinate from a range of 0 to
 LDA QQ0                \ 255 into a range from 31 to 222, so it fits nicely
 SEC                    \ into the Long-range Chart
 SBC T1
 CLC
 ADC #31
 STA QQ19

 LDA QQ1                \ Set QQ19+1 = 8 + (QQ10 - (QQ10 / 4)) / 2
 LSR A                  \            = 8 + 0.375 * QQ10
 LSR A                  \
 STA T1                 \ So this scales the y-coordinate from a range of 0 to
 LDA QQ1                \ 255 into a range from 8 to 127, so it fits nicely
 SEC                    \ into the Long-range Chart
 SBC T1
 LSR A
 CLC
 ADC #8
 STA QQ19+1

ENDIF

 LDA #7                 \ Set QQ19+2 = 7, the size of the crosshairs on the
 STA QQ19+2             \ Long-range Chart

IF _MASTER_VERSION \ Master: See group A

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ELIF _APPLE_VERSION

 LDA #GREEN             \ ???
 STA COL

ENDIF

 JSR TT15               \ Draw the set of crosshairs defined in QQ19, which will
                        \ be drawn 24 pixels to the right of QQ19+1

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: The Master version uses variables to define the size of the Long-range Chart

 LDA QQ19+1             \ Add GCYT to the y-coordinate of the crosshairs in
 CLC                    \ QQ19+1 so that the centre of the circle matches the
 ADC #GCYT              \ centre of the crosshairs
 STA QQ19+1

ELIF _CASSETTE_VERSION OR _DISC_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION OR _ELITE_A_VERSION

 LDA QQ19+1             \ Add 24 to the y-coordinate of the crosshairs in QQ19+1
 CLC                    \ so that the centre of the circle matches the centre
 ADC #24                \ of the crosshairs
 STA QQ19+1

ENDIF

                        \ Fall through into TT128 to draw a circle with the
                        \ centre at the same coordinates as the crosshairs,
                        \ (QQ19, QQ19+1), and radius K that reflects the
                        \ current fuel levels

