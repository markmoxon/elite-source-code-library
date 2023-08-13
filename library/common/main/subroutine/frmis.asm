\ ******************************************************************************
\
\       Name: FRMIS
\       Type: Subroutine
\   Category: Tactics
\    Summary: Fire a missile from our ship
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

 JSR ANGRY              \ Call ANGRY to make the target ship hostile

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDY #0                 \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = 0)

ELIF _ELECTRON_VERSION

 LDY #&04               \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = &04)

ELIF _NES_VERSION

 LDY #&85               \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = &85) ???

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

 LDA demoInProgress     \ ???
 BEQ C9235

 LDA #147               \ Print recursive token 146 ("60 SECOND PENALTY") in
 LDY #10                \ the middle of the screen and leave it there for 10
 JSR PrintMessage       \ ticks of the DLY counter

 LDA #&19               \ ???
 STA nmiTimer
 LDA nmiTimerLo
 CLC
 ADC #&3C
 STA nmiTimerLo
 BCC C9235
 INC nmiTimerHi

.C9235

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

ELIF _NES_VERSION

 LDY #9                 \ Call the NOISE routine with Y = 9 to make the sound
 JMP NOISE              \ of a missile launch, returning from the subroutine
                        \ using a tail call ???

ELIF _ELITE_A_VERSION

 JMP n_sound30          \ Call n_sound30 to make the sound of a missile launch,
                        \ returning from the subroutine using a tail call

ENDIF

