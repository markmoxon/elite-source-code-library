\ ******************************************************************************
\
\       Name: CATDcode
\       Type: Subroutine
\   Category: Save and load
\    Summary: The CATD routine, bundled up in the loader so it can be moved to
\             &0D7A to be run
\
\ ******************************************************************************

.CATDcode

 ORG &0D7A              \ Set the assembly address to &0D7A

INCLUDE "library/disc/loader3/subroutine/catd.asm"

 COPYBLOCK CATD, P%, CATDcode

 ORG CATDcode + P% - CATD

