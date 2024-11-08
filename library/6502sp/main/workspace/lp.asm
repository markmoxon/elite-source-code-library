\ ******************************************************************************
\
\       Name: LP
\       Type: Workspace
\    Address: &8600 to &91FF (&8900 to &94FF in the Executive version)
\   Category: Workspaces
\    Summary: Variables used for displaying the scrolling text in the demo
\
\ ******************************************************************************

IF _6502SP_VERSION \ 6502SP: The Executive version has a different memory map to the other 6502SP versions, with the LP workspace at &8900 instead of &8600

IF _SNG45 OR _SOURCE_DISC

 ORG &8600

ELIF _EXECUTIVE

 ORG &8900

ENDIF

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

 PRINT "LP workspace (6502sp parasite) from ", ~LP, "to ", ~P%-1, "inclusive"

