\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The main interrupt handler (IRQ1V points here)
\
\ ******************************************************************************

.IRQ1

 LDA L0D06              \ ???
 EOR #&FF
 STA L0D06

 ORA L0D01
 BMI jvec

 LDA VIA+&05
 ORA #&20
 STA VIA+&05

 LDA &FC                \ Restore the value of A from before the call to the
                        \ interrupt handler (the MOS stores the value of A in
                        \ location &FC before calling the interrupt handler)

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

.jvec

 JMP (S%+2)             \ Jump to the original value of IRQ1V to process the
                        \ interrupt as normal

