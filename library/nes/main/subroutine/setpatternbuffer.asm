\ ******************************************************************************
\
\       Name: SetPatternBuffer
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the high byte of the pattern buffer address variables
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The bitplane whose pattern address we should use
\
\ ******************************************************************************

.SetPatternBuffer

 LDA pattBufferHiAddr,X \ Set the high byte of pattBufferAddr(1 0) to the
 STA pattBufferAddr+1   \ correct address for the pattern buffer for bitplane X

 LSR A                  \ Set pattBufferHiDiv8 to the high byte of the pattern
 LSR A                  \ buffer address, divided by 8
 LSR A
 STA pattBufferHiDiv8

 RTS                    \ Return from the subroutine

