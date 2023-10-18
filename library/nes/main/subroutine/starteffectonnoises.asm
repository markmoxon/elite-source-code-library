\ ******************************************************************************
\
\       Name: StartEffectOnNOISES
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the
\             StartEffectOnNOISE routine
\
\ ******************************************************************************

.StartEffectOnNOISES

 JMP StartEffectOnNOISE \ Jump to the StartEffectOnNOISE routine, returning from
                        \ the subroutine using a tail call

