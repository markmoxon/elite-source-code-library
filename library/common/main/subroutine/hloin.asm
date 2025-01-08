\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Comment
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
ELIF _6502SP_VERSION
\    Summary: Implement the OSWORD 247 command (draw the sun lines in the
\             horizontal line buffer in orange)
ELIF _ELITE_A_6502SP_IO
\    Summary: Implement the draw_hline command (draw a horizontal line
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\  Deep dive: Drawing monochrome pixels on the BBC Micro
ELIF _MASTER_VERSION
\  Deep dive: Drawing colour pixels on the BBC Micro
ELIF _C64_VERSION
\  Deep dive: Drawing pixels in the Commodore 64 version
ENDIF
\
IF NOT(_C64_VERSION)
\ ------------------------------------------------------------------------------
\
ENDIF
IF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a draw_hline command. It draws a
\ horizontal line.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ We do not draw a pixel at the right end of the line.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
ELIF _MASTER_VERSION
\ This routine draws a horizontal orange line in the space view.
\
\ We do not draw a pixel at the right end of the line.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   HLOIN3              Draw a line from (X, Y1) to (X2, Y1) in the colour given
\                       in A
\
ELIF _6502SP_VERSION
\ This routine is run when the parasite sends an OSWORD 247 command with
\ parameters in the block at OSSC(1 0). It draws a horizontal orange line (or a
\ collection of lines) in the space view.
\
\ The parameters match those put into the HBUF block in the parasite. Each line
\ is drawn from (X1, Y1) to (X2, Y1), and lines are drawn in orange.
\
\ We do not draw a pixel at the right end of the line.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #0 = The size of the parameter block being sent
\
\                         * Byte #2 = The x-coordinate of the first line's
\                                     starting point
\
\                         * Byte #3 = The x-coordinate of the first line's end
\                                     point
\
\                         * Byte #4 = The y-coordinate of the first line
\
\                         * Byte #5 = The x-coordinate of the second line's
\                                     starting point
\
\                         * Byte #6 = The x-coordinate of the second line's end
\                                     point
\
\                         * Byte #7 = The y-coordinate of the second line
\
\                       and so on
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   HLOIN3              Draw a line from (X1, Y1) to (X2, Y1) in the current
\                       colour (we need to set Q = Y2 + 1 before calling
\                       HLOIN3 so only one line is drawn)
\
ENDIF
\ ******************************************************************************

.HLOIN

IF _ELITE_A_6502SP_IO

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA X1                 \
 JSR tube_get           \   draw_hline(x1, y1, x2)
 STA Y1                 \
 JSR tube_get           \ and store them as follows:
 STA X2                 \
                        \   * X1 = the start point's x-coordinate
                        \
                        \   * Y1 = the horizontal line's y-coordinate
                        \
                        \   * X2 = the end point's x-coordinate

 LDX X1                 \ Set X = X1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Electron: Group A: The Electron doesn't have a dedicated routine for drawing horizontal lines, unlike the other versions; instead, it just uses the normal line-drawing routine, and sets the y-coordinates to be the same

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDX X1                 \ Set X = X1

ELIF _ELECTRON_VERSION

 LDX Y1                 \ Set Y2 = Y1, so we can use the normal line-drawing
 STX Y2                 \ routine to draw a horizontal line

ELIF _MASTER_VERSION

 LDA Y1                 \ Set A = Y1, the pixel y-coordinate of the line

ELIF _6502SP_VERSION

 LDY #0                 \ Fetch byte #0 from the parameter block (which gives
 LDA (OSSC),Y           \ size of the parameter block) and store it in Q
 STA Q

 INY                    \ Increment Y to point to byte #2, which is where the
 INY                    \ line coordinates start

