\ ******************************************************************************
\
\       Name: Main flight loop (Part 15 of 16)
\       Type: Subroutine
\   Category: Main loop
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Perform altitude checks with the planet and sun and process fuel
\             scooping if appropriate
ELIF _ELECTRON_VERSION
\    Summary: Perform altitude checks with the planet
ENDIF
\  Deep dive: Program flow of the main game loop
\             Scheduling tasks with the main loop counter
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Perform an altitude check with the planet (every 32 iterations of the main
\     loop, on iteration 10 of each 32)
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   * Perform an an altitude check with the sun and process fuel scooping (every
\     32 iterations of the main loop, on iteration 20 of each 32)
\
ENDIF
\ ******************************************************************************

.MA22

IF _CASSETTE_VERSION \ Label

 LDA MJ                 \ If we are in witchspace, jump down to MA23 to skip
 BNE MA23               \ the following, as there are no planets or suns to
                        \ bump into in witchspace

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDA MJ                 \ If we are in witchspace, jump down to MA23S to skip
 BNE MA23S              \ the following, as there are no planets or suns to
                        \ bump into in witchspace

ENDIF

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 32,
 AND #31                \ which tells us the position of this loop in each block
                        \ of 32 iterations

.MA93

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 CMP #10                \ If this is the tenth iteration in this block of 32,
 BNE MA29               \ do the following, otherwise jump to MA29 to skip the
                        \ planet altitude check and move on to the sun distance
                        \ check

ELIF _ELECTRON_VERSION

 CMP #10                \ If this is the tenth iteration in this block of 32,
 BNE MA29               \ do the following, otherwise jump to MA29 to skip the
                        \ planet altitude check

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ 6502SP: If speech is enabled on the Executive version, it will say "Energy low" every time the "ENERGY LOW,SIR" message flashes on-screen

 LDA #50                \ If our energy bank status in ENERGY is >= 50, skip
 CMP ENERGY             \ printing the following message (so the message is
 BCC P%+6               \ only shown if our energy is low)

 ASL A                  \ Print recursive token 100 ("ENERGY LOW{beep}") as an
 JSR MESS               \ in-flight message

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 LDA #50                \ If our energy bank status in ENERGY is >= 50, skip
 CMP ENERGY             \ printing the following message (so the message is
 BCC P%+6               \ only shown if our energy is low)

 ASL A                  \ Print recursive token 100 ("ENERGY LOW{beep}") as an
 JSR MESS               \ in-flight message

ELIF _EXECUTIVE

 LDA #50                \ If our energy bank status in ENERGY is >= 50, skip
 CMP ENERGY             \ printing the following message (so the message is
 BCC P%+11              \ only shown if our energy is low)

 ASL A                  \ Print recursive token 100 ("ENERGY LOW{beep}") as an
 JSR MESS               \ in-flight message

 LDX #2                 \ Call TALK with X = 2 to say "Energy low" using the
 JSR TALK               \ Watford Electronics Beeb Speech Synthesiser (if one
                        \ is fitted and speech has been enabled)

ENDIF

ENDIF

 LDY #&FF               \ Set our altitude in ALTIT to &FF, the maximum
 STY ALTIT

 INY                    \ Set Y = 0

 JSR m                  \ Call m to calculate the maximum distance to the
                        \ planet in any of the three axes, returned in A

 BNE MA23               \ If A > 0 then we are a fair distance away from the
                        \ planet in at least one axis, so jump to MA23 to skip
                        \ the rest of the altitude check

 JSR MAS3               \ Set A = x_hi^2 + y_hi^2 + z_hi^2, so using Pythagoras
                        \ we now know that A now contains the square of the
                        \ distance between our ship (at the origin) and the
                        \ centre of the planet at (x_hi, y_hi, z_hi)

 BCS MA23               \ If the C flag was set by MAS3, then the result
                        \ overflowed (was greater than &FF) and we are still a
                        \ fair distance from the planet, so jump to MA23 as we
                        \ haven't crashed into the planet

 SBC #36                \ Subtract 36 from x_hi^2 + y_hi^2 + z_hi^2. The radius
                        \ of the planet is defined as 6 units and 6^2 = 36, so
                        \ A now contains the high byte of our altitude above
                        \ the planet surface, squared

 BCC MA28               \ If A < 0 then jump to MA28 as we have crashed into
                        \ the planet

 STA R                  \ We are getting close to the planet, so we need to
 JSR LL5                \ work out how close. We know from the above that A
                        \ contains our altitude squared, so we store A in R
                        \ and call LL5 to calculate:
                        \
                        \   Q = SQRT(R Q) = SQRT(A Q)
                        \
                        \ Interestingly, Q doesn't appear to be set to 0 for
                        \ this calculation, so presumably this doesn't make a
                        \ difference

 LDA Q                  \ Store the result in ALTIT, our altitude
 STA ALTIT

 BNE MA23               \ If our altitude is non-zero then we haven't crashed,
                        \ so jump to MA23 to skip to the next section

