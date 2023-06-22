\ ******************************************************************************
\
\       Name: msblob
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Display the dashboard's missile indicators in green
ELIF _ELECTRON_VERSION
\    Summary: Display the dashboard's missile indicators as white squares
ELIF _NES_VERSION
\    Summary: Display the dashboard's missile indicators in black
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Display the dashboard's missile indicators, with all the missiles reset to
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ green/cyan (i.e. not armed or locked).
ELIF _ELECTRON_VERSION
\ white squares (i.e. not armed or locked).
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ green (i.e. not armed or locked).
ELIF _NES_VERSION
\ black (i.e. not armed or locked).
ENDIF
\
IF _ELITE_A_VERSION
\ Returns:
\
\   X                   X is set to &FF
\
\   Y                   Y is set to 0
\
ENDIF
\ ******************************************************************************

.msblob

IF NOT(_ELITE_A_VERSION)

 LDX #4                 \ Set up a loop counter in X to count through all four
                        \ missile indicators

ELIF _ELITE_A_VERSION

 LDX #3                 \ Set up a loop counter in X to count through all four
                        \ missile indicators (in Elite-A the missile indicators
                        \ are numbered 0-3 rather than 1-4)

ENDIF

.ss

IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SAL8 to draw the remaining missiles, as
                        \ the rest of them are present and should be drawn in
                        \ green/cyan

ELIF _ELECTRON_VERSION

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SAL8 to draw the remaining missiles, as
                        \ the rest of them are present and should be drawn as
                        \ white squares

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SAL8 to draw the remaining missiles, as
                        \ the rest of them are present and should be drawn in
                        \ green

ELIF _ELITE_A_VERSION

 LDY #0                 \ If X >= NOMSL, then jump down to miss_miss with Y = 0
 CPX NOMSL              \ to draw the missile indicator at position X in black
 BCS miss_miss

ELIF _NES_VERSION

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SAL8 to draw the remaining missiles, as
                        \ the rest of them are present and should be drawn in
                        \ black

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDY #0                 \ Draw the missile indicator at position X in black
 JSR MSBAR

ELIF _ELECTRON_VERSION

 LDY #&04               \ Draw the missile indicator at position X in black
 JSR MSBAR

ELIF _NES_VERSION

 LDY #&85               \ Draw the missile indicator at position X as an empty
 JSR MSBAR              \ slot ???

ENDIF

IF NOT(_ELITE_A_VERSION)

 DEX                    \ Decrement the counter to point to the next missile

 BNE ss                 \ Loop back to ss if we still have missiles to draw

 RTS                    \ Return from the subroutine

.SAL8

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 LDY #&EE               \ Draw the missile indicator at position X in green/cyan
 JSR MSBAR

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #GREEN2            \ Draw the missile indicator at position X in green
 JSR MSBAR

ELIF _ELECTRON_VERSION

 LDY #&09               \ Draw the missile indicator at position X as a white
 JSR MSBAR              \ square

ELIF _NES_VERSION

 LDY #&6C               \ Draw the missile indicator at position X in black ???
 JSR MSBAR

ELIF _ELITE_A_VERSION

 LDY #&EE               \ Set the colour of the missile indicator to green/cyan

.miss_miss

 JSR MSBAR              \ Draw the missile indicator at position X in colour Y,
                        \ and return with Y = 0

ENDIF

IF NOT(_ELITE_A_VERSION)

 DEX                    \ Decrement the counter to point to the next missile

 BNE SAL8               \ Loop back to SAL8 if we still have missiles to draw

ELIF _ELITE_A_VERSION

 DEX                    \ Decrement the counter to point to the next missile

 BPL ss                 \ Loop back to ss if we still have missiles to draw,
                        \ ending when X = &FF

ENDIF

 RTS                    \ Return from the subroutine

