\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ------------------------------------------------------------------------------
\
\ Each indicator is a rectangle that's 3 pixels wide and 5 pixels high. If the
\ indicator is set to black, this effectively removes a missile.
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left, so indicator NOMSL is the leftmost
\                       indicator)
\
\   Y                   The colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
\
\ Returns:
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.MSBAR

IF _CASSETTE_VERSION

 TXA                    \ Set T = X * 8
 ASL A
 ASL A
 ASL A
 STA T

 LDA #49                \ Set SC = 49 - T
 SBC T                  \        = 48 + 1 - (X * 8)
 STA SC

ELIF _6502SP_VERSION

 LDY #2
 LDA (OSSC),Y
 ASL A
 ASL A
 ASL A
 ASL A
 STA T

 LDA #97
 SBC T
 STA SC

ENDIF

                        \ So the low byte of SC(1 0) contains the row address
                        \ for the rightmost missile indicator, made up as
                        \ follows:
                        \
                        \   * 48 (character block 7, or byte #7 * 8 = 48, which
                        \     is the character block of the rightmost missile
                        \
                        \   * 1 (so we start drawing on the second row of the
                        \     character block)
                        \
                        \   * Move right one character (8 bytes) for each count
                        \     of X, so when X = 0 we are drawing the rightmost
                        \     missile, for X = 1 we hop to the left by one
                        \     character, and so on

IF _CASSETTE_VERSION

 LDA #&7E               \ Set the high byte of SC(1 0) to &7E, the character row
 STA SCH                \ that contains the missile indicators (i.e. the bottom
                        \ row of the screen)

 TYA                    \ Set A to the correct colour, which is a 3-pixel wide
                        \ mode 5 character row in the correct colour (for
                        \ example, a green block has Y = &EE, or %11101110, so
                        \ the missile blocks are 3 pixels wide, with the
                        \ fourth pixel on the character row being empty)

ELIF _6502SP_VERSION

 LDA #&7C
 STA SCH
 LDY #3
 LDA (OSSC),Y
 LDY #5

.MBL1

 STA (SC),Y
 DEY
 BNE MBL1
 PHA
 LDA SC
 CLC
 ADC #8
 STA SC
 PLA
 AND #&AA

ENDIF

 LDY #5                 \ We now want to draw this line five times, so set a
                        \ counter in Y

IF _CASSETTE_VERSION

.MBL1

ELIF _6502SP_VERSION

.MBL2

ENDIF

 STA (SC),Y             \ Draw the 3-pixel row, and as we do not use EOR logic,
                        \ this will overwrite anything that is already there
                        \ (so drawing a black missile will delete what's there)

 DEY                    \ Decrement the counter for the next row

IF _CASSETTE_VERSION

 BNE MBL1               \ Loop back to MBL1 if have more rows to draw

ELIF _6502SP_VERSION

 BNE MBL2

ENDIF

 RTS                    \ Return from the subroutine

