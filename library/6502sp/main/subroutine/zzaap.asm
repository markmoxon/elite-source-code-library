\ ******************************************************************************
\
\       Name: ZZAAP
\       Type: Subroutine
\   Category: Demo
\    Summary: Draw a vertical red laser line from (128, 67) to (128, 160)
\
\ ******************************************************************************

.ZZAAP

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is red in the space view

 LDA #128               \ Set X1 = 128
 STA X1

 STA X2                 \ Set X2 = 128

 LDA #67                \ Set Y1 = 67
 STA Y1

 LDA #160               \ Set Y2 = 160
 STA Y2

 JMP LL30               \ Call LL30 to draw a line from (X1, Y1) to (X2, Y2),
                        \ returning from the subroutine using a tail

