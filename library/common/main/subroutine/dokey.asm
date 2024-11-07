\ ******************************************************************************
\
\       Name: DOKEY
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Keyboard
ELIF _NES_VERSION
\   Category: Controllers
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\    Summary: Scan for the seven primary flight controls
\  Deep dive: The key logger
\             The docking computer
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
\    Summary: Scan for the seven primary flight controls and apply the docking
\             computer manoeuvring code
\  Deep dive: The key logger
\             The docking computer
ELIF _DISC_DOCKED OR _ELITE_A_DOCKED
\    Summary: Scan for the joystick
ELIF _NES_VERSION
\    Summary: Populate the key logger and apply the docking computer manoeuvring
\             code
\  Deep dive: Bolting NES controllers onto the key logger
ENDIF
\
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Comment
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
ELIF _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ Scan for the seven primary flight controls (or the equivalent on joystick),
\ pause and configuration keys, and secondary flight controls, and update the
\ key logger accordingly. Specifically, this part clears the key logger and
\ updates it for the seven primary flight controls, and updates the pitch and
\ roll rates accordingly.
\
\ We then end up at DK4 to scan for other keys, beyond the seven primary flight
\ controls.
\
ELIF _ELECTRON_VERSION
\ ------------------------------------------------------------------------------
\
\ Scan for the seven primary flight controls, pause and configuration keys, and
\ secondary flight controls, and update the key logger and pitch and roll rates
\ accordingly.
\
\ Unlike the other versions of Elite, the Electron version doesn't actually read
\ the joystick values from the ADC channels, so although you can configure
\ joysticks using the "K" option when paused, they won't have any effect. All
\ the other joystick code is present, though, so perhaps the intention was to
\ support joysticks at some point?
\
ENDIF
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   auton               Get the docking computer to "press" the flight keys to
\                       dock the ship
\
ENDIF
\ ******************************************************************************

.DOKEY

IF _6502SP_VERSION \ Tube

 LDA NEEDKEY            \ If NEEDKEY is zero, skip the next instruction
 BEQ P%+5

 JSR RDKEY              \ NEEDKEY is non-zero, so call RDKEY to ask the I/O
                        \ processor to scan the keyboard for key presses and
                        \ update the key logger buffer at KTRAN

 LDA #&FF               \ Set NEEDKEY to &FF, so the next call to DOKEY updates
 STA NEEDKEY            \ the key logger buffer

ENDIF

IF _DISC_DOCKED \ Electron: The Electron version doesn't read joystick values from the ADC channel in the main DOKEY routine, so although you can switch to a joystick using the "K" configuration option, it doesn't mean you can use it to fly your ship

 LDA JSTK               \ If JSTK is zero, then we are configured to use the
 BEQ DK9                \ keyboard rather than the joystick, so jump to DK9 to
                        \ make sure the Bitstik is disabled as well (DK9 then
                        \ jumps to DK4 to scan for pause, configuration and
                        \ secondary flight keys)

 LDX #1                 \ Call DKS2 to fetch the value of ADC channel 1 (the
 JSR DKS2               \ joystick X value) into (A X), and OR A with 1. This
 ORA #1                 \ ensures that the high byte is at least 1, and then we
 STA JSTX               \ store the result in JSTX

 LDX #2                 \ Call DKS2 to fetch the value of ADC channel 2 (the
 JSR DKS2               \ joystick Y value) into (A X), and EOR A with JSTGY.
 EOR JSTGY              \ JSTGY will be &FF if the game is configured to
 STA JSTY               \ reverse the joystick Y channel, so this EOR does
                        \ exactly that, and then we store the result in JSTY

ELIF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 JSR U%                 \ Call U% to clear the key logger

 LDA JSTK               \ If JSTK is non-zero, then we are configured to use
 BNE DKJ1               \ the joystick rather than keyboard, so jump to DKJ1
                        \ to read the joystick flight controls, before jumping
                        \ to DK4 to scan for pause, configuration and secondary
                        \ flight keys

ELIF _ELECTRON_VERSION

 JSR U%                 \ Call U% to clear the key logger

ELIF _ELITE_A_FLIGHT

 JSR U%                 \ Call U% to clear the key logger

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BEQ l_open             \ If the hyperspace countdown is non-zero, jump to DK4
 JMP DK4                \ to skip scanning for primary flight keys, and move on
                        \ to scanning for pause, configuration and secondary
                        \ flight keys

