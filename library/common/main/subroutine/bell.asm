\ ******************************************************************************
\
\       Name: BELL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a standard system beep
\
\ ------------------------------------------------------------------------------
\
\ This is the standard system beep as made by the VDU 7 command in BBC BASIC.
\
\ ******************************************************************************

.BELL

 LDA #7                 \ Control code 7 makes a beep, so load this into A

IF _CASSETTE_VERSION

                        \ Fall through into the TT27 print routine to
                        \ actually make the sound

ELIF _6502SP_VERSION

                        \ Fall through into the CHPR print routine to
                        \ actually make the sound

ENDIF

