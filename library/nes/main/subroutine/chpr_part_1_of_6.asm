\ ******************************************************************************
\
\       Name: CHPR (Part 1 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ If the relevant font is already loaded into the pattern buffers, then this is
\ used as the tile pattern for the character, otherwise the pattern for the
\ character being printed is extracted from the fontImage table and into the
\ pattern buffer.
\
\ For fontStyle = 3, the pattern is always extracted from the fontImage table,
\ as it has different colour text (colour 3) than the normal font. This is used
\ when printing characters into 2x2 attribute blocks where printing the normal
\ font would result in the wrong colour text being shown.
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
\   fontStyle           Determines the font style:
\
\                         * 1 = normal font
\
\                         * 2 = highlight font
\
\                         * 3 = green text on a black background (colour 3 on
\                               background colour 0)
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
\ ******************************************************************************

.chpr1

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

.chpr2

 LDA #2                 \ Move the text cursor to row 2
 STA YC

 LDA K3                 \ Set A to the character to be printed

 JMP chpr4              \ Jump to chpr4 to print the character in A

.chpr3

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

 LDA #12                \ This instruction is never called, but it would set A
                        \ to a carriage return character and fall through into
                        \ CHPR to print the newline

.CHPR

 STA K3                 \ Store the A register in K3 so we can retrieve it below
                        \ (so K3 contains the number of the character to print)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ chpr3              \ chpr17 (via the JMP in chpr3) to restore the registers
                        \ and return from the subroutine using a tail call

.chpr4

 CMP #7                 \ If this is a beep character (A = 7), jump to chpr1,
 BEQ chpr1              \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to chpr6
 BCS chpr6              \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ chpr5              \ chpr5, which will move down a line, restore the
                        \ registers and return from the subroutine

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.chpr5

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ chpr3              \ to chpr17 (via the JMP in chpr3) to restore the
                        \ registers and return from the subroutine using a tail
                        \ call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

 BNE chpr3              \ Jump to chpr17 via chpr3 to restore the registers and
                        \ return from the subroutine using a tail call (this BNE
                        \ is effectively a JMP as Y will never be zero)

.chpr6

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95

 LDX XC                 \ If the text cursor is on a column of 30 or less, then
 CPX #31                \ we have space to print the character on the current
 BCC chpr7              \ row, so jump to chpr7 to skip the following

 LDX #1                 \ The text cursor has moved off the right end of the
 STX XC                 \ current line, so move the cursor back to column 1 and
 INC YC                 \ down to the next row

.chpr7

 LDX YC                 \ If the text cursor is on row 26 or less, then the
 CPX #27                \ cursor is on-screen, so jump to chpr8 to skip the
 BCC chpr8              \ following instruction

 JMP chpr2              \ The cursor is off the bottom of the screen, so jump to
                        \ chpr2 to move the cursor up to row 2 before printing
                        \ the character

.chpr8

 CMP #127               \ If the character to print is not ASCII 127, then jump
 BNE chpr9              \ to chpr9 to skip the following instruction

 JMP chpr21             \ Jump to chpr21 to delete the character to the left of
                        \ the text cursor