.HLLO

 LDA (OSSC),Y           \ Fetch the Y-th byte from the parameter block (the
 STA X1                 \ line's X1 coordinate) and store it in X1 and X
 TAX

 INY                    \ Fetch the Y+1-th byte from the parameter block (the
 LDA (OSSC),Y           \ line's X2 coordinate) and store it in X2
 STA X2

 INY                    \ Fetch the Y+2-th byte from the parameter block (the
 LDA (OSSC),Y           \ line's Y1 coordinate) and store it in Y1
 STA Y1

 STY Y2                 \ Store the parameter block offset for this line's Y1
                        \ coordinate in Y2, so we know where to fetch the next
                        \ line from in the parameter block once we have drawn
                        \ this one

ENDIF

IF _MASTER_VERSION \ Screen

 AND #3                 \ Set A to the correct order of red/yellow pixels to
 TAX                    \ make this line an orange colour (by using bits 0-1 of
 LDA orange,X           \ the pixel y-coordinate as the index into the orange
                        \ lookup table)

 STA COL                \ Store the correct orange colour in COL

.HLOIN3

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDY #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STY VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 LDX X1                 \ Set X = X1

ELIF _6502SP_VERSION

 AND #3                 \ Set A to the correct order of red/yellow pixels to
 TAY                    \ make this line an orange colour (by using bits 0-1 of
 LDA orange,Y           \ the pixel y-coordinate as the index into the orange
                        \ lookup table)

.HLOIN3

 STA S                  \ Store the line colour in S

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 CPX X2                 \ If X1 = X2 then the start and end points are the same,
 BEQ HL6                \ so return from the subroutine (as HL6 contains an RTS)

 BCC HL5                \ If X1 < X2, jump to HL5 to skip the following code, as
                        \ (X1, Y1) is already the left point

 LDA X2                 \ Swap the values of X1 and X2, so we know that (X1, Y1)
 STA X1                 \ is on the left and (X2, Y1) is on the right
 STX X2

 TAX                    \ Set X = X1

.HL5

 DEC X2                 \ Decrement X2 so we do not draw a pixel at the end
                        \ point

ELIF _6502SP_VERSION

 CPX X2                 \ If X1 = X2 then the start and end points are the same,
 BEQ HL6                \ so jump to HL6 to move on to the next line

 BCC HL5                \ If X1 < X2, jump to HL5 to skip the following code, as
                        \ (X1, Y1) is already the left point

 LDA X2                 \ Swap the values of X1 and X2, so we know that (X1, Y1)
 STA X1                 \ is on the left and (X2, Y1) is on the right
 STX X2

 TAX                    \ Set X = X1

.HL5

 DEC X2                 \ Decrement X2 so we do not draw a pixel at the end
                        \ point

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA Y1                 \ Set A = Y1 / 8, so A now contains the character row
 LSR A                  \ that will contain our horizontal line
 LSR A
 LSR A

 ORA #&60               \ As A < 32, this effectively adds &60 to A, which gives
                        \ us the screen address of the character row (as each
                        \ character row takes up 256 bytes, and the first
                        \ character row is at screen address &6000, or page &60)

 STA SCH                \ Store the page number of the character row in SCH, so
                        \ the high byte of SC is set correctly for drawing our
                        \ line

 LDA Y1                 \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our line (as
                        \ each character block has 8 rows)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY Y1                 \ Look up the page number of the character row that
 LDA ylookup,Y          \ contains the pixel with the y-coordinate in Y1, and
 STA SC+1               \ store it in SC+1, so the high byte of SC is set
                        \ correctly for drawing our line

 TYA                    \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our line (as
                        \ each character block has 8 rows)

ELIF _C64_VERSION

 LDA Y1                 \ Set the low byte of SC(1 0) to Y1 mod 8, which is the
 TAY                    \ pixel row within the character block at which we want
 AND #7                 \ to draw our line (as each character block has 8 rows)
 STA SC

 LDA ylookuph,Y         \ Set the top byte of SC(1 0) to the address of the
 STA SC+1               \ start of the character row to draw in, from the
                        \ ylookup table

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 STA SC                 \ Store this value in SC, so SC(1 0) now contains the
                        \ screen address of the far left end (x-coordinate = 0)
                        \ of the horizontal pixel row that we want to draw our
                        \ horizontal line on

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 TXA                    \ Set Y = bits 3-7 of X1
 AND #%11111000
 TAY

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TXA                    \ Set Y = 2 * bits 2-6 of X1
 AND #%11111100         \
 ASL A                  \ and shift bit 7 of X1 into the C flag
 TAY

 BCC P%+4               \ If bit 7 of X1 was set, so X1 > 127, increment the
 INC SC+1               \ high byte of SC(1 0) to point to the second page on
                        \ this screen row, as this page contains the right half
                        \ of the row

ELIF _C64_VERSION

 TXA                    \ Set A = bits 3-7 of X1
 AND #%11111000

 CLC                    \ The ylookup table lets us look up the 16-bit address
 ADC ylookupl,Y         \ of the start of a character row containing a specific
 TAY                    \ pixel, so this fetches the address for the start of
                        \ the character row containing the y-coordinate in Y,
                        \ and adds it to the row offset we just calculated in A,
                        \ storing the result in Y

 BCC P%+4               \ If the addition overflowed, increment the high byte
 INC SC+1               \ of SC(1 0), so SC(1 0) + Y gives us the correct
                        \ address of the start of the line

ENDIF

.HL1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 TXA                    \ Set T = bits 3-7 of X1, which will contain the
 AND #%11111000         \ character number of the start of the line * 8
 STA T

 LDA X2                 \ Set A = bits 3-7 of X2, which will contain the
 AND #%11111000         \ character number of the end of the line * 8

 SEC                    \ Set A = A - T, which will contain the number of
 SBC T                  \ character blocks we need to fill - 1 * 8

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TXA                    \ Set T = bits 2-7 of X1, which will contain the
 AND #%11111100         \ character number of the start of the line * 4
 STA T

 LDA X2                 \ Set A = bits 2-7 of X2, which will contain the
 AND #%11111100         \ character number of the end of the line * 4

 SEC                    \ Set A = A - T, which will contain the number of
 SBC T                  \ character blocks we need to fill - 1 * 4

ELIF _C64_VERSION

 TXA                    \ Set T2 = bits 3-7 of X1, which will contain the
 AND #%11111000         \ character number of the start of the line * 8
 STA T2

 LDA X2                 \ Set A = bits 3-7 of X2, which will contain the
 AND #%11111000         \ character number of the end of the line * 8

 SEC                    \ Set A = A - T2, which will contain the number of
 SBC T2                 \ character blocks we need to fill - 1 * 8

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 BEQ HL2                \ If A = 0 then the start and end character blocks are
                        \ the same, so the whole line fits within one block, so
                        \ jump down to HL2 to draw the line

                        \ Otherwise the line spans multiple characters, so we
                        \ start with the left character, then do any characters
                        \ in the middle, and finish with the right character

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 LSR A                  \ Set R = A / 8, so R now contains the number of
 LSR A                  \ character blocks we need to fill - 1
 LSR A
 STA R

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LSR A                  \ Set R = A / 4, so R now contains the number of
 LSR A                  \ character blocks we need to fill - 1
 STA R

 LDA X1                 \ Set X = X1 mod 4, which is the horizontal pixel number
 AND #3                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 4 pixels
                        \ wide)

ELIF _C64_VERSION

 LSR A                  \ Set R2 = A / 8, so R2 now contains the number of
 LSR A                  \ character blocks we need to fill - 1
 LSR A
 STA R2

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _ELITE_A_6502SP_IO

 LSR A                  \ Set P = A / 8, so R now contains the number of
 LSR A                  \ character blocks we need to fill - 1
 LSR A
 STA P

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

ENDIF

IF _6502SP_VERSION \ Screen

 AND S                  \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in S, so we now know which bits to set
                        \ in screen memory to paint the relevant pixels in the
                        \ required colour

ELIF _MASTER_VERSION

 AND COL                \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in COL, so we now know which bits to
                        \ set in screen memory to paint the relevant pixels in
                        \ the required colour

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: See group A

 EOR (SC),Y             \ Store this into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen,
                        \ so we have now drawn the line's left cap

 TYA                    \ Set Y = Y + 8 so (SC),Y points to the next character
 ADC #8                 \ block along, on the same pixel row as before
 TAY

ELIF _ELECTRON_VERSION

 JMP LL30               \ Draw a line from (X1, Y1) to (X2, Y2), which will be
                        \ horizontal because we set Y2 to Y1 above

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 BCS HL7                \ If the above addition overflowed, then we have just
                        \ crossed over from the left half of the screen into the
                        \ right half, so call HL7 to increment the high byte in
                        \ SC+1 so that SC(1 0) points to the page in screen
                        \ memory for the right half of the screen row. HL7 also
                        \ clears the C flag and jumps back to HL8, so this acts
                        \ like a conditional JSR instruction

.HL8

ELIF _C64_VERSION

 BCC P%+4               \ If the addition overflowed, increment the high byte
 INC SC+1               \ of SC(1 0), so SC(1 0) + Y gives us the correct
                        \ address of the pixel

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDX R                  \ Fetch the number of character blocks we need to fill
                        \ from R

 DEX                    \ Decrement the number of character blocks in X

 BEQ HL3                \ If X = 0 then we only have the last block to do (i.e.
                        \ the right cap), so jump down to HL3 to draw it

 CLC                    \ Otherwise clear the C flag so we can do some additions
                        \ while we draw the character blocks with full-width
                        \ lines in them

.HLL1

ELIF _C64_VERSION

 LDX R2                 \ Fetch the number of character blocks we need to fill
                        \ from R2

 DEX                    \ Decrement the number of character blocks in X

 BEQ HL3                \ If X = 0 then we only have the last block to do (i.e.
                        \ the right cap), so jump down to HL3 to draw it

 CLC                    \ Otherwise clear the C flag so we can do some additions
                        \ while we draw the character blocks with full-width
                        \ lines in them

.HLL1

ELIF _ELITE_A_6502SP_IO

 LDX P                  \ Fetch the number of character blocks we need to fill
                        \ from P

 DEX                    \ Decrement the number of character blocks in X

 BEQ HL3                \ If X = 0 then we only have the last block to do (i.e.
                        \ the right cap), so jump down to HL3 to draw it

 CLC                    \ Otherwise clear the C flag so we can do some additions
                        \ while we draw the character blocks with full-width
                        \ lines in them

.HLL1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 LDA #%11111111         \ Store a full-width eight-pixel horizontal line in
 EOR (SC),Y             \ SC(1 0) so that it draws the line on-screen, using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

ELIF _6502SP_VERSION

 LDA S                  \ Store a full-width four-pixel horizontal line of
 EOR (SC),Y             \ colour S in SC(1 0) so that it draws the line
 STA (SC),Y             \ on-screen, using EOR logic so it merges with whatever
                        \ is already on-screen

ELIF _MASTER_VERSION

 LDA COL                \ Store a full-width four-pixel horizontal line of
 EOR (SC),Y             \ colour COL in SC(1 0) so that it draws the line
 STA (SC),Y             \ on-screen, using EOR logic so it merges with whatever
                        \ is already on-screen

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 TYA                    \ Set Y = Y + 8 so (SC),Y points to the next character
 ADC #8                 \ block along, on the same pixel row as before
 TAY

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 BCS HL9                \ If the above addition overflowed, then we have just
                        \ crossed over from the left half of the screen into the
                        \ right half, so call HL9 to increment the high byte in
                        \ SC+1 so that SC(1 0) points to the page in screen
                        \ memory for the right half of the screen row. HL9 also
                        \ clears the C flag and jumps back to HL10, so this acts
                        \ like a conditional JSR instruction

.HL10

ELIF _C64_VERSION

 BCC P%+5               \ If the addition overflowed, increment the high byte
 INC SC+1               \ of SC(1 0), so SC(1 0) + Y gives us the correct
 CLC                    \ address of the start of the line
                        \
                        \ We also clear the C flag so additions will work
                        \ properly if we loop back for more

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 DEX                    \ Decrement the number of character blocks in X

 BNE HLL1               \ Loop back to draw more full-width lines, if we have
                        \ any more to draw

.HL3

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 LDA X2                 \ Now to draw the last character block at the right end
 AND #7                 \ of the line, so set X = X2 mod 8, which is the
 TAX                    \ horizontal pixel number where the line ends

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA X2                 \ Now to draw the last character block at the right end
 AND #3                 \ of the line, so set X = X2 mod 3, which is the
 TAX                    \ horizontal pixel number where the line ends

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

ENDIF

IF _6502SP_VERSION \ Screen

 AND S                  \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in S, so we now know which bits to set
                        \ in screen memory to paint the relevant pixels in the
                        \ required colour

ELIF _MASTER_VERSION

 AND COL                \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in COL, so we now know which bits to
                        \ set in screen memory to paint the relevant pixels in
                        \ the required colour

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 EOR (SC),Y             \ Store this into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen,
                        \ so we have now drawn the line's right cap

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Tube

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved across the
                        \ call to this subroutine

ELIF _6502SP_VERSION

.HL6

 LDY Y2                 \ Set Y to the parameter block offset for this line's Y1
                        \ coordinate, which we stored in Y2 before we drew the
                        \ line

 INY                    \ Increment Y so that it points to the first parameter
                        \ for the next line in the parameter block

 CPY Q                  \ If Y = Q then we have drawn all the lines in the
 BEQ P%+5               \ parameter block, so skip the next instruction to
                        \ return from the subroutine

 JMP HLLO               \ There is another line in the parameter block after the
                        \ one we just drew, so jump to HLLO with Y pointing to
                        \ the new line's coordinates, so we can draw it

ELIF _MASTER_VERSION

.HL6

 LDY #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STY VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 RTS                    \ Return from the subroutine

.HL2

                        \ If we get here then the entire horizontal line fits
                        \ into one character block

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA X1                 \ Set X = X1 mod 4, which is the horizontal pixel number
 AND #3                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 4 pixels
                        \ wide)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
 STA T                  \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte)

