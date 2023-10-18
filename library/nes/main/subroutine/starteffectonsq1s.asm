\ ******************************************************************************
\
\       Name: StartEffectOnSQ1S
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the StartEffectOnSQ1
\             routine
\
\ ******************************************************************************

.StartEffectOnSQ1S

 JMP StartEffectOnSQ1   \ Jump to the StartEffectOnSQ1 routine, returning from
                        \ the subroutine using a tail call

