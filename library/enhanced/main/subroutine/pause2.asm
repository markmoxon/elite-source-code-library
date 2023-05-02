\ ******************************************************************************
\
\       Name: PAUSE2
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Wait until a key is pressed, ignoring any existing key press
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\   X                   The internal key number of the key that was pressed
ELIF _MASTER_VERSION
\   X                   The ASCII code of the key that was pressed
ENDIF
\
\ ******************************************************************************

.PAUSE2

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

ELIF _MASTER_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press)

ENDIF

IF NOT(_NES_VERSION)

 BNE PAUSE2             \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to PAUSE2, until
                        \ the key is released

ELIF _NES_VERSION

 JSR CF186_BANK6         \ ???

ENDIF

IF _ELITE_A_ENCYCLOPEDIA

.l_out

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ internal key number in X (or 0 for no key press)

ELIF _MASTER_VERSION

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press)

ELIF _NES_VERSION

.loop_CB3C4

 JSR CHECK_DASHBOARD_A  \ ???
 LDA L04B2
 ORA L04B4
 AND #&C0
 CMP #&40
 BNE loop_CB3C4

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)

 BEQ PAUSE2             \ Keep looping up to PAUSE2 until a key is pressed

ELIF _ELITE_A_ENCYCLOPEDIA

 BEQ l_out              \ Keep looping up to l_out until a key is pressed

ENDIF

IF _MASTER_VERSION \ Label

.newyearseve

ENDIF

 RTS                    \ Return from the subroutine

