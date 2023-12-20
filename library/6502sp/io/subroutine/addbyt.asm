\ ******************************************************************************
\
\       Name: ADDBYT
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Implement the OSWRCH 130 <byte> command (add a byte to a line and
\             draw it when all bytes are received)
\
\ ------------------------------------------------------------------------------
\
\ This routine receives bytes from the parasite, each of which is a coordinate
\ in the line that is currently being drawn (following a call from the parasite
\ to OSWRCH 129, which starts the I/O processor listening for line bytes). They
\ are stored in the buffer at TABLE, where LINTAB points to the first free byte
\ in the table, and LINMAX contains double the number of points we are expecting
\ plus 1.
\
\ If the byte received is the last one in the line, then the line segments are
\ drawn by sending them to the LOIN routine.
\
\ If a laser line is sent by the parasite, it will be the first line segment
\ sent, and will be preceded by a dummy pair of coordinates where the Y2 value
\ is 255, which is not in the space view (as the maximum y-coordinate in the
\ space view is 191). Laser lines are drawn in red.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The byte to be added to the line that's currently being
\                       transmitted to the I/O processor
\
\ ******************************************************************************

.RTS1

 RTS                    \ Return from the subroutine (this is called below)

.ADDBYT

 INC LINTAB             \ LINTAB points to the last free byte in TABLE, which is
                        \ where we're about to store the new byte in A, so
                        \ increment LINTAB to point to the byte after this one

 LDX LINTAB             \ Store the new byte in A at position LINTAB-1 in TABLE
 STA TABLE-1,X          \ (which was the last free byte before we incremented
                        \ LINTAB above)

 INX                    \ Increment X, so it now points to the byte after the
                        \ last free byte in TABLE (i.e. LINTAB + 1)

 CPX LINMAX             \ If X < LINMAX, jump up to RTS1 to return from the
 BCC RTS1               \ subroutine, as the line isn't complete yet (because
                        \ LINMAX contains the 2 * number of points + 1)

                        \ If we get here then X = LINMAX and we have received
                        \ all the line's points from the parasite, so now we
                        \ draw it

 LDY #0                 \ We are going to loop through all the points in the
                        \ line, so set a counter in Y, starting from 0

 DEC LINMAX             \ Decrement LINMAX so it now contains 2 * number of
                        \ points

 LDA TABLE+3            \ If TABLE+3 = 255, jump to doalaser to draw this line,
 CMP #255               \ as this denotes that the following segment is a laser
 BEQ doalaser           \ line, which should be drawn in red

.LL27

 LDA TABLE,Y            \ Set X1 to the Y-th byte from TABLE
 STA X1

 LDA TABLE+1,Y          \ Set Y1 to the Y+1-th byte from TABLE
 STA Y1

 LDA TABLE+2,Y          \ Set X2 to the Y+2-th byte from TABLE
 STA X2

 LDA TABLE+3,Y          \ Set Y2 to the Y+3-th byte from TABLE
 STA Y2

 STY T1                 \ Store the loop counter in T1 so we can retrieve it
                        \ after the call to LOIN

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 LDA T1                 \ Retrieve the loop counter from T1

 CLC                    \ Set A = A + 4
 ADC #4

.Ivedonealaser

 TAY                    \ Transfer the updated loop counter from A into Y

 CMP LINMAX             \ Loop back to LL27 to draw the next line segment, until
 BCC LL27               \ we the loop counter has reached LINMAX (which contains
                        \ 2 * number of points, so this is when we have run out
                        \ of points)

.DRLR1

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

.doalaser

 LDA COL                \ Store the current line colour on the stack, so we can
 PHA                    \ restore it below

 LDA #RED               \ Set the laser colour to red
 STA COL

                        \ The coordinates at bytes Y to Y+3 were used up with
                        \ the indicator bytes to say this is a laser line, so
                        \ we need to fetch the following bytes to get the line's
                        \ coordinates to draw

 LDA TABLE+4            \ Set X1 to the Y+4-th byte from TABLE
 STA X1

 LDA TABLE+5            \ Set Y1 to the Y+5-th byte from TABLE
 STA Y1

 LDA TABLE+6            \ Set X2 to the Y+6-th byte from TABLE
 STA X2

 LDA TABLE+7            \ Set Y2 to the Y+7-th byte from TABLE
 STA Y2

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 PLA                    \ Restore the original line colour from the stack
 STA COL

 LDA #8                 \ Jump up to Ivedonealaser with A set to 8, which will
 BNE Ivedonealaser      \ point to the rest of the lines as the laser line is
                        \ always the first to be transmitted from the parasite
                        \ (this BNE is effectively a JMP as A is never zero)

