\ ******************************************************************************
\
\       Name: GRS1
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Demo
ELIF _NES_VERSION
\   Category: Combat demo
ENDIF
\    Summary: Populate the line coordinate tables with the lines for a single
\             scroll text character
\  Deep dive: The 6502 Second Processor demo mode
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ This routine populates the X-th byte in the X1TB, Y1TB, X2TB and Y2TB tables
\ (the TB tables) with the coordinates for the lines that make up the character
\ whose definition is given in A.
ELIF _NES_VERSION
\ This routine populates the X-th byte in the X1TB, Y1TB and X2TB tables (the TB
\ tables) with the coordinates for the lines that make up the character whose
\ definition is given in A.
ENDIF
\
\ Arguments:
\
\   A                   The value from the LTDEF table for the character
\
\   (XP, YP)            The coordinate where we should draw this character
\
\   X                   The index of the character within the scroll text
\
\ Returns:
\
\   X                   X gets incremented to point to the next character
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.GRS1

 BEQ GRR1               \ If A = 0, jump to GRR1 to return from the subroutine
                        \ as 0 denotes no line segment

 STA R                  \ Store the value from the LTDEF table in R

IF NOT(_NES_VERSION)

 AND #%00001111         \ Set A to bits 0-3 of the LTDEF table value, i.e. the
                        \ low nibble

ENDIF

 STY P                  \ Store the offset in P, so we can preserve it through
                        \ calls to GRS1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

.gris1

 LDA Y1TB,X             \ If the Y1 coordinate for character X is zero then it
 BEQ gris2              \ is empty and can be used, so jump to gris2 to get on
                        \ with the calculation

 INX                    \ Otherwise increment the byte pointer in X to check the
                        \ next entry in the coordinate table

 CPX #240               \ If X <> 240 then we have not yet reached the end of
 BNE gris1              \ the coordinate table (as each of the X1TB, X2TB and
                        \ Y1TB tables is 240 bytes long), so loop back to gris1
                        \ to check the next entry to see if it is free

 LDX #0                 \ Otherwise set X = 0 so we wrap around to the start of
                        \ the table

.gris2

 LDA R                  \ Set A to bits 0-3 of the LTDEF table value, i.e. the
 AND #%00001111         \ low nibble

ENDIF

 TAY                    \ Set Y = A

 LDA NOFX,Y             \ Set X1TB+X = XP + NOFX+Y
 CLC                    \
 ADC XP                 \ so the X1 coordinate is XP + the NOFX entry given by
 STA X1TB,X             \ the low nibble of the LTDEF table value

 LDA YP                 \ Set Y1TB+X = YP - NOFY+Y
 SEC                    \
 SBC NOFY,Y             \ so the Y1 coordinate is YP - the NOFY entry given by
 STA Y1TB,X             \ the low nibble of the LTDEF table value

 LDA R                  \ Set Y to bits 4-7 of the LTDEF table value, i.e. the
 LSR A                  \ high nibble
 LSR A
 LSR A
 LSR A
 TAY

 LDA NOFX,Y             \ Set X2TB+X = XP + NOFX+Y
 CLC                    \
 ADC XP                 \ so the X2 coordinate is XP + the NOFX entry given by
 STA X2TB,X             \ the high nibble of the LTDEF table value

IF NOT(_NES_VERSION)

 LDA YP                 \ Set Y2TB+X = YP - NOFY+Y
 SEC                    \
 SBC NOFY,Y             \ so the Y2 coordinate is YP - the NOFY entry given by
 STA Y2TB,X             \ the high nibble of the LTDEF table value

 INX                    \ Increment the byte pointer in X

ELIF _NES_VERSION

 LDA YP                 \ Set A = YP - NOFY+Y
 SEC                    \
 SBC NOFY,Y             \ so the value in A is YP - the NOFY entry given by the
                        \ high nibble of the LTDEF table value

 ASL A                  \ Shift the result from the low nibble of A into the top
 ASL A                  \ nibble
 ASL A
 ASL A

 ORA Y1TB,X             \ Stick the result into the top nibble of Y1TB+X, so
 STA Y1TB,X             \ the Y1TB coordinate contains both y-coordinates, with
                        \ Y1 in the low nibble and Y2 in the high nibble

ENDIF

 LDY P                  \ Restore Y from P so it gets preserved through calls to
                        \ GRS1

.GRR1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 RTS                    \ Return from the subroutine

