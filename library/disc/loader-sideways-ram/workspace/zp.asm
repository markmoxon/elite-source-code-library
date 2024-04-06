\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0070 to &0079
\   Category: Workspaces
\    Summary: Important variables used by the sideways RAM loader
\
\ ******************************************************************************

 ORG &0070

INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/p.asm"
INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/s.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/u.asm"
INCLUDE "library/common/main/variable/v.asm"

