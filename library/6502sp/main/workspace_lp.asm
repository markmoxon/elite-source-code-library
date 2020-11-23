\ ******************************************************************************
\
\       Name: LP
\       Type: Workspace
\    Address: &8600
\   Category: Workspaces
\
\ ******************************************************************************

ORG &8600

.LP

 SKIP 0                 \ The start of the LP workspace

INCLUDE "library/6502sp/main/variable_x1tb.asm"
INCLUDE "library/6502sp/main/variable_y1tb.asm"
INCLUDE "library/6502sp/main/variable_x2tb.asm"
INCLUDE "library/6502sp/main/variable_y2tb.asm"
INCLUDE "library/6502sp/main/variable_x1ub.asm"
INCLUDE "library/6502sp/main/variable_y1ub.asm"
INCLUDE "library/6502sp/main/variable_x2ub.asm"
INCLUDE "library/6502sp/main/variable_y2ub.asm"
INCLUDE "library/6502sp/main/variable_x1vb.asm"
INCLUDE "library/6502sp/main/variable_y1vb.asm"
INCLUDE "library/6502sp/main/variable_x2vb.asm"
INCLUDE "library/6502sp/main/variable_y2vb.asm"
