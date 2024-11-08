\ ******************************************************************************
\
\       Name: Parasite variables
\       Type: Workspace
\    Address: &1000 to &100B (&1000 to &100D in the Executive version)
\   Category: Workspaces
\    Summary: Various variables used by the parasite
\
\ ******************************************************************************

INCLUDE "library/6502sp/main/variable/mos.asm"
INCLUDE "library/common/main/variable/comc.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/djd.asm"
INCLUDE "library/common/main/variable/patg.asm"
INCLUDE "library/common/main/variable/flh.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/jste.asm"
INCLUDE "library/common/main/variable/jstk.asm"

IF _6502SP_VERSION \ 6502SP: The Executive version has two extra variables for storing the new configuration options

IF _EXECUTIVE

INCLUDE "library/6502sp/main/variable/jump.asm"
INCLUDE "library/6502sp/main/variable/speak.asm"

ENDIF

ENDIF

INCLUDE "library/enhanced/main/variable/bstk.asm"
INCLUDE "library/6502sp/main/variable/catf.asm"
INCLUDE "library/6502sp/main/variable/zip.asm"

 PRINT "Parasite variables workspace (6502sp parasite) from ", ~MOS, "to ", ~P%-1, "inclusive"

