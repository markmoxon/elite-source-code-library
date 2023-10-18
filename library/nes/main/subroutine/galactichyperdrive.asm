\ ******************************************************************************
\
\       Name: GalacticHyperdrive
\       Type: Subroutine
\   Category: Flight
\    Summary: If we are in space and the countdown has ended, activate the
\             galactic hyperdrive
\
\ ******************************************************************************

.GalacticHyperdrive

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to dockEd to
 BNE dockEd             \ print an error message and return from the subroutine
                        \ using a tail call (as we can't hyperspace when docked)

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BEQ Ghy                \ If the countdown is zero, then the galactic hyperdrive
                        \ has been activated, so jump to Ghy to process it

 RTS                    \ Otherwise return from the subroutine

