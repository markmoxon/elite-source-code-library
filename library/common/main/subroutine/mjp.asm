\ ******************************************************************************
\
\       Name: MJP
\       Type: Subroutine
\   Category: Flight
\    Summary: Process a mis-jump into witchspace
\
\ ------------------------------------------------------------------------------
\
\ Process a mis-jump into witchspace (which happens very rarely). Witchspace has
\ a strange, almost dust-free aspect to it, and it is populated by hostile
\ Thargoids. Using our escape pod will be fatal, and our position on the
\ galactic chart is in-between systems. It is a scary place...
\
IF NOT(_NES_VERSION OR _APPLE_VERSION)
\ There is a 0.78% chance that this routine is called from TT18 instead of doing
\ a normal hyperspace, or we can manually trigger a mis-jump by holding down
\ CTRL after first enabling the "author display" configuration option ("X") when
\ paused.
ELIF _APPLE_VERSION
\ There is a 0.78% chance that this routine is called from TT18 instead of doing
\ a normal hyperspace, or we can manually trigger a mis-jump by holding down TAB
\ after first enabling the "author display" configuration option ("X") when
\ paused.
ELIF _NES_VERSION
\ There is a 0.78% chance that this routine is called from TT18 instead of doing
\ a normal hyperspace, or we can manually trigger a mis-jump by holding down
\ either the up or down button at the point that the hyperspace countdown
\ reaches zero.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
IF NOT(_ELITE_A_VERSION OR _NES_VERSION)
\   ptg                 Called when the user manually forces a mis-jump
\
ENDIF
IF _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
\   RTS111              Contains an RTS
\
ENDIF
\ ******************************************************************************

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

.ptg

 LSR COK                \ Set bit 0 of the competition flags in COK, so that the
 SEC                    \ competition code will include the fact that we have
 ROL COK                \ manually forced a mis-jump into witchspace

ENDIF

.MJP

IF _MASTER_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment

\JSR CATLOD             \ This instruction is commented out in the original
                        \ source

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 LDA #3                 \ Call SHIPinA to load ship blueprints file D, which is
 JSR SHIPinA            \ one of the two files that contain Thargoids

ELIF _ELITE_A_6502SP_PARA

 LDA #3                 \ Call SHIPinA populate the ship blueprints table but
 JSR SHIPinA            \ without setting the compass to show the planet (the
                        \ LDA here has no effect and is left over from the disc
                        \ version)

ENDIF

IF _CASSETTE_VERSION \ Minor

\LDA #1                 \ This instruction is commented out in the original
                        \ source - it is not required as a call to TT66-2 sets
                        \ A to 1 for us. This is presumably an example of the
                        \ authors saving a couple of bytes by calling TT66-2
                        \ instead of TT66, while leaving the original LDA
                        \ instruction in place

 JSR TT66-2             \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 1

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDA #3                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 3

ENDIF

IF NOT(_NES_VERSION)

 JSR LL164              \ Call LL164 to show the hyperspace tunnel and make the
                        \ hyperspace sound for a second time (as we already
                        \ called LL164 in TT18)

ELIF _NES_VERSION

 LDY #29                \ Call the NOISE routine with Y = 29 to make the first
 JSR NOISE              \ sound of a mis-jump

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces, as
                        \ well as setting Y to &FF

 STY MJ                 \ Set the mis-jump flag in MJ to &FF, to indicate that
                        \ we are now in witchspace

IF _NES_VERSION

 LDA QQ1                \ Fetch the current system's galactic y-coordinate in
 EOR #%00011111         \ QQ1 and flip bits 0-5, so we end up somewhere in the
 STA QQ1                \ vicinity of our original destination, but above or
                        \ below it in the galactic chart

ENDIF

IF _6502SP_VERSION \ 6502SP: If speech is enabled on the Executive version, it will say "Oh shit, it's a mis-jump" when we mis-jump into witchspace (this happens with both accidental and manually triggered mis-jumps)

IF _EXECUTIVE

 LDX #4                 \ Call TALK with X = 4 to say "Oh shit, it's a mis-jump"
 JSR TALK               \ using the Watford Electronics Beeb Speech Synthesiser
                        \ (if one is fitted and speech has been enabled)

ENDIF

ENDIF

.MJP1

IF NOT(_NES_VERSION)

 JSR GTHG               \ Call GTHG to spawn a Thargoid ship and a Thargon
                        \ companion

ELIF _NES_VERSION

 JSR GTHG               \ Call GTHG three times to spawn three Thargoid ships
 JSR GTHG               \ and three Thargon companions
 JSR GTHG

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: The Master version spawns three Thargoid motherships in witchspace, while the other versions spawn four

 LDA #3                 \ Fetch the number of Thargoid ships from MANY+THG, and
 CMP MANY+THG           \ if it is less than or equal to 3, loop back to MJP1 to
 BCS MJP1               \ spawn another one, until we have four Thargoids

ELIF _MASTER_VERSION

 LDA #2                 \ Fetch the number of Thargoid ships from MANY+THG, and
 CMP MANY+THG           \ if it is less than or equal to 2, loop back to MJP1 to
 BCS MJP1               \ spawn another one, until we have three Thargoids

ELIF _APPLE_VERSION

IF _IB_DISK OR _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

 LDA #2                 \ Fetch the number of Thargoid ships from MANY+THG, and
 CMP MANY+THG           \ if it is less than or equal to 2, loop back to MJP1 to
 BCS MJP1               \ spawn another one, until we have three Thargoids

ELIF _SOURCE_DISK_CODE_FILES

 LDA #3                 \ Fetch the number of Thargoid ships from MANY+THG, and
 CMP MANY+THG           \ if it is greater than 3, loop back to MJP1 to spawn
 BCC MJP1               \ another one ???

ENDIF

ENDIF

IF NOT(_NES_VERSION)

 STA NOSTM              \ Set NOSTM (the maximum number of stardust particles)
                        \ to 3, so there are fewer bits of stardust in
                        \ witchspace (normal space has a maximum of 18)

 LDX #0                 \ Initialise the front space view
 JSR LOOK1

 LDA QQ1                \ Fetch the current system's galactic y-coordinate in
 EOR #%00011111         \ QQ1 and flip bits 0-5, so we end up somewhere in the
 STA QQ1                \ vicinity of our original destination, but above or
                        \ below it in the galactic chart

ELIF _NES_VERSION

 LDA #3                 \ Set NOSTM (the maximum number of stardust particles)
 STA NOSTM              \ to 3, so there are fewer bits of stardust in
                        \ witchspace (normal space has a maximum of 18)

 JSR SelectNearbySystem \ Set the current system to the nearest system to
                        \ (QQ9, QQ10) and update the selected system flags
                        \ accordingly

 JSR UpdateIconBar_b3   \ Update the icon bar to show the hyperspace icon

 LDY #30                \ Call the NOISE routine with Y = 30 to make the second
 JSR NOISE              \ sound of a mis-jump

 JMP RedrawCurrentView  \ Update the current view for when we arrive in a new
                        \ system, returning from the subroutine using a tail
                        \ call

ENDIF

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Label

.RTS111

ENDIF

IF NOT(_NES_VERSION)

 RTS                    \ Return from the subroutine

ENDIF

