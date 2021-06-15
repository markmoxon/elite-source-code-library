\ ******************************************************************************
\
\       Name: TVT1code
\       Type: Subroutine
\   Category: Loader
\    Summary: Code block at &1100-&11E2 that remains resident in both docked and
\             flight mode (palettes, screen mode routine and commander data)
\
IF NOT(_ELITE_A_VERSION)
\ ------------------------------------------------------------------------------
\
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as it is moved to &1000.
\
ENDIF
\ ******************************************************************************

.TVT1code

ORG &1100

INCLUDE "library/original/main/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/enhanced/main/variable/s1_per_cent.asm"
INCLUDE "library/common/main/variable/na_per_cent-default_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"
INCLUDE "library/disc/loader3/subroutine/brbr1.asm"

IF NOT(_ELITE_A_VERSION)

 EQUB &64, &5F, &61     \ These bytes appear to be unused
 EQUB &74, &74, &72
 EQUB &69, &62, &75
 EQUB &74, &65, &73
 EQUB &00, &C4, &24
 EQUB &6A, &43, &67
 EQUB &65, &74, &72
 EQUB &64, &69, &73
 EQUB &63, &00, &B6
 EQUB &3C, &C6

ENDIF

COPYBLOCK TVT1, P%, TVT1code

ORG TVT1code + P% - TVT1

