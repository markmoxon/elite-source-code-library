\ ******************************************************************************
\
\       Name: DOENTRY
\       Type: Subroutine
\   Category: Flight
IF NOT(_C64_VERSION OR _APPLE_VERSION)
\    Summary: Dock at the space station, show the ship hangar and work out any
\             mission progression
ELIF _C64_VERSION OR _APPLE_VERSION
\    Summary: Dock at the space station and work out any mission progression
ENDIF
\  Deep dive: The Constrictor mission
\             The Thargoid Plans mission
IF _NES_VERSION OR _C64_VERSION
\             The Trumbles mission
ENDIF
IF _ELITE_A_DOCKED OR _DISC_DOCKED
\             Swapping between the docked and flight code
ENDIF
\
IF _ELITE_A_DOCKED
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   icode_set           Reset a number of flight variables and workspaces and go
\                       to the docking bay (i.e. show the Status Mode screen)
\
ENDIF
\ ******************************************************************************

.DOENTRY

IF _DISC_DOCKED \ Platform

 JSR DEEOR              \ Decrypt the newly loaded code

ELIF _ELITE_A_DOCKED

IF _BUG_FIX

 JSR SwitchToCharSet+5  \ Switch &C000 to the MOS character definitions even if
                        \ we are not in the middle of disc activity

ENDIF

 LDA KL+1               \ Before loading the docked code, the encyclopedia code
 BNE INBAY              \ sets KL+1 to a non-zero value (in the launch routine),
                        \ so this jumps to INBAY if we just came from the
                        \ encyclopedia, thereby skipping the docking tunnel and
                        \ ship hangar when we swap between the docked and
                        \ encyclopedia views. The flight code zeroes the key
                        \ logger before loading the docked code, so when we dock
                        \ we keep going and show the docking tunnel and ship
                        \ hangar

 LDA #&FF               \ Call SCRAM to set save_lock to &FF and set the break
 JSR SCRAM              \ handler

ELIF _ELITE_A_6502SP_PARA

 LDA #0                 \ Set dockedp = 0 to indicate we are docked
 STA dockedp

 LDA #&FF               \ Call SCRAM to set save_lock to &FF (i.e. we have just
 JSR SCRAM              \ docked and have unsaved changes) and set the break
                        \ handler

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Platform

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR HFS1               \ Show the space station docking tunnel

ELIF _6502SP_VERSION

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR LAUN               \ Show the space station docking tunnel

 STZ DELTA              \ Reduce the speed to 0

 STZ QQ22+1             \ Reset the on-screen hyperspace counter

 STZ GNTMP              \ Cool down the lasers completely

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

ELIF _MASTER_VERSION

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR LAUN               \ Show the space station docking tunnel

 LDA #0                 \ Reduce the speed to 0
 STA DELTA

 STA GNTMP              \ Cool down the lasers completely

 STA QQ22+1             \ Reset the on-screen hyperspace counter

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

ELIF _C64_VERSION OR _APPLE_VERSION

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR LAUN               \ Show the space station docking tunnel

 LDA #0                 \ Reduce the speed to 0
 STA DELTA

\STA ALPHA              \ These instructions are commented out in the original
\STA BETA               \ source
\STA ALP1
\STA BET1

 STA GNTMP              \ Cool down the lasers completely

 STA QQ22+1             \ Reset the on-screen hyperspace counter

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

ELIF _NES_VERSION

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR LAUN               \ Show the space station docking tunnel

 JSR ResetShipStatus    \ Reset the ship's speed, hyperspace counter, laser
                        \ temperature, shields and energy banks

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION)

 JSR HALL               \ Show the ship hangar

 LDY #44                \ Wait for 44/50 of a second (0.88 seconds)
 JSR DELAY

ELIF _C64_VERSION

\JSR HALL               \ This instruction is commented out in the original
                        \ source

 LDY #44                \ Wait for 44/50 of a second (0.88 seconds) on PAL
 JSR DELAY              \ systems, or 44/60 of a second (0.73 seconds) on NTSC

ELIF _APPLE_VERSION

