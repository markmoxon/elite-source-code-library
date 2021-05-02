\ ******************************************************************************
\
\       Name: Parasite variables
\       Type: Workspace
\    Address: &1000 to &100B (&1000 to &100D in Executive version)
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

IF _EXECUTIVE

 SKIP 1                 \ ???

.SPEAK

 SKIP 1                 \ Speech on/off configuration setting
                        \
                        \   * 0 = speech is off (default)
                        \
                        \   * Non-zero = speech is on
                        \
                        \ Toggled by pressing ":" when paused, see the DK4
                        \ routine for details
                        \
                        \ For speech to work, the BBC must be fitted with a
                        \ Watford Electronics Speech Synthesizer

ENDIF

INCLUDE "library/enhanced/main/variable/bstk.asm"
INCLUDE "library/6502sp/main/variable/catf.asm"
INCLUDE "library/6502sp/main/variable/zip.asm"

