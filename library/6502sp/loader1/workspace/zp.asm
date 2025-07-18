\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0090 to &0095
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &0090              \ Set the assembly address to &0090

INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/common/loader/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/cassette/loader/variable/yy.asm"
INCLUDE "library/common/main/variable/t.asm"

