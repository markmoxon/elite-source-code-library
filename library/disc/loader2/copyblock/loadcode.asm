\ ******************************************************************************
\
\       Name: LOADcode
\       Type: Subroutine
\   Category: Copy protection
\    Summary: LOAD routine, bundled up in the loader so it can be moved to &0400
\             to be run
\
\ ******************************************************************************

.LOADcode

ORG &0400

INCLUDE "library/disc/loader2/subroutine/load.asm"

COPYBLOCK LOAD, P%, LOADcode

ORG LOADcode + P% - LOAD

