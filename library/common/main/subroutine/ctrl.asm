\ ******************************************************************************
\
\       Name: CTRL
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard to see if CTRL is currently pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X = %10000001 (i.e. 129 or -127) if CTRL is being
\                       pressed
\
\                       X = 1 if CTRL is not being pressed
\
\   A                   Contains the same as X
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

.CTRL

 LDX #1                 \ Set X to the internal key number for CTRL and fall
                        \ through to DKS4 to scan the keyboard

ELIF _MASTER_VERSION

IF _SNG47

.CTRL

 LDA #1                 \ Set A to the internal key number for CTRL and fall
                        \ through to DKS5 to scan the keyboard

ENDIF

ENDIF

