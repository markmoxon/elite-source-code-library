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

IF NOT(_ELITE_A_6502SP_PARA)

 JSR LSHIPS             \ Call LSHIPS to load a new ship blueprints file

ELIF _ELITE_A_6502SP_PARA

 JSR LSHIPS             \ Call LSHIPS to populate the ship blueprints table
                        \ with a random selection of ships

ENDIF

 JSR RESET              \ Call RESET to reset most variables

 LDA #&FF               \ Set QQ1 to &FF to indicate we are docked, so when
 STA QQ12               \ we reach TT110 after calling FRCE below, it shows the
                        \ launch tunnel

 STA QQ11               \ Set the view number to a non-zero value, so when we
                        \ reach LOOK1 after calling FRCE below, it sets up a
                        \ new space view

IF NOT(_ELITE_A_6502SP_PARA)

 LDA #f0                \ Jump into the main game loop at FRCE, setting the key
 JMP FRCE               \ "pressed" to red key f0 (so we launch from the
                        \ station)

ELIF _ELITE_A_6502SP_PARA

 STA dockedp            \ Set dockedp to &FF to indicate that we are no longer
                        \ docked

 LDA #f0                \ Jump into the main game loop at FRCE_FLIGHT, setting
 JMP FRCE_FLIGHT        \ the key "pressed" to red key f0 (so we launch from the
                        \ station)

ENDIF