.l_open

 LDA JSTK               \ If JSTK is non-zero, then we are configured to use
 BNE DKJ1               \ the joystick rather than keyboard, so jump to DKJ1
                        \ to read the joystick flight controls, before jumping
                        \ to DK4 to scan for pause, configuration and secondary
                        \ flight keys

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA

 LDA JSTK               \ If JSTK is zero, then we are configured to use the
 BEQ DK4                \ keyboard rather than the joystick, so jump to DK4 to
                        \ scan for pause, configuration and secondary flight
                        \ keys

 LDX #1                 \ Call DKS2 to fetch the value of ADC channel 1 (the
 JSR DKS2               \ joystick X value) into (A X), and OR A with 1. This
 ORA #1                 \ ensures that the high byte is at least 1, and then we
 STA JSTX               \ store the result in JSTX

 LDX #2                 \ Call DKS2 to fetch the value of ADC channel 2 (the
 JSR DKS2               \ joystick Y value) into (A X), and EOR A with JSTGY.
 EOR JSTGY              \ JSTGY will be &FF if the game is configured to
 STA JSTY               \ reverse the joystick Y channel, so this EOR does
                        \ exactly that, and then we store the result in JSTY

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT \ Enhanced: The Bitstik configuration option only works if joysticks are configured

 STA BSTK               \ Set BSTK = 0 to disable the Bitstik

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Tube

 LDY #7                 \ We're going to work our way through the primary flight
                        \ control keys (pitch, roll, speed and laser), so set a
                        \ counter in Y so we can loop through all 7

.DKL2

 JSR DKS1               \ Call DKS1 to see if the KYTB key at offset Y is being
                        \ pressed, and set the key logger accordingly

 DEY                    \ Decrement the loop counter

 BNE DKL2               \ Loop back for the next key, working our way from A at
                        \ KYTB+7 down to ? at KYTB+1

ELIF _ELECTRON_VERSION

 LDY #7                 \ We're going to work our way through the primary flight
                        \ control keys (pitch, roll, speed and laser), so set a
                        \ counter in Y so we can loop through all 7

.DKL2

 LDX KYTB,Y             \ Call DKS4 to see if the KYTB key at offset Y is being
 JSR DKS4               \ pressed

 BPL P%+6               \ If the key isn't being pressed, skip the following two
                        \ instructions

 LDX #&FF               \ Set the key logger for this key to indicate it's being
 STX KL,Y               \ pressed

 DEY                    \ Decrement the loop counter

 BNE DKL2               \ Loop back for the next key, working our way from A at
                        \ KYTB+7 down to ? at KYTB+1

ELIF _6502SP_VERSION

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

ELIF _MASTER_VERSION

 JSR RDKEY-1            \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in X

ELIF _C64_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal code of the key pressed in X

\JSR U%                 \ These instructions are commented out in the original
\JMP DK15               \ source

ELIF _APPLE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in X

ELIF _NES_VERSION

 JSR SetKeyLogger_b6    \ Populate the key logger table with the controller
                        \ button presses and return the button number in X
                        \ if an icon bar button has been chosen

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION \ Enhanced: Group A: The docking computer literally takes the controls in the enhanced versions. The DOKEY routine normally scans the keyboard for the primary flight controls, but if the docking computer is enabled, it calls DOCKIT to ask the docking computer how to move the ship, and then it "presses" the relevant keys instead of scanning the keyboard

 LDA auto               \ If auto is 0, then the docking computer is not
 BEQ DK15               \ currently activated, so jump to DK15 to skip the
                        \ docking computer manoeuvring code below

.auton

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA auto               \ If auto is 0, then the docking computer is not
 BEQ DK15               \ currently activated, so jump to DK15 to skip the
                        \ docking computer manoeuvring code below

ELIF _NES_VERSION

 LDA auto               \ If auto is non-zero, then the docking computer is
 BNE doky3              \ currently activated, so jump to doky3 to apply the
                        \ docking computer manoeuvring code below

