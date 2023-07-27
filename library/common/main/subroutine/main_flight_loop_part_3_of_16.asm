\ ******************************************************************************
\
\       Name: Main flight loop (Part 3 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Scan for flight keys and process the results
\  Deep dive: Program flow of the main game loop
\             The key logger
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Scan for flight keys and process the results
\
\ Flight keys are logged in the key logger at location KY1 onwards, with a
\ non-zero value in the relevant location indicating a key press. See the deep
\ dive on "The key logger" for more details.
\
IF NOT(_NES_VERSION)
\ The key presses that are processed are as follows:
\
\   * Space and "?" to speed up and slow down
\   * "U", "T" and "M" to disarm, arm and fire missiles
ENDIF
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   * TAB to fire an energy bomb
ELIF _ELECTRON_VERSION
\   * "-" to fire an energy bomb
ELIF _ELITE_A_VERSION
\   * TAB to activate the hyperspace unit
ENDIF
IF NOT(_NES_VERSION)
\   * ESCAPE to launch an escape pod
\   * "J" to initiate an in-system jump
\   * "E" to deploy E.C.M. anti-missile countermeasures
\   * "C" to use the docking computer
\   * "A" to fire lasers
\
ENDIF
\ ******************************************************************************

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Label

.BS2

ENDIF

 LDA KY2                \ If Space is being pressed, keep going, otherwise jump
 BEQ MA17               \ down to MA17 to skip the following

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 LDA DELTA              \ The "go faster" key is being pressed, so first we
 CMP #40                \ fetch the current speed from DELTA into A, and if
 BCS MA17               \ A >= 40, we are already going at full pelt, so jump
                        \ down to MA17 to skip the following

 INC DELTA              \ We can go a bit faster, so increment the speed in
                        \ location DELTA

ELIF _NES_VERSION

 LDA DELTA              \ The "go faster" key is being pressed, so first we
 CLC                    \ add 4 to the current speed in DELTA (we also store
 ADC #4                 \ this value in DELTA, though this isn't necessary as
 STA DELTA              \ we are about to do that again)

 CMP #40                \ If the new speed in A < 40, then this is a valid
 BCC C85F3              \ speed, so jump down to C85F3 to set DELTA to this
                        \ value

 LDA #40                \ The maximum allowed speed is 40, so set A = 40

.C85F3

 STA DELTA              \ Store the updated speed in DELTA

ELIF _ELITE_A_VERSION

 LDA DELTA              \ The "go faster" key is being pressed, so first we
 CMP new_speed          \ fetch the current speed from DELTA into A, and if
 BCC speed_up           \ A < new_speed (the maximum speed of our current ship),
                        \ then we can go a bit faster, so jump to speed_up to
                        \ accelerate

ENDIF

.MA17

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA KY1                \ If "?" is being pressed, keep going, otherwise jump
 BEQ MA4                \ down to MA4 to skip the following

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 DEC DELTA              \ The "slow down" key is being pressed, so we decrement
                        \ the current ship speed in DELTA

 BNE MA4                \ If the speed is still greater than zero, jump to MA4

 INC DELTA              \ Otherwise we just braked a little too hard, so bump
                        \ the speed back up to the minimum value of 1

ELIF _NES_VERSION

 LDA DELTA              \ The "slow down" key is being pressed, so subtract 4
 SEC                    \ from the speed in DELTA
 SBC #4

 BEQ C8610              \ If the result is zero, jump to C8610 to set the speed
                        \ to the minimum value of 1

 BCS C8612              \ If the subtraction didn't underflow then this is a
                        \ valid speed, so jump down to C8612 to set DELTA to
                        \ this value

.C8610

 LDA #1                 \ Set A = 1 to use as the minimum speed

.C8612

 STA DELTA              \ Store the updated speed in DELTA

ELIF _ELITE_A_VERSION

 DEC DELTA              \ The "slow down" key is being pressed, so we decrement
                        \ the current ship speed in DELTA

 BNE MA4                \ If the speed is still greater than zero, jump to MA4

.speed_up

 INC DELTA              \ Otherwise we just braked a little too hard, so bump
                        \ the speed back up to the minimum value of 1

ENDIF

.MA4

IF NOT(_NES_VERSION)

 LDA KY15               \ If "U" is being pressed and the number of missiles
 AND NOMSL              \ in NOMSL is non-zero, keep going, otherwise jump down
 BEQ MA20               \ to MA20 to skip the following

ELIF _NES_VERSION

 LDA L0081              \ ???
 CMP #&18
 BNE MA25

 LDA NOMSL
 BEQ MA64S

 LDA MSAR
 EOR #&FF
 STA MSAR

 BNE MA20

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Screen

 LDY #&EE               \ The "disarm missiles" key is being pressed, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green/cyan (Y = &EE)

ELIF _ELECTRON_VERSION

 JSR ABORT-2            \ The "disarm missiles" key is being pressed, so call
                        \ ABORT-2 to disarm the missile and update the missile
                        \ indicators on the dashboard to white squares (Y = &09)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #GREEN2            \ The "disarm missiles" key is being pressed, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green (Y = &EE)

ELIF _NES_VERSION

 LDY #&6C               \ The "disarm missiles" key is being pressed, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green (Y = &6C) ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Master: The Master version has a unique "low beep" sound that has more reverb than in the other versions

 LDA #40                \ Call the NOISE routine with A = 40 to make a low,
 JSR NOISE              \ long beep to indicate the missile is now disarmed

ELIF _MASTER_VERSION

 JSR BOOP               \ Call the BOOP routine to make a low, long beep to
                        \ indicate the missile is now disarmed

ELIF _ELITE_A_VERSION

 JSR WA1                \ Call the WA1 routine to make a low, long beep to
                        \ indicate the missile is now disarmed

ELIF _NES_VERSION

 LDY #4                 \ ???

.loop_C8630

 JSR NOISE

 JMP MA64

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Label

.MA31

ENDIF

IF NOT(_NES_VERSION)

 LDA #0                 \ Set MSAR to 0 to indicate that no missiles are
 STA MSAR               \ currently armed

.MA20

 LDA MSTG               \ If MSTG is positive (i.e. it does not have bit 7 set),
 BPL MA25               \ then it indicates we already have a missile locked on
                        \ a target (in which case MSTG contains the ship number
                        \ of the target), so jump to MA25 to skip targeting. Or
                        \ to put it another way, if MSTG = &FF, which means
                        \ there is no current target lock, keep going

 LDA KY14               \ If "T" is being pressed, keep going, otherwise jump
 BEQ MA25               \ down to MA25 to skip the following

 LDX NOMSL              \ If the number of missiles in NOMSL is zero, jump down
 BEQ MA25               \ to MA25 to skip the following

 STA MSAR               \ The "target missile" key is being pressed and we have
                        \ at least one missile, so set MSAR = &FF to denote that
                        \ our missile is currently armed (we know A has the
                        \ value &FF, as we just loaded it from MSTG and checked
                        \ that it was negative)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Screen

 LDY #&E0               \ Change the leftmost missile indicator to yellow/white
 JSR MSBAR              \ on the missile bar (this call changes the leftmost
                        \ indicator because we set X to the number of missiles
                        \ in NOMSL above, and the indicators are numbered from
                        \ right to left, so X is the number of the leftmost
                        \ indicator)

ELIF _ELECTRON_VERSION

 LDY #&0D               \ Change the leftmost missile indicator to a black box
 JSR MSBAR              \ in a white square on the missile bar (this call
                        \ changes the leftmost indicator because we set X to the
                        \ number of missiles in NOMSL above, and the indicators
                        \ are numbered from right to left, so X is the number of
                        \ the leftmost indicator)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #YELLOW2           \ Change the leftmost missile indicator to yellow
 JSR MSBAR              \ on the missile bar (this call changes the leftmost
                        \ indicator because we set X to the number of missiles
                        \ in NOMSL above, and the indicators are numbered from
                        \ right to left, so X is the number of the leftmost
                        \ indicator)

ELIF _ELITE_A_FLIGHT

 LDY #&E0               \ Change the leftmost missile indicator to yellow/white
 DEX                    \ on the missile bar (this call changes the leftmost
 JSR MSBAR              \ indicator because we set X to the number of missiles
                        \ in NOMSL above, and the indicators are numbered from
                        \ right to left, starting at 0, so X - 1 is the number
                        \ of the leftmost indicator)

ELIF _ELITE_A_6502SP_PARA

 LDY #&E0               \ Change the leftmost missile indicator to yellow/white
 DEX                    \ on the missile bar (this call changes the leftmost
 JSR MSBARS             \ indicator because we set X to the number of missiles
                        \ in NOMSL above, and the indicators are numbered from
                        \ right to left, starting at 0, so X - 1 is the number
                        \ of the leftmost indicator)

ELIF _NES_VERSION

.MA20

 LDY #&6C               \ ???
 LDX NOMSL
 JSR MSBAR

 LDY #3
 BNE loop_C8630

ENDIF

.MA25

IF NOT(_NES_VERSION)

 LDA KY16               \ If "M" is being pressed, keep going, otherwise jump
 BEQ MA24               \ down to MA24 to skip the following

ELIF _NES_VERSION

 CMP #&19               \ ???
 BNE MA24

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA MSTG               \ If MSTG = &FF then there is no target lock, so jump to
 BMI MA64               \ MA64 to skip the following (also skipping the checks
                        \ for TAB, ESCAPE, "J" and "E")

ELIF _ELECTRON_VERSION

 LDA MSTG               \ If MSTG = &FF then there is no target lock, so jump to
 BMI MA64               \ MA64 to skip the following (also skipping the checks
                        \ for "-", ESCAPE, "J" and "E")

ELIF _NES_VERSION

 LDA MSTG               \ If MSTG = &FF then there is no target lock, so jump to
 BMI MA64S              \ MA64 via MA64S to skip the following (also skipping
                        \ the checks for the energy bomb)

ENDIF

 JSR FRMIS              \ The "fire missile" key is being pressed and we have
                        \ a missile lock, so call the FRMIS routine to fire
                        \ the missile

IF _NES_VERSION

 JSR subm_AC5C_b3       \ ???

.MA64S

 JMP MA64

ENDIF

.MA24

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA KY12               \ If TAB is being pressed, keep going, otherwise jump
 BEQ MA76               \ down to MA76 to skip the following

ELIF _ELECTRON_VERSION

 LDA KY12               \ If "-" is being pressed, keep going, otherwise jump
 BEQ MA76               \ down to MA76 to skip the following

ELIF _ELITE_A_VERSION

 LDA KY12               \ If TAB is not being pressed (i.e. KY12 = 0) and we do
 AND BOMB               \ not have a hyperspace unit fitted (i.e. BOMB = 0),
 BEQ MA76               \ jump down to MA76 to skip the following

ELIF _NES_VERSION

 CMP #&1A               \ ???
 BNE MA76

ENDIF

IF _MASTER_VERSION \ Platform

 LDA BOMB               \ If we already set off our energy bomb, then BOMB is
 BMI MA76               \ negative, so this skips to MA76 if our energy bomb is
                        \ already going off

ELIF _NES_VERSION

 LDA BOMB               \ If we already set off our energy bomb, then BOMB is
 BMI MA64S              \ negative, so this skips to MA64 via MA64S if our
                        \ energy bomb is already going off

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 ASL BOMB               \ The "energy bomb" key is being pressed, so double
                        \ the value in BOMB. If we have an energy bomb fitted,
                        \ BOMB will contain &7F (%01111111) before this shift
                        \ and will contain &FE (%11111110) after the shift; if
                        \ we don't have an energy bomb fitted, BOMB will still
                        \ contain 0. The bomb explosion is dealt with in the
                        \ MAL1 routine below - this just registers the fact that
                        \ we've set the bomb ticking

ELIF _NES_VERSION

 ASL BOMB               \ ???
 BEQ MA64S

 LDA #&28               \ Set hiddenColour to &28, which is green-brown, so this
 STA hiddenColour       \ reveals pixels that use the (no-longer) hidden colour
                        \ in palette 0

 LDY #8
 JSR NOISE
 JMP MA64

ELIF _ELITE_A_VERSION

 INC BOMB               \ The "hyperspace unit" key is being pressed and we have
                        \ a hyperspace unit fitted, so increment BOMB from &FF
                        \ (hyperspace unit fitted) to 0 (hyperspace unit not
                        \ fitted), as it is a single-use item and we are now
                        \ using it

 INC new_hold           \ Free up one tonne of space in the hold, as we have
                        \ just used up the hyperspace unit

 JSR DORND              \ Set A and X to random numbers

 STA QQ9                \ Set (QQ9, QQ10) to (A, X), so we jump to a random
 STX QQ10               \ point in the galaxy

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR hyper_snap         \ Call hyper_snap to perform a hyperspace, but without
                        \ using up any fuel

ENDIF

IF _MASTER_VERSION \ Master: The Master's energy bomb lightning bolt effect contains nine random zig-zag lines that are set up in the BOMBON routine

 BEQ MA76               \ If BOMB now contains 0, then the bomb is not going off
                        \ any more (or it never was), so skip the following
                        \ instruction

 JSR BOMBON             \ Call BOMBON to set up and display a new energy bomb
                        \ zig-zag lightning bolt

ENDIF

.MA76

IF _6502SP_VERSION OR _DISC_FLIGHT \ Enhanced: In the enhanced versions, the main loop scans for "P" being pressed, which disables the docking computer

 LDA KY20               \ If "P" is being pressed, keep going, otherwise skip
 BEQ MA78               \ the next two instructions

 LDA #0                 \ The "cancel docking computer" key is bring pressed,
 STA auto               \ so turn it off by setting auto to 0

.MA78

ELIF _MASTER_VERSION

 LDA KY20               \ If "P" is being pressed, keep going, otherwise skip
 BEQ MA78               \ the next two instructions

 LDA #0                 \ The "cancel docking computer" key is bring pressed,
 STA auto               \ so turn it off by setting auto to 0

\JSR stopbd             \ This instruction is commented out in the original
                        \ source

.MA78

ELIF _ELITE_A_VERSION

 LDA KY19               \ If "C" is being pressed, and we have a docking
 AND DKCMP              \ computer fitted, then KY19 and DKCMP will both be &FF,
 BNE dock_toggle        \ so jump down to dock_toggle with A set to &FF

 LDA KY20               \ If "P" is being pressed, keep going, otherwise skip
 BEQ MA78               \ the next two instructions

 LDA #0                 \ The "cancel docking computer" key is bring pressed,
                        \ so turn it off by setting A to 0, so we set auto to 0
                        \ in the next instruction

.dock_toggle

 STA auto               \ Set auto to the value in A, which will be &FF if we
                        \ just turned on the docking computer, or 0 if we just
                        \ turned it off

.MA78

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA KY13               \ If ESCAPE is being pressed and we have an escape pod
 AND ESCP               \ fitted, keep going, otherwise skip the next
 BEQ P%+5               \ instruction

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA KY13               \ If ESCAPE is being pressed and we have an escape pod
 AND ESCP               \ fitted, keep going, otherwise jump to noescp to skip
 BEQ noescp             \ the following instructions

ELIF _NES_VERSION

 CMP #&1B               \ ???
 BNE noescp

 LDX ESCP
 BEQ MA64

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: In the original versions, you can launch your escape pod in witchspace (though it may be fatal, depending on the version). You can't even launch it in the advanced versions, as the launch key is disabled in witchspace

 LDA MJ                 \ If we are in witchspace, we can't launch our escape
 BNE noescp             \ pod, so jump down to noescp

ELIF _NES_VERSION

 LDA MJ                 \ If we are in witchspace, we can't launch our escape
 BNE MA64               \ pod, so jump down to MA64

ENDIF

 JMP ESCAPE             \ The "launch escape pod" button is being pressed and
                        \ we have an escape pod fitted, so jump to ESCAPE to
                        \ launch it, and exit the main flight loop using a tail
                        \ call

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Label

.noescp

ENDIF

IF NOT(_NES_VERSION)

 LDA KY18               \ If "J" is being pressed, keep going, otherwise skip
 BEQ P%+5               \ the next instruction

 JSR WARP               \ Call the WARP routine to do an in-system jump

 LDA KY17               \ If "E" is being pressed and we have an E.C.M. fitted,
 AND ECM                \ keep going, otherwise jump down to MA64 to skip the
 BEQ MA64               \ following

ELIF _NES_VERSION

 CMP #&0C               \ ???
 BNE C8690
 LDA L0300
 AND #&C0
 BNE MA64
 JSR WARP
 JMP MA64

.C8690

 CMP #&17
 BNE MA64

 LDA ECM
 BEQ MA64

ENDIF

 LDA ECMA               \ If ECMA is non-zero, that means an E.C.M. is already
 BNE MA64               \ operating and is counting down (this can be either
                        \ our E.C.M. or an opponent's), so jump down to MA64 to
                        \ skip the following (as we can't have two E.C.M.
                        \ systems operating at the same time)

 DEC ECMP               \ The "E.C.M." button is being pressed and nobody else
                        \ is operating their E.C.M., so decrease the value of
                        \ ECMP to make it non-zero, to denote that our E.C.M.
                        \ is now on

 JSR ECBLB2             \ Call ECBLB2 to light up the E.C.M. indicator bulb on
                        \ the dashboard, set the E.C.M. countdown timer to 32,
                        \ and start making the E.C.M. sound

.MA64

IF _NES_VERSION

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF _CASSETTE_VERSION \ Enhanced: If "C" is pressed during flight and we have a docking computer, then in the enhanced versions the docking computer takes control of the ship, unlike in the cassette version, which instantly docks when "C" is pressed

 LDA KY19               \ If "C" is being pressed, and we have a docking
 AND DKCMP              \ computer fitted, and we are inside the space station's
 AND SSPR               \ safe zone, keep going, otherwise jump down to MA68 to
 BEQ MA68               \ skip the following

 LDA K%+NI%+32          \ Fetch the AI counter (byte #32) of the second ship
 BMI MA68               \ from the ship data workspace at K%, which is reserved
                        \ for the sun or the space station (in this case it's
                        \ the latter as we are in the safe zone). If byte #32 is
                        \ negative, meaning the station is hostile, then jump
                        \ down to MA68 to skip the following (so we can't use
                        \ the docking computer to dock at a station that has
                        \ turned against us)

 JMP GOIN               \ The "docking computer" button has been pressed and
                        \ we are allowed to dock at the station, so jump to
                        \ GOIN to dock (or "go in"), and exit the main flight
                        \ loop using a tail call

ELIF _ELECTRON_VERSION

 LDA KY19               \ If "C" is being pressed, and we have a docking
 AND DKCMP              \ computer fitted, and we are inside the space station's
 AND SSPR               \ safe zone, keep going, otherwise jump down to MA68 to
 BEQ MA68               \ skip the following

 LDA K%+NI%+32          \ Fetch the AI counter (byte #32) of the second ship
 BMI MA68               \ from the ship data workspace at K%, which is reserved
                        \ for the space station. If byte #32 is negative,
                        \ meaning the station is hostile, then jump down to
                        \ MA68 to skip the following (so we can't use the
                        \ docking computer to dock at a station that has turned
                        \ against us)

 JMP GOIN               \ The "docking computer" button has been pressed and
                        \ we are allowed to dock at the station, so jump to
                        \ GOIN to dock (or "go in"), and exit the main flight
                        \ loop using a tail call

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDA KY19               \ If "C" is being pressed, and we have a docking
 AND DKCMP              \ computer fitted, keep going, otherwise jump down to
 BEQ MA68               \ MA68 to skip the following

 STA auto               \ Set auto to the non-zero value of A, so the docking
                        \ computer is activated

ENDIF

IF _MASTER_VERSION \ Comment

\EOR KLO+&29            \ These instructions are commented out in the original
\BEQ MA68               \ source
\STA auto
\JSR startbd

ENDIF

.MA68

IF _MASTER_VERSION \ Comment

\kill phantom Cs        \ This comment appears in the original source

ENDIF

 LDA #0                 \ Set LAS = 0, to switch the laser off while we do the
 STA LAS                \ following logic

 STA DELT4              \ Take the 16-bit value (DELTA 0) - i.e. a two-byte
 LDA DELTA              \ number with DELTA as the high byte and 0 as the low
 LSR A                  \ byte - and divide it by 4, storing the 16-bit result
 ROR DELT4              \ in DELT4(1 0). This has the effect of storing the
 LSR A                  \ current speed * 64 in the 16-bit location DELT4(1 0)
 ROR DELT4
 STA DELT4+1

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

 LDA LASCT              \ If LASCT is zero, keep going, otherwise the laser is
 BNE MA3                \ a pulse laser that is between pulses, so jump down to
                        \ MA3 to skip the following

ELIF _NES_VERSION

 LDA LASCT              \ ???
 ORA QQ11
 BNE MA3

ELIF _ELITE_A_6502SP_PARA

 JSR read_0346          \ Get the value of the I/O processor's copy of LASCT

 BNE MA3                \ If LASCT is zero, keep going, otherwise the laser is
                        \ a pulse laser that is between pulses, so jump down to
                        \ MA3 to skip the following

ENDIF

IF NOT(_NES_VERSION)

 LDA KY7                \ If "A" is being pressed, keep going, otherwise jump
 BEQ MA3                \ down to MA3 to skip the following

ELIF _NES_VERSION

 LDA KY7                \ If "A" is being pressed, keep going, otherwise jump
 BPL MA3                \ down to MA3 to skip the following

ENDIF

 LDA GNTMP              \ If the laser temperature >= 242 then the laser has
 CMP #242               \ overheated, so jump down to MA3 to skip the following
 BCS MA3

 LDX VIEW               \ If the current space view has a laser fitted (i.e. the
 LDA LASER,X            \ laser power for this view is greater than zero), then
 BEQ MA3                \ keep going, otherwise jump down to MA3 to skip the
                        \ following

IF _NES_VERSION

 BMI C86D9              \ ???
 BIT KY7
 BVS MA3

.C86D9

ENDIF

                        \ If we get here, then the "fire" button is being
                        \ pressed, our laser hasn't overheated and isn't already
                        \ being fired, and we actually have a laser fitted to
                        \ the current space view, so it's time to hit me with
                        \ those laser beams

 PHA                    \ Store the current view's laser power on the stack

IF NOT(_ELITE_A_VERSION)

 AND #%01111111         \ Set LAS and LAS2 to bits 0-6 of the laser power
 STA LAS
 STA LAS2

ELIF _ELITE_A_VERSION

 AND #%01111111         \ Set LAS and LAS2 to bits 0-6 of the laser power
 STA LAS2
 STA LAS

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master version has a unique sound for when our laser is firing

 LDA #0                 \ Call the NOISE routine with A = 0 to make the sound
 JSR NOISE              \ of our laser firing

ELIF _MASTER_VERSION

 JSR LASNO              \ Call the LASNO routine to make the sound of our laser
                        \ firing

ELIF _NES_VERSION

 LDY #&12
 PLA
 PHA
 BMI C86F0
 CMP #&32
 BNE C86EE
 LDY #&10

.C86EE

 BNE C86F9

.C86F0

 CMP #&97
 BEQ C86F7
 LDY #&11
 EQUB &2C

.C86F7

 LDY #&0F

.C86F9

 JSR NOISE

ENDIF

 JSR LASLI              \ Call LASLI to draw the laser lines

 PLA                    \ Restore the current view's laser power into A

 BPL ma1                \ If the laser power has bit 7 set, then it's an "always
                        \ on" laser rather than a pulsing laser, so keep going,
                        \ otherwise jump down to ma1 to skip the following
                        \ instruction

 LDA #0                 \ This is an "always on" laser (i.e. a beam laser,
                        \ as the cassette version of Elite doesn't have military
                        \ lasers), so set A = 0, which will be stored in LASCT
                        \ to denote that this is not a pulsing laser

.ma1

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 AND #%11111010         \ LASCT will be set to 0 for beam lasers, and to the
 STA LASCT              \ laser power AND %11111010 for pulse lasers, which
                        \ comes to 10 (as pulse lasers have a power of 15). See
                        \ MA23 below for more on laser pulsing and LASCT

ELIF _ELITE_A_FLIGHT

 STA LASCT              \ LASCT will be set to 0 for beam lasers, and to the
                        \ laser power (15) for pulse lasers. See MS23 below
                        \ for more on laser pulsing and LASCT

ELIF _ELITE_A_6502SP_PARA

 JSR write_0346         \ Tell the I/O processor to set its copy of LASCT to A,
                        \ which will be 0 for beam lasers, or the laser power
                        \ (15) for pulse lasers. See MS23 below for more on
                        \ laser pulsing and LASCT

ELIF _NES_VERSION

 AND #%11101111         \ LASCT will be set to 0 for beam lasers, and to the
 STA LASCT              \ laser power AND %11101111 for pulse lasers, which
                        \ comes to comes to ???

.MA3

 JSR subm_MA23          \ ???

 LDA QQ11
 BNE C874C

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA drawingBitplane    \ ???
 BNE C872A

 LDA L046D
 EOR #&FF
 STA L046D

 BMI C8733

 LDA KL
 ORA KY2
 ROR A
 BNE C8733

.C872A

 JSR SendDrawPlaneToPPU

 JSR COMPAS

 JMP DrawPitchRollBars

.C8733

 LDA #%10001000
 JSR SetDrawPlaneFlags

 JSR COMPAS

 JSR DrawPitchRollBars

 JSR DIALS_b6

 LDX drawingBitplane

 LDA bitplaneFlags,X    \ Set bit 6 of the flags for the drawing bitplane, so
 ORA #%01000000         \ we send both nametable and pattern table data for
 STA bitplaneFlags,X    \ bitplane X to the PPU in the NMI handler

 RTS

.C874C

 CMP #&98
 BNE C876F

 JSR GetStatusCondition

 CPX L0471
 BEQ C875B

 JSR STATUS

.C875B

 LDX L0471
 CPX #3
 BNE C876A

 LDA frameCounter
 AND #&20
 BNE C876A

 INX

.C876A

 LDA LF333,X
 STA visibleColour

.C876F

 RTS

ENDIF

