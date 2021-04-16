\ ******************************************************************************
\
\       Name: BELL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a standard system beep
\
\ ------------------------------------------------------------------------------
\
\ This is the standard system beep as made by the VDU 7 statement in BBC BASIC.
\
\ ******************************************************************************

.BELL

 LDA #7                 \ Control code 7 makes a beep, so load this into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment

                        \ Fall through into the TT26 print routine to
                        \ actually make the sound

ELIF _6502SP_VERSION

                        \ Fall through into the CHPR print routine to
                        \ actually make the sound

ELIF _MASTER_VERSION

 JMP CHPR               \ Call the CHPR print routine to actually make the sound

ENDIF

