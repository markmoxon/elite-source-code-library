\ ******************************************************************************
\
\       Name: ChooseMusicS
\       Type: Subroutine
\   Category: Sound
\    Summary: A jump table entry at the start of bank 6 for the ChooseMusic
\             routine
\
\ ******************************************************************************

.ChooseMusicS

 JMP ChooseMusic        \ Jump to the ChooseMusic routine, returning from the
                        \ subroutine using a tail call

