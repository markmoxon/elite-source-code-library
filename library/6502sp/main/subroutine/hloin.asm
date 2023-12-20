\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Add a sun line to the horizontal line buffer
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y1                  The screen y-coordinate of the line
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.HLOIN

 STY T1                 \ Store Y in T1 so we can preserve it through the call
                        \ to HLOIN

 LDY HBUP               \ Set Y to the size of the horizontal line buffer

 LDA X1                 \ Store X1, X2 and Y1 in the Y-th to Y+2-th bytes of
 STA HBUF,Y             \ the horizontal line buffer at HBUF
 LDA X2
 STA HBUF+1,Y
 LDA Y1
 STA HBUF+2,Y

 TYA                    \ Set A = Y + 3
 CLC                    \       = HBUP + 3
 ADC #3
 STA HBUP

 BMI HBFL               \ If A > 127, jump to HBFL to draw the lines in the
                        \ horizontal line buffer as the buffer is full

 LDY T1                 \ Restore the value of Y from T1, so it is preserved

 RTS                    \ Return from the subroutine

