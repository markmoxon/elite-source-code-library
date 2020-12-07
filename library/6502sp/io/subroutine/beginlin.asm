\ ******************************************************************************
\
\       Name: BEGINLIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Implement the OSWRCH &81 command (start receiving a new line to
\             draw)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of points in the new line
\
\ ******************************************************************************

.BEGINLIN

 STA LINMAX             \ Set LINMAX to the number of points in the new line

 LDA #0                 \ Set LINTAB = 0 to point to the position of the next
 STA LINTAB             \ free byte in the TABLE buffer (i.e. the first byte, as
                        \ we have just reset the buffer)

 LDA #&82               \ Call USOSWRCH to run an #ADDBYT command, so subsequent
 JMP USOSWRCH           \ OSWRCH calls by the I/O processor get added to TABLE,
                        \ and return from the subroutine using a tail call

