\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0004 to &0005 and &0070 to &0086
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &0004

INCLUDE "library/original/main/variable/trtb_per_cent.asm"

 ORG &0070

INCLUDE "library/common/loader/variable/zp.asm"
INCLUDE "library/common/loader/variable/p.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/cassette/loader/variable/yy.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"
INCLUDE "library/cassette/loader/variable/blptr.asm"
INCLUDE "library/cassette/loader/variable/v219.asm"

 SKIP 4                 \ These bytes appear to be unused

INCLUDE "library/common/loader/variable/k3.asm"
INCLUDE "library/cassette/loader/variable/blcnt.asm"
INCLUDE "library/cassette/loader/variable/bln.asm"
INCLUDE "library/cassette/loader/variable/excn.asm"

