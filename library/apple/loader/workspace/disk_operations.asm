\ ******************************************************************************
\
\       Name: Disk operations workspace 1
\       Type: Workspace
\    Address: &0300 to &0310
\   Category: Workspaces
\    Summary: Variables used by the disk operations and DOS 3.3 RWTS routines
\
\ ******************************************************************************

 ORG &0300              \ Set the assembly address to &0300

INCLUDE "library/apple/main/variable/track.asm"
INCLUDE "library/apple/main/variable/sector.asm"
INCLUDE "library/apple/main/variable/curtrk.asm"
INCLUDE "library/apple/main/variable/tsltrk.asm"
INCLUDE "library/apple/main/variable/tslsct.asm"
INCLUDE "library/apple/main/variable/filtrk.asm"
INCLUDE "library/apple/main/variable/filsct.asm"
INCLUDE "library/apple/main/variable/mtimel.asm"
INCLUDE "library/apple/main/variable/mtimeh.asm"
INCLUDE "library/apple/main/variable/seeks.asm"
INCLUDE "library/apple/main/variable/recals.asm"
INCLUDE "library/apple/main/variable/slot16.asm"
INCLUDE "library/apple/main/variable/atemp0.asm"
INCLUDE "library/apple/main/variable/idfld.asm"

 PRINT "Disk operations workspace 1 from ", ~track, "to ", ~P%-1, "inclusive"

\ ******************************************************************************
\
\       Name: Disk operations workspace 2
\       Type: Workspace
\    Address: &25D6 to &287B
\   Category: Workspaces
\    Summary: Variables used by the disk operations and DOS 3.3 RWTS routines
\
\ ******************************************************************************

 ORG &25D6              \ Set the assembly address to &25D6

INCLUDE "library/apple/main/variable/buffer.asm"
INCLUDE "library/apple/main/variable/fretrk.asm"
INCLUDE "library/apple/main/variable/dirtrk.asm"
INCLUDE "library/apple/main/variable/tracks.asm"

 SKIP 3                 \ Padding to ensure the bitmap variable lines up with
                        \ byte #56 (&38) for the bitmap of free sectors

INCLUDE "library/apple/main/variable/bitmap.asm"

 SKIP 72                \ These bytes appear to be unused

INCLUDE "library/apple/main/variable/buffr2.asm"

 PRINT "Disk operations workspace 2 from ", ~buffer, "to ", ~P%-1, "inclusive"
