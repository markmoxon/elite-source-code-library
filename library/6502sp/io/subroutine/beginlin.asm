\ ******************************************************************************
\
\       Name: BEGINLIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Implement the OSWRCH 129 command (start receiving a new line to
\             draw)
\
\ ------------------------------------------------------------------------------
\
\ We draw line by first sending an OSWRCH 129 command to the I/O processor to
\ tell it to start receiving a new line to draw. The parameter to this call
\ (sent with the next OSWRCH) contains the number of bytes we are going to send
\ containing the line's coordinates.
\
\ This routine then executes an OSWRCH 130 command, which calls the ADDBYT
\ routine to start the I/O processor listening for more bytes from the parasite.
\ These get added to the TABLE buffer, and when the parasite has sent all the
\ coordinates, we draw the line.
\
\ Arguments:
\
\   A                   The number of points in the new line + 1
\
\ ******************************************************************************

.BEGINLIN

 STA LINMAX             \ Set LINMAX to the number of points in the new line + 1

 LDA #0                 \ Set LINTAB = 0 to point to the position of the next
 STA LINTAB             \ free byte in the TABLE buffer (i.e. the first byte, as
                        \ we have just reset the buffer)

 LDA #130               \ Execute a USOSWRCH 130 command so subsequent OSWRCH
 JMP USOSWRCH           \ calls from the parasite can send coordinates that get
                        \ added to TABLE, and return from the subroutine using a
                        \ tail call

