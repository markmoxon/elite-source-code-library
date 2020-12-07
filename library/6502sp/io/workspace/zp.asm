\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0080 to &0089
\   Category: Workspaces
\    Summary: Important variables used by the I/O processor
\
\ ******************************************************************************

ORG &0080

.ZP

 SKIP 0                 \ The start of the zero page workspace

INCLUDE "library/6502sp/io/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/s.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/common/main/variable/t1.asm"
INCLUDE "library/common/main/variable/col.asm"
INCLUDE "library/6502sp/io/variable/ossc.asm"
