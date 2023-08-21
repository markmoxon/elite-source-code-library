\ ******************************************************************************
\
\       Name: Main flight loop (Part 9 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: If it is a space station, check whether we
\             are successfully docking with it
\  Deep dive: Program flow of the main game loop
\             Docking checks
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Process docking with a space station
\
\ For details on the various docking checks in this routine, see the deep dive
\ on "Docking checks".
\
\ Other entry points:
\
\   GOIN                We jump here from part 3 of the main flight loop if the
\                       docking computer is activated by pressing "C"
\
\ ******************************************************************************

.ISDK

IF _CASSETTE_VERSION \ Platform

 LDA K%+NI%+32          \ 1. Fetch the AI counter (byte #32) of the second ship
 BMI MA62               \ in the ship data workspace at K%, which is reserved
                        \ for the sun or the space station (in this case it's
                        \ the latter), and if it's negative, i.e. bit 7 is set,
                        \ meaning the station is hostile, jump down to MA62 to
                        \ fail docking (so trying to dock at a station that we
                        \ have annoyed does not end well)

ELIF _ELECTRON_VERSION

 LDA K%+NI%+32          \ 1. Fetch the AI counter (byte #32) of the second ship
 BMI MA62               \ in the ship data workspace at K%, which is reserved
                        \ for the space station, and if it's negative, i.e. bit
                        \ 7 is set, meaning the station is hostile, jump down
                        \ to MA62 to fail docking (so trying to dock at a
                        \ station that we have annoyed does not end well)

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA K%+NI%+36          \ 1. Fetch the NEWB flags (byte #36) of the second ship
 AND #%00000100         \ in the ship data workspace at K%, which is reserved
 BNE MA62               \ for the sun or the space station (in this case it's
                        \ the latter), and if bit 2 is set, meaning the station
                        \ is hostile, jump down to MA62 to fail docking (so
                        \ trying to dock at a station that we have annoyed does
                        \ not end well)

ELIF _NES_VERSION

 LDA K%+NIK%+36         \ 1. Fetch the NEWB flags (byte #36) of the second ship
 AND #%00000100         \ in the ship data workspace at K%, which is reserved
 BNE MA622              \ for the sun or the space station (in this case it's
                        \ the latter), and if bit 2 is set, meaning the station
                        \ is hostile, jump down to MA622 to fail docking (so
                        \ trying to dock at a station that we have annoyed does
                        \ not end well)

ENDIF

 LDA INWK+14            \ 2. If nosev_z_hi < 214, jump down to MA62 to fail
 CMP #214               \ docking, as the angle of approach is greater than 26
 BCC MA62               \ degrees

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: The cassette version contains an extra docking check that makes sure we are facing towards the station when trying to dock

 JSR SPS4               \ Call SPS4 to get the vector to the space station
                        \ into XX15

 LDA XX15+2             \ 3. Check the sign of the z-axis (bit 7 of XX15+2) and
 BMI MA62               \ if it is negative, we are facing away from the
                        \ station, so jump to MA62 to fail docking

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR SPS1               \ Call SPS1 to calculate the vector to the planet and
                        \ store it in XX15

 LDA XX15+2             \ Set A to the z-axis of the vector

                        \ This version of Elite omits check 3 (which would check
                        \ the sign of the z-axis)

ELIF _ELITE_A_VERSION

 LDY #NI%               \ Set Y = NI% so the following call to SPS1 calculates
                        \ the vector to the space station rather than the planet

 JSR SPS1               \ Call SPS1 to calculate the vector to the space station
                        \ and store it in XX15

 LDA XX15+2             \ Set A to the z-axis of the vector

                        \ This version of Elite omits check 3 (which would check
                        \ the sign of the z-axis)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Standard: When docking, the cassette version checks that the angle between the vector to the space station and the nominal approach is less than 22.0 degrees; in the disc version, it checks that the angle between the vector to the planet and the nominal approach is less than 26.3 degrees; and in the advanced versions, it checks that the angle between the vector to the planet and the nominal approach is less than 22.0 degrees

 CMP #89                \ 4. If z-axis < 89, jump to MA62 to fail docking, as
 BCC MA62               \ we are not in the 22.0 degree safe cone of approach

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 CMP #86                \ 4. If z-axis < 86, jump to MA62 to fail docking, as
 BCC MA62               \ we are not in the 26.3 degree safe cone of approach

ENDIF

 LDA INWK+16            \ 5. If |roofv_x_hi| < 80, jump to MA62 to fail docking,
 AND #%01111111         \ as the slot is more than 36.6 degrees from horizontal
 CMP #80
 BCC MA62

.GOIN

IF _MASTER_VERSION \ Comment

\JSR stopbd             \ This instruction is commented out in the original
                        \ source

ENDIF

IF _NES_VERSION

 JSR ResetMusicAfterNMI \ ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

                        \ If we arrive here, either the docking computer has
                        \ been activated, or we just docked successfully

 LDA #0                 \ Set the on-screen hyperspace counter to 0
 STA QQ22+1

 LDA #8                 \ This instruction has no effect, so presumably it used
                        \ to do something, and didn't get removed

 JSR LAUN               \ Show the space station launch tunnel

 JSR RES4               \ Reset the shields and energy banks, stardust and INWK
                        \ workspace

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen)

ELIF _DISC_VERSION OR _ELITE_A_FLIGHT

                        \ If we arrive here, we just docked successfully

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDA #8                 \ Set the step size for the launch tunnel rings to 8, so
                        \ there are fewer sections in the rings and they are
                        \ quite polygonal (compared to the step size of 4 used
                        \ in the much rounder hyperspace rings)

 JSR HFS2               \ Call HFS2 to draw the launch tunnel rings

 JMP DOENTRY            \ Go to the docking bay (i.e. show the ship hangar)

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

                        \ If we arrive here, we just docked successfully

 JMP DOENTRY            \ Go to the docking bay (i.e. show the ship hangar)

ELIF _ELITE_A_6502SP_PARA

                        \ If we arrive here, we just docked successfully

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDA #8                 \ Set the step size for the launch tunnel rings to 8, so
                        \ there are fewer sections in the rings and they are
                        \ quite polygonal (compared to the step size of 4 used
                        \ in the much rounder hyperspace rings)

 JSR HFS2               \ Call HFS2 to draw the launch tunnel rings

 JMP DOENTRYS           \ Go to the docking bay (i.e. show the ship hangar)

ENDIF

.MA62

                        \ If we arrive here, docking has just failed

IF _NES_VERSION

 LDA auto               \ If the docking computer is engaged, ensure we dock
 BNE GOIN               \ successfully even if the approach isn't correct, as
                        \ the docking computer algorithm isn't perfect (so this
                        \ fixes the issue in the other versions of Elite where
                        \ the docking computer can kill you)

.MA622

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDA DELTA              \ If the ship's speed is < 5, jump to MA67 to register
 CMP #5                 \ some damage, but not a huge amount
 BCC MA67

 JMP DEATH              \ Otherwise we have just crashed into the station, so
                        \ process our death

ELIF _ELITE_A_VERSION

 LDA DELTA              \ If the ship's speed is >= 5, jump to n_crunch to
 CMP #5                 \ register a fair amount of damage to our shields (128)
 BCS n_crunch

                        \ Otherwise we have just crashed gently into the
                        \ station, so we need to check whether it's our fault or
                        \ the docking computer

ENDIF

