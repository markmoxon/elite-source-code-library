\ ******************************************************************************
\
\       Name: SOUL3b
\       Type: Subroutine
\   Category: Sound
\    Summary: Check whether this is the last voice when making sound effects in
\             the interrupt routine, and return from the interrupt if it is
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The voice number that is currently being processed in
\                       the interrupt routine at SOINT (0 to 2)
\
\ ******************************************************************************

.SOUL3b

 DEY                    \ Decrement the voice number

 BPL SOUL8              \ If we have not yet processed all three voices then Y
                        \ will still be positive (i.e. 0, 1 or 2), so jump to
                        \ SOUL8 to process this voice

                        \ If we get here then we have processed all three voices
                        \ in the sound effects interrupt routine, so we now need
                        \ to return from the interrupt

 PLA                    \ Retrieve the value of Y we stored on the stack at the
 TAY                    \ start of the music section of the interrupt routine,
                        \ so it is preserved

                        \ Fall through into COMIRQ3 to restore the A and X
                        \ registers and the correct memory configuration, and
                        \ return from the interrupt

