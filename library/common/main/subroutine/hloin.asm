\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
IF _CASSETTE_VERSION
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
ELIF _6502SP_VERSION
\    Summary: Implement the OSWORD 247 command (draw a horizontal line)
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION
\ We do not draw a pixel at the end point (X2, X1).
\
\ To understand how this routine works, you might find it helpful to read the
\ deep dive on "Drawing monochrome pixels in mode 4".
\
\ Returns:
\
\   Y                   Y is preserved
ELIF _6502SP_VERSION
\ This routine is run when the parasite sends an OSWORD 247 command with
\ parameters in the block at OSSC(1 0). It draws a horizontal line (or a
\ collection of lines) in the space view.
\
\ The parameters match those put into the HBUF block in the parasite. Each line
\ is drawn from (X1, Y1) to (X2, Y1), and lines are drawn in orange.
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
\ Other entry points:
\
\   HLOIN3              Draw a line from (X, Y1) to (X2, Y1) in the colour given
\                       in A (we also need to set Q = Y2 + 1 before calling so
\                       only one line is drawn)
ENDIF
\
\ ******************************************************************************

.HLOIN

IF _CASSETTE_VERSION

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDX X1                 \ Set X = X1

ELIF _6502SP_VERSION

 LDY #0                 \ Fetch byte #0 from the parameter block (size of the
 LDA (OSSC),Y           \ parameter block) and store it in Q
 STA Q

 INY                    \ Increment Y to point to byte #2
 INY

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

 STY Y2                 \ Store the parameter block offset for this line in Y2,
                        \ so we know where to fetch the next line from in the
                        \ parameter block once we have drawn this one

 AND #3
 TAY
 LDA orange,Y

.HLOIN3

 STA S                  \ Store the line colour in S

ENDIF

 CPX X2                 \ If X1 = X2 then the start and end points are the same,
 BEQ HL6                \ so return from the subroutine (as HL6 contains an RTS)

 BCC HL5                \ If X1 < X2, jump to HL5 to skip the following code, as
                        \ (X1, Y1) is already the left point

 LDA X2                 \ Swap the values of X1 and X2, so we know that (X1, Y1)
 STA X1                 \ is on the left and (X2, Y1) is on the right
 STX X2

 TAX                    \ Set X = X1

.HL5

 DEC X2                 \ Decrement X2

IF _CASSETTE_VERSION

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

ELIF _6502SP_VERSION

 LDY Y1

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TYA
 AND #7

ENDIF

 STA SC                 \ Store this value in SC, so SC(1 0) now contains the
                        \ screen address of the far left end (x-coordinate = 0)
                        \ of the horizontal pixel row that we want to draw our
                        \ horizontal line on

IF _CASSETTE_VERSION

 TXA                    \ Set Y = bits 3-7 of X1
 AND #%11111000
 TAY

ELIF _6502SP_VERSION

 TXA
 AND #&FC
 ASL A
 TAY
 BCC P%+4
 INC SC+1

ENDIF

.HL1

IF _CASSETTE_VERSION

 TXA                    \ Set T = bits 3-7 of X1, which will contain the
 AND #%11111000         \ the character number of the start of the line * 8
 STA T

 LDA X2                 \ Set A = bits 3-7 of X2, which will contain the
 AND #%11111000         \ the character number of the end of the line * 8

ELIF _6502SP_VERSION

 TXA
 AND #&FC
 STA T
 LDA X2
 AND #&FC

ENDIF

 SEC                    \ Set A = A - T, which will contain the number of
 SBC T                  \ character blocks we need to fill - 1 * 8

 BEQ HL2                \ If A = 0 then the start and end character blocks are
                        \ the same, so the whole line fits within one block, so
                        \ jump down to HL2 to draw the line

                        \ Otherwise the line spans multiple characters, so we
                        \ start with the left character, then do any characters
                        \ in the middle, and finish with the right character

IF _CASSETTE_VERSION

 LSR A                  \ Set R = A / 8, so R now contains the number of
 LSR A                  \ character blocks we need to fill - 1
 LSR A
 STA R

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _6502SP_VERSION

 LSR A
 LSR A
 STA R
 LDA X1
 AND #3
 TAX