.doky1

 LDX iconBarKeyPress    \ If the icon bar key logger entry in iconBarKeyPress
 CPX #64                \ is not 64, then jump to doky2 to skip the following
 BNE doky2              \ (interestingly, iconBarKeyPress can never contain
                        \ this value, as none of the keys in the iconBarButtons
                        \ table have this value, and the value for the Start
                        \ button is 80)

 JMP PauseGame_b6       \ Pause the game and process choices from the pause menu
                        \ until the game is unpaused by another press of Start,
                        \ returning from the subroutine using a tail call

.doky2

 RTS                    \ Return from the subroutine

.doky3

 LDA SSPR               \ If we are inside the space station safe zone, jump to
 BNE doky4              \ doky4 to run the docking computer manoeuvring code

 STA auto               \ Otherwise set auto to 0 to disable the docking
                        \ computer, so we can't engage it outside of the safe
                        \ zone

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the music

 JMP doky1              \ Loop back to doky1 to check the icon bar key logger
                        \ entry and return from the subroutine

.doky4

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #96                \ Set nosev_z_hi = 96
 STA INWK+14

 ORA #%10000000         \ Set sidev_x_hi = -96
 STA INWK+22

 STA TYPE               \ Set the ship type to -96, so the negative value will
                        \ let us check in the DOCKIT routine whether this is our
                        \ ship that is activating its docking computer, rather
                        \ than an NPC ship docking

 LDA DELTA              \ Set the ship speed to DELTA (our speed)
 STA INWK+27

 JSR DOCKIT             \ Call DOCKIT to calculate the docking computer's moves
                        \ and update INWK with the results

                        \ We now "press" the relevant flight keys, depending on
                        \ the results from DOCKIT, starting with the pitch keys

 LDA INWK+27            \ Fetch the updated ship speed from byte #27 into A

 CMP #22                \ If A < 22, skip the next instruction
 BCC P%+4

 LDA #22                \ Set A = 22, so the maximum speed during docking is 22

 STA DELTA              \ Update DELTA to the new value in A

 LDA #&FF               \ Set A = &FF, which we can insert into the key logger
                        \ to "fake" the docking computer working the keyboard

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 LDX #0                 \ Set X = 0, so we "press" KY1 below ("?", slow down)

ELIF _MASTER_VERSION

 LDX #15                \ Set X = 15, so we "press" KY+15, i.e. KY1, below
                        \ ("?", slow down)

ELIF _C64_VERSION OR _APPLE_VERSION

 LDX #(KY1-KLO)         \ Set X to the offset of KY1 within the KLO table, so we
                        \ "press" KY1 below ("?", slow down)

ELIF _NES_VERSION

 LDX #0                 \ Set X = 0, so we "press" KY1 below (the "slow down"
                        \ key combination of the B and down buttons)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 LDY INWK+28            \ If the updated acceleration in byte #28 is zero, skip
 BEQ DK11               \ to DK11

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 BMI P%+3               \ If the updated acceleration is negative, skip the
                        \ following instruction

 INX                    \ The updated acceleration is positive, so increment X
                        \ to 1, so we "press" KY2 below (Space, speed up)

 STA KY1,X              \ Store &FF in either KY1 or KY2 to "press" the relevant
                        \ key, depending on whether the updated acceleration is
                        \ negative (in which case we "press" KY1, "?", to slow
                        \ down) or positive (in which case we "press" KY2,
                        \ Space, to speed up)

ELIF _MASTER_VERSION

 BMI P%+4               \ If the updated acceleration is negative, skip the
                        \ following instruction

 LDX #11                \ Set X = 11, so we "press" KY+11, i.e. KY2, with the
                        \ next instruction (Space, speed up)

 STA KL,X               \ Store &FF in either KY1 or KY2 to "press" the relevant
                        \ key, depending on whether the updated acceleration is
                        \ negative (in which case we "press" KY1, "?", to slow
                        \ down) or positive (in which case we "press" KY2,
                        \ Space, to speed up)

ELIF _C64_VERSION OR _APPLE_VERSION

 BMI P%+4               \ If the updated acceleration is negative, skip the
                        \ following instruction

 LDX #(KY2-KLO)         \ Set X to the offset of KY2 within the KLO table, so we
                        \ "press" KY2 with the next instruction (Space, speed
                        \ up)

 STA KLO,X              \ Store &FF in either KY1 or KY2 to "press" the relevant
                        \ key, depending on whether the updated acceleration is
                        \ negative (in which case we "press" KY1, "?", to slow
                        \ down) or positive (in which case we "press" KY2,
                        \ Space, to speed up)

