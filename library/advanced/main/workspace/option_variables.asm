\ ******************************************************************************
\
\       Name: Option variables
\       Type: Workspace
IF _C64_VERSION
\    Address: &1D00 to &1D13
ELIF _APPLE_VERSION
\    Address: &4543 to &4562
ENDIF
\   Category: Workspaces
\    Summary: Variables that are predominantly used to store the game options
\
\ ******************************************************************************

IF _C64_VERSION

INCLUDE "library/6502sp/main/variable/mos.asm"

ENDIF

INCLUDE "library/common/main/variable/comc.asm"

IF _C64_VERSION

INCLUDE "library/c64/main/variable/mutokold.asm"
INCLUDE "library/c64/main/variable/mupla.asm"

ELIF _APPLE_VERSION

INCLUDE "library/advanced/main/variable/dials.asm"
INCLUDE "library/advanced/main/variable/mscol.asm"

ENDIF

INCLUDE "library/advanced/main/variable/dflag.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/djd.asm"
INCLUDE "library/common/main/variable/patg.asm"
INCLUDE "library/common/main/variable/flh.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/jste.asm"
INCLUDE "library/common/main/variable/jstk.asm"

IF _C64_VERSION

INCLUDE "library/c64/main/variable/mutok.asm"

ELIF _APPLE_VERSION

INCLUDE "library/master/main/variable/uptog.asm"

ENDIF

INCLUDE "library/master/main/variable/disk.asm"

IF _C64_VERSION

INCLUDE "library/c64/main/variable/pltog.asm"
INCLUDE "library/c64/main/variable/mufor.asm"

IF _GMA_RELEASE

INCLUDE "library/c64/main/variable/muswap.asm"

ENDIF

INCLUDE "library/c64/main/variable/musilly.asm"

ENDIF

INCLUDE "library/advanced/main/variable/mulie.asm"

IF _APPLE_VERSION

IF _IB_DISK

.L4562

 EQUB &0B               \ ??? Related to joystick fire button in TITLE

ENDIF

ENDIF

