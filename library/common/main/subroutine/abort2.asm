\ ******************************************************************************
\
\       Name: ABORT2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Set/unset the lock target for a missile and update the dashboard
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Set the lock target for the leftmost missile and update the dashboard.
ELIF _NES_VERSION
\ Set the lock target for the active missile and update the dashboard.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The slot number of the ship to lock our missile onto, or
\                       &FF to remove missile lock
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
ELIF _ELECTRON_VERSION
\   Y                   The new shape of the missile indicator:
\
\                         * &04 = black (no missile)
\
\                         * &11 = black "T" in white square (armed and locked)
\
\                         * &0D = black box in white square (armed)
\
\                         * &09 = white square (disarmed)
ELIF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * #RED2 = red (armed and locked)
\
\                         * #YELLOW2 = yellow/white (armed)
\
\                         * #GREEN2 = green (disarmed)
ELIF _APPLE_VERSION
\   Y                   The new colour of the missile indicator:
\
\                         * #BLACK = black (no missile)
\
\                         * #RED = red (armed and locked)
\
\                         * #YELLOW = yellow (armed)
\
\                         * #GREEN = green (disarmed)
ELIF _NES_VERSION
\   Y                   The pattern number for the new missile indicator:
\
\                         * 133 = no missile indicator
\
\                         * 109 = red (armed and locked)
\
\                         * 108 = black (disarmed)
\
\                       The armed missile flashes black and red, so the tile is
\                       swapped between 108 and 109 in the main loop
ENDIF
\
\ ******************************************************************************

.ABORT2

 STX MSTG               \ Store the target of our missile lock in MSTG

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 LDX NOMSL              \ Call MSBAR to update the leftmost indicator in the
 JSR MSBAR              \ dashboard's missile bar, which returns with Y = 0

ELIF _NES_VERSION

 LDX NOMSL              \ Call MSBAR to update the active indicator in the
 JSR MSBAR              \ dashboard's missile bar, which returns with Y = 0

ELIF _ELITE_A_FLIGHT

 LDX NOMSL              \ Call MSBAR to update the leftmost indicator in the
 DEX                    \ dashboard's missile bar, by calling with X = NOMSL - 1
 JSR MSBAR              \ (as the missile indicators are numbered 0-3 in Elite-A
                        \ rather than the 1-4 in the disc version)
                        \
                        \ MSBAR returns with Y = 0

ELIF _ELITE_A_6502SP_PARA

 LDX NOMSL              \ Call MSBAR (via MSBARS) to update the leftmost
 DEX                    \ indicator in the dashboard's missile bar, by calling
 JSR MSBARS             \ with X = NOMSL - 1 (as the missile indicators are
                        \ numbered 0-3 in Elite-A rather than the 1-4 in the
                        \ disc version)
                        \
                        \ MSBARS returns with Y = 0

ENDIF

IF NOT(_NES_VERSION)

 STY MSAR               \ Set MSAR = 0 to indicate that the leftmost missile
                        \ is no longer seeking a target lock

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

 JMP UpdateIconBar_b3   \ Update the icon bar so the missile button shows the
                        \ correct available option for the active missile,
                        \ returning from the subroutine using a tail call

ENDIF

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Minor

.msbpars

 EQUB 4, 0, 0, 0, 0     \ These bytes appear to be unused (they are left over
                        \ from the 6502 Second Processor version of Elite)

ENDIF