.MA28

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 JMP DEATH              \ If we get here then we just crashed into the planet
                        \ or got too close to the sun, so jump to DEATH to start
                        \ the funeral preparations and return from the main
                        \ flight loop using a tail call

ELIF _ELECTRON_VERSION

 JMP DEATH              \ If we get here then we just crashed into the planet,
                        \ so jump to DEATH to start the funeral preparations
                        \ and return from the main flight loop using a tail call

ENDIF

.MA29

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: The docking computer in the enhanced versions updates its position every 32 iterations round the main loop (on the 15th iteration), at which point it displays "DOCKING COMPUTERS ON" as an in-flight message

 CMP #15                \ If this is the 15th iteration in this block of 32,
 BNE MA33               \ do the following, otherwise jump to MA33 to skip the
                        \ docking computer manoeuvring

 LDA auto               \ If auto is zero, then the docking computer is not
 BEQ MA23               \ activated, so jump to MA33 to skip the
                        \ docking computer manoeuvring

 LDA #123               \ Set A = 123 and jump down to MA34 to print token 123
 BNE MA34               \ ("DOCKING COMPUTERS ON") as an in-flight message

.MA33

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: As there are no suns in the Electron version, we don't need to set the cabin temperature based on the altitude from the sun, and we don't need to implement fuel scooping

 CMP #20                \ If this is the 20th iteration in this block of 32,
 BNE MA23               \ do the following, otherwise jump to MA23 to skip the
                        \ sun altitude check

 LDA #30                \ Set CABTMP to 30, the cabin temperature in deep space
 STA CABTMP             \ (i.e. one notch on the dashboard bar)

 LDA SSPR               \ If we are inside the space station safe zone, jump to
 BNE MA23               \ MA23 to skip the following, as we can't have both the
                        \ sun and space station at the same time, so we clearly
                        \ can't be flying near the sun

 LDY #NI%               \ Set Y to NI%, which is the offset in K% for the sun's
                        \ data block, as the second block at K% is reserved for
                        \ the sun (or space station)

 JSR MAS2               \ Call MAS2 to calculate the largest distance to the
 BNE MA23               \ sun in any of the three axes, and if it's non-zero,
                        \ jump to MA23 to skip the following, as we are too far
                        \ from the sun for scooping or temperature changes

 JSR MAS3               \ Set A = x_hi^2 + y_hi^2 + z_hi^2, so using Pythagoras
                        \ we now know that A now contains the square of the
                        \ distance between our ship (at the origin) and the
                        \ heart of the sun at (x_hi, y_hi, z_hi)

 EOR #%11111111         \ Invert A, so A is now small if we are far from the
                        \ sun and large if we are close to the sun, in the
                        \ range 0 = far away to &FF = extremely close, ouch,
                        \ hot, hot, hot!

 ADC #30                \ Add the minimum cabin temperature of 30, so we get
                        \ one of the following:
                        \
                        \   * If the C flag is clear, A contains the cabin
                        \     temperature, ranging from 30 to 255, that's hotter
                        \     the closer we are to the sun
                        \
                        \   * If the C flag is set, the addition has rolled over
                        \     and the cabin temperature is over 255

 STA CABTMP             \ Store the updated cabin temperature

 BCS MA28               \ If the C flag is set then jump to MA28 to die, as
                        \ our temperature is off the scale

 CMP #&E0               \ If the cabin temperature < 224 then jump to MA23 to
 BCC MA23               \ to skip fuel scooping, as we aren't close enough

 LDA BST                \ If we don't have fuel scoops fitted, jump to BA23 to
 BEQ MA23               \ skip fuel scooping, as we can't scoop without fuel
                        \ scoops

 LDA DELT4+1            \ We are now successfully fuel scooping, so it's time
 LSR A                  \ to work out how much fuel we're scooping. Fetch the
                        \ high byte of DELT4, which contains our current speed
                        \ divided by 4, and halve it to get our current speed
                        \ divided by 8 (so it's now a value between 1 and 5, as
                        \ our speed is normally between 1 and 40). This gives
                        \ us the amount of fuel that's being scooped in A, so
                        \ the faster we go, the more fuel we scoop, and because
                        \ the fuel levels are stored as 10 * the fuel in light
                        \ years, that means we just scooped between 0.1 and 0.5
                        \ light years of free fuel

 ADC QQ14               \ Set A = A + the current fuel level * 10 (from QQ14)

 CMP #70                \ If A > 70 then set A = 70 (as 70 is the maximum fuel
 BCC P%+4               \ level, or 7.0 light years)
 LDA #70

 STA QQ14               \ Store the updated fuel level in QQ14

ENDIF

IF _CASSETTE_VERSION \ Minor

 LDA #160               \ Print recursive token 0 ("FUEL SCOOPS ON") as an
 JSR MESS               \ in-flight message

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDA #160               \ Set A to token 160 ("FUEL SCOOPS ON")

.MA34

 JSR MESS               \ Print the token in A as an in-flight message

ENDIF

