\ ******************************************************************************
\
\       Name: GRS1
\       Type: Subroutine
\   Category: Demo
\    Summary: Populate the line coordinate tables with the lines for a single
\             scroll text character
\
\ ------------------------------------------------------------------------------
\
\ This routine populates the X-th byte in the X1TB, Y1TB, X2TB and Y2TB tables
\ (the TB tables) with the coordinates for the lines that make up the character
\ whose definition is given in A.
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

 AND #%00001111         \ Set A to bits 0-3 of the LTDEF table value, i.e the
                        \ low nibble

 STY P                  \ Store the offset in P, so we can preserve it through
                        \ calls to GRS1

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

 LDA YP                 \ Set Y2TB+X = YP - NOFY+Y
 SEC                    \
 SBC NOFY,Y             \ so the Y2 coordinate is YP - the NOFY entry given by
 STA Y2TB,X             \ the high nibble of the LTDEF table value

 INX                    \ Increment the byte pointer in X

 LDY P                  \ Restore Y from P so it gets preserved through calls to
                        \ GRS1

.GRR1

 RTS                    \ Return from the subroutine

