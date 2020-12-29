\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Implement the #DOdot command (draw a dot on the compass)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOdot command with parameters
\ in the block at OSSC(1 0). It draws a dot on the compass.
\
\ The parameters match those put into the DOTpars block in the parasite.
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The screen pixel x-coordinate of the dot
\
\                         * Byte #3 = The screen pixel x-coordinate of the dot
\
\                         * Byte #4 = The colour of the dot
\
\ ******************************************************************************

.DOT

 LDY #2                 \ Fetch byte #2 from the parameter block (the dot's
 LDA (OSSC),Y           \ x-coordinate) and store it in X1
 STA X1

 INY                    \ Fetch byte #3 from the parameter block (the dot's
 LDA (OSSC),Y           \ y-coordinate) and store it in X1
 STA Y1

 INY                    \ Fetch byte #3 from the parameter block (the dot's
 LDA (OSSC),Y           \ colour) and store it in COL
 STA COL

 CMP #WHITE2            \ If the dot's colour is not white, jump to CPIX2 to
 BNE CPIX2              \ draw a single-height dot in the compass, as it is
                        \ showing that the planet or station is behind us

                        \ Otherwise the dot is white, which is in front of us,
                        \ so fall through into CPIX4 to draw a double-height
                        \ dot in the compass

