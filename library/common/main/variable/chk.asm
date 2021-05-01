\ ******************************************************************************
\
\       Name: CHK
\       Type: Variable
\   Category: Save and load
\    Summary: First checksum byte for the saved commander data file
\  Deep dive: Commander save files
\             The competition code
\
\ ------------------------------------------------------------------------------
\
\ Commander checksum byte. If the default commander is changed, a new checksum
\ will be calculated and inserted by the elite-checksum.py script.
\
\ The offset of this byte within a saved commander file is also shown (it's at
\ byte #75).
\
\ ******************************************************************************

.CHK

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Platform

 EQUB &03               \ The checksum value for the default commander, #75

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 EQUB &03               \ The checksum value for the default commander, #75

ELIF _EXECUTIVE

 EQUB &3F               \ The checksum value for the max default commander, #75

ENDIF

ELIF _MASTER_VERSION

 EQUB 0

ENDIF