ELIF _NES_VERSION

 BMI P%+4               \ If the updated acceleration is negative, skip the
                        \ following instruction

 LDX #1                 \ Set X = 1, so we "press" KY+1, i.e. KY2, with the
                        \ next instruction (speed up)

 STA KL,X               \ Store &FF in either KY1 or KY2 to "press" the relevant
                        \ key, depending on whether the updated acceleration is
                        \ negative (in which case we "press" KY1, i.e. the B and
                        \ down buttons, to slow down) or positive (in which case
                        \ we "press" KY2, i.e. the B and up buttons, to speed
                        \ up)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

.DK11

                        \ We now "press" the relevant roll keys, depending on
                        \ the results from DOCKIT

 LDA #128               \ Set A = 128, which indicates no change in roll when
                        \ stored in JSTX (i.e. the centre of the roll indicator)

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 LDX #0                 \ Set X = 0, so we "press" KY3 below ("<", increase
                        \ roll)

ELIF _MASTER_VERSION

 LDX #13                \ Set X = 13, so we "press" KY+13, i.e. KY3, below
                        \ ("<", increase roll)

ELIF _C64_VERSION OR _APPLE_VERSION

 LDX #(KY3-KLO)         \ Set X to the offset of KY3 within the KLO table, so we
                        \ "press" KY3 below ("<", increase roll)

ELIF _NES_VERSION

 LDX #2                 \ Set X = 2, so we "press" KL+2, i.e. KY3 below (left
                        \ button, increase roll)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 ASL INWK+29            \ Shift ship byte #29 left, which shifts bit 7 of the
                        \ updated roll counter (i.e. the roll direction) into
                        \ the C flag

 BEQ DK12               \ If the remains of byte #29 is zero, then the updated
                        \ roll counter is zero, so jump to DK12 set JSTX to 128,
                        \ to indicate there's no change in the roll

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 BCC P%+3               \ If the C flag is clear, skip the following instruction

 INX                    \ The C flag is set, i.e. the direction of the updated
                        \ roll counter is negative, so increment X to 1 so we
                        \ "press" KY4 below (">", decrease roll)

ELIF _MASTER_VERSION

 BCC P%+4               \ If the C flag is clear, skip the following instruction

 LDX #14                \ The C flag is set, i.e. the direction of the updated
                        \ roll counter is negative, so set X to 14 so we
                        \ "press" KY+14. i.e. KY4, below (">", decrease roll)

ELIF _C64_VERSION OR _APPLE_VERSION

 BCC P%+4               \ If the C flag is clear, skip the following instruction

 LDX #(KY4-KLO)         \ Set X to the offset of KY4 within the KLO table, so we
                        \ "press" KY4 below (">", decrease roll)

ELIF _NES_VERSION

 BCC P%+4               \ If the C flag is clear, skip the following instruction

 LDX #3                 \ The C flag is set, i.e. the direction of the updated
                        \ roll counter is negative, so set X to 3 so we
                        \ "press" KY+3. i.e. KY4, below (right button, decrease
                        \ roll)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 BIT INWK+29            \ We shifted the updated roll counter to the left above,
 BPL DK14               \ so this tests bit 6 of the original value, and if it
                        \ is clear (i.e. the magnitude is less than 64), jump to
                        \ DK14 to "press" the key and leave JSTX unchanged

 LDA #64                \ The magnitude of the updated roll is 64 or more, so
 STA JSTX               \ set JSTX to 64 (so the roll decreases at half the
                        \ maximum rate)

 LDA #0                 \ And set A = 0 so we do not "press" any keys (so if the
                        \ docking computer needs to make a serious roll, it does
                        \ so by setting JSTX directly rather than by "pressing"
                        \ a key)

.DK14

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 STA KY3,X              \ Store A in either KY3 or KY4, depending on whether
                        \ the updated roll rate is increasing (KY3) or
                        \ decreasing (KY4)

ELIF _MASTER_VERSION OR _NES_VERSION

 STA KL,X               \ Store A in either KY3 or KY4, depending on whether
                        \ the updated roll rate is increasing (KY3) or
                        \ decreasing (KY4)

