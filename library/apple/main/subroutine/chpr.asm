\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\  Deep dive: Drawing text
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ The CHPR2 sends characters here for printing if they are in the range 13-122.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
\                         * 10-13 (line feeds and carriage returns)
\
\                         * 32-95 (ASCII capital letters, numbers and
\                           punctuation)
\
\                         * 127 (delete the character to the left of the text
\                           cursor and move the cursor to the left)
\
\   XC                  Contains the text column to print at (the x-coordinate)
\
\   YC                  Contains the line number to print on (the y-coordinate)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\   C flag              The C flag is cleared
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RREN                Prints the character definition pointed to by P(2 1) at
\                       the screen address pointed to by (A SC). Used by the
\                       BULB routine
\
\   RR4                 Restore the registers and return from the subroutine
\
\   RR6                 A re-entry point from the RR5 routine after we print the
\                       character in A in the text screen mode
\
\   RRafter             A re-entry point from the clss routine to print the
\                       character in A
\
\ ******************************************************************************

.CHPR

 STA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4                \ RR4, which doesn't print anything, it just restores
                        \ the registers and returns from the subroutine

.RRafter

 CMP #7                 \ If this is a beep character (A = 7), jump to R5,
 BEQ R5                 \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to RR1
 BCS RR1                \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ RRX1               \ RRX1, which will move down a line, restore the
                        \ registers and return from the subroutine

.RRX2

 LDX #1                 \ If we get here, then this is control code 12 or 13,
 STX XC                 \ both of which are used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.RRX1

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RR4                \ RR4 to restore the registers and return from the
                        \ subroutine

 INC YC                 \ Print a line feed, simply by incrementing the row
                        \ number (y-coordinate) of the text cursor, which is
                        \ stored in YC

 BNE RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine (this BNE is effectively a JMP as Y
                        \ will never be zero)

.RR1

 LDX XC                 \ Set X to the text column in XC where we want to print
                        \ the character in A

 CPX #31                \ If X < 31 then we are printing in a text column
 BCC RRa                \ that's on-screen, so jump to RRa to skip the following

 JSR RRX2               \ Otherwise call RRX2 above as a subroutine to move the
                        \ text cursor to column 1 and print a carriage return,
                        \ so we move onto the next text row

 LDX XC                 \ Set X to the new value of XC, which is column 1

.RRa

 LDY YC                 \ Set Y to the text row in YC where we want to print
                        \ the character in A

 CPY #24                \ If Y >= 24 then the row is off the bottom of the
 BCS clss               \ screen, so call clss to clear the screen, move the
                        \ text cursor to the top-left corner and jump back to
                        \ RRafter above to print the character in A

 BIT text               \ If bit 7 of text is set then the current screen mode
 BMI RR5                \ is the text mode, so jump to RR5 to print the
                        \ character in the text screen mode

 PHA                    \ Store the character to print on the stack

 LDA XC                 \ Set X = 8 * XC + 13 - XC - 1
 ASL A                  \       = 7 * XC + 12
 ASL A                  \
 ASL A                  \ So X is the pixel number of the text column, plus 12,
 ADC #13                \ as each byte contains seven pixels
 SBC XC
 TAX

 PLA                    \ Restore the character to print from the stack into A

 JSR letter             \ Draw the character in A in the high-resolution screen
                        \ mode at pixel x-coordinate X and text row YC

.RR6

 INC XC                 \ Move the text cursor to the right by one column

.RR4

 LDY YSAV2              \ We're done printing, so restore the values of the
 LDX XSAV2              \ A, X and Y registers that we saved above and clear
 LDA K3                 \ the C flag, so everything is back to how it was
 CLC

 RTS                    \ Return from the subroutine

