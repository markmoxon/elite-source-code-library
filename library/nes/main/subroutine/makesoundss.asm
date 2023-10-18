\ ******************************************************************************
\
\       Name: MakeSoundsS
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the MakeSounds
\             routine
\
\ ******************************************************************************

.MakeSoundsS

 JMP MakeSounds         \ Jump to the MakeSounds routine, returning from the
                        \ subroutine using a tail call

