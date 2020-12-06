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

 LDY #0                 \ We have just launched a missile, so we need to remove
 JSR ABORT              \ missile lock and hide the leftmost indicator on the
                        \ dashboard by setting it to black (Y = 0)

 DEC NOMSL              \ Reduce the number of missiles we have by 1

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 JMP NOISE              \ of a missile launch, returning from the subroutine
                        \ using a tail call