\JSR HALL               \ This instruction is commented out in the original
                        \ source

 LDY #44                \ Wait for 44 delay loops
 JSR DELAY

ELIF _NES_VERSION

 JSR HALL_b1            \ Show the ship hangar

 LDY #44                \ Wait until 44 NMI interrupts have passed (i.e. the
 JSR DELAY              \ next 44 VBlanks)

ENDIF

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 JSR cour_dock          \ Update the current special cargo delivery mission

ENDIF

 LDA TP                 \ Fetch bits 0 and 1 of TP, and if they are non-zero
 AND #%00000011         \ (i.e. mission 1 is either in progress or has been
 BNE EN1                \ completed), skip to EN1

 LDA TALLY+1            \ If the high byte of TALLY is zero (so we have a combat
 BEQ EN4                \ rank below Competent, or we are Competent but have not
                        \ yet earned a grand total of at least 256 kill points),
                        \ jump to EN4 as we are not yet good enough to qualify
                        \ for a mission

 LDA GCNT               \ Fetch the galaxy number into A, and if any of bits 1-7
 LSR A                  \ are set (i.e. A > 1), jump to EN4 as mission 1 can
 BNE EN4                \ only be triggered in the first two galaxies

 JMP BRIEF              \ If we get here then mission 1 hasn't started, we have
                        \ reached a combat rank of at least Competent plus 128
                        \ kill points, and we are in galaxy 0 or 1 (shown
                        \ in-game as galaxy 1 or 2), so it's time to start
                        \ mission 1 by calling BRIEF

.EN1

                        \ If we get here then mission 1 is either in progress or
                        \ has been completed

 CMP #%00000011         \ If bits 0 and 1 are not both set, then jump to EN2
 BNE EN2

 JMP DEBRIEF            \ Bits 0 and 1 are both set, so mission 1 is both in
                        \ progress and has been completed, which means we have
                        \ only just completed it, so jump to DEBRIEF to end the
                        \ mission get our reward

.EN2

                        \ Mission 1 has been completed, so now to check for
                        \ mission 2

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 LDA GCNT               \ Fetch the galaxy number into A

 CMP #2                 \ If this is not galaxy 2 (shown in-game as galaxy 3),
 BNE EN4                \ jump to EN4 as we can only start mission 2 in the
                        \ third galaxy

ENDIF

 LDA TP                 \ Extract bits 0-3 of TP into A
 AND #%00001111

 CMP #%00000010         \ If mission 1 is complete and no longer in progress,
 BNE EN3                \ and mission 2 is not yet started, then bits 0-3 of TP
                        \ will be %0010, so this jumps to EN3 if this is not the
                        \ case

 LDA TALLY+1            \ If the high byte of TALLY is < 5 (so we have a combat
 CMP #5                 \ rank that is less than 3/8 of the way from Dangerous
 BCC EN4                \ to Deadly), jump to EN4 as our rank isn't high enough
                        \ for mission 2

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 LDA GCNT               \ Fetch the galaxy number into A

 CMP #2                 \ If this is not galaxy 2 (shown in-game as galaxy 3),
 BNE EN4                \ jump to EN4 as we can only start mission 2 in the
                        \ third galaxy

ENDIF

 JMP BRIEF2             \ If we get here, mission 1 is complete and no longer in
                        \ progress, mission 2 hasn't started, we have reached a
                        \ combat rank of 3/8 of the way from Dangerous to
                        \ Deadly, and we are in galaxy 2 (shown in-game as
                        \ galaxy 3), so it's time to start mission 2 by calling
                        \ BRIEF2

.EN3

 CMP #%00000110         \ If mission 1 is complete and no longer in progress,
 BNE EN5                \ and mission 2 has started but we have not yet been
                        \ briefed and picked up the plans, then bits 0-3 of TP
                        \ will be %0110, so this jumps to EN5 if this is not the
                        \ case

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 LDA GCNT               \ Fetch the galaxy number into A

 CMP #2                 \ If this is not galaxy 2 (shown in-game as galaxy 3),
 BNE EN4                \ jump to EN4 as we can only start mission 2 in the
                        \ third galaxy

