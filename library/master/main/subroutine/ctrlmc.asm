\ ******************************************************************************
\
\       Name: CTRLmc
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the Master Compact keyboard to see if CTRL is currently
\             pressed
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

.CTRLmc

IF _COMPACT

 LDA #1                 \ Set A to the internal key number for CTRL and fall
                        \ through to DKS4mc to scan the keyboard

ENDIF

