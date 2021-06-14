
\ ******************************************************************************
\
\       Name: iff_index_code
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.iff_index_code

ORG &0D7A

INCLUDE "library/elite-a/loader/subroutine/iff_index.asm"

COPYBLOCK iff_index, P%, iff_index_code

ORG iff_index_code + P% - iff_index

