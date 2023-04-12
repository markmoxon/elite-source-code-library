\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: LL30
ELIF _MASTER_VERSION
\       Name: LOIN
ENDIF
\       Type: Subroutine
\   Category: Drawing lines
IF _6502SP_VERSION \ Comment
\    Summary: Draw a one-segment line by sending an OSWRCH 129 command to the
\             I/O processor
ELIF _MASTER_VERSION
\    Summary: Draw a one-segment line
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   Y1                  The screen y-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y2                  The screen y-coordinate of the end of the line
\
\ ******************************************************************************

IF _6502SP_VERSION \ Tube

.LL30

 LDA #129               \ Send an OSWRCH 129 command to the I/O processor to
 JSR OSWRCH             \ tell it to start receiving a new line to draw. The
                        \ parameter to this call needs to contain the number of
                        \ bytes we are going to send for the line's coordinates,
                        \ plus 1, which we send next

 LDA #5                 \ Send 5 to the I/O processor as the argument to the
 JSR OSWRCH             \ OSWRCH 129 command, so the I/O processor should expect
                        \ 4 bytes (as we send the count plus 1)

 LDA X1                 \ Send X1, Y1, X2 and Y2 to the I/O processor, so the
 JSR OSWRCH             \ I/O processor will draw a line from (X1, Y1) to
 LDA Y1                 \ (X2, Y2), returning from the subroutine using a tail
 JSR OSWRCH             \ call
 LDA X2
 JSR OSWRCH
 LDA Y2
 JMP OSWRCH

ELIF _MASTER_VERSION

.LOIN

 STY YSAV               \ Store Y in YSAV so we can retrieve it below

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 JSR LOINQ              \ Draw a line from (X1, Y1) to (X2, Y2)

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 LDY YSAV               \ Retrieve the value of Y we stored above

 RTS                    \ Return from the subroutine

ENDIF

