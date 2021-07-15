\ ******************************************************************************
\
\       Name: n_name
\       Type: Subroutine
\   Category: Text
\    Summary: Print the type of a given ship
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The ship type number, in the range 0 to 14, as defined
\                       in the new_ships table
\
\ ******************************************************************************

.n_name

 LDX new_offsets,Y      \ Set X to the offset, measured from new_ships, for this
                        \ ship's details block, so X now points to the offset of
                        \ the first character of the ship's type in the
                        \ new_ships table

 LDA #9                 \ Each ship type consists of exactly 9 characters
 STA K+1                \ (including spaces), so set K+1 = 9 as a character
                        \ counter in the following loop

.n_lprint

 LDA new_ships,X        \ Set A to the character we want to print from the
                        \ new_ships table

 STX K                  \ Store the offset in K so we can retrieve it after the
                        \ call to TT27

 JSR TT27               \ Call TT27 to print the text token in A

 LDX K                  \ Restore the offset from K back into X

 INX                    \ Increment X to point to the next character

 DEC K+1                \ Decrement the character counter in K+1

 BNE n_lprint           \ Loop back to print the next character until we have
                        \ printed all 9 of them

 RTS                    \ Return from the subroutine

