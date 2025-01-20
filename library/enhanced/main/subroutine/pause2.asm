\ ******************************************************************************
\
\       Name: PAUSE2
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Keyboard
ELIF _NES_VERSION
\   Category: Controllers
ENDIF
\    Summary: Wait until a key is pressed, ignoring any existing key press
\
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The internal key number of the key that was pressed
\
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The ASCII code of the key that was pressed
\
ENDIF
\ ******************************************************************************

.PAUSE2

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the ASCII
                        \ code of the key pressed in A and X (or 0 for no key
                        \ press)

ENDIF

IF NOT(_NES_VERSION)

 BNE PAUSE2             \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to PAUSE2, until
                        \ the key is released

ELIF _NES_VERSION

 JSR DrawScreenInNMI_b0 \ Configure the NMI handler to draw the screen

ENDIF

IF _ELITE_A_ENCYCLOPEDIA

.l_out

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ internal key number in A and X (or 0 for no key press)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press)

ELIF _NES_VERSION

.paws1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1A       \ Keep looping back to paws1 until either the A button
 ORA controller1B       \ or the B button has been pressed and then released on
 AND #%11000000         \ controller 1
 CMP #%01000000
 BNE paws1

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)

 BEQ PAUSE2             \ Keep looping up to PAUSE2 until a key is pressed

ELIF _ELITE_A_ENCYCLOPEDIA

 BEQ l_out              \ Keep looping up to l_out until a key is pressed

ENDIF

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Label

.newyearseve

ENDIF

 RTS                    \ Return from the subroutine

