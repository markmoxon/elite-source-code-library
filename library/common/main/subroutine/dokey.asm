\ ******************************************************************************
\
\       Name: DOKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for the seven primary flight controls
\
\ ------------------------------------------------------------------------------
\
\ Scan for the seven primary flight controls (or the equivalent on joystick),
\ pause and configuration keys, and secondary flight controls, and update the
\ key logger accordingly. Specifically:
\
\   * If we are on keyboard configuration, clear the key logger and update it
\     for the seven primary flight controls, and update the pitch and roll
\     rates accordingly.
\
\   * If we are on joystick configuration, clear the key logger and jump to
\     DKJ1, which reads the joystick equivalents of the primary flight
\     controls.
\
\ Both options end up at DK4 to scan for other keys, beyond the seven primary
\ flight controls.
\
\ ******************************************************************************

.DOKEY

IF _6502SP_VERSION

 LDA NEEDKEY            \ If NEEDKEY is zero, skip the next insruction
 BEQ P%+5

 JSR RDKEY              \ NEEDKEY is non-zero, so call RDKEY to ask the I/O
                        \ processor to scan the keyboard for key presses and
                        \ update the key logger buffer at KTRAN

 LDA #&FF               \ Set NEEDKEY to &FF, so the next call to DOKEY updates
 STA NEEDKEY            \ the key logger buffer

ENDIF

 JSR U%                 \ Call U% to clear the key logger

 LDA JSTK               \ If JSTK is non-zero, then we are configured to use
 BNE DKJ1               \ the joystick rather than keyboard, so jump to DKJ1
                        \ to read the joystick flight controls, before jumping
                        \ to DK4 below

IF _CASSETTE_VERSION

 LDY #7                 \ We're going to work our way through the primary flight
                        \ control keys (pitch, roll, speed and laser), so set a
                        \ counter in Y so we can loop through all 7

.DKL2

 JSR DKS1               \ Call DKS1 to see if the KYTB key at offset Y is being
                        \ pressed, and set the key logger accordingly

 DEY                    \ Decrement the loop counter

 BNE DKL2               \ Loop back for the next key, working our way from A at
                        \ KYTB+7 down to ? at KYTB+1

ELIF _6502SP_VERSION

 STA BSTK               \ Set BSTK = 0 to disable the Bitstik

 LDX #7                 \ We're now going to copy key press data for the primary
                        \ flight keys from the key logger buffer at KTRAN to the
                        \ key logger at KL, so set a loop counter in X so we can
                        \ count down from KTRAN + 7 to KTRAN + 1

.DKL2

 LDA KTRAN,X            \ Copy the X-th byte of KTRAN to the X-th byte of KL
 STA KL,X

 DEX                    \ Decrement the loop counter

 BNE DKL2               \ Loop back until we have copied all seven primary
                        \ flight control key presses to KL

 LDA auto               \ If auto is 0, then the docking computer is not
 BEQ DK15               \ currently activated, so jump to DK15 to skip the
                        \ docking computer manoeuvring code below

.auton

 JSR ZINF
 LDA #96
 STA INWK+14
 ORA #128
 STA INWK+22
 STA TYPE
 LDA DELTA
 STA INWK+27
 JSR DOCKIT
 LDA INWK+27
 CMP #22
 BCC P%+4
 LDA #22
 STA DELTA
 LDA #&FF
 LDX #0
 LDY INWK+28
 BEQ DK11
 BMI P%+3
 INX
 STA KY1,X

.DK11

 LDA #128
 LDX #0
 ASL INWK+29
 BEQ DK12
 BCC P%+3
 INX
 BIT INWK+29
 BPL DK14
 LDA #64
 STA JSTX
 LDA #0

.DK14

 STA KY3,X
 LDA JSTX

.DK12

 STA JSTX
 LDA #128
 LDX #0
 ASL INWK+30
 BEQ DK13
 BCS P%+3
 INX
 STA KY5,X
 LDA JSTY

.DK13

 STA JSTY

.DK15

ENDIF

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #7                 \ Set A to 7, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KL+3               \ If the < key is being pressed, then call the BUMP2
 BEQ P%+5               \ routine to increase the roll rate in X by A
 JSR BUMP2

 LDY KL+4               \ If the > key is being pressed, then call the REDU2
 BEQ P%+5               \ routine to decrease the roll rate in X by A, taking
 JSR REDU2              \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

 ASL A                  \ Double the value of A, to 14

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KL+5               \ If the > key is being pressed, then call the REDU2
 BEQ P%+5               \ routine to decrease the pitch rate in X by A, taking
 JSR REDU2              \ the keyboard auto re-centre setting into account

 LDY KL+6               \ If the S key is being pressed, then call the BUMP2
 BEQ P%+5               \ routine to increase the pitch rate in X by A
 JSR BUMP2

 STX JSTY               \ Store the updated roll rate in JSTY

                        \ Fall through into DK4 to scan for other keys

