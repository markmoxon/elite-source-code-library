\ ******************************************************************************
\
\       Name: CLIP_b1
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Call the CLIP routine in ROM bank 1, drawing the clipped line if
\             it fits on-screen
\
\ ******************************************************************************

.CLIP_b1

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR CLIP               \ Call CLIP, now that it is paged into memory

 BCS P%+5               \ If the C flag is set then the clipped line does not
                        \ fit on-screen, so skip the next instruction

 JSR LOIN               \ The clipped line fits on-screen, so draw it

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

