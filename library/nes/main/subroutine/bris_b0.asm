\ ******************************************************************************
\
\       Name: BRIS_b0
\       Type: Subroutine
\   Category: Missions
\    Summary: Clear the screen, display "INCOMING MESSAGE" and wait for 2
\             seconds
\
\ ******************************************************************************

.BRIS_b0

 LDA #216               \ Print extended token 216 ("{clear screen}{tab 6}{move
 JSR DETOK_b2           \ to row 10, white, lower case}{white}{all caps}INCOMING
                        \ MESSAGE"

 JSR UpdateViewWithFade \ Update the view, fading the screen to black first if
                        \ required

 LDY #100               \ Wait for 100/50 of a second (2 seconds) and return
 JMP DELAY              \ from the subroutine using a tail call

