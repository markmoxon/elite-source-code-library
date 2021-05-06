\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Draw a specific indicator in the dashboard's missile bar
ELIF _6502SP_VERSION
\    Summary: Implement the #DOmsbar command (draw a specific indicator in the
\             dashboard's missile bar)
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ Each indicator is a rectangle that's 3 pixels wide and 5 pixels high. If the
\ indicator is set to black, this effectively removes a missile.
ELIF _ELECTRON_VERSION
\ Each indicator is a rectangle that's 6 pixels wide and 5 pixels high. If the
\ indicator is set to black, this effectively removes a missile.
ENDIF
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
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
ELIF _ELECTRON_VERSION
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left, so indicator NOMSL is the leftmost
\                       indicator)
\
\   Y                   The status of the missile indicator:
\
\                         * &04 = black (no missile)
\
\                         * &11 = black "T" in white square (armed and locked)
\
\                         * &0D = black box in white square (armed)
\
\                         * &09 = white square (disarmed)
ELIF _MASTER_VERSION
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
\                         * #RED2 = red (armed and locked)
\
\                         * #YELLOW2 = yellow/white (armed)
\
\                         * #GREEN2 = green (disarmed)
ELIF _6502SP_VERSION
\ This routine is run when the parasite sends a #DOmsbar command with parameters
\ in the block at OSSC(1 0). It draws a specific indicator in the dashboard's
\ missile bar. The parameters match those put into the msbpars block in the
\ parasite.
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The number of the missile indicator to
\                           update (counting from right to left, so indicator
\                           NOMSL is the leftmost indicator)
\
\                         * Byte #3 = The colour of the missile indicator:
\
\                           * &00 = black (no missile)
\
\                           * #RED2 = red (armed and locked)
\
\                           * #YELLOW2 = yellow/white (armed)
\
\                           * #GREEN2 = green (disarmed)
ENDIF
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.MSBAR

IF _MASTER_VERSION \ Platform

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 TXA                    \ Store the value of X on the stack so we can preserve
 PHA                    \ it across the call to this subroutine

ENDIF

IF _6502SP_VERSION \ Tube

 LDY #2                 \ Fetch byte #2 from the parameter block (the number of
 LDA (OSSC),Y           \ the missile indicator) into A

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 TXA                    \ Set T = X * 8
 ASL A
 ASL A
 ASL A
 STA T

 LDA #49                \ Set SC = 49 - T
 SBC T                  \        = 48 + 1 - (X * 8)
 STA SC

ELIF _ELECTRON_VERSION

 TXA                    \ Store X on the stack, so we can preserve it across
 PHA                    \ the call to the subroutine

 ASL A                  \ Set T = X * 8
 ASL A
 ASL A
 STA T

 LDA #209               \ Set SC = &80 + 32 + 49 - T
 SBC T                  \        = &80 + 32 + 48 + 1 - (X * 8)
 STA SC                 \
                        \ The &80 part comes from the fact that the character
                        \ row containing the missile starts at address &7D80,
                        \ and the low byte of this is &80
                        \
                        \ The 32 part comes from the 32-byte blank border to
                        \ the left of the screen
                        \
                        \ And the 48 part is from character block 7, which is
                        \ the character block containing the missile indicators

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ Set T = A * 8
 ASL A
 ASL A
 ASL A
 STA T

 LDA #97                \ Set SC = 97 - T
 SBC T                  \        = 96 + 1 - (X * 8)
 STA SC

ENDIF

                        \ So the low byte of SC(1 0) contains the row address
                        \ for the rightmost missile indicator, made up as
                        \ follows:
                        \
