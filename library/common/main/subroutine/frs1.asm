\ ******************************************************************************
\
\       Name: FRS1
\       Type: Subroutine
\   Category: Tactics
\    Summary: Launch a ship straight ahead of us, below the laser sights
\
\ ------------------------------------------------------------------------------
\
\ This is used in two places:
\
\   * When we launch a missile, in which case the missile is the ship that is
\     launched ahead of us
\
\   * When we launch our escape pod, in which case it's our abandoned Cobra Mk
\     III that is launched ahead of us
\
\   * The fq1 entry point is used to launch a bunch of cargo canisters ahead of
\     us as part of the death screen
\
\ Arguments:
\
\   X                   The type of ship to launch ahead of us
\
\ Returns:
\
\   C flag              Set if the ship was successfully launched, clear if it
\                       wasn't (as there wasn't enough free memory)
\
\ Other entry points:
\
\   fq1                 Used to add a cargo canister to the universe
\
\ ******************************************************************************

.FRS1

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #28                \ Set y_lo = 28
 STA INWK+3

 LSR A                  \ Set z_lo = 14, so the launched ship starts out
 STA INWK+6             \ ahead of us

 LDA #%10000000         \ Set y_sign to be negative, so the launched ship is
 STA INWK+5             \ launched just below our line of sight

 LDA MSTG               \ Set A to the missile lock target, shifted left so the
 ASL A                  \ slot number is in bits 1-5

 ORA #%10000000         \ Set bit 7 and store the result in byte #32, the AI
 STA INWK+32            \ flag launched ship for the launched ship. For missiles
                        \ this enables AI (bit 7), makes it friendly towards us
                        \ (bit 6), sets the target to the value of MSTG (bits
                        \ 1-5), and sets its lock status as launched (bit 0).
                        \ It doesn't matter what it does for our abandoned
                        \ Cobra, as the AI flag gets overwritten once we return
                        \ from the subroutine back to the ESCAPE routine that
                        \ called FRS1 in the first place

.fq1

 LDA #&60               \ Set byte #14 (nosev_z_hi) to 1 (&60), so the launched
 STA INWK+14            \ ship is pointing away from us

 ORA #128               \ Set byte #22 (sidev_x_hi) to -1 (&D0), so the launched
 STA INWK+22            \ ship has the same orientation as spawned ships, just
                        \ pointing away from us (if we set sidev to +1 instead,
                        \ this ship would be a mirror image of all the other
                        \ ships, which are spawned with -1 in nosev and +1 in
                        \ sidev)

 LDA DELTA              \ Set byte #27 (speed) to 2 * DELTA, so the launched
 ROL A                  \ ship flies off at twice our speed
 STA INWK+27

 TXA                    \ Add a new ship of type X to our local bubble of
 JMP NWSHP              \ universe and return from the subroutine using a tail
                        \ call

