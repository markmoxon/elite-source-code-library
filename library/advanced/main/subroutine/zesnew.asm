\ ******************************************************************************
\
\       Name: ZESNEW
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill memory from SC(1 0) to the end of the page
\
\ ------------------------------------------------------------------------------
\
\ Zero-fill from address SC(1 0) + Y to SC(1 0) + &FF.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset from SC(1 0) where we start zeroing, counting
\                       up to &FF
\
\   SC(1 0)             The starting address of the zero-fill
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Z flag              Z flag is set
\
\ ******************************************************************************

.ZESNEW

 LDA #0                 \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

.ZESNEWL

 STA (SC),Y             \ Zero the Y-th byte of the block pointed to by SC

 INY                    \ Increment the loop counter

 BNE ZESNEWL            \ Loop back to zero the next byte

 RTS                    \ Return from the subroutine

