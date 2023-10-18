\ ******************************************************************************
\
\       Name: SetSelectionFlags
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the selected system flags for the currently selected system
\             and update the icon bar if required
\
\ ******************************************************************************

.SetSelectionFlags

 LDA QQ8+1              \ If the high byte of the distance to the selected
 BNE ssel3              \ system in QQ18(1 0) is non-zero, then it is a long way
                        \ from us, so jump to ssel3 to set the selected system
                        \ flags to indicate we can't hyperspace there

 LDA QQ8                \ If the low byte of the distance to the selected
 BNE ssel1              \ system in QQ18(1 0) is non-zero, then jump to ssel1
                        \ to check whether we have enough fuel to hyperspace
                        \ there

                        \ If we get here then QQ18(1 0) is zero, so the selected
                        \ system is the same as the current system

 LDA MJ                 \ If MJ is zero then we are not in witchspace, so jump
 BEQ ssel3              \ to ssel3 to set the selected system flags to indicate
                        \ we can't hyperspace to the selected system (as it is
                        \ the same as the current system)

 BNE ssel2              \ MJ is non-zero so we are in witchspace, so jump to
                        \ ssel2 to set the selected system flags to indicate we
                        \ can hyperspace to the selected system (as we are in
                        \ the middle of nowhere without a current system)

.ssel1

 CMP QQ14               \ If the distance to the selected system is equal to the
 BEQ ssel2              \ fuel level in QQ14, jump to ssel2 to set the selected
                        \ system flags to indicate we can hyperspace to the
                        \ selected system

 BCS ssel3              \ If the distance to the selected system is greater than
                        \ the fuel level in QQ14, jump to ssel3 to set the
                        \ selected system flags to indicate we can't hyperspace
                        \ to the selected system (as we don't have enough fuel)

                        \ If we get here then the distance to the selected
                        \ system is less than the fuel level in QQ14, so fall
                        \ through into ssel2 to set the selected system flags to
                        \ indicate we can hyperspace to the selected system

.ssel2

 LDA #%11000000         \ Set A so we set bits 6 and 7 of the selected system
                        \ flags below to indicate that a system is selected and
                        \ we can hyperspace to it

 BNE ssel4              \ Jump to ssel4 to skip the following instruction (this
                        \ BNE is effectively a JMP as A is never zero)

.ssel3

 LDA #%10000000         \ Set A so we set bit 7 and clear bit 6 of the selected
                        \ system flags below to indicate that a system is
                        \ selected but we can't hyperspace to it

.ssel4

 TAX                    \ Copy A into X so we can set selectedSystemFlag to this
                        \ value below

 EOR selectedSystemFlag \ Flip bit 7 and possibly bit 6 in selectedSystemFlag
                        \ and keep the result in A

 STX selectedSystemFlag \ Set selectedSystemFlag to X

 ASL A                  \ If bit 6 of the EOR result in A is clear, then the
 BPL RTS6               \ state of bit 6 did not changed in the update above, so
                        \ we don't need to update the icon bar to show or hide
                        \ the hyperspace button, so return from the subroutine
                        \ (as RTS6 contains an RTS)

 JMP UpdateIconBar_b3   \ Otherwise the newly selected system has a different
                        \ "can we hyperspace here?" status to the previous
                        \ selected system, so we need to update the icon bar to
                        \ either hide or show the Hyperspace button, returning
                        \ from the subroutine using a tail call

