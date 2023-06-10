\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: Keyboard
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\    Summary: Display a rotating ship at space coordinates (0, 112, 256) and
ELIF _MASTER_VERSION
\    Summary: Display a rotating ship at space coordinates (0, 120, 256) and
ENDIF
\             scan the keyboard
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
ELIF _MASTER_VERSION
\   X                   If a key is being pressed, X contains the ASCII code of
\                       the key being pressed, otherwise it contains 0
ENDIF
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.PAS1

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the Master version, the rotating Constrictor in the mission 1 briefing is slightly higher up the screen than in the other versions

 LDA #112               \ Set y_lo = 112
 STA INWK+3

ELIF _MASTER_VERSION

 LDA #120               \ Set y_lo = 120
 STA INWK+3

ENDIF

 LDA #0                 \ Set x_lo = 0
 STA INWK

 STA INWK+6             \ Set z_lo = 0

 LDA #2                 \ Set z_hi = 1, so (z_hi z_lo) = 256
 STA INWK+7

 JSR LL9                \ Draw the ship on screen

 JSR MVEIT              \ Call MVEIT to move and rotate the ship in space

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JMP RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press),
                        \ returning from the subroutine using a tail call

ELIF _MASTER_VERSION

 JMP RDKEY              \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press), returning from the subroutine using a tail
                        \ call

ENDIF

