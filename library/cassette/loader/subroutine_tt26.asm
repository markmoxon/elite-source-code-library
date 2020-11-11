\ ******************************************************************************
\
\       Name: TT26
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor (WRCHV points here)
\
\ ------------------------------------------------------------------------------
\
\ This routine prints a character at the text cursor (XC, YC). It is very
\ similar to the routine of the same name in the main game code, so refer to
\ that routine for a more detailed description.
\
\ This routine, however, only works within a small 14x14 character text window,
\ which we use for the tape loading messages, so there is extra code for fitting
\ the text into the window (and it also reverses the effect of line feeds and
\ carriage returns).
\
\ Arguments:
\
\   A                   The character to be printed
\
\   XC                  Contains the text column to print at (the x-coordinate)
\
\   YC                  Contains the line number to print on (the y-coordinate)
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.TT26

 STA K3                 \ Store the A, X and Y registers (in K3 for A, and on
 TYA                    \ the stack for the others), so we can restore them at
 PHA                    \ the end (so they don't get changed by this routine)
 TXA
 PHA

.rr

 LDA K3                 \ Set A = the character to be printed

 CMP #7                 \ If this is a beep character (A = 7), jump to R5,
 BEQ R5                 \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to RR1
 BCS RR1                \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RRX1               \ to RRX1, which will move along on character, restore
                        \ the registers and return from the subroutine (as we
                        \ don't have room in the text window for new lines)

 INC YC                 \ If we get here, then this is control code 10, a line
                        \ feed, so move down one line and fall through into RRX1
                        \ to move the cursor to the start of the line

.RRX1

 LDX #7                 \ Set the column number (x-coordinate) of the text
 STX XC                 \ to 7

 BNE RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine (this BNE is effectively a JMP as Y
                        \ will never be zero)

.RR1

 LDX #&BF               \ Set X to point to the first font page in ROM minus 1,
                        \ which is &C0 - 1, or &BF

 ASL A                  \ If bit 6 of the character is clear (A is 32-63)
 ASL A                  \ then skip the following instruction
 BCC P%+4

 LDX #&C1               \ A is 64-126, so set X to point to page &C1

 ASL A                  \ If bit 5 of the character is clear (A is 64-95)
 BCC P%+3               \ then skip the following instruction

 INX                    \ Increment X, so X now contains the high byte
                        \ (the page) of the address of the definition that we
                        \ want, while A contains the low byte (the offset into
                        \ the page) of the address

 STA P                  \ Store the address of this character's definition in
 STX P+1                \ P(1 0)

 LDA XC                 \ If the column number (x-coordinate) of the text is
 CMP #20                \ less than 20, skip to NOLF
 BCC NOLF

 LDA #7                 \ Otherwise we just reached the end of the line, so
 STA XC                 \ move the text cursor to column 7, and down onto the
 INC YC                 \ next line

.NOLF

 ASL A                  \ Multiply the x-coordinate (column) of the text by 8
 ASL A                  \ and store in ZP, to get the low byte of the screen
 ASL A                  \ address for the character we want to print
 STA ZP

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing XC

 LDA YC                 \ If the row number (y-coordinate) of the text is less
 CMP #19                \ than 19, skip to RR3
 BCC RR3

                        \ Otherwise we just reached the bottom of the screen,
                        \ which is a small 14x14 character text window we use
                        \ for showing the tape loading messages, so now we need
                        \ to clear that window and move the cursor to the top

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #&65               \ Set the high byte of the SC(1 0) to &65, for character
 STA SC+1               \ row 5 of the screen

 LDY #7*8               \ Set Y = 7 * 8, for column 7 (as there are 8 bytes per
                        \ character block)

 LDX #14                \ Set X = 14, to count the number of character rows we
                        \ need to clear

 STY SC                 \ Set the low byte of SC(1 0) to 7*8, so SC(1 0) now
                        \ points to the character block at row 5, column 7, at
                        \ the top-left corner of the small text window

 LDA #0                 \ Set A = 0 for use in clearing the screen (which we do
                        \ by setting the screen memory to 0)

 TAY                    \ Set Y = 0

.David1

 STA (SC),Y             \ Clear the Y-th byte of the block pointed to by SC(1 0)

 INY                    \ Increment the counter in Y

 CPY #14*8              \ Loop back to clear the next byte until we have done 14
 BCC David1             \ lots of 8 bytes (i.e. 14 characters, the width of the
                        \ small text window)

 TAY                    \ Set Y = 0, ready for the next row

 INC SC+1               \ Point SC(1 0) to the next page in memory, i.e. the
                        \ next character row

 DEX                    \ Decrement the counter in X

 BPL David1             \ Loop back to David1 until we have done 14 character
                        \ rows (the height of the small text window)

 LDA #5                 \ Set the text row to 5
 STA YC

 BNE rr                 \ Jump to rr to print the character we were about to
                        \ print when we ran out of space (this BNE is
                        \ effectively a JMP as A will never be zero)


.RR3

 ORA #&60               \ Add &60 to YC, giving us the page number that we want

 STA ZP+1               \ Store the page number of the destination screen
                        \ location in ZP+1, so ZP now points to the full screen
                        \ location where this character should go

 LDY #7                 \ We want to print the 8 bytes of character data to the
                        \ screen (one byte per row), so set up a counter in Y
                        \ to count these bytes

.RRL1

 LDA (P),Y              \ The character definition is at P(1 0) - we set this up
                        \ above -  so load the Y-th byte from P(1 0)

 STA (ZP),Y             \ Store the Y-th byte at the screen address for this
                        \ character location

 DEY                    \ Decrement the loop counter

 BPL RRL1               \ Loop back for the next byte to print to the screen

.RR4

 PLA                    \ We're done printing, so restore the values of the
 TAX                    \ A, X and Y registers that we saved above, loading them
 PLA                    \ from K3 (for A) and the stack (for X and Y)
 TAY
 LDA K3

.^FOOL

 RTS                    \ Return from the subroutine

.R5

 LDA #7                 \ Control code 7 makes a beep, so load this into A

 JSR osprint            \ Call OSPRINT to "print" the beep character

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

