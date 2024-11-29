\ ******************************************************************************
\
\       Name: ZES2k
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill a specific page
\
\ ------------------------------------------------------------------------------
\
\ Zero-fill from address (X SC) + Y to (X SC) + 1.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset from (X SC) where we start zeroing, counting
\                       down to 1; if Y = 0, then the whole page is reset
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Z flag              Z flag is set
\
\   A                   A is 0
\
\   Y                   Y is 0
\
\ ******************************************************************************

.ZES2k

 LDA #0                 \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

 STX SC+1               \ We want to zero-fill page X, so store this in the
                        \ high byte of SC, so the 16-bit address in SC and
                        \ SC+1 is now pointing to the SC-th byte of page X

.ZEL1k

 STA (SC),Y             \ Zero the Y-th byte of the block pointed to by SC,
                        \ so that's effectively the Y-th byte before SC

 DEY                    \ Decrement the loop counter

 BNE ZEL1k              \ Loop back to zero the next byte

 RTS                    \ Return from the subroutine

