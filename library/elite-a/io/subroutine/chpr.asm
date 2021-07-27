\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the write_xyc command (write a character to the screen)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a write_xyc command. It writes a
\ text character to the screen at specified position. If the character is null
\ (i.e. A = 0) then it just moves the text cursor and doesn't print anything.
\
\ ******************************************************************************

.CHPR

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA XC                 \
 JSR tube_get           \   write_xyc(x, y, char)
 STA YC                 \
 JSR tube_get           \ and store them as follows:
                        \
                        \   * XC = text column (x-coordinate)
                        \
                        \   * YC = text row (y-coordinate)
                        \
                        \   * A = the character to print

 CMP #' '               \ If we are not printing a space character, jump to
 BNE tube_wrch          \ tube_wrch to print the character, returning from the
                        \ subroutine using a tail call

 LDA #9                 \ We are printing a space, so set A to 9 and fall
                        \ through into tube_wrch to print the character

