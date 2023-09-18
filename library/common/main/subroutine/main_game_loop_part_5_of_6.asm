\ ******************************************************************************
\
\       Name: Main game loop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Cool down lasers, make calls to update the dashboard
\  Deep dive: Program flow of the main game loop
\             The dashboard indicators
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

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

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

IF _MASTER_VERSION \ Comment

\LDA QQ11               \ These instructions are commented out in the original
\BNE P%+5               \ source

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

ELIF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ11               \ If this is a space view, skip the following five
 BEQ P%+13              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+7               \ then skip the following two instructions

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _MASTER_VERSION

 LDA QQ11               \ If this is a space view, jump to plus13 to skip the
 BEQ plus13             \ following five instructions

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+7               \ then skip the following two instructions

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

IF _NES_VERSION

 LDA TRIBBLE+1          \ If the high byte of TRIBBLE(1 0), the number of
 BEQ game4              \ Trumbles in the hold, is zero, jump to game4 to skip
                        \ the following

                        \ We have a lot of Trumbles in the hold, so let's see if
                        \ any of them are breeding (note that Trumbles always
                        \ breed when we jump into a new system in the SOLAR
                        \ routine, but when we have lots of them, they also
                        \ breed here in the main flight loop

 JSR DORND              \ Set A and X to random numbers

 CMP #220               \ If A >= 220 then set the C flag (14% chance)

 LDA TRIBBLE            \ Add the C flag to TRIBBLE(1 0), starting with the low
 ADC #0                 \ bytes
 STA TRIBBLE

 BCC game4              \ And then the high bytes
 INC TRIBBLE+1          \
                        \ So there is a 14% chance of a Trumble being born

 BPL game4              \ If the high byte of TRIBBLE(1 0) is now &80, then
 DEC TRIBBLE+1          \ decrement it back to &7F, so the number of Trumbles
                        \ never goes above &7FFF (32767)

.game4

 LDA TRIBBLE+1          \ If the high byte of TRIBBLE(1 0), the number of
 BEQ game6              \ Trumbles in the hold, is zero, jump to game6 to skip
                        \ the following

                        \ We have a lot of Trumbles in the hold, so they are
                        \ probably making a bit of a noise

 LDY CABTMP             \ If the cabin temperature is >= 224 then jump to game5
 CPY #224               \ to skip the following and leave the value of A as a
 BCS game5              \ high value, so the chances of the Trumbles making a
                        \ noise in hot temperature is greater (specifically,
                        \ this is the temperature at which the fuel scoop start
                        \ working)

 LSR A                  \ Set A = A / 2
 LSR A

.game5

 STA T                  \ Set T = A, which will be higher with more Trumbles and
                        \ higher temperatures

 JSR DORND              \ Set A and X to random numbers

 CMP T                  \ If A >= T then jump to game6 to skip making any noise,
 BCS game6              \ so there is a higher chance of Trumbles making noise
                        \ when there are lots of them or the cabin temperature
                        \ is hot enough for the fuel scoops to work

 AND #3                 \ Set Y to our random number reduced to the range 0 to 3
 TAY

 LDA trumbleNoises,Y    \ Set Y to the Y-th noise number from the trumbleNoises
 TAY                    \ table, so there's a 75% change of Y being set to 5,
                        \ and a 25% chance of Y being set to 6

 JSR NOISE              \ Call the NOISE routine to make the sound of the
                        \ Trumbles in Y, which will be one of 5 or 6, with 5
                        \ more likely than 6

.game6

 LDA allowInSystemJump  \ ???
 LDX QQ22+1
 BEQ game7
 ORA #&80

.game7

 LDX demoInProgress
 BEQ game8
 AND #&7F

.game8

 STA allowInSystemJump
 AND #&C0
 BEQ game9
 CMP #&C0
 BEQ game9
 CMP #&80
 ROR A
 STA allowInSystemJump
 JSR UpdateIconBar_b3

.game9

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

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
