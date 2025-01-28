\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &00F0 to &00F7
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &00F0

INCLUDE "library/apple/loader/variable/ztemp0.asm"
INCLUDE "library/apple/loader/variable/ztemp1.asm"
INCLUDE "library/apple/loader/variable/ztemp2.asm"
INCLUDE "library/apple/loader/variable/ztemp3.asm"
INCLUDE "library/apple/loader/variable/fromaddr.asm"
INCLUDE "library/apple/loader/variable/toaddr.asm"

