\ ******************************************************************************
\
\       Name: Sound variables
\       Type: Workspace
\   Category: Sound
\    Summary: The sound buffer where the data to be sent to the sound chip is
\             processed
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
INCLUDE "library/c64/main/variable/sevens.asm"
INCLUDE "library/c64/main/variable/sfxpr.asm"
INCLUDE "library/c64/main/variable/sfxcnt.asm"
INCLUDE "library/c64/main/variable/sfxfq.asm"
INCLUDE "library/c64/main/variable/sfxcr.asm"
INCLUDE "library/c64/main/variable/sfxatk.asm"
INCLUDE "library/c64/main/variable/sfxsus.asm"
INCLUDE "library/c64/main/variable/sfxfrch.asm"
INCLUDE "library/c64/main/variable/sfxvch.asm"

ENDIF

