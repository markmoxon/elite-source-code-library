\ ******************************************************************************
\
\       Name: TT81
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the selected system's seeds to those of system 0
\
\ ------------------------------------------------------------------------------
\
\ Copy the three 16-bit seeds for the current galaxy's system 0 (QQ21) into the
\ seeds for the selected system (QQ15) - in other words, set the selected
\ system's seeds to those of system 0.
\
\ ******************************************************************************

.TT81

 LDX #5                 \ Set up a counter in X to copy six bytes (for three
                        \ 16-bit numbers)

 LDA QQ21,X             \ Copy the X-th byte in QQ21 to the X-th byte in QQ15
 STA QQ15,X

 DEX                    \ Decrement the counter

 BPL TT81+2             \ Loop back up to the LDA instruction if we still have
                        \ more bytes to copy

 RTS                    \ Return from the subroutine

