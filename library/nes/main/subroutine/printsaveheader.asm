\ ******************************************************************************
\
\       Name: PrintSaveHeader
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print header text for the Save and Load screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   V(1 0)              The address of a null-terminated string to print
\
\ ******************************************************************************

.PrintSaveHeader

 LDY #0                 \ Set an index in Y so we can work through the text

.stxt1

 LDA (V),Y              \ Fetch the Y-th character from V(1 0)

 BEQ stxt2              \ If A = 0 then we have reached the null terminator, so
                        \ jump to stxt2 to return from the subroutine

 JSR TT27_b2            \ Print the character in A

 INY                    \ Increment the character counter

 BNE stxt1              \ Loop back to print the next character (this BNE is
                        \ effectively a JMP as we will reach a null terminator
                        \ well before Y wraps around to zero)

.stxt2

 RTS                    \ Return from the subroutine

