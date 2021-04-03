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

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDX GNTMP              \ If the laser temperature in GNTMP is non-zero,
 BEQ EE20               \ decrement it (i.e. cool it down a bit)
 DEC GNTMP

.EE20

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

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

 JSR DIALS              \ Call DIALS to update the dashboard

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

ELIF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ11               \ If this is a space view, skip the following five
 BEQ P%+13              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+7               \ then skip the following two instructions

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ELIF _DISC_DOCKED

 LDA QQ11               \ If this is a space view, skip the following two
 BEQ P%+7               \ instructions (i.e. jump to JSR TT17 below)

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

ENDIF

 JSR TT17               \ Scan the keyboard for the cursor keys or joystick,
                        \ returning the cursor's delta values in X and Y and
                        \ the key pressed in A

