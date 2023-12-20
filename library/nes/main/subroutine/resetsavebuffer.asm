\ ******************************************************************************
\
\       Name: ResetSaveBuffer
\       Type: Subroutine
\   Category: Save and load
\    Summary: Reset the commander file buffer at BUF to the default commander
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ResetSaveBuffer+1   Omit the initial PHA (so we can jump here if the value
\                       of the preserved A is already on the stack from another
\                       routine)
\
\ ******************************************************************************

.ResetSaveBuffer

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 LDX #78                \ We are going to copy 79 bytes, so set a counter in X

.resb1

 LDA NA2%,X             \ Copy the X-th byte of the default commander in NA2% to
 STA BUF,X              \ the X-th byte of BUF

 DEX                    \ Decrement the byte counter

 BPL resb1              \ Loop back until we have copied all 79 bytes

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

