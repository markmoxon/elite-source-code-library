\ ******************************************************************************
\
\       Name: RES4
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset shields and energy banks and lots of flight variables
\
\ ------------------------------------------------------------------------------
\
\ Reset the shields and energy banks, then fall through into RES2 to reset the
\ stardust and the ship workspace at INWK.
\
\ ******************************************************************************

.RES4

 LDA #&FF               \ Set A to &FF so we can fill up the shields and energy
                        \ bars with a full charge

 LDX #2                 \ The two shields and energy bank levels are stored in
                        \ three consecutive bytes, at FSH through FSH+2, so set
                        \ up a counter in X to index these three bytes

.REL5

 STA FSH,X              \ Set the X-th byte in the FSH block to &FF

 DEX                    \ Decrement the loop counter

 BPL REL5               \ Loop back to do the next byte, until we have done
                        \ all three

                        \ Fall through into RES2 to reset stardust and INWK

