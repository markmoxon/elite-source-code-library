\ ******************************************************************************
\
\       Name: DK4_FLIGHT
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for pause, configuration and secondary flight keys (flight
\             version)
\
\ ******************************************************************************

.DK4_FLIGHT

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 STX KL                 \ Store X in KL, byte #0 of the key logger

 CPX #&69               \ If COPY is not being pressed, jump to DK2_FLIGHT
 BNE DK2_FLIGHT         \ below, otherwise let's process the configuration
                        \ keys

.FREEZE_FLIGHT

                        \ COPY is being pressed, so we enter a loop that
                        \ listens for configuration keys, and we keep looping
                        \ until we detect a DELETE key press. This effectively
                        \ pauses the game when COPY is pressed, and unpauses
                        \ it when DELETE is pressed

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 CPX #&51               \ If "S" is not being pressed, skip to DK6_FLIGHT
 BNE DK6_FLIGHT

 LDA #0                 \ "S" is being pressed, so set DNOIZ to 0 to turn the
 STA DNOIZ              \ sound on

.DK6_FLIGHT

 LDY #&40               \ We now want to loop through the keys that toggle
                        \ various settings. These have internal key numbers
                        \ between &40 (CAPS LOCK) and &46 ("K"), so we set up
                        \ the first key number in Y to act as a loop counter.
                        \ See subroutine DKS3 for more details on this

.DKL4_FLIGHT

 JSR DKS3               \ Call DKS3 to scan for the key given in Y, and toggle
                        \ the relevant setting if it is pressed

 INY                    \ Increment Y to point to the next toggle key

 CPY #&48               \ The last toggle key is &47 (@), so check whether we
                        \ have just done that one

 BNE DKL4_FLIGHT        \ If not, loop back to check for the next toggle key

 CPX #&10               \ If "Q" is not being pressed, skip to DK7_FLIGHT
 BNE DK7_FLIGHT

 STX DNOIZ              \ "Q" is being pressed, so set DNOIZ to X, which is
                        \ non-zero (&10), so this will turn the sound off

.DK7_FLIGHT

 CPX #&70               \ If ESCAPE is not being pressed, skip over the next
 BNE P%+5               \ instruction

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end
                        \ the game

\CPX #&37               \ These instructions are commented out in the original
\BNE dont_dump          \ source
\JSR printer
\.dont_dump

 CPX #&59               \ If DELETE is not being pressed, we are still paused,
 BNE FREEZE_FLIGHT      \ so loop back up to keep listening for configuration
                        \ keys, otherwise fall through into the rest of the
                        \ key detection code, which unpauses the game

.DK2_FLIGHT

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE DK5                \ view), return from the subroutine (as DK5 contains
                        \ an RTS)

 LDY #16                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+16, and their key logger locations are from KL+8
                        \ to KL+16. So set a decreasing counter in Y for the
                        \ index, starting at 16, so we can loop through them

.DKL1_FLIGHT

 JSR DKS1               \ Call DKS1 to see if the KYTB key at offset Y is being
                        \ pressed, and set the key logger accordingly

 DEY                    \ Decrement the loop counter

 CPY #7                 \ Have we just done the last key?

 BNE DKL1_FLIGHT        \ If not, loop back to process the next key

.DK5

 RTS                    \ Return from the subroutine