ELIF _C64_VERSION OR _APPLE_VERSION

 STA KLO,X              \ Store A in either KY3 or KY4, depending on whether
                        \ the updated roll rate is increasing (KY3) or
                        \ decreasing (KY4)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 LDA JSTX               \ Fetch A from JSTX so the next instruction has no
                        \ effect

.DK12

 STA JSTX               \ Store A in JSTX to update the current roll rate

                        \ We now "press" the relevant pitch keys, depending on
                        \ the results from DOCKIT

 LDA #128               \ Set A = 128, which indicates no change in pitch when
                        \ stored in JSTX (i.e. the centre of the pitch
                        \ indicator)

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 LDX #0                 \ Set X = 0, so we "press" KY5 below ("X", decrease
                        \ pitch, pulling the nose up)

ELIF _MASTER_VERSION

 LDX #6                 \ Set X = 6, so we "press" KY+6, i.e. KY5, below
                        \ ("X", decrease pitch, pulling the nose up)

ELIF _C64_VERSION OR _APPLE_VERSION

 LDX #(KY5-KLO)         \ Set X to the offset of KY5 within the KLO table, so we
                        \ "press" KY5 below ("X", decrease pitch, pulling the
                        \ nose up)

ELIF _NES_VERSION

 LDX #4                 \ Set X = 4, so we "press" KY+4, i.e. KY5, below
                        \ (down button, decrease pitch, pulling the nose up)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 ASL INWK+30            \ Shift ship byte #30 left, which shifts bit 7 of the
                        \ updated pitch counter (i.e. the pitch direction) into
                        \ the C flag

 BEQ DK13               \ If the remains of byte #30 is zero, then the updated
                        \ pitch counter is zero, so jump to DK13 set JSTY to
                        \ 128, to indicate there's no change in the pitch

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Enhanced: See group A

 BCS P%+3               \ If the C flag is set, skip the following instruction

 INX                    \ The C flag is clear, i.e. the direction of the updated
                        \ pitch counter is positive (dive), so increment X to 1
                        \ so we "press" KY6 below ("S", increase pitch, so the
                        \ nose dives)

 STA KY5,X              \ Store 128 in either KY5 or KY6 to "press" the relevant
                        \ key, depending on whether the pitch direction is
                        \ negative (in which case we "press" KY5, "X", to
                        \ decrease the pitch, pulling the nose up) or positive
                        \ (in which case we "press" KY6, "S", to increase the
                        \ pitch, pushing the nose down)

ELIF _MASTER_VERSION

 BCS P%+4               \ If the C flag is set, skip the following instruction

 LDX #8                 \ Set X = 8, so we "press" KY+8, i.e. KY6, with the next
                        \ instruction ("S", increase pitch, so the nose dives)

 STA KL,X               \ Store 128 in either KY5 or KY6 to "press" the relevant
                        \ key, depending on whether the pitch direction is
                        \ negative (in which case we "press" KY5, "X", to
                        \ decrease the pitch, pulling the nose up) or positive
                        \ (in which case we "press" KY6, "S", to increase the
                        \ pitch, pushing the nose down)

ELIF _C64_VERSION OR _APPLE_VERSION

 BCS P%+4               \ If the C flag is set, skip the following instruction

 LDX #(KY6-KLO)         \ Set X to the offset of KY6 within the KLO table, so we
                        \ "press" KY6 below ("S", increase pitch, so the nose
                        \ dives)

 STA KLO,X              \ Store 128 in either KY5 or KY6 to "press" the relevant
                        \ key, depending on whether the pitch direction is
                        \ negative (in which case we "press" KY5, "X", to
                        \ decrease the pitch, pulling the nose up) or positive
                        \ (in which case we "press" KY6, "S", to increase the
                        \ pitch, pushing the nose down)

ELIF _NES_VERSION

 BCS P%+4               \ If the C flag is set, skip the following instruction

 LDX #5                 \ Set X = 5, so we "press" KY+5, i.e. KY6, with the next
                        \ instruction (up button, increase pitch, so the nose
                        \ dives)

 STA KL,X               \ Store 128 in either KY5 or KY6 to "press" the relevant
                        \ key, depending on whether the pitch direction is
                        \ negative (in which case we "press" KY5, the down
                        \ button, to decrease the pitch, pulling the nose up) or
                        \ positive (in which case we "press" KY6, the up button,
                        \ to increase the pitch, pushing the nose down)

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 LDA JSTY               \ Fetch A from JSTY so the next instruction has no
                        \ effect

