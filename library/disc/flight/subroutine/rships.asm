\ ******************************************************************************
\
\       Name: RSHIPS
\       Type: Subroutine
\   Category: Loader
\    Summary: Launch from the station, load a new set of ship blueprints and
\             jump into the main game loop
\
\ ******************************************************************************

.RSHIPS

 JSR LSHIPS             \ Call LSHIPS to load a new ship blueprints file

 JSR RESET              \ Call RESET to reset most variables

 LDA #&FF               \ Set QQ1 to &FF to indicate we are docked, so when
 STA QQ12               \ we reach TT110 after calling FRCE below, it skips the
                        \ launch tunnel

 STA QQ11               \ Set the view number to a non-zero value, so when we
                        \ reach LOOK1 after calling FRCE below, it sets up a
                        \ new space view

 LDA #f0                \ Jump into the main game loop at FRCE, setting the key
 JMP FRCE               \ "pressed" to red key f0 (so we launch from the
                        \ station)

