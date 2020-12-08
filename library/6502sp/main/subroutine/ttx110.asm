\ ******************************************************************************
\
\       Name: TTX110
\       Type: Subroutine
\   Category: Flight
\    Summary: Set the current system to the nearest system and return to hyp
\
\ ******************************************************************************

.TTX110

                        \ This routine is only called from the hyp routine, and
                        \ it jumps back into hyp at label TTX111

 JSR TT111              \ Call TT111 to set the current system to the nearest
                        \ system to (QQ9, QQ10), and put the seeds of the
                        \ nearest system into QQ15 to QQ15+5

 JMP TTX111             \ Return to TTX111 in the hyp routine