ELIF _C64_VERSION

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
 STA T2                 \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ where the line ends
 TAX

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA X2                 \ Set X = X2 mod 4, which is the horizontal pixel number
 AND #3                 \ where the line ends
 TAX

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X)

 AND T                  \ We now have two bytes, one (T) containing pixels from
                        \ the starting point X1 onwards, and the other (A)
                        \ containing pixels up to the end point at X2, so we can
                        \ get the actual line we want to draw by AND'ing them
                        \ together. For example, if we want to draw a line from
ELIF _C64_VERSION

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X)

 AND T2                 \ We now have two bytes, one (T2) containing pixels from
                        \ the starting point X1 onwards, and the other (A)
                        \ containing pixels up to the end point at X2, so we can
                        \ get the actual line we want to draw by AND'ing them
                        \ together. For example, if we want to draw a line from
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Comment
                        \ point 2 to point 5 (within the row of 8 pixels
                        \ numbered from 0 to 7), we would have this:
ELIF _6502SP_VERSION
                        \ point 1 to point 2 (within the row of 4 pixels
                        \ numbered from 0 to 3), we would have this:
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform
                        \
                        \   T       = %00111111
                        \   A       = %11111100
                        \   T AND A = %00111100
                        \
                        \ So we can stick T AND A in screen memory to get the
                        \ line we want, which is what we do here by setting
                        \ A = A AND T
