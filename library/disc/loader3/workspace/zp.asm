\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0070 to &008B
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

IF _SRAM_DISC

 ORG &0004

.TRTB%

 SKIP 2                 \ Contains the address of the keyboard translation
                        \ table, which is used to translate internal key
                        \ numbers to ASCII

ENDIF

 ORG &0070

INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/common/loader/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/cassette/loader/variable/yy.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"
INCLUDE "library/disc/loader3/variable/chksm.asm"

 ORG &008B

INCLUDE "library/common/main/variable/dl.asm"

