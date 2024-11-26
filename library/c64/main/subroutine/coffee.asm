\ ******************************************************************************
\
\       Name: coffee
\       Type: Subroutine
\   Category: Sound
\    Summary: Return from the interrupt routine, for when we are making sound
\             effects
\
\ ******************************************************************************

.coffee

 PLA                    \ Retrieve the value of Y we stored on the stack at the
 TAY                    \ start of the music section of the interrupt routine,
                        \ so it is preserved

 PLA                    \ Retrieve the value of X we stored on the stack at the
 TAX                    \ start of the interrupt routine, so it is preserved

 LDA l1                 \ Set bits 0 to 2 of the port register at location l1
 AND #%11111000         \ (&0001) to bits 0 to 2 of L1M, leaving bits 3 to 7
 ORA L1M                \ unchanged
 STA l1                 \
                        \ This sets LORAM, HIRAM and CHAREN to the values in
                        \ L1M, which ensures we return memory to the same
                        \ configuration as when we entered the interrupt routine

 PLA                    \ Retrieve the value of A we stored on the stack at the
                        \ start of the interrupt routine, so it is preserved

 RTI                    \ Return from the interrupt

