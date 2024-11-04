\ ******************************************************************************
\
\       Name: TT103
\       Type: Subroutine
\   Category: Charts
\    Summary: Draw a small set of crosshairs on a chart
\
\ ------------------------------------------------------------------------------
\
\ Draw a small set of crosshairs on a galactic chart at the coordinates in
\ (QQ9, QQ10).
\
\ ******************************************************************************

.TT103

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: The moveable chart crosshairs in the Master version are drawn with white/yellow vertical stripes (with the exception of the static crosshairs on the Long-range Chart, which are white). All crosshairs are white in the other versions

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

 LDA QQ11               \ Fetch the current view type into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Other: The cassette version doesn't draw crosshairs in routine TT103 if this is a space view, but the other versions don't do this check, so perhaps it isn't required?

 BEQ TT180              \ If this is a space view, return from the subroutine
                        \ (as TT180 contains an RTS), as there are no moveable
                        \ crosshairs in space

ENDIF

 BMI TT105              \ If this is the Short-range Chart screen, jump to TT105

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: Master version contains code to scale the crosshairs on the chart views, though it has no effect in this version. The code is left over from the Apple II version, which uses a different scale

 LDA QQ9                \ Store the crosshairs x-coordinate in QQ19
 STA QQ19

 LDA QQ10               \ Halve the crosshairs y-coordinate and store it in QQ19
 LSR A                  \ (we halve it because the Long-range Chart is half as
 STA QQ19+1             \ high as it is wide)

ELIF _MASTER_VERSION

 LDA QQ9                \ Store the crosshairs x-coordinate in QQ19
 JSR SCALEX             \
 STA QQ19               \ The call to SCALEX has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 LDA QQ10               \ Halve the crosshairs y-coordinate and store it in QQ19
 JSR SCALEY             \ (we halve it because the Long-range Chart is half as
 STA QQ19+1             \ high as it is wide)
                        \
                        \ The call to SCALEY simply does an LSR A, but having
                        \ this call instruction here would enable different
                        \ scaling to be applied by altering the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 LDA QQ9                \ Store the scaled crosshairs x-coordinate in QQ19
 JSR SCALEX
 STA QQ19

 LDA QQ10               \ Store the scaled crosshairs y-coordinate and in QQ19
 JSR SCALEY
 STA QQ19+1

ENDIF

 LDA #4                 \ Set QQ19+2 to 4 denote crosshairs of size 4
 STA QQ19+2

 JMP TT15               \ Jump to TT15 to draw crosshairs of size 4 at the
                        \ crosshairs coordinates, returning from the subroutine
                        \ using a tail call