.DK13

 STA JSTY               \ Store A in JSTY to update the current pitch rate

ENDIF

IF _MASTER_VERSION \ Master: The Master Compact release supports the Compact's digital joystick via the RDJOY routine, which also supports the standard analogue joystick interface

IF _COMPACT

 JMP DK152              \ Jump to DK152 to skip reading the joystick, as this is
                        \ a Master Compact that doesn't support an analogue
                        \ joystick (instead it supports a digital joystick,
                        \ which is read elsewhere)

ENDIF

.DK15

 LDA JSTK               \ If JSTK is zero, then we are configured to use the
 BEQ DK152              \ keyboard rather than the joystick, so jump to DK152 to
                        \ skip reading the joystick

IF _SNG47

 LDA JOPOS              \ Fetch the high byte of the joystick X value

 EOR JSTE               \ The high byte A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the high byte but inverted, if that's what
                        \ the current settings say)

 ORA #1                 \ Ensure the value is at least 1

 STA JSTX               \ Store the resulting joystick X value in JSTX

 LDA JOPOS+1            \ Fetch the high byte of the joystick Y value

 EOR #&FF               \ This EOR is used in conjunction with the EOR JSTGY
                        \ below, as having a value of 0 in JSTGY means we have
                        \ to invert the joystick Y value, and this EOR does
                        \ that part

 EOR JSTE               \ The high byte A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the high byte but inverted, if that's what
                        \ the current settings say)

 EOR JSTGY              \ JSTGY will be 0 if the game is configured to reverse
                        \ the joystick Y channel, so this EOR along with the
                        \ EOR #&FF above does exactly that

 STA JSTY               \ Store the resulting joystick Y value in JSTY

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 BNE DK4                \ If the joystick fire button is not being pressed,
                        \ jump to DK4 to scan for other keys

 LDA #&FF               \ Update the key logger at KY7 to "press" the "A" (fire)
 STA KY7                \ button

 BNE DK4                \ Jump to DK4 to scan for other keys (this BNE is
                        \ effectively a JMP as A is never 0)

ELIF _COMPACT

 JSR RDJOY              \ Call RDJOY to read from either the analogue or digital
                        \ joystick

 BCC DK4                \ If we just read from the analogue joystick, the C flag
                        \ will be clear, so jump to DK4 to scan for other keys

                        \ Otherwise we just read the digital joystick, so we now
                        \ update the pitch and roll

ENDIF

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION \ Enhanced: See group A

.DK15

ELIF _MASTER_VERSION

.DK152

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #7                 \ Set A to 7, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KL+3               \ If the "<" key is being pressed, then call the BUMP2
 BEQ P%+5               \ routine to increase the roll rate in X by A
 JSR BUMP2

 LDY KL+4               \ If the ">" key is being pressed, then call the REDU2
 BEQ P%+5               \ routine to decrease the roll rate in X by A, taking
 JSR REDU2              \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

 ASL A                  \ Double the value of A, to 14

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KL+5               \ If the "X" key is being pressed, then call the REDU2
 BEQ P%+5               \ routine to decrease the pitch rate in X by A, taking
 JSR REDU2              \ the keyboard auto re-centre setting into account

 LDY KL+6               \ If the "S" key is being pressed, then call the BUMP2
 BEQ P%+5               \ routine to increase the pitch rate in X by A
 JSR BUMP2

 STX JSTY               \ Store the updated roll rate in JSTY

ELIF _MASTER_VERSION

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #7                 \ Set A to 7, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KY3                \ If the "<" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "<" key is being pressed, so call the BUMP2
                        \ routine to increase the roll rate in X by A

 LDY KY4                \ If the ">" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "<" key is being pressed, so call the REDU2
                        \ routine to decrease the roll rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

 ASL A                  \ Double the value of A, to 14

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KY5                \ If the "X" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "X" key is being pressed, so call the REDU2
                        \ routine to decrease the pitch rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 LDY KY6                \ If the "S" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "S" key is being pressed, so call the BUMP2
                        \ routine to increase the pitch rate in X by A

 STX JSTY               \ Store the updated roll rate in JSTY

