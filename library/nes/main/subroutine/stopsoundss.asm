\ ******************************************************************************
\
\       Name: StopSoundsS
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the StopSounds
\             routine
\
\ ******************************************************************************

.StopSoundsS

 JMP StopSounds         \ Jump to the StopSounds routine, returning from the
                        \ subroutine using a tail call

