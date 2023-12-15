\ ******************************************************************************
\
\       Name: DET1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Show or hide the dashboard (for when we die) by sending a #DODIALS
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of text rows to display on the screen (24
\                       will hide the dashboard, 31 will make it reappear)
\
\ ******************************************************************************

.DET1

 LDA #DODIALS           \ Send the first part of a #DODIALS command to the I/O
 JSR OSWRCH             \ processor

 TXA                    \ Send the new number of rows to the I/O processor, so
 JMP OSWRCH             \ we've now sent a #DODIALS <rows> command

