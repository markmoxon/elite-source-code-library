\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0070 to &0075
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &0002

INCLUDE "library/master/loader/variable/mos.asm"

 ORG &0070

INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/common/loader/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/cassette/loader/variable/yy.asm"
INCLUDE "library/common/main/variable/t.asm"

 ORG &00F4

INCLUDE "library/master/main/variable/latch.asm"

