\ ******************************************************************************
\
\       Name: Main game loop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Cool down lasers, make calls to update the dashboard
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

IF _CASSETTE_VERSION

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA SHEILA+&4E         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ENDIF

 LDX #&FF               \ Reset the 6502 stack pointer, which clears the stack
 TXS

 LDX GNTMP              \ If the laser temperature in GNTMP is non-zero,
 BEQ EE20               \ decrement it (i.e. cool it down a bit)
 DEC GNTMP

.EE20

IF _6502SP_VERSION

 LDX LASCT
 BEQ NOLASCT
 DEX
 BEQ P%+3
 DEX
 STX LASCT

.NOLASCT

ENDIF

 JSR DIALS              \ Call DIALS to update the dashboard

IF _CASSETTE_VERSION

 LDA QQ11               \ If this is a space view, skip the following four
 BEQ P%+11              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+5               \ then skip the following instruction

 JSR DELAY-5            \ Delay for 8 vertical syncs (8/50 = 0.16 seconds), to
                        \ slow the main loop down a bit

ELIF _6502SP_VERSION

 BIT printflag
 BPL dontdolinefeedontheprinternow
 LDA #prilf
 JSR OSWRCH
 JSR OSWRCH

.dontdolinefeedontheprinternow

 STZ printflag

 LDA QQ11               \ If this is a space view, skip the following four
 BEQ P%+13              \ instructions (i.e. jump to JSR TT17 below)

 AND PATG               \ If PATG = &FF (author names are shown on start-up)
 LSR A                  \ and bit 0 of QQ11 is 1 (the current view is type 1),
 BCS P%+7               \ then skip the following instruction

 LDY #2

 JSR DELAY

ENDIF

 JSR TT17               \ Scan the keyboard for the cursor keys or joystick,
                        \ returning the cursor's delta values in X and Y and
                        \ the key pressed in A

