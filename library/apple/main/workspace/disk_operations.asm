\ ******************************************************************************
\
\       Name: Disk operations workspace
\       Type: Workspace
\    Address: &0800 to &0A6F
\   Category: Workspaces
\    Summary: Variables used by the disk operations and DOS 3.3 RWTS routines
\
\ ******************************************************************************

 ORG &0800              \ Set the assembly address to &0800

 CLEAR &0800, &0A6E     \ The disk operations workspace shares memory with the
                        \ ship data blocks at K%, so we need to clear this block
                        \ of memory to prevent BeebAsm from complaining

INCLUDE "library/apple/main/variable/buffer.asm"
INCLUDE "library/apple/main/variable/fretrk.asm"
INCLUDE "library/apple/main/variable/dirtrk.asm"
INCLUDE "library/apple/main/variable/tracks.asm"

 SKIP 3                 \ Padding to ensure the bitmap variable lines up with
                        \ byte #56 (&38) for the bitmap of free sectors

INCLUDE "library/apple/main/variable/bitmap.asm"
INCLUDE "library/apple/main/variable/buffr2.asm"
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
INCLUDE "library/apple/main/variable/stkptr.asm"
INCLUDE "library/apple/main/variable/idfld.asm"

 PRINT "Disk operations workspace from ", ~buffer, "to ", ~P%-1, "inclusive"

