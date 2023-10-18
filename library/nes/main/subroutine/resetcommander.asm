\ ******************************************************************************
\
\       Name: ResetCommander
\       Type: Subroutine
\   Category: Save and load
\    Summary: Reset the current commander to the default "JAMESON" commander
\
\ ******************************************************************************

.ResetCommander

 JSR JAMESON            \ Copy the default "JAMESON" commander to the buffer at
                        \ currentSlot

 LDX #79                \ We now want to copy 78 bytes from the buffer at
                        \ currentSlot to the current commander at NAME, so
                        \ set a byte counter in X (which counts down from 79 to
                        \ 1 as we copy bytes 78 to 0)

.resc1

 LDA currentSlot-1,X    \ Copy byte X-1 from currentSlot to byte X-1 of NAME
 STA NAME-1,X

 DEX                    \ Decrement the byte counter

 BNE resc1              \ Loop back until we have copied all 78 bytes

 RTS                    \ Return from the subroutine

