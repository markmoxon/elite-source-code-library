\ ******************************************************************************
\
\       Name: CHK2
\       Type: Variable
\   Category: Save and load
\    Summary: Second checksum byte for the saved commander data file
\  Deep dive: Commander save files
\             The competition code
\
\ ------------------------------------------------------------------------------
\
\ Second commander checksum byte. If the default commander is changed, a new
\ checksum will be calculated and inserted by the elite-checksum.py script.
\
\ The offset of this byte within a saved commander file is also shown (it's at
\ byte #74).
\
\ ******************************************************************************

.CHK2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ 6502SP: The Executive version contains a maxed-out default commander, which has a different second checksum byte

 EQUB &03 EOR &A9       \ The checksum value for the default commander, EOR'd
                        \ with &A9 to make it harder to tamper with the checksum
                        \ byte, #74

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 EQUB &03 EOR &A9       \ The checksum value for the default commander, EOR'd
                        \ with &A9 to make it harder to tamper with the checksum
                        \ byte, #74

ELIF _EXECUTIVE

 EQUB &3F EOR &A9       \ The checksum value for the maxed-out default
                        \ commander, EOR'd with &A9 to make it harder to tamper
                        \ with the checksum byte, #74

ENDIF

ELIF _MASTER_VERSION

 EQUB 0

ENDIF

