\ ******************************************************************************
\
\       Name: FRMIS
\       Type: Subroutine
\   Category: Tactics
\    Summary: Fire a missile from our ship
IF _NES_VERSION
\  Deep dive: The NES combat demo
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ We fired a missile, so send it streaking away from us to unleash mayhem and
\ destruction on our sworn enemies.
\
\ ******************************************************************************

.FRMIS

 LDX #MSL               \ Call FRS1 to launch a missile straight ahead of us
 JSR FRS1

 BCC FR1                \ If FRS1 returns with the C flag clear, then there
                        \ isn't room in the universe for our missile, so jump
                        \ down to FR1 to display a "missile jammed" message

 LDX MSTG               \ Fetch the slot number of the missile's target

 JSR GINF               \ Get the address of the data block for the target ship
                        \ and store it in INF

 LDA FRIN,X             \ Fetch the ship type of the missile's target into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

 JSR ANGRY              \ Call ANGRY to make the target ship angry; if it is the
                        \ space station this will make it hostile, or if this is
                        \ a ship it will wake up its AI and give it a kick of
                        \ speed

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR ANGRY              \ Call ANGRY to make the target ship or station hostile,
                        \ and if this is a ship, wake up its AI and give it a
                        \ kick of speed

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDY #0                 \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = 0)

ELIF _ELECTRON_VERSION

 LDY #&04               \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = &04)

ELIF _C64_VERSION

 LDY #BLACK2            \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black

ELIF _APPLE_VERSION

 LDY #BLACK             \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black

ELIF _NES_VERSION

 LDY #133               \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the active indicator on the
                        \ dashboard by setting it to the pattern number in Y
                        \ (no missile indicator = pattern 133)

ENDIF

 DEC NOMSL              \ Reduce the number of missiles we have by 1

IF _ELITE_A_VERSION

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted, returning with Y = 0 and X = &FF

 STY MSAR               \ The call to msblob returns Y = 0, so this sets MSAR
                        \ to 0 to indicate that the leftmost missile is no
                        \ longer seeking a target lock

 STX MSTG               \ The call to msblob returns X = &FF, so this resets the
                        \ missile so that it is no longer locked on a target

ENDIF

IF _NES_VERSION

 LDA demoInProgress     \ If the demo is not in progress, jump to frmi1 to skip
 BEQ frmi1              \ the following

                        \ If we get here then the demo is in progress and we
                        \ just fired a missile, so we get a 60-second penalty
                        \ added to the time taken to complete the demo

 LDA #147               \ Print recursive token 146 ("60 SECOND PENALTY") in
 LDY #10                \ the middle of the screen and leave it there for 10
 JSR PrintMessage       \ ticks of the DLY counter

 LDA #25                \ Set nmiTimer = 25 to add half a second on top of the
 STA nmiTimer           \ penalty below (as 25 frames is half a second in PAL
                        \ systems)

 LDA nmiTimerLo         \ Add 60 to (nmiTimerHi nmiTimerLo) so the time recorded
 CLC                    \ to complete the combat demo is 60 seconds longer than
 ADC #60                \ it would have been if we hadn't fired the missile
 STA nmiTimerLo
 BCC frmi1
 INC nmiTimerHi

.frmi1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Platform

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 JMP NOISE              \ of a missile launch, returning from the subroutine
                        \ using a tail call

ELIF _MASTER_VERSION

 LDY #solaun            \ Call the NOISE routine with Y = 8 to make the sound
 JSR NOISE              \ of a missile launch

                        \ Fall through into ANGRY to make the missile target
                        \ angry, though as we already did this above, I'm not
                        \ entirely sure why we do this again

ELIF _C64_VERSION

 LDY #sfxwhosh          \ Call the NOISE routine with Y = sfxwhosh to make the
 JMP NOISE              \ sound of a missile launch, returning from the
                        \ subroutine using a tail call

ELIF _APPLE_VERSION

 LDY #120               \ Call the SOHISS routine with Y = 120 to make the sound
 JSR SOHISS             \ of our missile launch

                        \ Fall through into ANGRY to make the missile target
                        \ angry, though as we already did this above, I'm not
                        \ entirely sure why we do this again

ELIF _NES_VERSION

 LDY #9                 \ Call the NOISE routine with Y = 9 to make the sound
 JMP NOISE              \ of a missile launch, returning from the subroutine
                        \ using a tail call

ELIF _ELITE_A_VERSION

 JMP n_sound30          \ Call n_sound30 to make the sound of a missile launch,
                        \ returning from the subroutine using a tail call

ENDIF

