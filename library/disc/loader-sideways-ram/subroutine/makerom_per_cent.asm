\ ******************************************************************************
\
\       Name: makerom%
\       Type: Subroutine
\   Category: Loader
\    Summary: Entry point for the routine to create the Elite ROM image in
\             sideways RAM
\
\ ******************************************************************************

.makerom%

 JMP MakeRom            \ Create a ROM image in sideways RAM that contains all
                        \ the ship blueprint files

