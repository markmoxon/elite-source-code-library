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

 LDA #104               \ Set QQ19 = 104, for the x-coordinate of the centre of
 STA QQ19               \ the fixed circle on the Short-range Chart

 LDA #90                \ Set QQ19+1 = 90, for the y-coordinate of the centre of
 STA QQ19+1             \ the fixed circle on the Short-range Chart

 LDA #16                \ Set QQ19+2 = 16, the size of the crosshairs on the
 STA QQ19+2             \ Short-range Chart

IF _MASTER_VERSION \ Master: Group A: The static chart crosshairs in the Master version are drawn with white/yellow vertical stripes (with the exception of the static crosshairs on the Long-range Chart, which are white). All crosshairs are white in the other versions

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

 JSR TT15               \ Draw the set of crosshairs defined in QQ19, at the
                        \ exact coordinates as this is the Short-range Chart

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group B: The Master version contains code to scale the chart views, though it has no effect in this version. The code is left over from the non-BBC versions, which needed to be able to scale the charts to fit their different-sized screens

 LDA QQ14               \ Set K to the fuel level from QQ14, so this can act as
 STA K                  \ the circle's radius (70 being a full tank)

ELIF _MASTER_VERSION

 LDA QQ14               \ Set K to the fuel level from QQ14, so this can act as
 JSR SCALEY2            \ the circle's radius (70 being a full tank)
 STA K                  \
                        \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines. This code is left over from the
                        \ conversion to other platforms, where the scale factor
                        \ might need to be different

ENDIF

 JMP TT128              \ Jump to TT128 to draw a circle with the centre at the
                        \ same coordinates as the crosshairs, (QQ19, QQ19+1),
                        \ and radius K that reflects the current fuel levels,
                        \ returning from the subroutine using a tail call

.TT14

IF _6502SP_VERSION \ Master: See group A

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ENDIF

 LDA QQ11               \ If the current view is the Short-range Chart, which
 BMI TT126              \ is the only view with bit 7 set, then jump up to TT126
                        \ to draw the crosshairs and circle for that view

                        \ Otherwise this is the Long-range Chart, so we draw the
                        \ crosshairs and circle for that view instead

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group B

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
                        \ scaling to be applied by altering the SCALE routines.
                        \ This code is left over from the conversion to other
                        \ platforms, where the scale factor might need to be
                        \ different

 LDA QQ0                \ Set QQ19 to the x-coordinate of the current system,
 JSR SCALEX             \ which will be the centre of the circle and crosshairs
 STA QQ19               \ we draw
                        \
                        \ The call to SCALEX has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines. This code is left over from the
                        \ conversion to other platforms, where the scale factor
                        \ might need to be different

 LDA QQ1                \ Set QQ19+1 to the y-coordinate of the current system,
 JSR SCALEY             \ halved because the galactic chart is half as high as
 STA QQ19+1             \ it is wide, which will again be the centre of the
                        \ circle and crosshairs we draw
                        \
                        \ Again, the call to SCALEY simply does an LSR A (see
                        \ the comment above)

ENDIF

 LDA #7                 \ Set QQ19+2 = 7, the size of the crosshairs on the
 STA QQ19+2             \ Long-range Chart

IF _MASTER_VERSION \ Master: See group A

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ENDIF

 JSR TT15               \ Draw the set of crosshairs defined in QQ19, which will
                        \ be drawn 24 pixels to the right of QQ19+1

 LDA QQ19+1             \ Add 24 to the y-coordinate of the crosshairs in QQ19+1
 CLC                    \ so that the centre of the circle matches the centre
 ADC #24                \ of the crosshairs
 STA QQ19+1

                        \ Fall through into TT128 to draw a circle with the
                        \ centre at the same coordinates as the crosshairs,
                        \ (QQ19, QQ19+1), and radius K that reflects the
                        \ current fuel levels

