\ ******************************************************************************
\
\       Name: DKJ1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read joystick and flight controls
\
\ ------------------------------------------------------------------------------
\
\ Specifically, scan the keyboard for the speed up and slow down keys, and read
\ the joystick's fire button and X and Y axes, storing the results in the key
\ logger and the joystick position variables.
\
\ This routine is only called if joysticks are enabled (JSTK = non-zero).
\
\ ******************************************************************************

.DKJ1

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Enhanced: The docking computer in the enhanced versions doesn't dock instantly like the cassette version, but it literally takes control of the ship and docks it for you, steering the ship into the slot by "pressing" the same keys that the player would if they were flying

 LDA auto               \ If auto is non-zero, then the docking computer is
 BNE auton              \ currently activated, so jump to auton in DOKEY so the
                        \ docking computer can "press" the flight keys for us

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Tube

 LDY #1                 \ Update the key logger for key 1 in the KYTB table, so
 JSR DKS1               \ KY1 will be &FF if "?" (slow down) is being pressed

 INY                    \ Update the key logger for key 2 in the KYTB table, so
 JSR DKS1               \ KY2 will be &FF if Space (speed up) is being pressed

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

ELIF _6502SP_VERSION

 LDA KTRAN+1            \ Copy the key press state for the "?" key from the
 STA KL+1               \ key logger buffer to the key logger

 LDA KTRAN+2            \ Copy the key press state for the SPACE key from the
 STA KL+2               \ key logger buffer to the key logger

.BS1

 LDA KTRAN+12           \ Fetch the key press state for the joystick 1 fire
                        \ button from the key logger buffer, which contains
                        \ the value of the 6522 System VIA input register IRB
                        \ (SHEILA &40)

ENDIF

 TAX                    \ This instruction doesn't seem to have any effect, as
                        \ X is overwritten in a few instructions. When the
                        \ joystick is checked in a similar way in the TITLE
                        \ subroutine for the "Press Fire Or Space,Commander."
                        \ stage of the start-up screen, there's another
                        \ unnecessary TAX instruction present, but there it's
                        \ commented out

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 EOR #%00010000         \ Flip bit 4 so that it's set if the fire button has
 STA KY7                \ been pressed, and store the result in the keyboard
                        \ logger at location KY7, which is also where the A key
                        \ (fire lasers) key is logged

 LDX #1                 \ Call DKS2 to fetch the value of ADC channel 1 (the
 JSR DKS2               \ joystick X value) into (A X), and OR A with 1. This
 ORA #1                 \ ensures that the high byte is at least 1, and then we
 STA JSTX               \ store the result in JSTX

 LDX #2                 \ Call DKS2 to fetch the value of ADC channel 2 (the
 JSR DKS2               \ joystick Y value) into (A X), and EOR A with JSTGY.
 EOR JSTGY              \ JSTGY will be &FF if the game is configured to
 STA JSTY               \ reverse the joystick Y channel, so this EOR does
                        \ exactly that, and then we store the result in JSTY

 JMP DK4                \ We are done scanning the joystick flight controls,
                        \ so jump to DK4 to scan for other keys, using a tail
                        \ call so we can return from the subroutine there

