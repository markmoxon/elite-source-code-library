\ ******************************************************************************
\
\       Name: DEBRIEF2
\       Type: Subroutine
\   Category: Missions
\    Summary: Finish mission 2
\  Deep dive: The Thargoid Plans mission
\
\ ******************************************************************************

.DEBRIEF2

 LDA TP                 \ Set bit 2 of TP to indicate mission 2 is complete (so
 ORA #%00000100         \ both bits 2 and 3 are now set)
 STA TP

IF _ELITE_A_VERSION

 LDA ENGY               \ If we already have an energy unit fitted (i.e. ENGY is
 BNE rew_notgot         \ non-zero), jump to rew_notgot to skip the following
                        \ instruction

 DEC new_hold           \ We're about to be given a special navy energy unit,
                        \ which doesn't take up space in the hold, so decrement
                        \ new_hold to reclaim the space for our old energy unit

.rew_notgot

ENDIF

 LDA #2                 \ Set ENGY to 2 so our energy banks recharge at a faster
 STA ENGY               \ rate, as our mission reward is a special navy energy
                        \ unit that recharges at a rate of 3 units of energy on
                        \ each iteration of the main loop, compared to a rate of
                        \ 2 units of energy for the standard energy unit

 INC TALLY+1            \ Award 256 kill points for completing the mission

 LDA #223               \ Set A = 223 so the call to BRP prints extended token
                        \ 223 (the thank you message at the end of mission 2)

 BNE BRP                \ Jump to BRP to print the extended token in A and show
                        \ the Status Mode screen), returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as A
                        \ is never zero)

