\ ******************************************************************************
\
\       Name: DEBRIEF2
\       Type: Subroutine
\   Category: Missions
\    Summary: Finish mission 2
\
\ ******************************************************************************

.DEBRIEF2

 LDA TP                 \ Set bit 2 of TP to indicate mission 2 is complete (so
 ORA #%00000100         \ both bits 2 and 3 are now set)
 STA TP

IF _ELITE_A_VERSION

 LDA ENGY               \ AJD
 BNE rew_notgot
 DEC new_hold	        \** NOT TRAPPED FOR NO SPACE

.rew_notgot

ENDIF

 LDA #2                 \ Set ENGY to 2 so our energy banks recharge at twice
 STA ENGY               \ the speed, as our mission reward is a special navy
                        \ energy unit

 INC TALLY+1            \ Award 256 kill points for completing the mission

 LDA #223               \ Set A = 223 so the call to BRP prints extended token
                        \ 223 (the thank you message at the end of mission 2)

 BNE BRP                \ Jump to BRP to print the extended token in A and show
                        \ the Status Mode screen), returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as A
                        \ is never zero)

