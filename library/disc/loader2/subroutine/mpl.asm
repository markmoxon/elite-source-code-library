\ ******************************************************************************
\
\       Name: MPL
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Move two pages of memory from LOADcode to LOAD and jump to ENTRY2
\
\ ******************************************************************************

.MPL

 LDY #0                 \ Set Y = 0 to act as a byte counter

 LDX #2                 \ Set X = 2 to act as a page counter

.MVBL

 LDA LOADcode,Y         \ Copy the Y-th byte of LOADcode to the Y-th byte of
 STA LOAD,Y             \ LOAD (this instruction gets modified below, so this is
                        \ a single-use, self-modifying routine)

 INY                    \ Increment the byte counter

 BNE MVBL               \ Loop back to MVBL to copy the next byte until we have
                        \ copied a whole page

 INC MVBL+2             \ Increment the high byte of the LDA instruction above,
                        \ so it now points to the next page

 INC MVBL+5             \ Increment the high byte of the STA instruction above,
                        \ so it now points to the next page

 DEX                    \ Decrement the page counter in X

 BNE MVBL               \ Loop back to MVBL to copy the next page until we have
                        \ copied X pages

 JMP ENTRY2             \ Jump to ENTRY2 to continue the loading process