ENDIF

 LDA QQ0                \ Set A = the current system's galactic x-coordinate

 CMP #215               \ If A <> 215 then jump to EN4
 BNE EN4

 LDA QQ1                \ Set A = the current system's galactic y-coordinate

 CMP #84                \ If A <> 84 then jump to EN4
 BNE EN4

 JMP BRIEF3             \ If we get here, mission 1 is complete and no longer in
                        \ progress, mission 2 has started but we have not yet
                        \ picked up the plans, and we have just arrived at
                        \ Ceerdi at galactic coordinates (215, 84), so we jump
                        \ to BRIEF3 to get a mission brief and pick up the plans
                        \ that we need to carry to Birera

.EN5

 CMP #%00001010         \ If mission 1 is complete and no longer in progress,
 BNE EN4                \ and mission 2 has started and we have picked up the
                        \ plans, then bits 0-3 of TP will be %1010, so this
                        \ jumps to EN5 if this is not the case

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 LDA GCNT               \ Fetch the galaxy number into A

 CMP #2                 \ If this is not galaxy 2 (shown in-game as galaxy 3),
 BNE EN4                \ jump to EN4 as we can only start mission 2 in the
                        \ third galaxy

ENDIF

 LDA QQ0                \ Set A = the current system's galactic x-coordinate

 CMP #63                \ If A <> 63 then jump to EN4
 BNE EN4

 LDA QQ1                \ Set A = the current system's galactic y-coordinate

 CMP #72                \ If A <> 72 then jump to EN4
 BNE EN4

 JMP DEBRIEF2           \ If we get here, mission 1 is complete and no longer in
                        \ progress, mission 2 has started and we have picked up
                        \ the plans, and we have just arrived at Birera at
                        \ galactic coordinates (63, 72), so we jump to DEBRIEF2
                        \ to end the mission and get our reward

IF _ELITE_A_DOCKED

.icode_set

 JSR RES2               \ Reset a number of flight variables and workspaces

ENDIF

.EN4

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\LDA CASH+2             \ These instructions are commented out in the original
\CMP #&C4               \ source
\BCC EN6
\
\LDA TP
\AND #&10
\BNE EN6
\
\JMP TBRIEF
\
\.EN6

ELIF _C64_VERSION

 LDA CASH+2             \ If the third most significant byte of CASH(0 1 2 3)
 CMP #&C4               \ is less than &C4 then the cash amount is less than
 BCC EN6                \ &C400 (5017.6 credits), so jump to EN6

 LDA TP                 \ If bit 4 of TP is set, then the Trumbles mission has
 AND #%00010000         \ already been completed, so jump to EN6
 BNE EN6

                        \ If we get here then cheat mode has not been applied,
                        \ we have at least 6553.6 credits and the Trumble
                        \ mission has not yet been offered, so we do that now

 JMP TBRIEF             \ Jump to TBRIEF to offer the Trumble mission, returning
                        \ from the subroutine using a tail call

.EN6

ELIF _NES_VERSION

 LDA COK                \ If bit 7 of COK is set, then cheat mode has been
 BMI EN6                \ applied, so jump to EN6

 LDA CASH+1             \ If the second most significant byte of CASH(0 1 2 3)
 BEQ EN6                \ is zero then the cash amount is less than &010000
                        \ (6553.6 credits), so jump to EN6

 LDA TP                 \ If bit 4 of TP is set, then the Trumbles mission has
 AND #%00010000         \ already been completed, so jump to EN6
 BNE EN6

                        \ If we get here then cheat mode has not been applied,
                        \ we have at least 6553.6 credits and the Trumble
                        \ mission has not yet been offered, so we do that now

 JMP TBRIEF             \ Jump to TBRIEF to offer the Trumble mission, returning
                        \ from the subroutine using a tail call

.EN6

ENDIF

 JMP BAY                \ If we get here them we didn't start or any missions,
                        \ so jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen)

IF _NES_VERSION

 RTS                    \ Return from the subroutine

ENDIF

