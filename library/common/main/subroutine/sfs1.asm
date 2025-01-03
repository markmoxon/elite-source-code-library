\ ******************************************************************************
\
\       Name: SFS1
\       Type: Subroutine
\   Category: Universe
\    Summary: Spawn a child ship from the current (parent) ship
\
\ ------------------------------------------------------------------------------
\
\ If the parent is a space station then the child ship is spawned coming out of
\ the slot, and if the child is a cargo canister, it is sent tumbling through
\ space. Otherwise the child ship is spawned with the same ship data as the
\ parent, just with damping disabled and the ship type and AI flag that are
\ passed in A and X.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   AI flag for the new ship (see the documentation on ship
\                       data byte #32 for details)
\
\   X                   The ship type of the child to spawn
\
\   INF                 Address of the parent's ship data block
\
\   TYPE                The type of the parent ship
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if ship successfully added, clear if it failed
\
\   INF                 INF is preserved
\
\   XX0                 XX0 is preserved
\
\   INWK                The whole INWK workspace is preserved
\
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   X                   X is preserved
\
ENDIF
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SFS1-2              Add a missile to the local bubble that has AI enabled,
\                       is hostile, but has no E.C.M.
\
\ ******************************************************************************

.SFS1

 STA T1                 \ Store the child ship's AI flag in T1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

                        \ Before spawning our child ship, we need to save the
                        \ INF and XX00 variables and the whole INWK workspace,
                        \ so we can restore them later when returning from the
                        \ subroutine

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 TXA                    \ Store X, the ship type to spawn, on the stack so we
 PHA                    \ can preserve it through the routine

ENDIF

 LDA XX0                \ Store XX0(1 0) on the stack, so we can restore it
 PHA                    \ later when returning from the subroutine
 LDA XX0+1
 PHA

 LDA INF                \ Store INF(1 0) on the stack, so we can restore it
 PHA                    \ later when returning from the subroutine
 LDA INF+1
 PHA

 LDY #NI%-1             \ Now we want to store the current INWK data block in
                        \ temporary memory so we can restore it when we are
                        \ done, and we also want to copy the parent's ship data
                        \ into INWK, which we can do at the same time, so set up
                        \ a counter in Y for NI% bytes

.FRL2

 LDA INWK,Y             \ Copy the Y-th byte of INWK to the Y-th byte of
 STA XX3,Y              \ temporary memory in XX3, so we can restore it later
                        \ when returning from the subroutine

 LDA (INF),Y            \ Copy the Y-th byte of the parent ship's data block to
 STA INWK,Y             \ the Y-th byte of INWK

 DEY                    \ Decrement the loop counter

 BPL FRL2               \ Loop back to copy the next byte until we have done
                        \ them all

                        \ INWK now contains the ship data for the parent ship,
                        \ so now we need to tweak the data before creating the
                        \ new child ship (in this way, the child inherits things
                        \ like location from the parent)

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Disc: In the disc version only, child ships that are spawned from a parent inherit the hostile, pirate and docking NEWB flags, meaning pirates spawn pirates, angry ships spawn angry ships, and ships that are docking spawn ships that are also docking

 LDA NEWB               \ Clear bits 0-1 and 5-7 of the ship's NEWB flags,
 AND #%00011100         \ leaving only the hostile, pirate and docking flags
 STA NEWB               \ (so the child inherits these flags from the parent,
                        \ meaning pirates spawn pirates, angry ships spawn
                        \ angry ships, and ships that are docking spawn ships
                        \ that are also docking)

ENDIF

 LDA TYPE               \ Fetch the ship type of the parent into A

 CMP #SST               \ If the parent is not a space station, jump to rx to
 BNE rx                 \ skip the following

                        \ The parent is a space station, so the child needs to
                        \ launch out of the space station's slot. The space
                        \ station's nosev vector points out of the station's
                        \ slot, so we want to move the ship along this vector.
                        \ We do this by taking the unit vector in nosev and
                        \ doubling it, so we spawn our ship 2 units along the
                        \ vector from the space station's centre

 TXA                    \ Store the child's ship type in X on the stack
 PHA

 LDA #32                \ Set the child's byte #27 (speed) to 32
 STA INWK+27

 LDX #0                 \ Add 2 * nosev_x_hi to (x_lo, x_hi, x_sign) to get the
 LDA INWK+10            \ child's x-coordinate
 JSR SFS2

 LDX #3                 \ Add 2 * nosev_y_hi to (y_lo, y_hi, y_sign) to get the
 LDA INWK+12            \ child's y-coordinate
 JSR SFS2

 LDX #6                 \ Add 2 * nosev_z_hi to (z_lo, z_hi, z_sign) to get the
 LDA INWK+14            \ child's z-coordinate
 JSR SFS2

 PLA                    \ Restore the child's ship type from the stack into X
 TAX

.rx

 LDA T1                 \ Restore the child ship's AI flag from T1 and store it
 STA INWK+32            \ in the child's byte #32 (AI)

 LSR INWK+29            \ Clear bit 0 of the child's byte #29 (roll counter) so
 ASL INWK+29            \ that its roll dampens (so if we are spawning from a
                        \ space station, for example, the spawned ship won't
                        \ keep rolling forever)

 TXA                    \ Copy the child's ship type from X into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Group A: On their demise, ships can spawn both cargo canisters and alloy plates in the enhanced versions

 CMP #OIL               \ If the child we are spawning is not a cargo canister,
 BNE NOIL               \ jump to NOIL to skip us setting up the pitch and roll
                        \ for the canister

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 CMP #SPL+1             \ If the type of the child we are spawning is less than
 BCS NOIL               \ #PLT or greater than #SPL - i.e. not an alloy plate,
 CMP #PLT               \ cargo canister, boulder, asteroid or splinter - then
 BCC NOIL               \ jump to NOIL to skip us setting up some pitch and roll
                        \ for it

 PHA                    \ Store the child's ship type on the stack so we can
                        \ retrieve it below

ENDIF

 JSR DORND              \ Set A and X to random numbers

 ASL A                  \ Set the child's byte #30 (pitch counter) to a random
 STA INWK+30            \ value, and at the same time set the C flag randomly

 TXA                    \ Set the child's byte #27 (speed) to a random value
 AND #%00001111         \ between 0 and 15
 STA INWK+27

 LDA #&FF               \ Set the child's byte #29 (roll counter) to a full
 ROR A                  \ roll with no damping (as bits 0 to 6 are set), so the
 STA INWK+29            \ canister tumbles through space, with the direction in
                        \ bit 7 set randomly, depending on the C flag from above

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 LDA #OIL               \ Set A to the ship type of a cargo canister

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 PLA                    \ Retrieve the child's ship type from the stack

ENDIF

.NOIL

 JSR NWSHP              \ Add a new ship of type A to the local bubble

                        \ We have now created our child ship, so we need to
                        \ restore all the variables we saved at the start of
                        \ the routine, so they are preserved when we return
                        \ from the subroutine

 PLA                    \ Restore INF(1 0) from the stack
 STA INF+1
 PLA
 STA INF

IF _NES_VERSION

 PHP                    \ Store the flags on the stack to we can retrieve them
                        \ after the macro

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 PLP                    \ Retrieve the flags from the stack

ENDIF

 LDX #NI%-1             \ Now to restore the INWK workspace that we saved into
                        \ XX3 above, so set a counter in X for NI% bytes

.FRL3

 LDA XX3,X              \ Copy the Y-th byte of XX3 to the Y-th byte of INWK
 STA INWK,X

 DEX                    \ Decrement the loop counter

 BPL FRL3               \ Loop back to copy the next byte until we have done
                        \ them all

 PLA                    \ Restore XX0(1 0) from the stack
 STA XX0+1
 PLA
 STA XX0

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 PLA                    \ Retrieve the ship type to spawn from the stack into X
 TAX                    \ so it is preserved through calls to this routine

ENDIF

 RTS                    \ Return from the subroutine

