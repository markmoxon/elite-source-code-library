\ ******************************************************************************
\
\       Name: LOADcode
\       Type: Subroutine
\   Category: Loader
\    Summary: Encrypted LOAD routine, bundled up in the loader so it can be
\             moved to &0B00 to be run
\
\ ------------------------------------------------------------------------------
\
\ This section is encrypted by EOR'ing with &18. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as it is moved to &0B00.
\
\ ******************************************************************************

.LOADcode

ORG &0B00

INCLUDE "library/disc/loader3/subroutine/load.asm"

IF NOT(_ELITE_A_VERSION)

 EQUB &44, &6F, &65     \ These bytes appear to be unused
 EQUB &73, &20, &79
 EQUB &6F, &75, &72
 EQUB &20, &6D, &6F
 EQUB &74, &68, &65
 EQUB &72, &20, &6B
 EQUB &6E, &6F, &77
 EQUB &20, &79, &6F
 EQUB &75, &20, &64
 EQUB &6F, &20, &74
 EQUB &68, &69, &73
 EQUB &3F

ENDIF

COPYBLOCK LOAD, P%, LOADcode

ORG LOADcode + P% - LOAD

