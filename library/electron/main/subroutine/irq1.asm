\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The main interrupt handler (IRQ1V points here)
\
\ ******************************************************************************

.IRQ1

 LDA L0D06              \ Flip all the bits in L0D06???
 EOR #%11111111
 STA L0D06

 ORA KEYB               \ If we are currently reading from the keyboard with an
 BMI jvec               \ OS command (OSWORD or OSRDCH) then KEYB will be &FF
                        \ rather than 0, so this jumps to jvec if we are already
                        \ reading the keyboard with an OS command

 LDA VIA+&05            \ If we get here then we are not already reading the
 ORA #%00100000         \ keyboard using an OS command, so set bit 5 of the 
 STA VIA+&05            \ interrupt clear and paging register at SHEILA &05 to
                        \ clear the RTC interrupt

 LDA &FC                \ Restore the value of A from before the call to the
                        \ interrupt handler (the MOS stores the value of A in
                        \ location &FC before calling the interrupt handler)

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

.jvec

 JMP (S%+2)             \ Jump to the original value of IRQ1V to process the
                        \ interrupt as normal

