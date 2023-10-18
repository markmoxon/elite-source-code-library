\ ******************************************************************************
\
\       Name: EnableSoundS
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the EnableSound
\             routine
\
\ ******************************************************************************

.EnableSoundS

 JMP EnableSound        \ Jump to the EnableSound routine, returning from the
                        \ subroutine using a tail call

