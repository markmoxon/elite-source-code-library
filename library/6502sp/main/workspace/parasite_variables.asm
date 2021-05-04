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

.JUMP

 SKIP 1                 \ Infinite jump range configuration setting
                        \
                        \   * 0 = maximum jump range is the standard 7 light
                        \         years (default)
                        \
                        \   * Non-zero = jump range is infinite
                        \
                        \ Toggled by pressing "@" when paused, see the DK4
                        \ routine for details
                        \
                        \ Not only is the jump range infinite, but you don't use
                        \ any fuel when jumping, either

.SPEAK

 SKIP 1                 \ Speech configuration setting
                        \
                        \   * 0 = speech is disabled (default)
                        \
                        \   * Non-zero = speech is enabled
                        \
                        \ Toggled by pressing ":" when paused, see the DK4
                        \ routine for details
                        \
                        \ For speech to work, the BBC must be fitted with a
                        \ Watford Electronics Beeb Speech Synthesiser

ENDIF

ENDIF

INCLUDE "library/enhanced/main/variable/bstk.asm"
INCLUDE "library/6502sp/main/variable/catf.asm"
INCLUDE "library/6502sp/main/variable/zip.asm"