IF _ELECTRON_VERSION \ Comment
                        \   * &80 + 32 as described above
                        \
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
                        \   * 48 (character block 7, as byte #7 * 8 = 48), the
ELIF _6502SP_VERSION OR _MASTER_VERSION
                        \   * 96 (character block 14, as byte #14 * 8 = 96), the
ENDIF
                        \     character block of the rightmost missile
                        \
                        \   * 1 (so we start drawing on the second row of the
                        \     character block)
                        \
                        \   * Move right one character (8 bytes) for each count
                        \     of X, so when X = 0 we are drawing the rightmost
                        \     missile, for X = 1 we hop to the left by one
                        \     character, and so on

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 LDA #&7E               \ Set the high byte of SC(1 0) to &7E, the character row
 STA SCH                \ that contains the missile indicators (i.e. the bottom
                        \ row of the screen)

ELIF _ELECTRON_VERSION

 LDA #&7D               \ Set the high byte of SC(1 0) to &7D, the high byte of
 STA SCH                \ &7D80, which is the start of the character row that
                        \ contains the missile indicators (i.e. the bottom row
                        \ of the screen)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #&7C               \ Set the high byte of SC(1 0) to &7C, the character row
 STA SCH                \ that contains the missile indicators (i.e. the bottom
                        \ row of the screen)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Electron: Group A: The monochrome dashboard can't use colour to indicate the status of the missiles, so instead the Electron version uses four different bitmaps - black (no missile), white box (disarmed), black box in white square (armed), and black "T" in white square (armed and locked)

 TYA                    \ Set A to the correct colour, which is a 3-pixel wide
                        \ mode 5 character row in the correct colour (for
                        \ example, a green block has Y = &EE, or %11101110, so
                        \ the missile blocks are 3 pixels wide, with the
                        \ fourth pixel on the character row being empty)

ELIF _ELECTRON_VERSION

 TYA                    \ Set X to the indicator status that was passed to the
 TAX                    \ subroutine, so we can use it below as an index into
                        \ the MDIALS table when fetching the bitmap to set the
                        \ missile indicator to

ENDIF

IF _6502SP_VERSION \ Screen

 LDY #3                 \ Fetch byte #2 from the parameter block (the indicator
 LDA (OSSC),Y           \ colour) into A. This is one of #GREEN2, #YELLOW2 or
                        \ #RED2, or 0 for black, so this is a 2-pixel wide mode
                        \ 2 character row byte in the specified colour

ELIF _MASTER_VERSION

 TYA                    \ Set A to the correct colour, which is a 2-pixel wide
                        \ mode 2 character row byte in the specified colour

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDY #5                 \ We now want to draw this line five times to do the
                        \ left two pixels of the indicator, so set a counter in
                        \ Y

.MBL1

 STA (SC),Y             \ Draw the 3-pixel row, and as we do not use EOR logic,
                        \ this will overwrite anything that is already there
                        \ (so drawing a black missile will delete what's there)

 DEY                    \ Decrement the counter for the next row

 BNE MBL1               \ Loop back to MBL1 if have more rows to draw

 PHA                    \ Store the value of A on the stack so we can retrieve
                        \ it after the following addition

 LDA SC                 \ Set SC = SC + 8
 CLC                    \
 ADC #8                 \ so SC(1 0) now points to the next character block on
 STA SC                 \ the row (for the right half of the indicator)

 PLA                    \ Retrieve A from the stack

 AND #%10101010         \ Mask the character row to plot just the first pixel
                        \ in the next character block, as we already did a
                        \ two-pixel wide band in the previous character block,
                        \ so we need to plot just one more pixel, width-wise

ENDIF

 LDY #5                 \ We now want to draw this line five times, so set a
                        \ counter in Y

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Label

.MBL1

ELIF _6502SP_VERSION OR _MASTER_VERSION

.MBL2

ENDIF

IF _ELECTRON_VERSION \ Electron: See group A

 LDA MDIALS,X           \ Fetch the X-th bitmap from the MDIALS table

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment

 STA (SC),Y             \ Draw the 3-pixel row, and as we do not use EOR logic,
ELIF _6502SP_VERSION OR _MASTER_VERSION

 STA (SC),Y             \ Draw the 1-pixel row, and as we do not use EOR logic,
ENDIF
                        \ this will overwrite anything that is already there
                        \ (so drawing a black missile will delete what's there)

IF _ELECTRON_VERSION \ Electron: See group A

 DEX                    \ Decrement the bitmap counter for the next row

ENDIF

 DEY                    \ Decrement the counter for the next row

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Label

 BNE MBL1               \ Loop back to MBL1 if have more rows to draw

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BNE MBL2               \ Loop back to MBL2 if have more rows to draw

ENDIF

IF _MASTER_VERSION \ Platform

 PLX                    \ Restore X from the stack, so that it's preserved

IF _SNG47

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

ELIF _COMPACT

 JMP $1F6B              \ ???

ENDIF

ELIF _ELECTRON_VERSION

 PLA                    \ Restore X from the stack, so that it's preserved
 TAX

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

IF _SNG47

 RTS                    \ Return from the subroutine

ENDIF

ENDIF

