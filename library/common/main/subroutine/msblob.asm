\ ******************************************************************************
\
\       Name: msblob
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Display the dashboard's missile indicators in green
\
\ ------------------------------------------------------------------------------
\
\ Display the dashboard's missile indicators, with all the missiles reset to
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ green/cyan (i.e. not armed or locked).
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ green (i.e. not armed or locked).
ENDIF
\
\ ******************************************************************************

.msblob

 LDX #4                 \ Set up a loop counter in X to count through all four
                        \ missile indicators

.ss

 CPX NOMSL              \ If the counter is equal to the number of missiles,
 BEQ SAL8               \ jump down to SQL8 to draw remaining the missiles, as
                        \ the rest of them are present and should be drawn in
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
                        \ green/cyan
ELIF _6502SP_VERSION OR _MASTER_VERSION
                        \ green
ENDIF

 LDY #0                 \ Draw the missile indicator at position X in black
 JSR MSBAR

 DEX                    \ Decrement the counter to point to the next missile

 BNE ss                 \ Loop back to ss if we still have missiles to draw

 RTS                    \ Return from the subroutine

.SAL8

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 LDY #&EE               \ Draw the missile indicator at position X in green/cyan
 JSR MSBAR

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #GREEN2            \ Draw the missile indicator at position X in green
 JSR MSBAR

ENDIF

 DEX                    \ Decrement the counter to point to the next missile

 BNE SAL8               \ Loop back to SAL8 if we still have missiles to draw

 RTS                    \ Return from the subroutine

