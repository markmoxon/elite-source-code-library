\ ******************************************************************************
\
\       Name: tube_wrch
\       Type: Subroutine
\   Category: Text
\    Summary: Write characters to the screen and process Tube commands from the
\             parasite
\  Deep dive: Tube communication in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ This routine prints characters to the screen.
\
\ It also processes Tube commands from the parasite, because those commands are
\ sent over the Tube via FIFO 1, and Acorn's Tube host code considers arrivals
\ on FIFO 1 to be OSWRCH commands executed on the parasite, and calls the WRCHV
\ handler to implement the call. We already set WRCHV to point here in the
\ tube_elite routine, so when the I/O processor receives a byte from the
\ parasite over FIFO 1, the Tube host code calls this routine.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 0 (do not print anything)
\
\                         * 9 (space)
\
\                         * 10 (line feed)
\
\                         * 13 (carriage return)
\
\                         * 32 (space, but do not print anything if it's on
\                           column 17, so the disc catalogue will fit on-screen)
\
\                         * 33-126 (ASCII capital letters, numbers and
\                           punctuation)
\
\                         * 127 (delete the character to the left of the text
\                           cursor and move the cursor to the left)
\
\                         * 128-255 (Tube command &80-&FF)
\
\ ******************************************************************************

.tube_wrch

 STA K3                 \ Store the A, X and Y registers, so we can restore
 STX XSAV2              \ them at the end (so they don't get changed by this
 STY YSAV2              \ routine)

 TAY                    \ Copy the character to be printed from A into Y

 BMI tube_func          \ If bit 7 of the character is set (i.e. A >= 128) then
                        \ this is a Tube command rather than a printable
                        \ character, so jump to tube_func to process it

 BEQ wrch_quit          \ If A = 0 then there is no character to print, so jump
                        \ to wrch_quit to return from the subroutine

 CMP #127               \ If A = 127 then this is a delete character, so jump
 BEQ wrch_del           \ to wrch_del to erase the character to the left of the
                        \ cursor

 CMP #32                \ If A = 32 then this is a space character, so jump to
 BEQ wrch_spc           \ wrch_spc to move the text cursor to the right

 BCS wrch_char          \ If this is an ASCII character (A > 32), jump to
                        \ wrch_char to print the character on-screen

 CMP #10                \ If A = 10 then this is a line feed, so jump to wrch_nl
 BEQ wrch_nl            \ to move the text cursor down a line

 CMP #13                \ If A = 13 then this is a carriage return, so jump to
 BEQ wrch_cr            \ wrch_cr to move the text cursor to the start of the
                        \ line

 CMP #9                 \ If A <> 9 then this isn't a character we can print,
 BNE wrch_quit          \ so jump to wrch_quit to return from the subroutine

                        \ If we get here then A = 9, which is a space character

.wrch_tab

 INC XC                 \ Move the text cursor to the right by 1 column

.wrch_quit

 LDY YSAV2              \ Restore the values of the A, X and Y registers that we
 LDX XSAV2              \ saved above
 LDA K3

 RTS                    \ Return from the subroutine

.wrch_char

                        \ If we get here then we want to print the character in
                        \ A onto the screen

 JSR wrch_font          \ Call wrch_font to set the following:
                        \
                        \   * font(1 0) points to the character definition of
                        \     the character to print in A
                        \
                        \   * SC(1 0) points to the screen address where we
                        \     should print the character

                        \ Now to actually print the character

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

 LDY #7                 \ We want to print the 8 bytes of character data to the
                        \ screen (one byte per row), so set up a counter in Y
                        \ to count these bytes

.wrch_or

 LDA (font),Y           \ The character definition is at font(1 0), so load the
                        \ Y-th byte from font(1 0), which will contain the
                        \ bitmap for the Y-th row of the character

 EOR (SC),Y             \ If we EOR this value with the existing screen
                        \ contents, then it's reversible (so reprinting the
                        \ same character in the same place will revert the
                        \ screen to what it looked like before we printed
                        \ anything); this means that printing a white pixel
                        \ onto a white background results in a black pixel, but
                        \ that's a small price to pay for easily erasable text

 STA (SC),Y             \ Store the Y-th byte at the screen address for this
                        \ character location

 DEY                    \ Decrement the loop counter

 BPL wrch_or            \ Loop back for the next byte to print to the screen

 BMI wrch_quit          \ Jump to wrch_quit to return from the subroutine (the
                        \ BMI is effectively a JMP as we just passed through a
                        \ BPL instruction)

.wrch_del

                        \ If we get here then we want to delete the character to
                        \ the left of the text cursor, which we can do by
                        \ printing a space over the top of it

 DEC XC                 \ We want to delete the character to the left of the
                        \ text cursor and move the cursor back one, so let's
                        \ do that by decrementing YC. Note that this doesn't
                        \ have anything to do with the actual deletion below,
                        \ we're just updating the cursor so it's in the right
                        \ position following the deletion

 LDA #' '               \ Call wrch_font to set the following:
 JSR wrch_font          \
                        \   * font(1 0) points to the character definition of
                        \     the space character
                        \
                        \   * SC(1 0) points to the screen address where we
                        \     should print the space

 LDY #7                 \ We want to print the 8 bytes of character data to the
                        \ screen (one byte per row), so set up a counter in Y
                        \ to count these bytes

.wrch_sta

 LDA (font),Y           \ The character definition is at font(1 0), so load the
                        \ Y-th byte from font(1 0), which will contain the
                        \ bitmap for the Y-th row of the space character

 STA (SC),Y             \ Store the Y-th byte at the screen address for this
                        \ character location

 DEY                    \ Decrement the loop counter

 BPL wrch_sta           \ Loop back for the next byte to print to the screen

 BMI wrch_quit          \ Jump to wrch_quit to return from the subroutine (the
                        \ BMI is effectively a JMP as we just passed through a
                        \ BPL instruction)

.wrch_nl

                        \ If we get here then we want to print a line feed

 INC YC                 \ Print a line feed, simply by incrementing the row
                        \ number (y-coordinate) of the text cursor, which is
                        \ stored in YC

 JMP wrch_quit          \ Jump to wrch_quit to return from the subroutine

.wrch_cr

                        \ If we get here then we want to print a carriage return

 LDA #1                 \ Print a carriage return by returning the text cursor
 STA XC                 \ to the start of the line, i.e. column 1

 JMP wrch_quit          \ Jump to wrch_quit to return from the subroutine

.wrch_spc

                        \ If we get here then we want to print a space, but not
                        \ if we are in column 17 (this is so the disc catalogue
                        \ will fit on-screen, and performs the same duty as the
                        \ CATF flag in the disc version)

 LDA XC                 \ If the text cursor is in column 32, then we are
 CMP #32                \ already at the right edge of the screen and can't
 BEQ wrch_quit          \ print a space, so jump to wrch_quit to return from
                        \ the subroutine

 CMP #17                \ If the text cursor is in column 17, then we want to
 BEQ wrch_quit          \ omit this space, so jump to wrch_quit to return from
                        \ the subroutine

 BNE wrch_tab           \ Otherwise jump to wrch_tab to move the cursor right by
                        \ one character (the BNE is effectively a JMP as we just
                        \ passed through a BEQ)

