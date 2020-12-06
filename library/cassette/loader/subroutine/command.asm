\ ******************************************************************************
\
\       Name: command
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Execute an OS command
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y X)               The address of the OS command string to execute
\
\ ******************************************************************************

.command

 JMP (oscliv)           \ Jump to &FFF7 to execute the OS command pointed to
                        \ by (Y X) and return using a tail call

