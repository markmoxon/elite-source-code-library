\ ******************************************************************************
\
\       Name: Sound variables
\       Type: Workspace
IF _MASTER_VERSION
\    Address: &144D to &1491
ELIF _C64_VERSION
\    Address: &AA13 to &1461
ENDIF
\   Category: Sound
\    Summary: The sound buffer where the data to be sent to the sound chip is
\             processed
IF _C64_VERSION
\  Deep dive: Sound effects in Commodore 64 Elite
ENDIF
\
\ ******************************************************************************

IF _MASTER_VERSION

INCLUDE "library/advanced/main/variable/soflg.asm"
INCLUDE "library/advanced/main/variable/socnt.asm"
INCLUDE "library/advanced/main/variable/sovol.asm"
INCLUDE "library/advanced/main/variable/sovch.asm"
INCLUDE "library/advanced/main/variable/sopr.asm"
INCLUDE "library/advanced/main/variable/sofrch.asm"
INCLUDE "library/advanced/main/variable/sofrq.asm"

ELIF _C64_VERSION

INCLUDE "library/advanced/main/variable/soflg.asm"
INCLUDE "library/advanced/main/variable/socnt.asm"
INCLUDE "library/advanced/main/variable/sopr.asm"
INCLUDE "library/c64/main/variable/pulsew.asm"
INCLUDE "library/advanced/main/variable/sofrch.asm"
INCLUDE "library/advanced/main/variable/sofrq.asm"
INCLUDE "library/c64/main/variable/socr.asm"
INCLUDE "library/c64/main/variable/soatk.asm"
INCLUDE "library/c64/main/variable/sosus.asm"
INCLUDE "library/advanced/main/variable/sovch.asm"

ENDIF

