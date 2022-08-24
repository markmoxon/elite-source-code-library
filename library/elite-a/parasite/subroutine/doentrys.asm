\ ******************************************************************************
\
\       Name: DOENTRYS
\       Type: Subroutine
\   Category: Loader
\    Summary: Dock at the space station, show the ship hangar and work out any
\             mission progression
\
\ ******************************************************************************

.DOENTRYS

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP DOENTRY            \ Jump to DOENTRY to dock at the space station

