\ ******************************************************************************
\
\       Name: CHK2
\       Type: Variable
\   Category: Save and load
\    Summary: Second checksum byte for the saved commander data file
\
\ ------------------------------------------------------------------------------
\
\ Second checksum byte, see elite-checksum.py for more details.
\
\ ******************************************************************************

IF NOT(_FIX_REAR_LASER)
 CH% = &92              \ The correct value for the released game
ELSE
 CH% = &3               \ The figure in the ELTB binary on the source disc
ENDIF

.CHK2

 EQUB CH% EOR &A9       \ Commander checksum byte, EOR'd with &A9 to make it
                        \ harder to tamper with the checksum byte

