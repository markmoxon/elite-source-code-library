\ ******************************************************************************
\
\       Name: LP
\       Type: Workspace
\    Address: &8600 to &91FF
\   Category: Workspaces
\    Summary: Variables used for displaying the scrolling text in the demo
\
\ ******************************************************************************

IF _SNG45 OR _SOURCE_DISC

ORG &8600

ELIF _EXECUTIVE

ORG &8900

ENDIF

.LP

 SKIP 0                 \ The start of the LP workspace

INCLUDE "library/6502sp/main/variable/x1tb.asm"
INCLUDE "library/6502sp/main/variable/y1tb.asm"
INCLUDE "library/6502sp/main/variable/x2tb.asm"
INCLUDE "library/6502sp/main/variable/y2tb.asm"
INCLUDE "library/6502sp/main/variable/x1ub.asm"
INCLUDE "library/6502sp/main/variable/y1ub.asm"
INCLUDE "library/6502sp/main/variable/x2ub.asm"
INCLUDE "library/6502sp/main/variable/y2ub.asm"
INCLUDE "library/6502sp/main/variable/x1vb.asm"
INCLUDE "library/6502sp/main/variable/y1vb.asm"
INCLUDE "library/6502sp/main/variable/x2vb.asm"
INCLUDE "library/6502sp/main/variable/y2vb.asm"
