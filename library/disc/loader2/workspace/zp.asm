\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0004 to &0005 and &0070 to &0082
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

ORG &0004

INCLUDE "library/original/loader/variable/trtb_per_cent.asm"

ORG &0070

INCLUDE "library/common/main/variable/s.asm"
INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/common/loader/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/t.asm"

ORG &0081

INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"

