\ ******************************************************************************
\
\       Name: BELL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a standard system beep
IF _APPLE_VERSION
\  Deep dive: Sound effects in Apple II Elite
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This is the standard system beep, as made by the ASCII 7 "BELL" control code.
\
\ ******************************************************************************

.BELL

 LDA #7                 \ Control code 7 makes a beep, so load this into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ 6502SP: If speech is enabled in the Executive version, only the BELL routine makes a standard system beep (the CHPR routine no longer does)

                        \ Fall through into the TT26 print routine to
                        \ actually make the sound

ELIF _6502SP_VERSION

                        \ Fall through into the CHPR print routine to
                        \ actually make the sound

IF _EXECUTIVE

 BNE CHPRD              \ Jump down to CHPRD to actually make the sound,
                        \ skipping the code that prevents CHPR from beeping if
                        \ speech is enabled, so the beep gets made even if
                        \ speech is enabled (this BNE is effectively a JMP as
                        \ A is never 0)

ENDIF

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 JMP CHPR               \ Call the CHPR print routine to actually make the sound

ENDIF