ELIF _C64_VERSION
                        \
                        \   T2       = %00111111
                        \   A        = %11111100
                        \   T2 AND A = %00111100
                        \
                        \ So we can stick T2 AND A in screen memory to get the
                        \ line we want, which is what we do here by setting
                        \ A = A AND T2
ENDIF

IF _6502SP_VERSION \ Screen

 AND S                  \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in S, so we now know which bits to set
                        \ in screen memory to paint the relevant pixels in the
                        \ required colour
ELIF _MASTER_VERSION

 AND COL                \ Apply the pixel mask in A to the four-pixel block of
                        \ coloured pixels in COL, so we now know which bits to
                        \ set in screen memory to paint the relevant pixels in
                        \ the required colour

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 EOR (SC),Y             \ Store our horizontal line byte into screen memory at
 STA (SC),Y             \ SC(1 0), using EOR logic so it merges with whatever is
                        \ already on-screen

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Tube

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

ELIF _6502SP_VERSION

 LDY Y2                 \ Set Y to the parameter block offset for this line's Y1
                        \ coordinate, which we stored in Y2 before we drew the
                        \ line

 INY                    \ Increment Y so that it points to the first parameter
                        \ for the next line in the parameter block

 CPY Q                  \ If Y = Q then we have drawn all the lines in the
 BEQ P%+5               \ parameter block, so skip the next instruction to
                        \ return from the subroutine

 JMP HLLO               \ There is another line in the parameter block after the
                        \ one we just drew, so jump to HLLO with Y pointing to
                        \ the new line's coordinates, so we can draw it

ELIF _MASTER_VERSION

 LDY #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STY VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

.HL7

 INC SC+1               \ We have just crossed over from the left half of the
                        \ screen into the right half, so increment the high byte
                        \ in SC+1 so that SC(1 0) points to the page in screen
                        \ memory for the right half of the screen row

 CLC                    \ Clear the C flag (as HL7 is called with the C flag
                        \ set, which this instruction reverts)

 JMP HL8                \ Jump back to HL8, just after the instruction that
                        \ called HL7

.HL9

 INC SC+1               \ We have just crossed over from the left half of the
                        \ screen into the right half, so increment the high byte
                        \ in SC+1 so that SC(1 0) points to the page in screen
                        \ memory for the right half of the screen row

 CLC                    \ Clear the C flag (as HL9 is called with the C flag
                        \ set, which this instruction reverts)

 JMP HL10               \ Jump back to HL10, just after the instruction that
                        \ called HL9

ENDIF
