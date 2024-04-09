\ ******************************************************************************
\
\       Name: romHeader
\       Type: Variable
\   Category: Loader
\    Summary: The ROM header code that gets copied to &8000 to create a sideways
\             RAM image containing the ship blueprint files
\
\ ******************************************************************************

.romHeader

 CLEAR &7C00, &7C00     \ Clear the guard we set above so we can assemble into
                        \ the sideways ROM part of memory

 ORG &8000              \ Set the assembly address for sideways RAM

INCLUDE "library/disc/loader-sideways-ram/variable/rom.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/filehandler.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/filenamepattern.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/coriolisstation.asm"

 COPYBLOCK ROM, P%, romHeader

 ORG romHeader + P% - ROM

