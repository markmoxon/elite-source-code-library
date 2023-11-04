\ ******************************************************************************
\
\       Name: CHPR (Part 4 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Process the delete character
\  Deep dive: Fonts in NES Elite
\
\ ******************************************************************************

.chpr21

                        \ If we get here then we are printing ASCII 127, which
                        \ is the delete character

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY XC                 \ Set Y to the text column of the text cursor, which
                        \ points to the character we want to delete (as we are
                        \ printing a delete character there)

 DEC XC                 \ Decrement XC to move the text cursor left by one
                        \ place, as we are deleting a character

 LDA #0                 \ Zero the Y-th nametable entry in nametable buffer 0
 STA (SC),Y             \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 STA (SC2),Y            \ Zero the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

