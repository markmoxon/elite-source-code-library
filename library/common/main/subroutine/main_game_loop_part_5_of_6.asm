\ ******************************************************************************
\
\       Name: Main game loop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Cool down lasers, make calls to update the dashboard
\  Deep dive: Program flow of the main game loop
\             The dashboard indicators
IF _NES_VERSION OR _C64_VERSION
\             The Trumbles mission
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This is the first half of the minimal game loop, which we iterate when we are
\ docked. This section covers the following:
\
\   * Cool down lasers
\
\   * Make calls to update the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MLOOP               The entry point for the main game loop. This entry point
\                       comes after the call to the main flight loop and
\                       spawning routines, so it marks the start of the main
\                       game loop for when we are docked (as we don't need to
\                       call the main flight loop or spawning routines if we
\                       aren't in space)
\
\ ******************************************************************************

.MLOOP

IF _CASSETTE_VERSION \ Other: The cassette version disables keyboard interrupts at the start of the minimal game loop, though I'm not entirely sure why

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ENDIF

IF _ELECTRON_VERSION \ Platform

 LDA LASCT              \ Set A to the value of LASCT, the laser pulse count

 SBC #4                 \ Decrement the value of LASCT by 4

 BCS P%+4               \ If we just reduced LASCT below 0, set it to 0
 LDA #0

 STA LASCT              \ Store the decremented value of X in LASCT, so LASCT
                        \ gets reduced by 4, but not into negative territory

ENDIF

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

IF _ELECTRON_VERSION \ Platform

 INX                    \ Set KEYB = 0 to indicate we are not currently reading
 STX KEYB               \ the keyboard using an OS command

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA)

 LDX GNTMP              \ If the laser temperature in GNTMP is non-zero,
 BEQ EE20               \ decrement it (i.e. cool it down a bit)
 DEC GNTMP

.EE20

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 LDX LASCT              \ Set X to the value of LASCT, the laser pulse count

 BEQ NOLASCT            \ If X = 0 then jump to NOLASCT to skip reducing LASCT,
                        \ as it can't be reduced any further

 DEX                    \ Decrement the value of LASCT in X

 BEQ P%+3               \ If X = 0, skip the next instruction

 DEX                    \ Decrement the value of LASCT in X again

 STX LASCT              \ Store the decremented value of X in LASCT, so LASCT
                        \ gets reduced by 2, but not into negative territory

.NOLASCT

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\LDA QQ11               \ These instructions are commented out in the original
\BNE P%+5               \ source

ELIF _C64_VERSION

 LDA QQ11               \ If QQ11 is non-zero then this is not the space view,
 BNE P%+5               \ so skip the following instruction as only the space
                        \ view has the dashboard

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 JSR DIALS              \ Call DIALS to update the dashboard

ENDIF

IF _6502SP_VERSION \ 6502SP: The 6502SP version supports a printer (holding CTRL when pressing a red function key will send that screen to the printer). As part of this, the code sends line feeds, which is mainly notable for using the longest label name in the entire source code: dontdolinefeedontheprinternow

 BIT printflag          \ If bit 7 of printflag is clear (printer output is not
                        \ enabled), jump to dontdolinefeedontheprinternow to
                        \ skip the following (and en route, why not take a
                        \ short moment to admire this, the longest label name in
                        \ the original Elite source code - presumably they got
                        \ longer when development moved to a 6502 second
                        \ processor system, with all that extra memory...)

 BPL dontdolinefeedontheprinternow

 LDA #prilf             \ Send a #prilf command to the I/O processor to print a
 JSR OSWRCH             \ blank line on the printer
 JSR OSWRCH

.dontdolinefeedontheprinternow

 STZ printflag          \ Set the printflag to 0 to disable printing

ENDIF

IF _CASSETTE_VERSION \ Minor

 LDA QQ11               \ If this is a space view, skip the following four
 BEQ P%+11              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+5               \ then skip the following instruction

 JSR DELAY-5            \ Delay for 8 vertical syncs (8/50 = 0.16 seconds), to
                        \ slow the main loop down a bit

ELIF _ELECTRON_VERSION

 LDA QQ11               \ If this is a space view, skip the following four
 BEQ P%+11              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+5               \ then skip the following instruction

 JSR DELAY-5            \ Delay for 1 delay loop, to slow the main loop down a
                        \ bit

ELIF _DISC_FLIGHT OR _6502SP_VERSION

 LDA QQ11               \ If this is a space view, skip the following five
 BEQ P%+13              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+7               \ then skip the following two instructions

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA QQ11               \ If this is a space view, jump to plus13 to skip the
 BEQ plus13             \ following five instructions

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS plus13             \ then skip the following two instructions

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

