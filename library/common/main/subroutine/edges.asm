\ ******************************************************************************
\
\       Name: EDGES
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line given a centre and a half-width
\
\ ------------------------------------------------------------------------------
\
\ Set X1 and X2 to the x-coordinates of the ends of the horizontal line with
\ centre x-coordinate YY(1 0), and length A in either direction from the centre
\ (so a total line length of 2 * A). In other words, this line:
\
\   X1             YY(1 0)             X2
\   +-----------------+-----------------+
\         <- A ->           <- A ->
\
\ The resulting line gets clipped to the edges of the screen, if needed. If the
\ calculation doesn't overflow, we return with the C flag clear, otherwise the C
\ flag gets set to indicate failure and the Y-th LSO entry gets set to 0.
\
\ Arguments:
\
\   A                   The half-length of the line
\
\   YY(1 0)             The centre x-coordinate
\
\ Returns:
\
\   C flag              Clear if the line fits on-screen, set if it doesn't
\
\   X1, X2              The x-coordinates of the clipped line
\
\   LSO+Y               If the line doesn't fit, LSO+Y is set to 0
\
\   Y                   Y is preserved
\
IF _DISC_DOCKED \ Comment
\ Other entry points:
\
\   PL44                Clear the C flag and return from the subroutine
\
ENDIF
\ ******************************************************************************

.EDGES

 STA T                  \ Set T to the line's half-length in argument A

 CLC                    \ We now calculate:
 ADC YY                 \
 STA X2                 \  (A X2) = YY(1 0) + A
                        \
                        \ to set X2 to the x-coordinate of the right end of the
                        \ line, starting with the low bytes

 LDA YY+1               \ And then adding the high bytes
 ADC #0

 BMI ED1                \ If the addition is negative then the calculation has
                        \ overflowed, so jump to ED1 to return a failure

 BEQ P%+6               \ If the high byte A from the result is 0, skip the
                        \ next two instructions, as the result already fits on
                        \ the screen

 LDA #254               \ The high byte is positive and non-zero, so we went
 STA X2                 \ past the right edge of the screen, so clip X2 to the
                        \ x-coordinate of the right edge of the screen

 LDA YY                 \ We now calculate:
 SEC                    \
 SBC T                  \   (A X1) = YY(1 0) - argument A
 STA X1                 \
                        \ to set X1 to the x-coordinate of the left end of the
                        \ line, starting with the low bytes

 LDA YY+1               \ And then subtracting the high bytes
 SBC #0

 BNE ED3                \ If the high byte subtraction is non-zero, then skip
                        \ to ED3

 CLC                    \ Otherwise the high byte of the subtraction was zero,
                        \ so the line fits on-screen and we clear the C flag to
                        \ indicate success

 RTS                    \ Return from the subroutine

.ED3

 BPL ED1                \ If the addition is positive then the calculation has
                        \ underflowed, so jump to ED1 to return a failure

 LDA #2                 \ The high byte is negative and non-zero, so we went
 STA X1                 \ past the left edge of the screen, so clip X1 to the
                        \ y-coordinate of the left edge of the screen

IF _DISC_DOCKED \ Label

.PL44

ENDIF

 CLC                    \ The line does fit on-screen, so clear the C flag to
                        \ indicate success

 RTS                    \ Return from the subroutine

.ED1

 LDA #0                 \ Set the Y-th byte of the LSO block to 0
 STA LSO,Y

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Minor

 SEC                    \ The line does not fit on the screen, so set the C flag
                        \ to indicate this result

 RTS                    \ Return from the subroutine

ELIF _DISC_DOCKED

                        \ The line does not fit on the screen, so fall through
                        \ into PL21 to set the C flag to indicate this result

ENDIF

