\ ******************************************************************************
\
\       Name: LOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Add a line segment to the multi-segment line buffer
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the segment
\
\   Y1                  The screen y-coordinate of the start of the segment
\
\   X2                  The screen x-coordinate of the end of the segment
\
\   Y2                  The screen y-coordinate of the end of the segment
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.LOIN

 STY T1                 \ Store Y in T1 so we can preserve it through the call
                        \ to LOIN

 LDY LBUP               \ Set Y to the size of the line buffer

 LDA X1                 \ Store X1, Y1, X2 and Y2 in the Y-th to Y+3-th bytes of
 STA LBUF,Y             \ the line buffer at LBUF
 LDA Y1
 STA LBUF+1,Y
 LDA X2
 STA LBUF+2,Y
 LDA Y2
 STA LBUF+3,Y

 TYA                    \ Set A = Y + 4
 CLC                    \       = LBUP + 4
 ADC #4

 STA LBUP               \ Update LBUP with the value in A, to grow the line
                        \ buffer by the four bytes we just added

 CMP #250               \ If A >= 250, jump to LBFL to draw the line in the
 BCS LBFL               \ line buffer

 LDY T1                 \ Restore the value of Y from T1, so it is preserved

 RTS                    \ Return from the subroutine

