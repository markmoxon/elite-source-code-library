\ ******************************************************************************
\
\       Name: CHECK
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Calculate a checksum from two 256-byte portions of the loader code
\
\ ******************************************************************************

.CHECK

 CLC                    \ Clear the C flag for the addition below

 LDY #0                 \ We are going to loop through 256 bytes, so set a byte
                        \ counter in Y

.p2

 ADC PLL1,Y             \ Set A = A + Y-th byte of PLL1

 EOR ENTRY,Y            \ Set A = A EOR Y-th byte of ENTRY

 DEY                    \ Decrement the byte counter

 BNE p2                 \ Loop back to checksum the next byte

 RTS                    \ Return from the subroutine

