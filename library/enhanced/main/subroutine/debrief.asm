\ ******************************************************************************
\
\       Name: DEBRIEF
\       Type: Subroutine
\   Category: Missions
\    Summary: Finish mission 1
\  Deep dive: The Constrictor mission
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BRPS                Print the extended token in A, show the Status Mode
\                       screen and return from the subroutine
\
\ ******************************************************************************

.DEBRIEF

 LSR TP                 \ Clear bit 0 of TP to indicate that mission 1 is no
 ASL TP                 \ longer in progress, as we have completed it

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Advanced: In the disc and 6502SP versions, killing the Constrictor at the end of mission 1 gives you 256 kill points, but only when you attend the debriefing. In the Master and NES versions, you get the kill points the instant you kill the Constrictor

 INC TALLY+1            \ Award 256 kill points for completing the mission

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

\INC TALLY+1            \ This instruction is commented out in the original
                        \ source

ENDIF

 LDX #LO(50000)         \ Increase our cash reserves by the generous mission
 LDY #HI(50000)         \ reward of 5,000 CR
 JSR MCASH

 LDA #15                \ Set A = 15 so the call to BRP prints extended token 15
                        \ (the thank you message at the end of mission 1)

.BRPS

 BNE BRP                \ Jump to BRP to print the extended token in A and show
                        \ the Status Mode screen, returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as A
                        \ is never zero)

