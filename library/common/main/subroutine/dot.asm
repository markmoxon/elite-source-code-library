\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Comment
\    Summary: Draw a dot on the compass
ELIF _6502SP_VERSION
\    Summary: Implement the #DOdot command (draw a dot on the compass)
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Comment
\   COMX                The screen pixel x-coordinate of the dot
\
\   COMY                The screen pixel y-coordinate of the dot
\
\   COMC                The colour and thickness of the dot:
\
\                         * &F0 = a double-height dot in yellow/white, for when
\                           the object in the compass is in front of us
\
\                         * &FF = a single-height dot in green/cyan, for when
\                           the object in the compass is behind us
ELIF _6502SP_VERSION
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The screen pixel x-coordinate of the dot
\
\                         * Byte #3 = The screen pixel x-coordinate of the dot
\
\                         * Byte #4 = The colour of the dot
ENDIF
\
\ ******************************************************************************

.DOT

IF _MASTER_VERSION \ Platform

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA+&34 to switch screen memory into &3000-&7FFF

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Tube

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dot
 STA Y1

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dot
 STA X1

 LDA COMC               \ Set COL = COMC, the mode 5 colour byte for the dot
 STA COL

ELIF _MASTER_VERSION

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dot
 STA X1

 LDX COMC               \ Set COL = COMC, the mode 2 colour byte for the dot
 STX COL

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dot

ELIF _6502SP_VERSION

 LDY #2                 \ Fetch byte #2 from the parameter block (the dot's
 LDA (OSSC),Y           \ x-coordinate) and store it in X1
 STA X1

 INY                    \ Fetch byte #3 from the parameter block (the dot's
 LDA (OSSC),Y           \ y-coordinate) and store it in X1
 STA Y1

 INY                    \ Fetch byte #3 from the parameter block (the dot's
 LDA (OSSC),Y           \ colour) and store it in COL
 STA COL

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Screen

 CMP #&F0               \ If COL is &F0 then the dot is in front of us and we
 BNE CPIX2              \ want to draw a double-height dot, so if it isn't &F0
                        \ jump to CPIX2 to draw a single-height dot

                        \ Otherwise fall through into CPIX4 to draw a double-
                        \ height dot

ELIF _MASTER_VERSION

 CPX #&0F               \ ???
 BNE L1EA5

 JSR CPIX2

 LDA Y1
 DEC A

.L1EA5

 JSR CPIX2

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA+&34 to switch main memory back into &3000-&7FFF

 RTS

ELIF _6502SP_VERSION

 CMP #WHITE2            \ If the dot's colour is not white, jump to CPIX2 to
 BNE CPIX2              \ draw a single-height dot in the compass, as it is
                        \ showing that the planet or station is behind us

                        \ Otherwise the dot is white, which is in front of us,
                        \ so fall through into CPIX4 to draw a double-height
                        \ dot in the compass

ENDIF