ELIF _C64_VERSION

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #14                \ Set A to 14, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KY3                \ If the "<" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "<" key is being pressed, so call the BUMP2
                        \ routine to increase the roll rate in X by A

 LDY KY4                \ If the ">" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "<" key is being pressed, so call the REDU2
                        \ routine to decrease the roll rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

\ASL A                  \ This instruction is commented out in the original
                        \ source

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KY5                \ If the "X" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "X" key is being pressed, so call the REDU2
                        \ routine to decrease the pitch rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 LDY KY6                \ If the "S" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "S" key is being pressed, so call the BUMP2
                        \ routine to increase the pitch rate in X by A

 STX JSTY               \ Store the updated roll rate in JSTY

ELIF _APPLE_VERSION

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #20                \ Set A to 20, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KY3                \ If the "<" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "<" key is being pressed, so call the BUMP2
                        \ routine to increase the roll rate in X by A

 LDY KY4                \ If the ">" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "<" key is being pressed, so call the REDU2
                        \ routine to decrease the roll rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KY5                \ If the "X" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The "X" key is being pressed, so call the REDU2
                        \ routine to decrease the pitch rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 LDY KY6                \ If the "S" key is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The "S" key is being pressed, so call the BUMP2
                        \ routine to increase the pitch rate in X by A

 STX JSTY               \ Store the updated roll rate in JSTY

ELIF _NES_VERSION

 LDX JSTX               \ Set X = JSTX, the current roll rate (as shown in the
                        \ RL indicator on the dashboard)

 LDA #14                \ Set A to 14, which is the amount we want to alter the
                        \ roll rate by if the roll keys are being pressed

 LDY KY3                \ If the left button is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The left button is being pressed, so call the BUMP2
                        \ routine to increase the roll rate in X by A

 LDY KY4                \ If the right button is not being pressed, skip the
 BEQ P%+5               \ next instruction

 JSR REDU2              \ The right button is being pressed, so call the REDU2
                        \ routine to decrease the roll rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 STX JSTX               \ Store the updated roll rate in JSTX

 LDA #14                \ Set A to 15, which is the amount we want to alter the
                        \ roll rate by if the pitch keys are being pressed

 LDX JSTY               \ Set X = JSTY, the current pitch rate (as shown in the
                        \ DC indicator on the dashboard)

 LDY KY5                \ If the down button is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR REDU2              \ The down button is being pressed, so call the REDU2
                        \ routine to decrease the pitch rate in X by A, taking
                        \ the keyboard auto re-centre setting into account

 LDY KY6                \ If the up button is not being pressed, skip the next
 BEQ P%+5               \ instruction

 JSR BUMP2              \ The up button is being pressed, so call the BUMP2
                        \ routine to increase the pitch rate in X by A

 STX JSTY               \ Store the updated roll rate in JSTY

 LDA auto               \ If auto is non-zero, then the docking computer is
 BNE doky6              \ currently activated, so jump up to doky1 via doky6 to
                        \ check the icon bar key logger entry and return from
                        \ the subroutine

 LDX #128               \ Set X = 128, which indicates no change in pitch when
                        \ stored in JSTX (i.e. the centre of the pitch
                        \ indicator)

 LDA KY3                \ If either of the left or right buttons are being
 ORA KY4                \ pressed, jump to doky5 to skip the following
 BNE doky5              \ instruction, so pressing buttons on the controller
                        \ overrides the docking computer

 STX JSTX               \ Store the updated roll rate in JSTX

.doky5

 LDA KY5                \ If either of the up or down buttons are being
 ORA KY6                \ pressed, jump to doky6 to skip the following
 BNE doky6              \ instruction, so pressing buttons on the controller
                        \ overrides the docking computer

 STX JSTY               \ Store the updated roll rate in JSTY

.doky6

 JMP doky1              \ Loop back to doky1 to check the icon bar key logger
                        \ entry and return from the subroutine

ENDIF

IF _C64_VERSION

 LDA JSTK               \ ???
 BEQ ant
 LDA auto
 BNE ant
 LDX #128
 LDA KY3
 ORA KY4
 BNE termite
 STX JSTX

.termite

 LDA KY5
 ORA KY6
 BNE ant
 STX JSTY

.ant

ENDIF

IF NOT(_NES_VERSION)

                        \ Fall through into DK4 to scan for other keys

ENDIF

