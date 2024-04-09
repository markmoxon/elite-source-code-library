\ ******************************************************************************
\
\       Name: loadrom%
\       Type: Subroutine
\   Category: Loader
\    Summary: Entry point for the ROM-loading routine
\
\ ******************************************************************************

.loadrom%

 JMP LoadRom            \ Copy a pre-generated ship blueprints ROM image into
                        \ sideways RAM

