\ ******************************************************************************
\
\       Name: Main flight loop (Part 15 of 16)
\       Type: Subroutine
\   Category: Main loop
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Perform altitude checks with the planet and sun and process fuel
\             scooping if appropriate
ELIF _ELECTRON_VERSION
\    Summary: Perform altitude checks with the planet
ENDIF
\  Deep dive: Program flow of the main game loop
\             Scheduling tasks with the main loop counter
IF _NES_VERSION
\             The NES combat demo
\             The Trumbles mission
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
IF NOT(_NES_VERSION)
\   * Perform an altitude check with the planet (every 32 iterations of the main
\     loop, on iteration 10 of each 32)
\
ELIF _NES_VERSION
\   * Perform an altitude check with the planet (every 16 iterations of the main
\     loop, on iterations 10 and 20 of each 32)
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * Perform an altitude check with the sun and process fuel scooping (every
\     32 iterations of the main loop, on iteration 20 of each 32)
\
ENDIF
\ ******************************************************************************

.MA22

IF _CASSETTE_VERSION \ Label

 LDA MJ                 \ If we are in witchspace, jump down to MA23 to skip
 BNE MA23               \ the following, as there are no planets or suns to
                        \ bump into in witchspace

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA MJ                 \ If we are in witchspace, jump down to MA23S to skip
 BNE MA23S              \ the following, as there are no planets or suns to
                        \ bump into in witchspace

ENDIF

IF NOT(_NES_VERSION)

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 32,
 AND #31                \ which tells us the position of this loop in each block
                        \ of 32 iterations

.MA93

ELIF _NES_VERSION

.MA93

 LDA demoInProgress     \ If the demo is not in progress, jump to main46 to skip
 BEQ main46             \ the following

                        \ If we get here then the demo is in progress, so now we
                        \ check to see if we have destroyed all the demo ships

 LDA JUNK               \ Set Y to the number of pieces of space junk (in JUNK)
 CLC                    \ plus the number of missiles (in MANY+1)
 ADC MANY+1
 TAY

 LDA FRIN+2,Y           \ There are Y non-ship items in the bubble, so if slot
 BNE main46             \ Y+2 is not empty (given that the first two slots are
                        \ the planet and sun), then this means there is at least
                        \ one ship in the bubble along with the junk and
                        \ missiles, so jump to main46 to skip the following as
                        \ we haven't yet destroyed all the ships in the combat
                        \ practice demo

 LDA #1                 \ If we get here then we have destroyed all the ships in
 JMP ShowScrollText_b6  \ the demo, so jump to ShowScrollText with A = 1 to show
                        \ the results of combat practice, returning from the
                        \ subroutine using a tail call

.main46

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 32,
 AND #31                \ which tells us the position of this loop in each block
                        \ of 32 iterations

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 CMP #10                \ If this is the tenth iteration in this block of 32,
 BNE MA29               \ do the following, otherwise jump to MA29 to skip the
                        \ planet altitude check and move on to the sun distance
                        \ check

ELIF _ELECTRON_VERSION

 CMP #10                \ If this is the tenth iteration in this block of 32,
 BNE MA29               \ do the following, otherwise jump to MA29 to skip the
                        \ planet altitude check

ELIF _NES_VERSION

 CMP #10                \ If this is the tenth or twentieth iteration in this
 BEQ main47             \ block of 32, do the following, otherwise jump to MA29
 CMP #20                \ to skip the planet altitude check and move on to the
 BNE MA29               \ sun distance check

.main47

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ 6502SP: If speech is enabled on the Executive version, it will say "Energy low" every time the "ENERGY LOW,SIR" message flashes on-screen

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

ELIF _NES_VERSION

 LDA #80                \ If our energy bank status in ENERGY is >= 80, skip
 CMP ENERGY             \ printing the following message (so the message is
 BCC main48             \ only shown if our energy is low)

 LDA #100               \ Print recursive token 100 ("ENERGY LOW{beep}") as an
 JSR MESS               \ in-flight message

 LDY #7                 \ Call the NOISE routine with Y = 7 to make a beep to
 JSR NOISE              \ indicate low energy

.main48

ENDIF

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 JSR CheckAltitude      \ Perform an altitude check with the planet, ending the
                        \ game if we hit the ground

 JMP MA23               \ Jump to MA23 to skip to the next section

