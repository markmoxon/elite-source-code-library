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

IF _MASTER_VERSION

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

 LDA QQ11               \ Fetch the current view type into A

IF _CASSETTE_VERSION \ Other: The cassette version doesn't draw crosshairs in routine TT103 if this is a space view, but the other versions don't do this check, so perhaps it isn't required?

 BEQ TT180              \ If this is a space view, return from the subroutine
                        \ (as TT180 contains an RTS), as there are no moveable
                        \ crosshairs in space

ENDIF

 BMI TT105              \ If this is the Short-range Chart screen, jump to TT105

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDA QQ9                \ Store the crosshairs x-coordinate in QQ19
 STA QQ19

 LDA QQ10               \ Halve the crosshairs y-coordinate and store it in QQ19
 LSR A                  \ (we halve it because the Long-range Chart is half as
 STA QQ19+1             \ high as it is wide)

ELIF _MASTER_VERSION

 LDA QQ9                \ Store the crosshairs x-coordinate in QQ19
 JSR LSR3               \
 STA QQ19               \ The call to LSR3 has no effect as it only contains an
                        \ RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the LSR routines, so perhaps this is code left over
                        \ from the conversion to other platforms, where the
                        \ scale factor might need to be different


 LDA QQ10               \ Halve the crosshairs y-coordinate and store it in QQ19
 JSR LSR1               \ (we halve it because the Long-range Chart is half as
 STA QQ19+1             \ high as it is wide)
                        \
                        \ The call to LSR1 simply does an LSR A, but having this
                        \ call instruction here would enable different scaling
                        \ to be applied by altering the LSR routines, so perhaps
                        \ this is code left over from the conversion to other
                        \ platforms, where the scale factor might need to be
                        \ different

ENDIF

 LDA #4                 \ Set QQ19+2 to 4 denote crosshairs of size 4
 STA QQ19+2

 JMP TT15               \ Jump to TT15 to draw crosshairs of size 4 at the
                        \ crosshairs coordinates, returning from the subroutine
                        \ using a tail call

