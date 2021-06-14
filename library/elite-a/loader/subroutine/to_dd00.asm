
\ ******************************************************************************
\
\       Name: to_dd00
\       Type: Subroutine
\   Category: Loader
\    Summary: BBC Master 128 code for save/restore characters
\
\ ******************************************************************************

CPU 1

.to_dd00

ORG &DD00

INCLUDE "library/elite-a/loader/subroutine/do_filev.asm"
INCLUDE "library/elite-a/loader/subroutine/do_fscv.asm"
INCLUDE "library/elite-a/loader/subroutine/do_bytev.asm"

dd00_len = P% - do_FILEV

COPYBLOCK do_FILEV, P%, to_dd00

ORG to_dd00 + P% - do_FILEV

