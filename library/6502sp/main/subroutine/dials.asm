\ ******************************************************************************
\
\       Name: DIALS
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Update the dashboard indicators by sending a #RDPARAMS command to
\             the I/O processor
\
\ ******************************************************************************

.DIALS

 LDA #RDPARAMS          \ Send a #RDPARAMS command to the I/O processor to tell
 JSR OSWRCH             \ it to expect a sequence of parameters containing the
 JSR OSWRCH             \ data it needs to update the dashboard dials

 LDA ENERGY             \ Send the energy bank status to the I/O processor
 JSR OSWRCH

 LDA ALP1               \ Send the magnitude of the roll angle to the I/O
 JSR OSWRCH             \ processor

 LDA ALP2               \ Send the sign of the roll angle to the I/O processor
 JSR OSWRCH

 LDA BETA               \ Send the magnitude of the pitch angle to the I/O
 JSR OSWRCH             \ processor

 LDA BET1               \ Send the sign of the pitch angle to the I/O processor
 JSR OSWRCH

 LDA DELTA              \ Send the current speed to the I/O processor
 JSR OSWRCH

 LDA ALTIT              \ Send the current altitude to the I/O processor
 JSR OSWRCH

 LDA MCNT               \ Send the value of the main loop counter to the I/O
 JSR OSWRCH             \ processor

 LDA FSH                \ Send the front shield status to the I/O processor
 JSR OSWRCH

 LDA ASH                \ Send the aft shield status to the I/O processor
 JSR OSWRCH

 LDA QQ14               \ Send the current fuel level to the I/O processor
 JSR OSWRCH

 LDA GNTMP              \ Send the laser temperature to the I/O processor
 JSR OSWRCH

 LDA CABTMP             \ Send the cabin temperature to the I/O processor
 JSR OSWRCH

 LDA FLH                \ Send the flashing console bars configuration setting
 JSR OSWRCH             \ to the I/O processor

 LDA ESCP               \ Send the escape pod status to the I/O processor
 JSR OSWRCH

 LDA MCNT               \ This value will be zero on one out of every four
 AND #3                 \ iterations of the main loop, so skip the following
 BEQ P%+3               \ instruction when that happens (so we only update the
                        \ compass once every four iterations of the main loop)
 
 RTS                    \ Return from the subroutine

 JMP COMPAS             \ Jump to COMPAS to update the compass, returning from
                        \ the subroutine using a tail call

