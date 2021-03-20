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

 LDA #&AF               \ ???
 STA COL

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

 LDA QQ9                \ ???
 JSR L4A44

 STA QQ19
 LDA QQ10
 JSR L4A42
 STA QQ19+1

ENDIF

 LDA #4                 \ Set QQ19+2 to 4 denote crosshairs of size 4
 STA QQ19+2

 JMP TT15               \ Jump to TT15 to draw crosshairs of size 4 at the
                        \ crosshairs coordinates, returning from the subroutine
                        \ using a tail call

