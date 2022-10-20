\ ******************************************************************************
\
\       Name: CTLI
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for cataloguing a disc
\
\ ******************************************************************************

.CTLI

IF _DISC_DOCKED OR _6502SP_VERSION \ Minor

 EQUS ".0"              \ The "0" part of the string is overwritten with the
 EQUB 13                \ actual drive number by the CATS routine

ELIF _MASTER_VERSION

IF _SNG47

 EQUS "CAT 1"           \ The "1" part of the string is overwritten with the
 EQUB 13                \ actual drive number by the CATS routine

ELIF _COMPACT

 EQUS "CAT"             \ The Master Compact only has one drive, so the CAT
 EQUB 13                \ command always catalogues that drive

ENDIF

ELIF _ELITE_A_VERSION

 EQUS ".:0"             \ The "0" part of the string is overwritten with the
 EQUB 13                \ actual drive number by the CATS routine

ENDIF

