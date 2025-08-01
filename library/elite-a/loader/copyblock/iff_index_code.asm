
\ ******************************************************************************
\
\       Name: iff_index_code
\       Type: Subroutine
\   Category: Dashboard
\    Summary: The iff_index routine, bundled up in the loader so it can be moved
\             to &0D7A to be run
\
\ ******************************************************************************

.iff_index_code

 ORG &0D7A              \ Set the assembly address to &0D7A

INCLUDE "library/elite-a/loader/subroutine/iff_index.asm"

 COPYBLOCK iff_index, P%, iff_index_code

 ORG iff_index_code + P% - iff_index

