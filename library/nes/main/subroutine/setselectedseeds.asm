\ ******************************************************************************
\
\       Name: SetSelectedSeeds
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the seeds for the selected system in QQ15 to the seeds in the
\             safehouse
\
\ ******************************************************************************

.SetSelectedSeeds

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ from safehouse into QQ15, where we store the seeds for
                        \ the selected system, so set up a counter in X for
                        \ copying six bytes (for three 16-bit seeds)

.safe1

 LDA safehouse,X        \ Copy the X-th byte in safehouse to the X-th byte in
 STA QQ15,X             \ QQ15

 DEX                    \ Decrement the counter

 BPL safe1              \ Loop back until we have copied all six bytes

