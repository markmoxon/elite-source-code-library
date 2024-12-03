\ ******************************************************************************
\
\       Name: NLIN3
\       Type: Subroutine
\   Category: Drawing lines
IF NOT(_NES_VERSION)
\    Summary: Print a title and draw a horizontal line at row 19 to box it in
\
\ ------------------------------------------------------------------------------
\
\ This routine print a text token at the cursor position and draws a horizontal
\ line at pixel row 19. It is used for the Status Mode screen, the Short-range
\ Chart, the Market Price screen and the Equip Ship screen.
ELIF _NES_VERSION
\    Summary: Print a title and draw a screen-wide horizontal line on tile row 2
\             to box it in
ENDIF
\
\ ******************************************************************************

.NLIN3

IF _NES_VERSION

 PHA                    \ Move the text cursor to row 0
 LDA #0
 STA YC
 PLA

ENDIF

IF NOT(_NES_VERSION)

 JSR TT27               \ Print the text token in A

                        \ Fall through into NLIN4 to draw a horizontal line at
                        \ pixel row 19

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A

                        \ Fall through into NLIN4 to draw a horizontal line at
                        \ pixel row 19

ENDIF

