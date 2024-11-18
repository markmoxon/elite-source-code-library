\ ******************************************************************************
\
\       Name: Sound variables
\       Type: Workspace
\   Category: Sound
\    Summary: The sound buffer where the data to be sent to the sound chip is
\             processed
\
\ ******************************************************************************

INCLUDE "library/advanced/main/variable/soflg.asm"
INCLUDE "library/advanced/main/variable/socnt.asm"

.SOVOL

 EQUB 0
 EQUB 0
 EQUB 0

INCLUDE "library/advanced/main/variable/sovch.asm"
INCLUDE "library/advanced/main/variable/sopr.asm"
INCLUDE "library/advanced/main/variable/sofrch.asm"
INCLUDE "library/advanced/main/variable/sofrq.asm"