ENDIF

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

IF _6502SP_VERSION

 AND S

ENDIF

 EOR (SC),Y             \ Store this into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen,
                        \ so we have now drawn the line's left cap

 TYA                    \ Set Y = Y + 8 so (SC),Y points to the next character
 ADC #8                 \ block along, on the same pixel row as before
 TAY

IF _6502SP_VERSION

 BCS HL7

.HL8

ENDIF

 LDX R                  \ Fetch the number of character blocks we need to fill
                        \ from R

 DEX                    \ Decrement the number of character blocks in X

 BEQ HL3                \ If X = 0 then we only have the last block to do (i.e.
                        \ the right cap), so jump down to HL3 to draw it

 CLC                    \ Otherwise clear the C flag so we can do some additions
                        \ while we draw the character blocks with full-width
                        \ lines in them

.HLL1

IF _CASSETTE_VERSION

 LDA #%11111111         \ Store a full-width 8-pixel horizontal line in SC(1 0)
 EOR (SC),Y             \ so that it draws the line on-screen, using EOR logic
 STA (SC),Y             \ so it merges with whatever is already on-screen

ELIF _6502SP_VERSION

 LDA S
 EOR (SC),Y
 STA (SC),Y

ENDIF

 TYA                    \ Set Y = Y + 8 so (SC),Y points to the next character
 ADC #8                 \ block along, on the same pixel row as before
 TAY

IF _6502SP_VERSION

 BCS HL9

.HL10

ENDIF

 DEX                    \ Decrement the number of character blocks in X

 BNE HLL1               \ Loop back to draw more full-width lines, if we have
                        \ any more to draw

.HL3

IF _CASSETTE_VERSION

 LDA X2                 \ Now to draw the last character block at the right end
 AND #7                 \ of the line, so set X = X2 mod 8, which is the
 TAX                    \ horizontal pixel number where the line ends

ELIF _6502SP_VERSION

 LDA X2
 AND #3
 TAX

ENDIF

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

IF _6502SP_VERSION

 AND S

ENDIF

 EOR (SC),Y             \ Store this into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen,
                        \ so we have now drawn the line's right cap

IF _CASSETTE_VERSION

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved across the
                        \ call to this subroutine

ELIF _6502SP_VERSION

.HL6

 LDY Y2
 INY
 CPY Q
 BEQ P%+5
 JMP HLLO

ENDIF

 RTS                    \ Return from the subroutine

.HL2

                        \ If we get here then the entire horizontal line fits
                        \ into one character block

IF _CASSETTE_VERSION

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _6502SP_VERSION

 LDA X1
 AND #3
 TAX

ENDIF

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
 STA T                  \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte)

IF _CASSETTE_VERSION

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ where the line ends
 TAX

ELIF _6502SP_VERSION

 LDA X2
 AND #3
 TAX

ENDIF

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X)

 AND T                  \ We now have two bytes, one (T) containing pixels from
                        \ the starting point X1 onwards, and the other (A)
                        \ containing pixels up to the end point at X2, so we can
                        \ get the actual line we want to draw by AND'ing them
                        \ together. For example, if we want to draw a line from
                        \ point 2 to point 5, we would have this:
                        \
                        \   T       = %00111111
                        \   A       = %11111100
                        \   T AND A = %00111100
                        \
                        \ so if we stick T AND A in screen memory, that's what
                        \ we do here, setting A = A AND T

IF _6502SP_VERSION

 AND S

ENDIF

 EOR (SC),Y             \ Store our horizontal line byte into screen memory at
 STA (SC),Y             \ SC(1 0), using EOR logic so it merges with whatever is
                        \ already on-screen

IF _CASSETTE_VERSION

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

ELIF _6502SP_VERSION

 LDY Y2
 INY
 CPY Q
 BEQ P%+5
 JMP HLLO

ENDIF

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION

.HL7

 INC SC+1
 CLC
 JMP HL8

.HL9

 INC SC+1
 CLC
 JMP HL10

ENDIF
