\ ******************************************************************************
\
\       Name: DisableJustifyText
\       Type: Subroutine
\   Category: Text
\    Summary: Turn off justified text and reset the justified text buffer
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS5                Contains an RTS
\
\ ******************************************************************************

.DisableJustifyText

 LDA #0                 \ Set DTW4 = %00000000 (do not justify text, print
 STA DTW4               \ buffer on carriage return)

 STA DTW5               \ Set DTW5 = 0, to reset the size of the message in the
                        \ text buffer at BUF

.RTS5

 RTS                    \ Return from the subroutine

