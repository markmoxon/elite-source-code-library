\ ******************************************************************************
\
\       Name: Main game loop for flight (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Cool down lasers, make calls to update the dashboard
\
\ ******************************************************************************

.MLOOP_FLIGHT

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDX GNTMP              \ If the laser temperature in GNTMP is non-zero,
 BEQ EE20               \ decrement it (i.e. cool it down a bit)
 DEC GNTMP

.EE20

 JSR DIALS              \ Call DIALS to update the dashboard

 JSR COMPAS             \ Call COMPAS to update the compass

 LDA QQ11               \ If this is a space view, skip the following two
 BEQ P%+7               \ instructions (i.e. jump to JSR TT17 below)

\AND PATG               \ These instructions are commented out in the original
\LSR A                  \ source
\BCS d_40f8

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds), to slow the
 JSR DELAY              \ main loop down a bit

\JSR WSCAN              \ This instruction is commented out in the original
                        \ source

 JSR DOKEY_FLIGHT       \ Scan the keyboard for flight controls and pause keys,
                        \ (or the equivalent on joystick) and update the key
                        \ logger, setting KL to the key pressed

 JSR chk_dirn           \ Call chk_dirn to set the movement variables based on
                        \ the current state of the key logger

