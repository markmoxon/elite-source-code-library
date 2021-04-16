\ ******************************************************************************
\
\       Name: STARS
\       Type: Subroutine
\   Category: Stardust
\    Summary: The main routine for processing the stardust
\
\ ------------------------------------------------------------------------------
\
\ Called at the very end of the main flight loop.
\
\ ******************************************************************************

.STARS

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Screen

\LDA #&FF               \ These instructions are commented out in the original
\STA COL                \ source, but they would set the stardust colour to
                        \ white. That said, COL is only used when updating the
                        \ dashboard, so this would have no effect - perhaps it's
                        \ left over from experiments with a colour top part of
                        \ the screen? Who knows...


ELIF _MASTER_VERSION

 LDA #WHITE             \ Switch to white (i.e. cyan/red)
 STA COL

ENDIF

 LDX VIEW               \ Load the current view into X:
                        \
                        \   0 = front
                        \   1 = rear
                        \   2 = left
                        \   3 = right

 BEQ STARS1             \ If this 0, jump to STARS1 to process the stardust for
                        \ the front view

 DEX                    \ If this is view 2 or 3, jump to STARS2 (via ST11) to
 BNE ST11               \ process the stardust for the left or right views

 JMP STARS6             \ Otherwise this is the rear view, so jump to STARS6 to
                        \ process the stardust for the rear view

.ST11

 JMP STARS2             \ Jump to STARS2 for the left or right views, as it's
                        \ too far for the branch instruction above

