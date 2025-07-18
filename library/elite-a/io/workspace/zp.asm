\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &008B to &009F
\   Category: Workspaces
\    Summary: Important variables used by the I/O processor
\
\ ******************************************************************************

 ORG &008B              \ Set the assembly address to &008B

INCLUDE "library/common/main/variable/dl.asm"

 ORG &0090              \ Set the assembly address to &0090

INCLUDE "library/elite-a/loader/variable/key_tube.asm"
INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"

.font
.ZZ
.bar_1
.angle_1
.missle_1
.picture_1
.print_bits
INCLUDE "library/common/main/variable/x1.asm"

.bar_2
.picture_2
INCLUDE "library/common/main/variable/y1.asm"

.bar_3
.K3
.COL
INCLUDE "library/common/main/variable/x2.asm"

.XSAV2
INCLUDE "library/common/main/variable/y2.asm"

.YSAV2
INCLUDE "library/common/loader/variable/p.asm"

.T
INCLUDE "library/common/main/variable/q.asm"

INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/s.asm"
INCLUDE "library/common/main/variable/swap.asm"

 SKIP 1

INCLUDE "library/common/main/variable/xc.asm"
INCLUDE "library/common/main/variable/yc.asm"

