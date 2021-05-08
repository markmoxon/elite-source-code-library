\ ******************************************************************************
\
\       Name: DJOY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for cursor key or digital joystick movement
\
\ ******************************************************************************

IF _COMPACT

.DJOY

 JSR TT17X              \ Call TT17X to read the digital joystick and return
                        \ deltas as appropriate

 JMP TJ1                \ Jump to TJ1 in the TT17 routine to check for cursor
                        \ key presses and return the combined deltas for the
                        \ digital joystick and cursor keys, returning from the
                        \ subroutine using a tail call

ENDIF

