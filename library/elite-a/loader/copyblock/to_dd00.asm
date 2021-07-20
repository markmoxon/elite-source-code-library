
\ ******************************************************************************
\
\       Name: to_dd00
\       Type: Subroutine
\   Category: Loader
\    Summary: BBC Master code for saving and restoring the MOS character set,
\             bundled up in the loader so it can be moved to &DD00 to be run
\
\ ******************************************************************************

CPU 1

.to_dd00

ORG &DD00

INCLUDE "library/elite-a/loader/subroutine/do_filev.asm"
INCLUDE "library/elite-a/loader/subroutine/savews.asm"
INCLUDE "library/elite-a/loader/subroutine/do_fscv.asm"
INCLUDE "library/elite-a/loader/subroutine/restorews.asm"
INCLUDE "library/elite-a/loader/subroutine/do_bytev.asm"
INCLUDE "library/elite-a/loader/subroutine/set_vectors.asm"
INCLUDE "library/elite-a/loader/subroutine/old_bytev.asm"

dd00_len = P% - do_FILEV

COPYBLOCK do_FILEV, P%, to_dd00

ORG to_dd00 + P% - do_FILEV

