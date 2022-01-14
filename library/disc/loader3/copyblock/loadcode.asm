\ ******************************************************************************
\
\       Name: LOADcode
\       Type: Subroutine
\   Category: Loader
\    Summary: Encrypted LOAD routine, bundled up in the loader so it can be
\             moved to &0B00 to be run
\
IF NOT(_ELITE_A_VERSION)
\ ------------------------------------------------------------------------------
\
\ This section is encrypted by EOR'ing with &18. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as it is moved to &0B00.
\
ENDIF
\ ******************************************************************************

.LOADcode

ORG &0B00

INCLUDE "library/disc/loader3/subroutine/load.asm"

COPYBLOCK LOAD, P%, LOADcode

ORG LOADcode + P% - LOAD

