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
\ ******************************************************************************

.NLIN

 LDA #23                \ Set A = 23 so NLIN2 below draws a horizontal line at
                        \ pixel row 23

IF _CASSETTE_VERSION OR _DISC_VERSION

 INC YC                 \ Move the text cursor down one line

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down one line

ENDIF

                        \ Fall through into NLIN2 to draw the horizontal line
                        \ at row 23

