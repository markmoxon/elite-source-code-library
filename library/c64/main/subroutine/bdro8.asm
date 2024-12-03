\ ******************************************************************************
\
\       Name: BDRO8
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#8> to rest for value4 interrupts
\
\ ******************************************************************************

.BDRO8

 LDA value4             \ Set the music counter to value4, so we introduce a
 STA counter            \ rest of value4 interrupts (i.e. a pause where we play
                        \ no music)

 JMP BDirqhere          \ Jump back to the start of the interrupt routine so the
                        \ counter starts to count down