.plus13

ELIF _DISC_DOCKED

 LDA QQ11               \ If this is a space view, skip the following two
 BEQ P%+7               \ instructions (i.e. jump to JSR TT17 below)

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _ELITE_A_FLIGHT

 LDA QQ11               \ If this is a space view, skip the following two
 BEQ P%+7               \ instructions (i.e. jump to JSR TT17 below)

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _NES_VERSION

 LDA QQ11               \ If this is a space view, skip the following two
 BEQ P%+7               \ instructions (i.e. jump to JSR TT17 below)

 LDY #4                 \ Wait for 4/50 of a second (0.08 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ENDIF

IF _NES_VERSION OR _C64_VERSION

 LDA TRIBBLE+1          \ If the high byte of TRIBBLE(1 0), the number of
 BEQ nobabies           \ Trumbles in the hold, is zero, jump to nobabies to
                        \ skip the following

                        \ We have a lot of Trumbles in the hold, so let's see if
                        \ any of them are breeding (note that Trumbles always
                        \ breed when we jump into a new system in the SOLAR
                        \ routine, but when we have lots of them, they also
                        \ breed here in the main flight loop)

 JSR DORND              \ Set A and X to random numbers

 CMP #220               \ If A >= 220 then set the C flag (14% chance)

 LDA TRIBBLE            \ Add the C flag to TRIBBLE(1 0), starting with the low
 ADC #0                 \ bytes
 STA TRIBBLE

 BCC nobabies           \ And then the high bytes
 INC TRIBBLE+1          \
                        \ So there is a 14% chance of a Trumble being born

 BPL nobabies           \ If the high byte of TRIBBLE(1 0) is now &80, then
 DEC TRIBBLE+1          \ decrement it back to &7F, so the number of Trumbles
                        \ never goes above &7FFF (32767)

.nobabies

 LDA TRIBBLE+1          \ If the high byte of TRIBBLE(1 0), the number of
 BEQ NOSQUEEK           \ Trumbles in the hold, is zero, jump to NOSQUEEK to
                        \ skip the following

                        \ We have a lot of Trumbles in the hold, so they are
                        \ probably making a bit of a noise

ENDIF

IF _C64_VERSION

 STA T                  \ Store the high byte of the number of Trumbles in T

 LDA CABTMP             \ If the cabin temperature is >= 224 then skip the ASL T
 CMP #224               \ instruction and leave the value of A as a lower value,
 BCS P%+4               \ so the chances of the Trumbles making a noise in hot
                        \ temperatures is lessened (specifically, this is the
                        \ temperature at which the fuel scoops start working)

 ASL T                  \ Set T = T * 2

 JSR DORND              \ Set A and X to random numbers

 CMP T                  \ If A >= T then jump to NOSQUEEK to skip making any
 BCS NOSQUEEK           \ noise, so there is a higher chance of Trumbles making
                        \ noise when there are lots of them and the cabin
                        \ temperature is cool enough for the fuel scoops to be
                        \ disabled (so they start to go quieter when things get
                        \ too hot)

                        \ If we get here then we want to make the noise of
                        \ Trumbles living in our ship

 JSR DORND              \ Set X to a random number in the range 64 to 255, which
 ORA #64                \ we will use as the frequency of the sound of Trumble
 TAX                    \ chatter (so they make a randomly pitched noise that's
                        \ not too high)

 LDA #&80               \ Set A = &80 to pass to NOISE2 as the sustain volume
                        \ and release length for when the cabin is relatively
                        \ cool, so that's a sustain volume of 8 and a release
                        \ length of 0
                        \
                        \ This makes the sounds more staccato and softer

 LDY CABTMP             \ If the cabin temperature is < 224, jump to
 CPY #224               \ burnthebastards to make the noise of Trumbles lightly
 BCC burnthebastards    \ toasting

 TXA                    \ Clip X to a random number in the range 0 to 15, so the
 AND #15                \ frequency of the Trumble chatter gets lower as the
 TAX                    \ cabin gets hotter

 LDA #&F1               \ Set A = &F1 to pass to NOISE2 as the sustain volume
                        \ and release length for when the cabin is really hot,
                        \ so that's a sustain volume of 15 and a release length
                        \ of 1
                        \
                        \ This makes the sounds more drawn out and louder

.burnthebastards

 LDY #sfxtrib           \ Call the NOISE2 routine with Y = sfxtrib and A and X
 JSR NOISE2             \ set according to the cabin temperature:
                        \
                        \   * A = &80, X = 64 to 255 when the cabin is cool
                        \     (quieter, higher-pitched, more staccato squeaks)
                        \
                        \   * A = &F1, X = 0 to 15 when the cabin is hot
                        \     (louder, lower-pitched, more drawn out squeaks)
                        \
                        \ This makes the sound of Trumbles either partying or
                        \ or being slowly roasted

