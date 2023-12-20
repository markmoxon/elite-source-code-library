\ ******************************************************************************
\
\       Name: NLIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line at pixel row 23 to box in a title
\
\ ------------------------------------------------------------------------------
\
\ Draw a horizontal line at pixel row 23 and move the text cursor down one
\ line.
\
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   NLIN5               Move the text cursor down one line before drawing the
\                       line
\
ENDIF
\ ******************************************************************************

.NLIN

 LDA #23                \ Set A = 23 so NLIN2 below draws a horizontal line at
                        \ pixel row 23

IF _MASTER_VERSION \ Label

.NLIN5

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 INC YC                 \ Move the text cursor down one line

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down one line

ENDIF

                        \ Fall through into NLIN2 to draw the horizontal line
                        \ at row 23

