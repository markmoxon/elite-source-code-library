\ ******************************************************************************
\
\       Name: SetCurrentSystem
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the seeds for the selected system to the system that we last
\             snapped the crosshairs to
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS6                Contains an RTS
\
\ ******************************************************************************

.SetCurrentSystem

 LDX #5                 \ Set up a counter in X to copy six bytes (for three
                        \ 16-bit numbers)

.ssys1

 LDA selectedSystem,X   \ Copy the X-th byte in selectedSystem to the X-th byte
 STA QQ15,X             \ in QQ15, to set the selected system to the previous
                        \ system that we snapped the crosshairs to

 DEX                    \ Decrement the counter

 BPL ssys1              \ Loop back until we have copied all six seeds

.RTS6

 RTS                    \ Return from the subroutine

