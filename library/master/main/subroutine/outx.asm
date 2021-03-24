\ ******************************************************************************
\
\       Name: OUTX
\       Type: Subroutine
\   Category: Text
\    Summary: Print the character in Q before returning to gnum
\
\ ******************************************************************************

.OUTX

 LDA Q                  \ Print the character in Q, which is the key that was
 JSR DASC               \ just pressed in the gnum routine

 SEC                    \ Set the C flag, as this routine is only called if the
                        \ key pressed makes the number too high

 JMP OUT                \ Jump back into the gnum routine to return the number
                        \ that has been built

