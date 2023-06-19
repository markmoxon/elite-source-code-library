\ ******************************************************************************
\
\       Name: KS2
\       Type: Subroutine
\   Category: Universe
\    Summary: Check the local bubble for missiles with target lock
\
\ ------------------------------------------------------------------------------
\
\ Check the local bubble of universe to see if there are any missiles with
\ target lock in the vicinity. If there are, then check their targets; if we
\ just removed their target in the KILLSHP routine, then switch off their AI so
\ they just drift in space, otherwise update their targets to reflect the newly
\ shuffled slot numbers.
\
\ This is called from KILLSHP once the slots have been shuffled down, following
\ the removal of a ship.
\
\ Arguments:
\
\   XX4                 The slot number of the ship we removed just before
\                       calling this routine
\
\ ******************************************************************************

.KS2

 LDX #&FF               \ We want to go through the ships in our local bubble
                        \ and pick out all the missiles, so set X to &FF to
                        \ use as a counter

.KSL4

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 INX                    \ Increment the counter (so it starts at 0 on the first
                        \ iteration)

 LDA FRIN,X             \ If slot X is empty, loop round again until it isn't,
 BEQ KS3                \ at which point A contains the ship type in that slot

 CMP #MSL               \ If the slot does not contain a missile, loop back to
 BNE KSL4               \ KSL4 to check the next slot

                        \ We have found a slot containing a missile, so now we
                        \ want to check whether it has target lock

 TXA                    \ Set Y = X * 2 and fetch the Y-th address from UNIV
 ASL A                  \ and store it in SC and SC+1 - in other words, set
 TAY                    \ SC(1 0) to point to the missile's ship data block
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1

 LDY #32                \ Fetch byte #32 from the missile's ship data (AI)
 LDA (SC),Y

 BPL KSL4               \ If bit 7 of byte #32 is clear, then the missile is
                        \ dumb and has no AI, so loop back to KSL4 to move on
                        \ to the next slot

 AND #%01111111         \ Otherwise this missile has AI, so clear bit 7 and
 LSR A                  \ shift right to set the C flag to the missile's "is
                        \ locked" flag, and A to the target's slot number

 CMP XX4                \ If this missile's target is less than XX4, then the
 BCC KSL4               \ target's slot isn't being shuffled down, so jump to
                        \ KSL4 to move on to the next slot

 BEQ KS6                \ If this missile was locked onto the ship that we just
                        \ removed in KILLSHP, jump to KS6 to stop the missile
                        \ from continuing to hunt it down

 SBC #1                 \ Otherwise this missile is locked and has AI enabled,
                        \ and its target will have moved down a slot, so
                        \ subtract 1 from the target number (we know C is set
                        \ from the BCC above)

 ASL A                  \ Shift the target number left by 1, so it's in bits
                        \ 1-6 once again, and also set bit 0 to 1, as the C
                        \ flag is still set, so this makes sure the missile is
                        \ still set to being locked

 ORA #%10000000         \ Set bit 7, so the missile's AI is enabled

 STA (SC),Y             \ Update the missile's AI flag to the value in A

 BNE KSL4               \ Loop back to KSL4 to move on to the next slot (this
                        \ BNE is effectively a JMP as A will never be zero)

.KS6

 LDA #0                 \ The missile's target lock just got removed, so set the
 STA (SC),Y             \ AI flag to 0 to make it dumb and not locked

 BEQ KSL4               \ Loop back to KSL4 to move on to the next slot (this
                        \ BEQ is effectively a JMP as A is always zero)

