\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0070 to &008B
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

ORG &0004

INCLUDE "library/elite-a/loader/variable/key_io.asm"

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

ORG &0090

INCLUDE "library/elite-a/loader/variable/key_tube.asm"
