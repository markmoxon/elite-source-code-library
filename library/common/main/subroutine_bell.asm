\ ******************************************************************************
\
\       Name: BELL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a beep sound
\
\ ------------------------------------------------------------------------------
\
\ This is the standard system beep as made by VDU 7.
\
\ ******************************************************************************

.BELL

 LDA #7                 \ Control code 7 makes a beep, so load this into A so
                        \ we can fall through into the TT27 print routine to
                        \ actually make the sound