.MA28

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

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

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: The docking computer in the enhanced versions updates its position every 32 iterations round the main loop (on the 15th iteration), at which point it displays "DOCKING COMPUTERS ON" as an in-flight message

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

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: As there are no suns in the Electron version, we don't need to set the cabin temperature based on the altitude from the sun

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

 CMP #224               \ If the cabin temperature < 224 then jump to MA23 to
 BCC MA23               \ skip fuel scooping, as we aren't close enough

ELIF _NES_VERSION

 AND #15                \ If this is the 6th iteration in this block of 16,
 CMP #6                 \ do the following, otherwise jump to MA23 to skip the
 BNE MA23               \ sun altitude check

 LDA #30                \ Set CABTMP to 30, the cabin temperature in deep space
 STA CABTMP             \ (i.e. one notch on the dashboard bar)

 LDA SSPR               \ If we are inside the space station safe zone, jump to
 BNE MA23               \ MA23 to skip the following, as we can't have both the
                        \ sun and space station at the same time, so we clearly
                        \ can't be flying near the sun

 LDY #NIK%              \ Set Y to NIK%+4, which is the offset in K% for the
                        \ sun's data block, as the second block at K% is
                        \ reserved for the sun (or space station)

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

 CMP #224               \ If the cabin temperature < 224 then jump to MA23 to
 BCC MA23               \ skip fuel scooping, as we aren't close enough

ELIF _ELITE_A_VERSION

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

 CMP #224               \ If the cabin temperature < 224 then jump to MA23 to
 BCC MA23               \ skip fuel scooping, as we aren't close enough

ENDIF

IF _MASTER_VERSION \ Comment

\CMP #&F0               \ These instructions are commented out in the original
\BCC nokilltr           \ source
\LDA #5
\JSR SETL1
\LDA VIC+&15
\AND #&3
\STA VIC+&15
\LDA #4
\JSR SETL1
\LSR TRIBBLE+1
\ROR TRIBBLE
\.nokilltr

ELIF _NES_VERSION

 CMP #240               \ If the cabin temperature < 240 then jump to nokilltr
 BCC nokilltr           \ as the heat isn't high enough to kill Trumbles

 LDA TRIBBLE+1          \ If TRIBBLE(1 0) = 0 then there are no Trumbles in the
 ORA TRIBBLE            \ hold, so jump to nokilltr to skip the following
 BEQ nokilltr

 LSR TRIBBLE+1          \ Halve the number of Trumbles in TRIBBLE(1 0) as the
 ROR TRIBBLE            \ cabin temperature is high enough to kill them off
                        \ (this will eventually bring the number down to zero)

 LDY #31                \ Call the NOISE routine with Y = 31 to make the sound
 JSR NOISE              \ of Trumbles being killed off by the heat of the sun

.nokilltr

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: As there are no suns in the Electron version, we don't need to implement fuel scooping

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

ELIF _NES_VERSION

 LDA BST                \ If we don't have fuel scoops fitted, jump to MA23 to
 BEQ MA23               \ skip fuel scooping, as we can't scoop without fuel
                        \ scoops

 LDA DELT4+1            \ We are now successfully fuel scooping, so it's time
 BEQ MA23               \ to work out how much fuel we're scooping. Fetch the
                        \ high byte of DELT4, which contains our current speed
                        \ divided by 4, and if it is zero, jump to BA23 to skip
                        \ skip fuel scooping, as we can't scoop fuel if we are
                        \ not moving

 LSR A                  \ If we are moving, halve A to get our current speed
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

 BCS MA23               \ If A >= 70, jump to BA23 to skip fuel scooping, as the
                        \ fuel tanks are already full

 JSR MakeScoopSound     \ Make the sound of the fuel scoops working

 JSR SetSelectionFlags  \ Set the selected system flags for the new system and
                        \ update the icon bar if required

ELIF _ELITE_A_VERSION

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

 CMP new_range          \ If A > new_range then set A = new_range (as new_range
 BCC P%+5               \ is the maximum fuel level for our current ship
 LDA new_range

 STA QQ14               \ Store the updated fuel level in QQ14

ENDIF

IF _CASSETTE_VERSION \ Minor

 LDA #160               \ Print recursive token 0 ("FUEL SCOOPS ON") as an
 JSR MESS               \ in-flight message

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA #160               \ Set A to token 160 ("FUEL SCOOPS ON")

.MA34

 JSR MESS               \ Print the token in A as an in-flight message

ENDIF

