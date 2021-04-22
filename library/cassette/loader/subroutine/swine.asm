\ ******************************************************************************
\
\       Name: swine
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Resets the machine if the copy protection detects a problem
\
\ ******************************************************************************

.swine

IF _CASSETTE_VERSION \ Platform

 LDA #%01111111         \ Set 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bits 0-6 (i.e. disable all hardware
                        \ interrupts from the System VIA)

ENDIF

 JMP (&FFFC)            \ Jump to the address in &FFFC to reset the machine