.NOSQUEEK

ELIF _NES_VERSION

 LDY CABTMP             \ If the cabin temperature is >= 224 then skip the next
 CPY #224               \ two LSR A instructions and leave the value of A as a
 BCS P%+4               \ high value, so the chances of the Trumbles making a
                        \ noise in hot temperatures is greater (specifically,
                        \ this is the temperature at which the fuel scoops start
                        \ working)

 LSR A                  \ Set A = A / 2
 LSR A

 STA T                  \ Set T = A, which will be higher with more Trumbles and
                        \ higher temperatures

 JSR DORND              \ Set A and X to random numbers

 CMP T                  \ If A >= T then jump to NOSQUEEK to skip making any
 BCS NOSQUEEK           \ noise, so there is a higher chance of Trumbles making
                        \ noise when there are lots of them or the cabin
                        \ temperature is hot enough for the fuel scoops to work

 AND #3                 \ Set Y to our random number reduced to the range 0 to 3
 TAY

 LDA trumbleSounds,Y    \ Set Y to the Y-th sound effect from the trumbleSounds
 TAY                    \ table, so there's a 75% change of Y being set to 5,
                        \ and a 25% chance of Y being set to 6

 JSR NOISE              \ Call the NOISE routine to make the sound of the
                        \ Trumbles in Y, which will be one of 5 or 6, with 5
                        \ more likely than 6

.NOSQUEEK

 LDA allowInSystemJump  \ Set A to the value of allowInSystemJump, which
                        \ determines whether we are allowed to perform an
                        \ in-system jump (which is the same as saying whether
                        \ the fast-forward button is enabled)

 LDX QQ22+1             \ Fetch into X the number that's shown on-screen during
                        \ the hyperspace countdown

 BEQ game5              \ If the counter is zero then we are not counting down
                        \ to hyperspace, so jump to game5 to skip the next
                        \ instruction

 ORA #%10000000         \ Set bit 7 of A to prevent in-system jumps, as there
                        \ is a hyperspace countdown in progress

.game5

 LDX demoInProgress     \ If the demo is not in progress, jump to game6 to skip
 BEQ game6              \ the following

 AND #%01111111         \ Clear bit 7 of A to enable the fast-forward button, as
                        \ this is the combat demo and the fast-forward button
                        \ lets us skip the rest of the demo

.game6

 STA allowInSystemJump  \ Store the updated value of A in allowInSystemJump

 AND #%11000000         \ If bits 6 and 7 of allowInSystemJump are both clear
 BEQ game7              \ then in-system jumps are allowed, so jump to game7
                        \ to leave allowInSystemJump alone

 CMP #%11000000         \ If bits 6 and 7 of allowInSystemJump are both set then
 BEQ game7              \ in-system jumps are not allowed, so jump to game7 to
                        \ leave allowInSystemJump alone

 CMP #%10000000         \ If bit 7 of allowInSystemJump is set but bit 6 isn't,
                        \ then this sets the C flag, otherwise it clears the C
                        \ flag

 ROR A                  \ This updates allowInSystemJump as follows:
 STA allowInSystemJump  \
                        \   * %10xxxxxx rotates to %11xxxxxx
                        \
                        \   * %01xxxxxx rotates to %00xxxxxx
                        \
                        \ In other words, when bit 7 of the allowInSystemJump
                        \ flag is set, then that condition will spread to both
                        \ bit 6 and 7, but if only bit 6 is set, then the flag
                        \ will clear at this point in the main game loop
                        \
                        \ So once bit 7 is cleared, in-system jumps will be
                        \ allowed within an iteration of the main loop, assuming
                        \ no more preventative conditions appear

 JSR UpdateIconBar_b3   \ Update the icon bar to hide or show the in-system jump
                        \ icon bar button, according to the new value of the
                        \ allowInSystemJump flag

.game7

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

 JSR TT17               \ Scan the keyboard for the cursor keys or joystick,
                        \ returning the cursor's delta values in X and Y and
                        \ the key pressed in A

ELIF _ELECTRON_VERSION

 JSR TT17               \ Scan the keyboard for the cursor keys, returning the
                        \ cursor's delta values in X and Y and the key pressed
                        \ in A

ELIF _NES_VERSION

 JSR TT17               \ Scan the key logger for the directional pad buttons,
                        \ returning the cursor's delta values in X and Y and
                        \ the button pressed in A

ENDIF
