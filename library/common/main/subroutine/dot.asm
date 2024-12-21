\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Draw a dash on the compass
ELIF _6502SP_VERSION
\    Summary: Implement the #DOdot command (draw a dash on the compass)
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   COMX                The screen pixel x-coordinate of the dash
\
\   COMY                The screen pixel y-coordinate of the dash
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
\   COMC                The colour and thickness of the dash:
\
\                         * &F0 = a double-height dash in yellow/white, for when
\                           the object in the compass is in front of us
\
\                         * &FF = a single-height dash in green/cyan, for when
\                           the object in the compass is behind us
ELIF _ELECTRON_VERSION
\   COMC                The thickness of the dash:
\
\                         * &F0 = a double-height dash in white, for when the
\                           object in the compass is in front of us
\
\                         * &FF = a single-height dash in white, for when the
\                           object in the compass is behind us
ELIF _6502SP_VERSION
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The screen pixel x-coordinate of the dash
\
\                         * Byte #3 = The screen pixel x-coordinate of the dash
\
\                         * Byte #4 = The colour of the dash
ELIF _C64_VERSION
\   COMC                The colour and thickness of the dash:
\
\                         * #YELLOW = a double-height dash in yellow, for when
\                           the object in the compass is in front of us
\
\                         * #GREEN = a single-height dash in green, for when
\                           the object in the compass is behind us
ELIF _APPLE_VERSION
\   COMC                The colour and thickness of the dash: ???
\
\                         * &F0 = a double-height dash in yellow/white, for when
\                           the object in the compass is in front of us
\
\                         * &FF = a single-height dash in green/cyan, for when
\                           the object in the compass is behind us
ENDIF
\
\ ******************************************************************************

.DOT

IF _MASTER_VERSION \ Platform

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Tube

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dash
 STA Y1

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dash
 STA X1

 LDA COMC               \ Set COL = COMC, the mode 5 colour byte for the dash
 STA COL

ELIF _ELECTRON_VERSION

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dash
 STA Y1

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dash
 STA X1

 LDA COMC               \ Set A = COMC, the thickness of the dash

ELIF _MASTER_VERSION

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dash
 STA X1

 LDX COMC               \ Set COL = COMC, the mode 2 colour byte for the dash
 STX COL

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dash

ELIF _6502SP_VERSION

 LDY #2                 \ Fetch byte #2 from the parameter block (the dash's
 LDA (OSSC),Y           \ x-coordinate) and store it in X1
 STA X1

 INY                    \ Fetch byte #3 from the parameter block (the dash's
 LDA (OSSC),Y           \ y-coordinate) and store it in X1
 STA Y1

 INY                    \ Fetch byte #3 from the parameter block (the dash's
 LDA (OSSC),Y           \ colour) and store it in COL
 STA COL

ELIF _C64_VERSION

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dash
 STA Y1

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dash
 STA X1

 LDA COMC               \ Set COL = COMC, the colour byte for the dash
 STA COL

ELIF _APPLE_VERSION

 LDA COMC               \ ???
 BEQ COR1
 STA ZZ

 LDA COMY               \ Set A = COMY, the y-coordinate of the dash

 LDX COMX               \ Set X = COMX, the x-coordinate of the dash

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Screen

 CMP #&F0               \ If COL is &F0 then the planet/station is in front of
 BNE CPIX2              \ us and we want to draw a double-height dash, so if it
                        \ isn't &F0 jump to CPIX2 to draw a single-height dash

                        \ Otherwise fall through into CPIX4 to draw a double-
                        \ height dash

ELIF _ELECTRON_VERSION

 CMP #&F0               \ If COMC is &F0 then the planet/station is in front of
 BNE CPIX2              \ us and we want to draw a double-height dash, so if it
                        \ isn't &F0 jump to CPIX2 to draw a single-height dash

                        \ Otherwise fall through into CPIX4 to draw a double-
                        \ height dash

ELIF _MASTER_VERSION

 CPX #YELLOW2           \ If the colour in X is yellow, then the planet/station
 BNE P%+8               \ is behind us, so skip the following three instructions
                        \ so we only draw a single-height dash

 JSR CPIXK              \ Call CPIXK to draw a single-height dash, i.e. the top
                        \ row of a double-height dash

 LDA Y1                 \ Fetch the y-coordinate of the row we just drew and
 DEC A                  \ decrement it, ready to draw the bottom row

.DOT2

 JSR CPIXK              \ Call CPIXK to draw a single-height dash

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 CMP #WHITE2            \ If the dash's colour is not white, jump to CPIX2 to
 BNE CPIX2              \ draw a single-height dash in the compass, as it is
                        \ showing that the planet or station is behind us

                        \ Otherwise the dash is white, which is in front of us,
                        \ so fall through into CPIX4 to draw a double-height
                        \ dash in the compass

ELIF _C64_VERSION

 CMP #YELLOW            \ If the dash's colour is not yellow, jump to CPIX2 to
 BNE CPIX2              \ draw a single-height dash in the compass, as it is
                        \ showing that the planet or station is behind us

                        \ Otherwise the dash is yellow, which is in front of us,
                        \ so fall through into CPIX4 to draw a double-height
                        \ dash in the compass

ELIF _APPLE_VERSION

 JMP PIXEL              \ ???

ENDIF

