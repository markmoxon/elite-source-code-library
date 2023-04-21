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
IF _DISC_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Comment
\ Other entry points:
\
\   PL44                Clear the C flag and return from the subroutine
\
ELIF _NES_VERSION
\ Other entry points:
\
\   EDGES-2             ???
\
ENDIF
\ ******************************************************************************

IF _NES_VERSION

.ED3

 BPL ED1
 LDA #0
 STA X1
 CLC
 RTS

.ED1

 SET_NAMETABLE_0        \ Switch the base nametable address to nametable 0

 SEC
 RTS

 BEQ ED1                \ ??? EDGES-2

ENDIF

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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #254               \ The high byte is positive and non-zero, so we went
 STA X2                 \ past the right edge of the screen, so clip X2 to the
                        \ x-coordinate of the right edge of the screen

ELIF _MASTER_VERSION

 LDA #255               \ The high byte is positive and non-zero, so we went
 STA X2                 \ past the right edge of the screen, so clip X2 to the
                        \ x-coordinate of the right edge of the screen

ELIF _NES_VERSION

 LDA #253               \ The high byte is positive and non-zero, so we went
 STA X2                 \ past the right edge of the screen, so clip X2 to the
                        \ x-coordinate of the right edge of the screen

ENDIF

 LDA YY                 \ We now calculate:
 SEC                    \
 SBC T                  \   (A X1) = YY(1 0) - argument A
 STA X1                 \
                        \ to set X1 to the x-coordinate of the left end of the
                        \ line, starting with the low bytes

 LDA YY+1               \ And then subtracting the high bytes
 SBC #0

IF NOT(_ELITE_A_FLIGHT) AND NOT(_NES_VERSION)

 BNE ED3                \ If the high byte subtraction is non-zero, then skip
                        \ to ED3

 CLC                    \ Otherwise the high byte of the subtraction was zero,
                        \ so the line fits on-screen and we clear the C flag to
                        \ indicate success

 RTS                    \ Return from the subroutine

.ED3

ELIF _ELITE_A_FLIGHT

 BEQ P%+8               \ If the high byte subtraction is zero, then skip the
                        \ following three instructions, as the line fits
                        \ on-screen and we want to clear the C flag and return
                        \ from the subroutine

ELIF _NES_VERSION

 BNE ED3                \ If the high byte subtraction is non-zero, then skip
                        \ to ED3

 LDA X1                 \ ???
 CMP X2

 RTS                    \ Return from the subroutine

ENDIF

IF NOT(_NES_VERSION)

 BPL ED1                \ If the addition is positive then the calculation has
                        \ underflowed, so jump to ED1 to return a failure

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #2                 \ The high byte is negative and non-zero, so we went
 STA X1                 \ past the left edge of the screen, so clip X1 to the
                        \ x-coordinate of the left edge of the screen

ELIF _MASTER_VERSION

 LDA #0                 \ The high byte is negative and non-zero, so we went
 STA X1                 \ past the left edge of the screen, so clip X1 to the
                        \ x-coordinate of the left edge of the screen

ENDIF

IF _DISC_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Label

.PL44

ENDIF

IF NOT(_NES_VERSION)

 CLC                    \ The line does fit on-screen, so clear the C flag to
                        \ indicate success

 RTS                    \ Return from the subroutine

.ED1

 LDA #0                 \ Set the Y-th byte of the LSO block to 0
 STA LSO,Y

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Minor

 SEC                    \ The line does not fit on the screen, so set the C flag
                        \ to indicate this result

 RTS                    \ Return from the subroutine

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

                        \ The line does not fit on the screen, so fall through
                        \ into PL21 to set the C flag to indicate this result

ENDIF

